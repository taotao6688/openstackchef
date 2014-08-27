# databag usage

If you set `node['openstack']['developer_mode']` to false, databag should be used in the cookbooks.

There are three databags need to create: `db_passwords`, `service_passwords` and `user_passwords`.

I wrote a shell script to easily create these databags and databag items.

You can simply run `bash create_databag.sh` on your Chef workstation to generate these databags and items.

The default databag secret key file is located in `/root/.chef/databag-secret-key`

## Be careful when you run this script, because it will remove all your exist databags.
## The random passwords are in this script directory, or run `knife data bag show user_passwords nova` to see.
