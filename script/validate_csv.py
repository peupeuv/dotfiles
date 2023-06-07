import pandas as pd
import pandas_schema
from pandas_schema import Column
from pandas_schema.validation import CustomElementValidation
import numpy as np
from decimal import *
import datetime
import re
import sys

def check_decimal(dec):
    try:
        Decimal(dec)
    except InvalidOperation:
        return False
    return True


def check_int(num):
    try:
        int(num)
    except ValueError:
        return False
    return True

def check_date(date):
    if isinstance(date, str):  # Check if input is a string
        try:
            datetime.datetime.strptime(date, '%Y-%m-%d %H:%M:%S.%f')
            return True
        except ValueError:
            return False
    return False

def check_varchar(string, length):
    try:
        if len(string) <= length:
            return True
        else:
            return False
    except TypeError:
        return False

def check_tinyint(num):
    if num in ['0', '1']:
        return True
    return False

def check_varchar_N(string):
    if string == "\\N":
        return True
    return False

def check_varchar_no_whitespace_alnum(string):
    if re.match('^[A-Za-z0-9]*$', string) and ' ' not in string:
        return True
    return False

def do_validation(filename):
    # read the data
    column_names = ['col0', 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7', 'col8', 'col9', 'col10', 'col11', 'col12', 'col13', 'col14']

    data = pd.read_csv(filename,header=None,names=column_names,dtype=str)

    if len(data.columns) != len(column_names):
        raise ValueError("Number of columns in the given file does not match the expected number")


    # define validation elements
    null_validation = [CustomElementValidation(lambda d: d is not np.nan, 'this field cannot be null')]
    decimal_validation = [CustomElementValidation(lambda d: check_decimal(d), 'is not decimal')]
    int_validation = [CustomElementValidation(lambda i: check_int(i), 'is not integer')]
    date_validation = [CustomElementValidation(lambda d: check_date(d), 'is not in the correct date format')]
    varchar_validation = [CustomElementValidation(lambda v: check_varchar(v,50), 'is not a valid varchar(50)')]
    tinyint_validation = [CustomElementValidation(lambda t: check_tinyint(t), 'is not a valid tinyint (0 or 1)')]
    varchar_N_validation = [CustomElementValidation(lambda v: check_varchar_N(v), 'is not "\\N"')]
    varchar_no_whitespace_alnum_validation = [CustomElementValidation(lambda v: check_varchar_no_whitespace_alnum(v), 'is not a valid varchar without whitespace and only alphanumeric')]

        # define validation schema
    schema = pandas_schema.Schema([
            Column('col0', varchar_validation + null_validation),
            Column('col1', varchar_validation + null_validation),
            Column('col2', varchar_validation + null_validation),
            Column('col3', int_validation + null_validation),
            Column('col4', date_validation + null_validation),
            Column('col5', decimal_validation + null_validation),
            Column('col6', decimal_validation + null_validation),
            Column('col7', decimal_validation + null_validation),
            Column('col8', decimal_validation + null_validation),
            Column('col9', int_validation + null_validation),
            Column('col10', int_validation + null_validation),
            Column('col11', varchar_validation + null_validation),
            Column('col12', varchar_validation + null_validation),
            Column('col13', varchar_N_validation + null_validation),
            Column('col14', tinyint_validation + null_validation)
    ])

    # apply validation
    errors = schema.validate(data)
    errors_index_rows = [e.row for e in errors]
    data_clean = data.drop(index=errors_index_rows)

    for error in errors:
        print(error)

    # save data
    pd.DataFrame({'col':errors}).to_csv('errors.csv')
    data_clean.to_csv('clean_data.csv')

if __name__ == '__main__':
    try:
        if len(sys.argv) != 2:
            print("Usage: python validation.py <filename>")
            sys.exit(1)

        filename = sys.argv[1]
        do_validation(filename)

    except Exception as e:
        print(e)
