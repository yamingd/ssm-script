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
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/_project_-web-res/src/main/resources/mybatis')
    fpath = format_line(outfolder, prjinfo)
    if not os.path.exists(fpath):
        os.makedirs(fpath)

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
    
    fname = os.path.join(fpath, minfo['ns'] + '.xml')
    print fname  
    render_template(fname, 'mybatis.mako', **kwargs)

def gen_spring_xml(prjinfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/_project_-web-res/src/main/resources/spring')
    fpath = format_line(outfolder, prjinfo)
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo

    # parse dburl for username, password
    tmp = prjinfo._dburl_.split('@')
    kwargs['dbuser'] = tmp[0].split(':')[0]
    kwargs['dbpwd'] = tmp[0].split(':')[1]
    kwargs['dbhost'] = tmp[1]
    
    fname = os.path.join(fpath, 'root-context.xml')
    print fname  
    render_template(fname, 'spring-context.mako', **kwargs)

def gen_jdbc_xml(prjinfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/_project_-web-res/src/main/resources')
    fpath = format_line(outfolder, prjinfo)
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    
    # parse dburl for username, password
    tmp = prjinfo._dburl_.split('@')
    kwargs['dbuser'] = tmp[0].split(':')[0]
    kwargs['dbpwd'] = tmp[0].split(':')[1]
    kwargs['dbhost'] = tmp[1]
    
    fname = os.path.join(fpath, 'jdbc.properties')
    print fname  
    render_template(fname, 'jdbcconfig.mako', **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_config_xml(prjinfo, minfo)

    gen_spring_xml(prjinfo)
    gen_jdbc_xml(prjinfo)
