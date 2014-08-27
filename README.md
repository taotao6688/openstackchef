# OpenStack DevOps Document

## Purpose

Install/Configure OpenStack with Chef.

## Requirements

* Redhat/CentOS >= 6.3
* Chef Server >= 11.0
* Chef Client >= 11.0
* IBM DB2 >= 10.5
* MySQL >= 5.0
* QPID >= 0.22


### Build Chef server and workstation

Please look `README.md` in `openstack-devops/chef` directory for details.


### Build rpm web repo

There need three repos, `redhat`, `epel` and `openstack`.

* rhel6.5: The packages are located in `RHEL-6.5.iso` file.

* epel: <http://dl.fedoraproject.org/pub/epel/6Server/x86_64/>

* openstack-x86_64: <http://rchgsa.ibm.com/projects/e/emsol/ccs/build/driver/osee-icehouse/openstack/D20140423-2052/x86_64>

* openstack-noarch: <http://rchgsa.ibm.com/projects/e/emsol/ccs/build/driver/osee-icehouse/openstack/D20140423-2052/noarch>

**Build your own rpm web repo**

    # RHEL REPO
    mkdir -p /var/www/html/rhel/6Server/x86_64
    mount -o loop RHEL6.5-20131111.0-Server-x86_64-DVD1.iso /mnt
    cp -r /mnt/Packages/* /var/www/html/rhel/6Server/x86_64
    umount /mnt
    createrepo /var/www/html/rhel/6Server/x86_64
    # EPEL REPO
    mkdir -p /var/www/html/epel
    cd /var/www/html/epel
    wget --recursive --level=0 --reject="*.html*" --no-host-directories --cut-dirs=2 --ignore-length --no-clobber --no-parent http://dl.fedoraproject.org/pub/epel/6Server/x86_64/
    # OpenStack OSEE REPO
    mkdir -p /var/www/html/openstack
    cd /var/www/html/openstack
    wget --recursive --level=0 --reject="*.html*" --no-host-directories --cut-dirs=9 --ignore-length --no-clobber --no-parent http://rchgsa.ibm.com/projects/e/emsol/ccs/build/driver/osee-icehouse/openstack/D20140423-2052/x86_64
    wget --recursive --level=0 --reject="*.html*" --no-host-directories --cut-dirs=9 --ignore-length --no-clobber --no-parent http://rchgsa.ibm.com/projects/e/emsol/ccs/build/driver/osee-icehouse/openstack/D20140423-2052/noarch

* IBM internal mirror of RHEL: <http://9.39.64.254:8800/rhel/6Server>
* IBM internal mirror of EPEL: <http://9.39.64.254:8800/epel/6Server>

## How to use

### Checkout code

    git clone http://github.rtp.raleigh.ibm.com/openstackchef/openstack-devops.git

###  Choose the branch, fetch cookbooks and apply patches

    cd openstack-devops
    git branch -a
    git checkout 20140428
    bash scripts/update_cookbooks.sh

1. change directory to `openstack-devops`

2. show git branch list(branches named with timestamp are stable branches)

3. if the particular branch is what you want, checkout it

4. fetch cookbooks and apply patches

### Start configure Chef environment

    cd openstack-devops/scripts
    vim icehouse.xml

For more details about `icehouse.xml` file, please look `ICEHOUSE.md` in `openstack-devops/scripts` directory.

You can edit `icehouse.sample.json` file directly and replace with your nodes info, and then use this file as Chef OpenStack environment.

NOTE: `icehouse.xml` is an optional file, this file is used to generate Chef OpenStack environment and bootstrap commands.

### Run install_openstack.py script

    cd openstack-devops/scripts
    python install_openstack.py -f icehouse.xml -E -U
    python install_openstack.py -f icehouse.xml -R -C
    python install_openstack.py -f icehouse.xml -D


For more details about `install_openstack.py`, please look `INSTALL_OPENSTACK.md` in `openstack-devops/scripts` directory.

### Create network from your controller

    ssh controller
    neutron net-create net1
    neutron subnet-create --name=subnet1 net1 192.168.0.0/24
    nova boot --image IMAGE-ID --flavor 2 --nic net-id=NET-ID [other options] vmname


## For developers

### Sync submodule cookbooks from upstream and check in to openstack-devops

Take openstack-common as an example:

    git clone http://github.rtp.raleigh.ibm.com/openstackchef/openstack-devops.git
    cd openstack-devops
    git submodule init
    git submodule update
    cd cookbooks/openstack-common
    git status # make sure there is no local change
    git pull
    cd ../../
    git add .
    git commit -m"syn openstack-common cookbook from upstream"
    git push origin master

##  Authors
|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  Chen Zhiwei (zhiwchen@cn.ibm.com>)                |
