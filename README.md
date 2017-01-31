# Alma SIS Integration - Legacy Data Converter

Scripts that will convert from a variety of text formats to Alma XML, then zip 
and make the files available to Alma.

## Usage

For each institution, this script will look in a fixed location for patron files 
(and any accompanying barcode files), parse the user information using the 
specified mappings, and create an XML document using the provided 
[template file](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/templates/user_xml_v2_template.xml.erb). 

### Make the Magic Happen

For the full experience:

`ruby run.rb any_institution_code_here`

To set the value of the `expiry_date` field to the current day for all users in 
the provided file (these files must be in the `expire` directory):

`ruby run.rb any_institution_code_here expire`

To just generate files and not upload or send notifications:

`ruby run.rb any_institution_code_here dry-run`

To randomly pick 5 patron records from the parsed file and skip archiving of original files, use:

`ruby run.rb any_institution_code_here sample`

## Mappings

+ [Default SIF](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/sif_user.rb#L17)
+ [University of Georgia](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/uga_user.rb#L12)
+ [Georgia State](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/gsu_user.rb#L9)
+ [Georgia Southern](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/ga_sou_user.rb#L9)
+ [Kennesaw State](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/ksu_user.rb#L9)
+ [Valdosta State](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/vsu_user.rb#L9)
+ [West Georgia](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/west_ga_user.rb#L9)
+ [Georgia Perimiter](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/gptc_user.rb#L9)
+ [Gordon State](https://github.com/mksndz/alma-user-integration-legacy-converter/blob/master/lib/classes/users/gordon_user.rb#L9)