# Alma SIS Integration - Legacy Data Converter

Scripts that will convert from a variety of text formats to Alma XML, then zip and upload the files to a secure server.

## Usage

Currently supports detection and processing the following kinds of files:

+ patron data file in a supported format
+ barcode file mapping primary identifiers to barcodes
+ expiration date file setting expiration date for patron records

##### With Your Own Data Files

`ruby run.rb any_institution_code_here`

## Mappings

+ [sif](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/sif_user.rb#L17)
+ [txt](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/txt_user.rb#L9)
+ [gsu](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/gsu_user.rb#L8)

## Running Tests

Tests test that classes do what they are supposed to do.

`ruby lib/test/sif_user_test.rb`

`ruby lib/test/txt_user_test.rb`

`ruby lib/test/gsu_user_test.rb`

`ruby lib/test/institution_test.rb`

`ruby lib/test/templater_test.rb`

`ruby lib/test/user_factory_test.rb`

`ruby lib/test/xml_factory_test.rb`

## To Do
+ pull contacts and configs via API
+ improved zip and upload handling
+ email notifications
+ finish field handling for txt type
+ More tests
+ _Validation of controlled values using Alma Configuration API?_

