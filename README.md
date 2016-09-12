# Alma SIS Integration - Legacy Data Converter

Scripts that will convert from a variety of text formats to something compatible with Alma (Alma XML)

## Usage

##### With Included Sample Data

Will output to `/data/sample/output.xml`. Also, will place zip file on GIL FTP server in `/test`

`ruby run.rb`

##### With Your Own Data File

Only txt files (pipe delimited) and sif files (column delimited) currently supported

`ruby run.rb '/path/to/input_file.txt' 'path/to/output_file.xml'`

## Mappings

+ [sif](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/objects/sif_user.rb#L7)
+ [txt](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/objects/txt_user.rb#L7)

## Running Tests

Tests test that file lines are properly parsed into User objects

`ruby lib/test/sif_user_test.rb`

`ruby lib/test/txt_user_test.rb`

## To Do
+ better default value handling (e.g. secondary_id)
+ User Group, Campus Code and other mystery fields
+ More tests
+ _Validation of controlled values using Alma Configuration API?_

