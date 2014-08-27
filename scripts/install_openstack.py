#!/usr/bin/env python
# -*- coding: utf-8 -*-
# VIM :set ts=4 sts=4 sw=4
#
# Author: Chen Zhiwei <zhiwchen@cn.ibm.com>
#

import os
import sys
import time
import subprocess
from xml.dom import minidom
from optparse import OptionParser


class XMLParser:

    def __init__(self, json_tmpl, xml_file):
        self.xml_file = xml_file
        self.json_tmpl = json_tmpl
        xmldoc = minidom.parse(xml_file)
        self.xmldoc = xmldoc
        self.nodes_obj = xmldoc.getElementsByTagName('node')
        self.order_obj = xmldoc.getElementsByTagName('order')[0]
        self.env_obj = xmldoc.getElementsByTagName('environment')[0]
        self.env_name = self.env_obj.getAttribute('env.name')
        self.username = None
        self.password = None
        self.ssh_key = None
        if self.env_obj.hasAttribute('node.username'):
            self.username = self.env_obj.getAttribute('node.username')
        else:
            self.username = 'root'
        if self.env_obj.hasAttribute('node.password') \
               and self.env_obj.getAttribute('node.password'):
            self.password = self.env_obj.getAttribute('node.password')
        if self.env_obj.hasAttribute('node.ssh_key') \
               and self.env_obj.getAttribute('node.ssh_key'):
            self.ssh_key = self.env_obj.getAttribute('node.ssh_key')

    def string_to_list(self, string):
        list = []
        for item in string.split(','):
            item = item.strip()
            if item not in list and item != '':
                list.append(item)
        return list

    def copy_list(self, list):
        copy = []
        for item in list:
            item = item.strip()
            if item not in copy and item != '':
                copy.append(item)
        return copy

    def get_value_of_element(self, element):
        xmldoc = self.xmldoc
        return xmldoc.getElementsByTagName(element)[0].firstChild.nodeValue

    def get_key_pair(self, obj):
        dict = {}
        if obj.nodeType == obj.ELEMENT_NODE:
            if obj.hasAttributes():
                for attr in obj.attributes.items():
                    dict[attr[0]] = attr[1]

            if obj.hasChildNodes():
                if obj.firstChild.nodeValue.strip() != '':
                    dict[obj.nodeName] = obj.firstChild.nodeValue
                dict.update(self.get_key_pair(obj))
        return dict

    def get_environment_content(self):
        env_obj = self.env_obj
        json_tmpl = self.json_tmpl
        key_pair = self.get_key_pair(env_obj)
        json_content = open(json_tmpl).read()
        for k, v in key_pair.items():
            json_content = json_content.replace(k, v)
        return json_content

    def get_role_sequences(self):
        list = []
        order_obj = self.order_obj
        sequence = order_obj.getAttribute('sequence')
        sequences = self.string_to_list(sequence)
        for sequence in sequences:
            roles = self.get_value_of_element(sequence)
            list.append(self.string_to_list(roles))
        return list

    def get_nodes_null_dict(self):
        dict = {}
        nodes_obj = self.nodes_obj
        for node in nodes_obj:
            host = node.getElementsByTagName('host')[0].firstChild.nodeValue
            dict[host] = []
        return dict

    def get_nodes_by_role(self, role):
        list = []
        node_roles = self.get_node_roles()
        for node, roles in node_roles.items():
            if role in roles and node not in list:
                list.append(node)
        return list

    def get_node_roles(self):
        dict = {}
        nodes_obj = self.nodes_obj
        for node in nodes_obj:
            host = node.getElementsByTagName('host')[0].firstChild.nodeValue
            roles = node.getElementsByTagName('roles')[0].firstChild.nodeValue
            dict[host] = self.string_to_list(roles)
        return dict

    def get_node_roles_sequence(self):
        list = []
        dict = self.get_nodes_null_dict()
        sequences = self.get_role_sequences()
        for sequence in sequences:
            dict = self.get_nodes_null_dict()
            nodes_dict = {}
            for role in sequence:
                nodes = self.get_nodes_by_role(role)
                for node in nodes:
                    dict[node].append(role)
                    nodes_dict[node] = self.copy_list(dict[node])
            if nodes_dict:
                list.append(nodes_dict)
        return list


