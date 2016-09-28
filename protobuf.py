#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

def gen_sh(prjinfo, base_folder, tmpl_name):
    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # protobuf files
    outfolder = os.path.join(prjinfo._root_, base_folder)
    outfolder = format_line(outfolder, prjinfo)
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    fpath = os.path.join(outfolder, "gen.sh")
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, tmpl_name, **kwargs)

def gen_convertor(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/_project_-model/src/main/java/com/_company_/_project_/convertor')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']
    
    exls = minfo.get('pbexcludes', [])
    for table in minfo['tables']:
        if table.name in exls:
            continue
        fname = os.path.join(fpath, table.java.name + 'Convertor.java')
        kwargs['_tbi_'] = table
        render_template(fname, 'entity-convertor.mako', **kwargs)

def gen_proto(prjinfo, minfo, base_folder, lang):

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']

    # protobuf files
    outfolder = os.path.join(prjinfo._root_, base_folder)
    outfolder = format_line(outfolder, prjinfo)
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)
    cmds = []
    exls = minfo.get('pbexcludes', [])
    # print 'exls: ', exls
    for table in minfo['tables']:
        if table.name in exls:
            continue
        kwargs['_tbi_'] = table
        fpath = os.path.join(outfolder, table.pb.name + "Proto.proto")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf_entity.mako', **kwargs)
        cmds.append('sh gen.sh %s %s' % (table.pb.name, minfo['ns']))

    # gen-module.sh
    fpath = os.path.join(outfolder, 'gen-' + minfo['ns'] + '.sh')
    with open(fpath, 'w+') as fw:
        fw.write('#!/usr/bin/env bash')
        fw.write('\n\n')
        for line in cmds:
            fw.write(line)
            fw.write('\n')
    # to run sh

def run_sh(prjinfo):
    fpath = os.path.join(prjinfo._root_, "pb-gen.sh")
    if os.path.exists(fpath):
        os.remove(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    render_template(fpath, 'sh-run.mako', **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    dbm.read_tables(prjinfo)

    java_base = 'java/_project_/_project_-model/src/script'
    android_base = 'android/_project_/app/src/script'
    ios_base = 'ios/_project_/_project_/Script'

    gen_sh(prjinfo, java_base, 'protobuf-sh-java.mako')
    gen_sh(prjinfo, android_base, 'protobuf-sh-android.mako')
    gen_sh(prjinfo, ios_base, 'protobuf-sh-ios.mako')

    for minfo in prjinfo._modules_:
        if 'protoc' in minfo and not minfo['protoc']:
            continue
        gen_convertor(prjinfo, minfo)
        gen_proto(prjinfo, minfo, java_base, 'java')
        gen_proto(prjinfo, minfo, android_base, 'android')
        gen_proto(prjinfo, minfo, ios_base, 'ios')
    
    run_sh(prjinfo)
