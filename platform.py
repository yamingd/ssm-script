#!/usr/bin/env python
# -*- coding: utf-8 -*-

import string
import mapping
import common
import names

SQLITE3_CREATE_SQL_0 = u'create table if not exists %s(%s) WITHOUT ROWID;'

class PBClass(object):
    """docstring for PBClass"""
    def __init__(self, table):
        self.table = table
        self.comment = table.hint
        self.package = table.package
        if table.prefix and len(table.prefix) > 0:
            self.name = 'PB' + common.gen_name(table.name[len(table.prefix):])
            self.varName = 'pb' + common.gen_name(table.name[len(table.prefix):])
        else:
            self.name = 'PB' + common.gen_name(table.name)
            self.varName = 'pb' + common.gen_name(table.name)
        
        # com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.PB{{_tbi_.java.name}}
        self.model_ns = 'com.%s.%s.protobuf.%s' % (table.prj._company_, table.prj._name_, table.package)


class PBField(object):
    """docstring for PBField"""
    def __init__(self, column):
        self.column = column
        self.name = common.gen_name(column.name, upperFirst=False)
        self.nameC = common.upper_first(self.name)
        self.typeName = mapping.protobuf_types.get(column.valType)
        if self.name.lower().endswith('date') or self.name.lower().endswith('time'):
            self.typeName = 'int64'
        self.mark = 'optional'
        self.package = column.package


class PBRefField(object):
    """docstring for PBField"""
    def __init__(self, ref, opb):
        self.ref = ref
        self.refpb = opb
        self.name = common.gen_name(ref.varName, upperFirst=False)
        self.nameC = common.upper_first(self.name)
        self.typeName = opb.name
        self.mark = 'optional'
        if ref.repeated:
            self.mark = 'repeated'
        self.package = opb.package + "."


class JavaClass(object):
    """docstring for JavaClass"""
    def __init__(self, table):
        self.table = table
        self.comment = table.hint
        self.package = table.package
        if table.prefix and len(table.prefix) > 0:
            self.name = common.gen_name(table.name[len(table.prefix):])
        else:
            self.name = common.gen_name(table.name)
        self.varName = common.lower_first(self.name)
        self.absName = 'Abstract' + self.name
        
        self.model_ns = 'com.%s.%s.model.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.convertor_ns = 'com.%s.%s.convertor.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.mapper_ns = 'com.%s.%s.mapper.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.service_ns = 'com.%s.%s.service.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.mapper_impl_ns = 'com.%s.%s.mapper.impl.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.service_impl_ns = 'com.%s.%s.service.impl.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.wrapper_impl_ns = 'com.%s.%s.wrapper.impl.%s' % (table.prj._company_, table.prj._name_, table.package)

    def dbFields(self):
        s = []
        for c in self.table.columns:
            s.append(c.name)
        return ', '.join(s)


class JavaField(object):
    """docstring for JavaField"""
    def __init__(self, column):
        self.column = column
        self.name = common.gen_name(column.name, upperFirst=False)
        self.valType = mapping.java_types.get(column.valType)
        self.setterName = common.upper_first(self.name)
        self.getterName = common.upper_first(self.name)
        self.typeName = self.valType
        if self.name.lower().endswith('date') or self.name.lower().endswith('time'):
            self.typeName = 'Date'

        if self.typeName != self.valType:
            self.typeDiff = True
        else:
            self.typeDiff = False

    def autoIncrementMark(self):
        return "true" if self.column.auto_increment else "false"
    
    def keyHodlerFun(self):
        if self.typeName == 'Integer':
            return 'intValue()'
        if self.typeName == 'Long':
            return 'longValue'
    
    @property
    def jdbcSetter(self):
        return mapping.jdbc_setter.get(self.column.valType)
    
    @property
    def defaultValue(self):
        if self.column.default:
            if self.column.default.startswith('0.0'):
                return self.column.default + "f"
            if self.valType == 'String':
                return '"%s"' % self.column.default
            return self.column.default
        else:
            return 'null'

    @property
    def jdbcValueFunc(self):
        s = 'null == %s ? %s : %s'
        v = mapping.jdbc_value_funcs.get(self.column.valType, None)
        if v:
            v = v % self.name
            s = s % (self.name, self.defaultValue, v)
        else:
            s = s % (self.name, self.defaultValue, self.name)
        return s
    
    @property
    def pbValue(self):
        if self.typeName == 'Date':
            return 'dateToInt(item.get%s())' % self.getterName
        if self.typeName == 'BigDecimal':
            return 'item.get%s().doubleValue()' % self.getterName
        if self.typeName == 'Boolean':
            return 'Values.get(item.get%s(), Integer.class)' % self.getterName
        return 'item.get%s()' % self.getterName


