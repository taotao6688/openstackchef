#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

platform_options = node["pacemaker"]["platform"]

platform_options["pacemaker_packages"].each do |pkg|
    package pkg do
        action :install
    end
end

service platform_options["cman_service"] do
    service_name platform_options["cman_service"]
    action :enable
end

service platform_options["pacemaker_service"] do
    service_name platform_options["pacemaker_service"]
    action :enable
end

remote_directory "/usr/lib/ocf/resource.d/heartbeat" do
    source "heartbeat"
    files_owner "root"
    files_group "root"
    files_mode 00755
end

directory "/usr/lib/ocf/resource.d/openstack" do
    owner "root"
    group "root"
    mode 00755
end

execute "cman_quorum_set" do
    command "echo 'CMAN_QUORUM_TIMEOUT=0' >> /etc/sysconfig/cman"
end

execute "iptables_set" do
    command "iptables -A INPUT -p udp --dport 5404:5405 -j ACCEPT;/etc/init.d/iptables save"
end

node['pacemaker']['cluster'].each do |name, info|
    if info.include?(node['hostname'])
        execute "debug host info" do
            command "echo \"host2 = #{node['hostname']}\" > /tmp/host.log"
        end
        pacemaker_cluster "cluster" do
            cluster_name name
            cluster_nodes info
        end
    end
end
#pacemaker_cluster "cluster" do
#    cluster_name node["pacemaker"]["cluster"]["name"]
#    cluster_nodes node["pacemaker"]["cluster"]["nodes"]
#end

service "cman service" do
   service_name platform_options["cman_service"]
   action :start
end

execute "pacemaker service" do
   command "nohup service pacemaker start > /dev/null 2>&1"
end

execute "stonith-setup" do
    command "pcs property set stonith-enabled=false"
    not_if "pcs property | grep 'stonith-enabled: false'"
end

execute "start-failure-setup" do
    command "pcs property set start-failure-is-fatal=false"
    not_if "pcs property | grep 'start-failure-is-fatal: false'"
end
