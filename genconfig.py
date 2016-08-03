#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

def gen_config_xml(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/dev-tools')
    fpath = format_line(outfolder, prjinfo)
    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']

    # parse dburl for username, password
    tmp = prjinfo._dburl_.split('@')
    kwargs['dbuser'] = tmp[0].split(':')[0]
    kwargs['dbpwd'] = tmp[0].split(':')[1]
    kwargs['dbhost'] = tmp[1]
    
    fname = os.path.join(fpath, minfo['ns'] + '_generatorConfig.xml')
    print fname  
    render_template(fname, 'generatorConfig.mako', **kwargs)

def gen_build_config(prjinfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/dev-tools')
    fpath = format_line(outfolder, prjinfo)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_modules_'] = prjinfo._modules_
    
    fname = os.path.join(fpath, 'build.gradle')
    print fname

    # parse dburl for username, password
    tmp = prjinfo._dburl_.split('@')
    kwargs['dbuser'] = tmp[0].split(':')[0]
    kwargs['dbpwd'] = tmp[0].split(':')[1]
    kwargs['dbhost'] = tmp[1]

    render_template(fname, 'generatorBuild.mako', **kwargs)

def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_config_xml(prjinfo, minfo)

    gen_build_config(prjinfo)