class JavaRefField(object):
    """docstring for JavaField"""
    def __init__(self, ref, ojava):
        print ojava.name, ojava.table.name, ref.varName
        self.ref = ref
        self.refJava = ojava
        self.typeName = ojava.name
        self.package = ojava.package
        self.name = common.gen_name(ref.varName, upperFirst=False)
        self.nameC = common.upper_first(self.name)
        self.setterName = common.upper_first(self.name)
        self.getterName = common.upper_first(self.name)
        self.repeated = ref.repeated
        if ref.repeated:
            self.typeName = 'List<%s>' % ojava.name

    def mapper(self, o):
        if o.name == self.refJava.name:
            return "this"
        else:
            return self.refJava.varName + 'Mapper'

class MySqlQueryFunc(object):
    """docstring for MySqlQueryFunc"""
    def __init__(self, cols):
        self.cols = cols
        self.unique = False

    @property
    def name(self):
        s = [common.upper_first(c.java.name) for c in self.cols]
        return ''.join(s)
    
    @property
    def nameWithDot(self):
        s = [c.java.name for c in self.cols]
        return ', '.join(s)

    @property
    def arglist(self):
        s = ['%s %s' % (c.java.typeName, c.java.name) for c in self.cols]
        return ', '.join(s)
    
    @property
    def varlist(self):
        s = [c.java.name for c in self.cols]
        return ', '.join(s)
    
    @property
    def sql_where(self):
        s = ['%s = ?' % (c.name, ) for c in self.cols]
        return ' and '.join(s)


class Link(object):
    """docstring for Link"""
    def __init__(self, parentTbl, childTbl):
        self.parent = parentTbl
        self.child = childTbl
        self.nameC = common.gen_name(self.child.name.replace(self.parent.name, "")[1:]) # 下划线分隔
        self.name = common.lower_first(self.nameC)
        self.getterName = '%sList' % self.nameC
        self.setterName = '%sList' % self.nameC
        self.varName = '%sList' % self.name
        self.comment = u'关联读取 @see %s' % (self.child.java.name) 
        self.queryFunc = 'findBy%sId' % (self.parent.java.name)
        self.queryField = '%sId' % (self.parent.java.varName)
        self.pbMark = 'repeated'

