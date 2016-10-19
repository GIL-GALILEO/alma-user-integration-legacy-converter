# Alma SIS Integration - Legacy Data Converter

Scripts that will convert from a variety of text formats to Alma XML, then zip and upload the files to a secure server.

## Usage

Currently supports detection and processing the following kinds of files:

+ patron data file in either `sif` or `csv` (pipe delimited) format
+ barcode file mapping primary identifiers to barcodes
+ expiration date file setting expiration date for patron records

##### With Your Own Data Files

`ruby run.rb any_institution_code_here`

## Mappings

+ [sif](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/objects/sif_user.rb#L7)
+ [txt](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/objects/txt_user.rb#L7)

## Running Tests

Tests test that objects do what they are supposed to do.

`ruby lib/test/sif_user_test.rb`

`ruby lib/test/txt_user_test.rb`

`ruby lib/test/templater_test.rb`

`ruby lib/test/user_factory_test.rb`

`ruby lib/test/institution_test.rb`

## To Do
+ improved zip and upload handling
+ email notifications
+ support expiration date in template
+ support secondary (and tertiary?) identifiers in template
+ finish User Group, Campus Code and other mystery field handling
+ More tests
+ _Validation of controlled values using Alma Configuration API?_

