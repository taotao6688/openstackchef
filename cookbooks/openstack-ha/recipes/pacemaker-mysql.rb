include_recipe "pacemaker::install"
require "uri"

op_var = {"monitor" => "interval=60s timeout=120s"}

pacemaker_agent "create mysql agent" do
    pm_resource_name "MYSQL"
    agent_name "ocf:heartbeat:mysql2"
    op_param op_var
    type "clone"
end