class MySqlTable(object):
    """docstring for MySqlTable"""
    def __init__(self, prj, package, name, hint, prefix):
        self.prj = prj
        self.package = package
        self.name = name
        self.hint = hint
        self.columns = []
        self.pks = []
        self.refFields = []  # MySqlRef
        self.impJavas = []   # JavaRefField
        self.impPBs = []     # PBRefField
        self.cmaps = {}
        self.cindex = {}
        self.prefix = prefix
        self.links = []
        self.linkModels = [] # MySqlTable
        self.linkFuncs = []
        self.linkFuncNames = []

    def initJava(self):
        self.java = JavaClass(self)
        self.model_ns = 'com.%s.%s.model.%s' % (self.prj._company_, self.prj._name_, self.package)
        self.convertor_ns = 'com.%s.%s.convertor.%s' % (self.prj._company_, self.prj._name_, self.package)
        self.mapper_ns = 'com.%s.%s.mapper.%s' % (self.prj._company_, self.prj._name_, self.package)
        self.service_ns = 'com.%s.%s.service.%s' % (self.prj._company_, self.prj._name_, self.package)
    
    def initProtobuf(self):
        self.pb = PBClass(self)
        self.java.pb = self.pb
    
    def initAndroid(self):
        self.android = AndroidClass(self)
        self.java.android = self.android

    def initFMDB(self):
        self.ios = iOSClass(self)

    @property
    def hasBigDecimal(self):
        for c in self.columns:
            if c.isBigDecimal:
                return True
        return False

    def initRef(self, obj_pkgs):
        print 'initRef:', self.name, 'pks:', self.pks
        self.pk = self.pks[0]

        for c in self.columns:
            c.initRef(obj_pkgs)
            if c.ref:
                self.refFields.append(c.ref)
                if c.ref.table.name != self.name:
                    self.impJavas.append(c.ref.java.refJava)
                    if not 't_sys' in c.comment:
                        self.impPBs.append(c.ref.pb.refpb)

    def uniqueImp(self):
        tmp = {}
        for r in self.impJavas:
            tmp[r.name] = r
        self.impJavas = tmp.values()
        #print tmp.keys()

        tmp = {}
        for r in self.impPBs:
            tmp[r.name] = r
        self.impPBs = tmp.values()
    
    def initLinks(self, obj_pkgs):
        for name in self.links:
            child = obj_pkgs[name]
            link = Link(self, child)
            self.linkModels.append(link)
            self.impPBs.append(child.pb)
            self.impJavas.append(child.java)
            child.linkFuncs.append(link)
            child.linkFuncNames.append('%sId' % self.java.name)
            # print child.linkFuncNames

    def initQueryFuncs(self):
        vals = self.cindex.values()
        fs = {}
        # print self.linkFuncNames
        for v in vals:
            j = 1
            unique = v[0]
            for i in range(1, len(v)):
                if i > 1:
                    qf = MySqlQueryFunc([v[i]])
                    if qf.name not in self.linkFuncNames:
                        qf.unique = False
                        fs[qf.name] = qf
                j += 1
                qf = MySqlQueryFunc(v[1:j])
                #print i, j, qf, qf.cols
                qf.unique = unique if len(v) == j else False
                if qf.name not in self.linkFuncNames:
                    fs[qf.name] = qf

        self.funcs = fs.values()
        #print fs

    def mvc_url(self):
        if hasattr(self, 'url'):
            return self.url
        url = self.name
        if self.prefix and len(self.prefix) > 0:
            url = self.name[len(self.prefix):]
        if '_' in url and url.startswith(self.package):
            url = url[len(self.package) + 1:]
        if url.endswith('_'):
            url = url[0:-1]
        url = url.split('_')
        url = [names.pluralize(item) for item in url]
        url = '/'.join(url)
        if url.endswith('/'):
            url = url[0:-1]
        if len(url) > 0:
            url = self.package + '/' + url
        else:
            url = self.package
        self.url = url
        return self.url


class MySqlRef(object):
    """docstring for RefField"""
    def __init__(self, column, obj_pkgs):
        print 'MySqlRef: ', column.name, column.comment, column.table.name

        self.column = column
        self.comment = column.comment
        i = self.comment.index('.')
        self.name = self.comment[1:i]
        self.table = obj_pkgs[self.name]
        if '_id' in column.name:
            self.varName = column.name.replace('_id', '')
        else:
            self.varName = column.name.replace('Id', '')
        self.varNameC = common.upper_first(self.varName)
        self.repeated = column.name.endswith('s')
        self.package = column.package
        self.docComment = '#see %s. %s' % (self.table.java.name, self.comment[i+1:])

        #self.varNameC = upper_first(self.varName)
        #self.mark = 'optional'  # single
        #self.ref_javatype = self.ref_obj.entityName

        #if self.name.endswith('s'):
        #    self.mark = 'repeated'  # many
        #    self.ref_javatype = 'List<%s>' % self.ref_obj.entityName
        
        self.initJava()
        self.initProtobuf()


    def initJava(self):
        self.java = JavaRefField(self, self.table.java)

    def initProtobuf(self):
        self.pb = PBRefField(self, self.table.pb)
        if self.table.name == self.column.table.name:
            self.pb.package = ""


