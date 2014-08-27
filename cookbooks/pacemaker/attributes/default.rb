default["pacemaker"]["cluster"]["name"] = "cluster"
default["pacemaker"]["cluster"]["nodes"] = [node["hostname"]]

case platform
when "fedora", "redhat", "centos", "suse"
    default["pacemaker"]["platform"] = {
        "pacemaker_packages" => ["cman", "pacemaker", "pcs", "ccs"],
        "cman_service" => "cman",
        "pacemaker_service" => "pacemaker"
    }
end