class Chef:

    def __init__(self):
        self.cur_dir = os.path.abspath(os.path.dirname(__file__))
        self.role_dir = os.path.dirname(self.cur_dir) + os.sep + 'roles'
        self.databag_dir = os.path.dirname(self.cur_dir) + os.sep + 'databags'
        self.cookbook_dir = os.path.dirname(self.cur_dir) + os.sep + 'cookbooks'
        self.environment_dir = os.path.dirname(self.cur_dir) + os.sep + 'environments'
        self.log_dir = self.cur_dir + os.sep + 'logs'
        if not os.path.exists(self.log_dir):
            os.mkdir(self.log_dir)

    def role_upload(self):
        cmd = 'knife role from file ' + self.role_dir + os.sep + '*'
        os.system(cmd)

    def databag_upload(self):
        cmd = 'bash ' + self.databag_dir + os.sep + 'create_databag.sh'
        os.system(cmd)

    def cookbook_upload(self):
        cmd = 'knife cookbook upload -a -o ' + self.cookbook_dir
        os.system(cmd)

    def environment_upload(self, env_name):
        cmd = 'knife environment from file ' + self.environment_dir + os.sep + env_name + '.json'
        os.system(cmd)

    def generate_environment(self, env_name, env_content):
        env_path = self.environment_dir + os.sep + env_name + '.json'
        fp = open(env_path, 'w')
        fp.write(env_content)
        fp.close()
        print 'Generate environment: ' + env_path

    def option_parser(self):
        parser = OptionParser()
        parser.add_option('-f', '--file', dest='file', help='The xml file', metavar='FILE')
        parser.add_option('-e', '--env-tmpl', dest='env_tmpl', default=self.cur_dir + os.sep + 'icehouse.zy.ha.json',
                help='The environment template file', metavar='FILE')
        parser.add_option('-E', '--environment-generate', action='store_true',
                dest='environment_generate', default=False, help='create environment file')
        parser.add_option('-R', '--role-upload', action='store_true',
                dest='role_upload', default=False, help='upload role file')
        parser.add_option('-C', '--cookbook-upload', action='store_true',
                dest='cookbook_upload', default=False, help='upload cookbook file')
        parser.add_option('-U', '--environment-upload', action='store_true',
                dest='environment_upload', default=False, help='upload environment file')
        parser.add_option('-B', '--bootstrap', action='store_true', dest='bootstrap',
                default=False, help='bootstrap all nodes')
        parser.add_option('-D', '--dry-run', action='store_true', dest='dry_run',
                default=False, help='perform a dry run of Chef commands')
        parser.add_option('-d', '--databag', action='store_true', dest='databag_upload',
                default=False, help='upload databags')
        parser.add_option('-a', '--all', action='store_true', dest='all',
                default=False, help='the same with -E -U -R -C -d -B')
        options, _ = parser.parse_args()

        status = True
        if not os.path.exists(options.file):
            status = False
            print options.file + ' DOES NOT EXIST'

        if os.path.basename(options.file) == 'icehouse.xml' or os.path.basename(options.file) == 'icehouse.ha.xml':
            status = False
            print 'DONT use default xml file: ' + options.file

        if not os.path.exists(options.env_tmpl):
            status = False
            print options.env + ' DOES NOT EXIST'

        if not status:
            exit(1)

        return options

    def sleep(self, count):
        global COUNTER
        for i in range(count, 0, -1):
            sys.stderr.write('BOOTSTRAP STARTED %d SECONDS\r' % COUNTER['TOTAL'])
            COUNTER['TOTAL'] = COUNTER['TOTAL'] + 1
            time.sleep(1)
        return None

    def list_to_string(self, list):
        string = ''
        for role in list:
            string = string + 'role[' + role + '],'
        return string.strip(',')

    def get_commands(self, node_roles_sequence, env, username, ssh_key, password=None):
        params = ' -E ' + env + ' -x ' + username
        if ssh_key:
            params = params + ' -i ' + ssh_key
        elif password:
            params = params + ' -P ' + password
        else:
            print 'You MUST either specify an SSH KEY or PASSWORD'
            exit(1)

        list = []
        for info in node_roles_sequence:
            dict = {}
            for node, roles in info.items():
                dict[node] = 'knife bootstrap ' + node + params + ' -r \'' + self.list_to_string(roles) + '\''
            list.append(dict)
        self.commands = list
        return list

    def dry_run(self, commands):
        print ''
        for dict in commands:
            for node, command in dict.items():
                print command
            print '#============================================'
            print ''
        return None

    def bootstrap(self, commands):
        global COUNTER
        for info in commands:
            dict = {}
            file = {}
            fp = {}
            for node, cmd in info.items():
                COUNTER[node] = time.time()
                file[node] = self.log_dir + os.sep + node + '.' + time.strftime('%Y%m%d%H%M%S') + '.bootstrap.log'
                fp[node] = open(file[node], 'w')
                dict[node] = subprocess.Popen(cmd, shell=True, stdout=fp[node], stderr=subprocess.STDOUT)

            while True:
                for node, process in dict.items():
                    if process.poll() is not None:
                        fp[node].close()
                        code = process.returncode
                        dict.pop(node)
                        timecost = time.time()-COUNTER[node]
                        if code == 0:
                            print ''
                            print '%s SUCCESS' % node
                            print info[node]
                            print 'total spent: %.0f min %d sec' % (timecost/60, int(timecost%60))
                            print '#===================================================='
                        else:
                            print ''
                            print '%s FAILED' % node
                            print info[node]
                            print 'total spent: %.0f min %d sec' % (timecost/60, int(timecost%60))
                            print 'Error occurs %s log: %s' % (node, file[node])
                            print ''
                            print 'Install failed !'
                            print ''
                            exit(1)
                if len(dict) == 0:
                    break
                else:
                    self.sleep(1)
        totaltimecost = time.time()-COUNTER['timestart']
        print ''
        print 'Install finished in %.0f min %d sec.' % (totaltimecost/60, int(totaltimecost%60))
        print ''
        return None


def run():
    chef = Chef()
    options = chef.option_parser()
    file = options.file
    env_tmpl = options.env_tmpl
    environment_generate = options.environment_generate
    role_upload = options.role_upload
    cookbook_upload = options.cookbook_upload
    environment_upload = options.environment_upload
    databag_upload = options.databag_upload
    bootstrap = options.bootstrap
    dry_run = options.dry_run
    all = options.all

    env = XMLParser(env_tmpl, file)
    env_name = env.env_name
    env_content = env.get_environment_content()
    node_roles_info = env.get_node_roles_sequence()
    commands = chef.get_commands(node_roles_info, env_name, env.username, env.ssh_key, env.password)

    if environment_generate:
        chef.generate_environment(env_name, env_content)
    if environment_upload:
        chef.environment_upload(env_name)
    if role_upload:
        chef.role_upload()
    if cookbook_upload:
        chef.cookbook_upload()
    if databag_upload:
        chef.databag_upload()
    if bootstrap:
        chef.bootstrap(commands)
    if dry_run:
        chef.dry_run(commands)

COUNTER = {'TOTAL': 0, 'timestart' : time.time()}

if __name__ == '__main__':
    run()