class MySqlColumn(object):
    """docstring for MySqlColumn"""
    def __init__(self, prj, package, row, index, table):
        self.table = table
        self.prj = prj
        self.package = package
        self.name = row[0]  # column_name
        self.nameC = common.upper_first(self.name)
        self.typeName = row[1]  # column_type
        self.null = row[2] == 'YES' or row[2] == '1'  # is_nullable
        self.key = row[3] and (row[3] == 'PRI' or row[3] == '1')  # column_key
        self.default = row[4] if row[4] else None  # column_default
        self.max = row[5] if row[5] else None
        self.comment = row[6]
        self.extra = row[7]
        self.auto_increment = row[7] == 'auto_increment'
        self.index = index
        self.lname = self.name.lower()
        if self.default == 'CURRENT_TIMESTAMP':
            self.default = None
        self.valType = self.typeName.split('(')[0]
        self.docComment = self.comment.replace('@', '#')
        self.unique = None

    @property
    def defaultTips(self):
        if self.default:
            return u'默认为: ' + self.default
        return u''

    @property
    def columnMark(self):
        vals = []
        if self.name != self.java.name:
            vals.append('name=\"%s\"' % self.name)
        if self.key:
            vals.append('pk = true')
            if self.auto_increment:
                vals.append('autoIncrement=true')
        else:
            if self.max:
                vals.append("maxLength=\"%s\"" % self.max)
            if not self.null:
                vals.append("nullable = false")
            if self.default and len(self.default) > 0:
                vals.append("defaultVal = \"%s\"" % self.default)
        if len(vals) > 0:
            return '@Column(%s)' % (', '.join(vals), )
        return '@Column'
    
    @property
    def isString(self):
        return self.typeName.startswith('varchar') or self.typeName.startswith('text') or self.typeName.startswith('nvarchar') or self.typeName.startswith('char') or self.typeName.startswith('nchar')
    
    @property
    def isNumber(self):
        return self.java.typeName in ['Integer', 'Byte', 'Short', 'Long']
    
    @property
    def isBigDecimal(self):
        return self.java.typeName in ['BigDecimal']

    @property
    def isFormField(self):
        return self.isString or self.ref is not None

    def annotationMark(self):
        hint = []
        hint.append(u"@ApiParameterDoc(\"%s\")" % (self.docComment, ))
        name = common.gen_name(self.name, upperFirst=False)
        if self.max:
            hint.append(u'@Length(min=0, max=%s, message="%s_too_long")' % (
                self.max, name))
        if not self.null and self.isString:
            hint.append(u'@NotEmpty(message="%s_empty")' % (name, ))
        if not self.null and self.isNumber:
            hint.append(u'@NotNull(message = "%s_empty")' % name)
        hint.append('')
        return '\n\t'.join(hint)

    def initRef(self, obj_pkgs):
        """
        get java, protobuf ready before initRef
        """
        if self.comment and self.comment.startswith('@'):
            i = self.comment.index('.')
            name = self.comment[1:i]
            table = obj_pkgs.get(name, None)
            if table:
                self.ref = MySqlRef(self, obj_pkgs)
                self.query = True
            else:
                self.ref = None
                self.query = True
        else:
            self.ref = None
            self.query = False
    
    def initJava(self):
        self.java = JavaField(self)

    def initProtobuf(self):
        self.pb = PBField(self)

    def initAndroid(self):
        self.android = AndroidField(self)
    
    def initFMDB(self):
        self.ios = iOSField(self)


