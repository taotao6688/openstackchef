# Details about icehouse.xml file

`icehouse.xml` is used to generate Chef OpenStack environment and Chef bootstrap commands, it is an optional file.

The intends of `icehouse.xml` is to help beginners easily generate environment file, because edit an xml file is easier than a json file.

This file contains three sections, `environment`, `nodes` and `order`.

## environment section

environment section is used to generate Chef environment file, `install_openstack.py` will read attributes from `icehouse.xml` file and use `icehouse.json` file an environment template, then generates a Chef OpenStack environment file in `../environments` directory.

**env.name** Chef OpenStack environment name, it can be `production` or `test` or whatever you want.

**node.username** The username of your nodes(which will be installed OpenStack), usually `root`.

**node.password** The password of the `node.username` on your nodes.

**node.ssh_key** The ssh private key path of the `node.username` on your nodes(You MUST configure one of `node.password` and `node.ssh_key`).

**openstack.mq.service_type** Message Queue type of you OpenStack environment.

**openstack.db.service_type** Database type of your OpenStack environment.

**openstack.db.db2.url**

**openstack.db.db2.odbc_url**

**openstack.db.compute.username**

**openstack.db.identity.username**

**openstack.db.orchestration.username**

**openstack.endpoints.db.port**

**openstack.endpoints.db.host**

**openstack.endpoints.mq.port**

**openstack.endpoints.mq.host**

**opnestack.endpoints.identity-api.host**

**openstack.endpoints.identity-admin.host**

**openstack.endpoints.telemetry-api.host**

**openstack.network.l3.external_network_bridge_interface** The physical external network ineterface which external bridge connects to.

**openstack.network.openvswitch.local_ip_interface** The `local_ip` (which is set in `ovs_neutron_plugin.ini` file).

**openstack.image.upload_images** Which images should be uploaded to your OpenStack glance.(`'["cirros"]'` means only upload cirros image and `'["cirros", "precise"]'` means upload both cirros and precise)

**openstack.image.upload_image.precise**

**openstack.image.upload_image.cirros** The cirros image URL.

**yum.repo.rhel** RHEL base repo URL.

**yum.repo.epel** EPEL repo URL.

**yum.repo.openstack** OpenStack repo URL.

## nodes section

**host** The IP or hostname or FQDN of your nodes, should ensure Chef workstation can connect to the node through `host`.

**roles** The Chef OpenStack roles that will be bootstraped on the nodes.

## order section

The Chef OpenStack roles bootstrap order, you can ignore this.

## In the end

This is a sample of OpenStack icehouse installation with Neutron openvswitch GRE network, DB2 as backend database, qpid as message queue.

Because DB2 has a schema concept, so there only need one DB2 database for OpenStack.

If you do not want `icehouse.xml` to generate Chef OpenStack environment, you can edit the sample `icehouse.sample.json` file to make your Chef OpenStack environment.
