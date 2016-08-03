#!/usr/bin/env python
# -*- coding: utf-8 -*-

java_types = {
    'int': 'Integer',
    'tinyint': 'Boolean',
    'smallint': 'Short',
    'mediumint': 'Integer',
    'bigint': 'Long',
    'bit': 'Byte',

    'float': 'Float',
    'decimal': 'BigDecimal',
    'double': 'Double',

    'text': 'String',
    'varchar': 'String',
    'nvarchar': 'String',
    'char': 'String',
    'nchar': 'String',
    'enum': 'String',

    'datetime': 'Date',
    'date': 'Date',
    'timestamp': 'Date',
    'time': 'Date'
}

jdbc_setter = {
    'int': 'setInt',
    'tinyint': 'setBoolean',
    'smallint': 'setShort',
    'mediumint': 'setInt',
    'bigint': 'setLong',
    'bit': 'setByte',

    'float': 'setFloat',
    'decimal': 'setBigDecimal',
    'double': 'setDouble',

    'text': 'setString',
    'varchar': 'setString',
    'nvarchar': 'setString',
    'char': 'setString',
    'nchar': 'setString',
    'enum': 'setString',

    'datetime': 'setTimestamp',
    'date': 'setDate',
    'timestamp': 'setTimestamp',
    'time': 'setTime'
}

jdbc_value_funcs = {
    "datetime": 'new java.sql.Timestamp(%s.getTime())',
    'date': 'new java.sql.Date(%s.getTime())',
    'timestamp': 'new java.sql.Timestamp(%s.getTime())',
    'time': 'new java.sql.Time(%s.getTime())'
}

jdbc_getter = {
    'int': 'getInt',
    'tinyint': 'getBoolean',
    'smallint': 'getShort',
    'mediumint': 'getInt',
    'bigint': 'getLong',
    'bit': 'getByte',

    'float': 'getFloat',
    'decimal': 'getDecimal',
    'double': 'getDouble',

    'text': 'getString',
    'varchar': 'getString',
    'nvarchar': 'getString',
    'char': 'getString',
    'nchar': 'getString',
    'enum': 'getString',

    'datetime': 'getDate',
    'date': 'getDate',
    'timestamp': 'getTimestamp',
    'time': 'getTime'
}

protobuf_types = {
    'int': 'int32',
    'tinyint': 'int32',
    'smallint': 'int32',
    'mediumint': 'int32',
    'bigint': 'int64',
    'bit': 'int32',

    'float': 'float',
    'decimal': 'double',
    'double': 'double',

    'text': 'string',
    'varchar': 'string',
    'nvarchar': 'string',
    'char': 'string',
    'nchar': 'string',
    'enum': 'string',

    'datetime': 'int64',
    'date': 'int64',
    'timestamp': 'int64',
    'time': 'int64'
}

ios_types = {
    'int': 'int',
    'tinyint': 'int',
    'smallint': 'int',
    'mediumint': 'int',
    'bigint': 'long',
    'bit': 'int',

    'float': 'float',
    'decimal': 'float',
    'double': 'double',

    'text': 'NSString',
    'varchar': 'NSString',
    'nvarchar': 'NSString',
    'char': 'NSString',
    'nchar': 'NSString',
    'enum': 'NSString',

    'datetime': 'NSDate',
    'date': 'NSDate',
    'timestamp': 'NSDate',
    'time': 'NSDate'
}

pb_ios_types = {
    'int32': 'int',
    'int64': 'long',
    'float': 'float',
    'double': 'double',
    'string': 'NSString'
}

pb_sqlite_types = {
    'int32': 'integer',
    'int64': 'integer',
    'float': 'real',
    'double': 'real',
    'string': 'text'
}

sqlite_types = {
    'int': 'integer',
    'tinyint': 'integer',
    'smallint': 'integer',
    'mediumint': 'integer',
    'bigint': 'integer',
    'bit': 'integer',

    'float': 'real',
    'decimal': 'real',
    'double': 'real',

    'text': 'text',
    'varchar': 'text',
    'nvarchar': 'text',
    'char': 'text',
    'nchar': 'text',
    'enum': 'text',

    'datetime': 'integer',
    'date': 'integer',
    'timestamp': 'integer',
    'time': 'integer',
    'byte[]': 'blob'
}

android_sqlite_setter = {
    'int': 'bindLong',
    'tinyint': 'bindLong',
    'smallint': 'bindLong',
    'mediumint': 'bindLong',
    'bigint': 'bindLong',
    'bit': 'bindLong',

    'float': 'bindDouble',
    'decimal': 'bindDouble',
    'double': 'bindDouble',

    'text': 'bindString',
    'varchar': 'bindString',
    'nvarchar': 'bindString',
    'char': 'bindString',
    'nchar': 'bindString',
    'enum': 'bindString',

    'datetime': 'bindLong',
    'date': 'bindLong',
    'timestamp': 'bindLong',
    'time': 'bindLong',
    'byte[]': 'bindBlob'
}

