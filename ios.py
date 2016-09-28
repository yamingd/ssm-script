#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

IOS_MAPPER_BASE_FOLDER = 'ios/_project_/_project_/Mappers'
IOS_MODEL_BASE_FOLDER = 'ios/_project_/_project_/Models'

def gen_model(prjinfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MODEL_BASE_FOLDER)
    outfolder = format_line(outfolder, prjinfo)
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')

    ms = []
    for minfo in prjinfo._modules_:
        if not minfo.get('protoc', True):
            continue
        pbexcludes = minfo.get('pbexcludes', [])    
        for table in minfo['tables']:
            if table.name in pbexcludes:
                continue
            ms.append(table)
    kwargs['ms'] = ms        
    fpath = os.path.join(outfolder, 'pb-models-all.h')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'ios-pb-all.mako', **kwargs)


def gen_mapper(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MAPPER_BASE_FOLDER)
    outfolder = format_line(outfolder, prjinfo)
    outfolder = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']

    # protobuf mapper
    pbexcludes = minfo.get('pbexcludes', [])
    for table in minfo['tables']:
        if table.name in pbexcludes:
            continue
        kwargs['_tbi_'] = table
        fpath = os.path.join(outfolder, table.pb.name + "Mapper.h")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-ios-mapper-h.mako', **kwargs)
        fpath = os.path.join(outfolder, table.pb.name + "Mapper.m")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-ios-mapper-m.mako', **kwargs)


def gen_mapper_init(prjinfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MAPPER_BASE_FOLDER)
    outfolder = format_line(outfolder, prjinfo)
    
    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')

    ms = []
    for minfo in prjinfo._modules_:
        if not minfo.get('protoc', True):
            continue
        pbexcludes = minfo.get('pbexcludes', [])    
        for table in minfo['tables']:
            if table.name in pbexcludes:
                continue
            ms.append(table)
    kwargs['ms'] = ms        
    fpath = os.path.join(outfolder, 'PBMapperInit.h')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'protobuf-ios-mapper-init-h.mako', **kwargs)
    fpath = os.path.join(outfolder, 'PBMapperInit.m')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'protobuf-ios-mapper-init-m.mako', **kwargs)


def gen_service(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'ios/_project_/_project_/Services')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']

    pbexcludes = minfo.get('pbexcludes', [])    
    for name in minfo['tables']:
        if name in pbexcludes:
            continue
        table = prjinfo._tbrefs_[name]
        kwargs['_tbi_'] = table
        fname = os.path.join(fpath, table.pb.name + 'Service.h')
        render_template(fname, 'ios-service-h.mako', **kwargs)

        fname = os.path.join(fpath, table.pb.name + 'Service.m')
        render_template(fname, 'ios-service-m.mako', **kwargs)

def gen_controller_folder(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'ios/_project_/_project_/Controllers')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        if 'protoc' in minfo and not minfo['protoc']:
            continue
        gen_mapper(prjinfo, minfo)

    gen_mapper_init(prjinfo)
    gen_model(prjinfo)
    
    for minfo in prjinfo.mobile:
        if 'protoc' in minfo and not minfo['protoc']:
            continue
        gen_service(prjinfo, minfo)
        gen_controller_folder(prjinfo, minfo)

