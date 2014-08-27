# install_openstack.py

`install_openstack.py` is used to:

1. Generate and upload Chef OpenStack environment file.

    python install_openstack.py -f icehouse.xml -E -U

2. Upload Chef OpenStack roles and cookbooks.

    python install_openstack.py -f icehouse.xml -R -C

3. Generate Chef OpenStack databags.

    python install_openstack.py -f icehouse.xml -d

4. Perform a dry run of bootstrap commands.

    python install_openstack.py -f icehouse.xml -D

5. Bootstrap all nodes.

    python install_openstack.py -f icehouse.xml -B


Sample of usage:

    [root@chef-server scripts]# ./install_openstack.py --help
    Usage: install_openstack.py [options]

    Options:
      -h, --help            show this help message and exit
      -f FILE, --file=FILE  The xml file
      -e FILE, --env-tmpl=FILE
                            The environment template file
      -E, --environment-generate
                            create environment file
      -R, --role-upload     upload role file
      -C, --cookbook-upload
                            upload cookbook file
      -U, --environment-upload
                            upload environment file
      -B, --bootstrap       bootstrap all nodes
      -D, --dry-run         perform a dry run of Chef commands
      -d, --databag         upload databags
      -a, --all             the same with -E -U -R -C -d -B

**-e** is environment template file, default is `icehouse.json`.