android_sqlite_getter = {
    'int': 'getInt',
    'tinyint': 'getShort',
    'smallint': 'getInt',
    'mediumint': 'getInt',
    'bigint': 'getLong',
    'bit': 'getShort',

    'float': 'getFloat',
    'decimal': 'getDouble',
    'double': 'getDouble',

    'text': 'getString',
    'varchar': 'getString',
    'nvarchar': 'getString',
    'char': 'getString',
    'nchar': 'getString',
    'enum': 'getString',

    'datetime': 'getLong',
    'date': 'getLong',
    'timestamp': 'getLong',
    'time': 'getLong',
    'byte[]': 'getBlob'
}

pb_sqlite_getter = {
    'int32': 'getInt',
    'int64': 'getLong',
    'float': 'getFloat',
    'double': 'getDouble',
    'string': 'getString'
}

fmdb_getter = {
    'int': 'intForColumnIndex',
    'tinyint': 'intForColumnIndex',
    'smallint': 'intForColumnIndex',
    'mediumint': 'intForColumnIndex',
    'bigint': 'longForColumnIndex',
    'bit': 'intForColumnIndex',

    'float': 'doubleForColumnIndex',
    'decimal': 'doubleForColumnIndex',
    'double': 'doubleForColumnIndex',

    'text': 'stringForColumnIndex',
    'varchar': 'stringForColumnIndex',
    'nvarchar': 'stringForColumnIndex',
    'char': 'stringForColumnIndex',
    'nchar': 'stringForColumnIndex',
    'enum': 'stringForColumnIndex',

    'datetime': 'dateForColumnIndex',
    'date': 'dateForColumnIndex',
    'timestamp': 'dateForColumnIndex',
    'time': 'dateForColumnIndex',
    'byte[]': 'dataForColumnIndex'
}

pb_fmdb_getter = {
    'int32': 'intForColumnIndex',
    'int64': 'longForColumnIndex',

    'float': 'doubleForColumnIndex',
    'double': 'doubleForColumnIndex',

    'string': 'stringForColumnIndex'
}

cpp_types = {
    'int': 'uint32_t',
    'tinyint': 'uint32_t',
    'smallint': 'uint32_t',
    'mediumint': 'uint32_t',
    'bigint': 'uint64_t',
    'bit': 'uint32_t',

    'float': 'float',
    'decimal': 'float',
    'double': 'double',

    'text': 'std::string',
    'varchar': 'std::string',
    'nvarchar': 'std::string',
    'char': 'std::string',
    'nchar': 'std::string',
    'enum': 'std::string',

    'datetime': 'uint64_t',
    'date': 'uint64_t',
    'timestamp': 'uint64_t',
    'time': 'uint64_t'
}

cpp_objcs = {
    'int': 'cppUInt32ToInt',
    'tinyint': 'cppUInt32ToInt',
    'smallint': 'cppUInt32ToInt',
    'mediumint': 'cppUInt32ToInt',
    'bigint': 'cppUInt64ToLong',

    'float': 'cppFloatToFloat',
    'decimal': 'cppFloatToFloat',
    'double': 'cppDoubleToDouble',

    'text': 'cppStringToObjc',
    'varchar': 'cppStringToObjc',
    'nvarchar': 'cppStringToObjc',
    'char': 'cppStringToObjc',
    'nchar': 'cppStringToObjc',
    'enum': 'cppStringToObjc',
    
    'datetime': 'cppDateToObjc',
    'date': 'cppDateToObjc',
    'timestamp': 'cppDateToObjc',
    'time': 'cppDateToObjc'
}

objc_cpps = {
    'int': 'cppUInt32ToInt',
    'tinyint': 'cppUInt32ToInt',
    'smallint': 'cppUInt32ToInt',
    'mediumint': 'cppUInt32ToInt',
    'bigint': 'cppUInt64ToLong',
    'bit': 'cppUInt32ToInt',

    'float': 'cppFloatToFloat',
    'decimal': 'cppFloatToFloat',
    'double': 'cppDoubleToDouble',

    'text': 'objcStringToCpp',
    'varchar': 'objcStringToCpp',
    'nvarchar': 'objcStringToCpp',
    'char': 'objcStringToCpp',
    'nchar': 'objcStringToCpp',
    'enum': 'objcStringToCpp',

    'datetime': 'objcDateToCpp',
    'date': 'objcDateToCpp',
    'timestamp': 'objcDateToCpp',
    'time': 'objcDateToCpp'
}