class AndroidField(object):

    def __init__(self, column):
        self.column = column
        self.pbType = column.pb.typeName
        self.sqliteType = mapping.pb_sqlite_types.get(self.pbType, '')
        self.typeName = mapping.sqlite_types.get(column.valType, 'text')
        self.binder = mapping.android_sqlite_setter.get(column.valType, 'NULL')
        
    def bindValue(self, tag):
        s = '%s.get%s()' % (tag, self.column.pb.nameC)
        if self.typeName == 'text':
            s = 'filterNull(%s)' % s
        return s

    def rsGetter(self, typeName=None):
        if typeName is None:
            return mapping.android_sqlite_getter.get(self.column.valType, 'NULL')
        else:
            return mapping.android_sqlite_getter.get(typeName, 'NULL')


class AndroidClass(object):

    def __init__(self, table):
        self.table = table

        self.model_ns = 'com.%s.%s.protobuf.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.convertor_ns = 'com.%s.%s.convertor.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.mapper_ns = 'com.%s.%s.mapper.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.service_ns = 'com.%s.%s.service.%s' % (table.prj._company_, table.prj._name_, table.package)
        self.event_ns = 'com.%s.%s.event.%s' % (table.prj._company_, table.prj._name_, table.package)

    @property
    def createTableSql(self):
        cols = []
        for c in self.table.columns:
            if c.key:
                cols.append('%s %s PRIMARY KEY' % (c.pb.name, c.android.sqliteType))
            else:
                cols.append('%s %s' % (c.pb.name, c.android.sqliteType))
        s = SQLITE3_CREATE_SQL_0 % (self.table.pb.name, ', '.join(cols))
        return s


class Sqlite3Column(object):

    def __init__(self, column):
        self.column = column
        self.typeName = mapping.sqlite_types.get(column.valType, 'text')
        self.binder = mapping.sqlite_setter.get(column.valType, 'NULL')
        
    def bindValue(self, tag):
        s = '%s.get%s()' % (tag, self.column.capName)
        if self.typeName == 'text':
            s = 'filterNull(%s)' % s
        return s

    def rsGetter(self, typeName=None):
        if typeName is None:
            return mapping.sqlite_getter.get(self.column.valType, 'NULL')
        else:
            return mapping.sqlite_getter.get(typeName, 'NULL')


class Sqlite3Table(object):

	def __init__(self, table):
		self.table = table
		cols = []
		for c in table.columns:
			if c.key:
				cols.append('%s %s PRIMARY KEY' % (c.name, c.sqlite3.typeName))
			else:
				cols.append('%s %s' % (c.name, c.sqlite3.typeName))
		self.createTableSql = SQLITE3_CREATE_SQL_0 % (table.name, ', '.join(cols))


class iOSField(object):

    def __init__(self, column):
        self.column = column
        self.pbType = column.pb.typeName
        self.sqliteType = mapping.pb_sqlite_types.get(self.pbType, '')
        self.typeName = mapping.pb_ios_types.get(self.pbType, '')
        self.typeRef = self.typeName
        if self.typeName.startswith('NS'):
        	self.typeRef = self.typeName + "*"
        self.rsGetter = mapping.pb_fmdb_getter.get(self.pbType, '')
    
    def valExp(self, tag):
        e = '@(%s.%s)' % (tag, self.column.pb.name)
        if self.pbType == 'string':
            e = '%s.%s' % (tag, self.column.pb.name)
        return e
    
    @property
    def pointer(self):
        return self.typeRef.endswith("*")


class iOSClass(object):

    def __init__(self, table):
        self.table = table
    
    def columns(self):
        return ["@\"%s\"" % c.pb.name for c in self.table.columns]
    
    def columnsInfo(self):
        tmp = ["@\"%s\": @\"%s\"" % (c.pb.name, c.ios.sqliteType) for c in self.table.columns]
        tmp = ", ".join(tmp)
        return "@{%s}" % tmp
