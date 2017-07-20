require 'csv'

# new patron class to eventually replace User
# receives a CSV file and stores patron info
class Patron
  FIELDS = %w(
    primary_id
    primary_group
    secondary_group
    first_name
    middle_name
    last_name
    gender
    campus_code
    status
    expiration_date
    primary_address_line_1
    primary_address_line_2
    primary_address_city
    primary_address_state_province
    primary_address_postal_code
    primary_address_country
    secondary_address_line_1
    secondary_address_line_2
    secondary_address_city
    secondary_address_state_province
    secondary_address_postal_code
    secondary_address_country
    primary_phone
    secondary_phone
    primary_email
    secondary_email
    barcode
    secondary_id
  ).freeze
  attr_accessor *FIELDS

  def initialize(csv_line, institution = nil)
    @institution = institution
    parse_csv csv_line
    populate_fields
  end

  private

  def populate_fields
    data = parsed_csv csv_line
  end

  def parse_csv(line)
    @csv_data = CSV.parse_line line
  end

  def populate_fields
    FIELDS.each_with_index do |field, i|
      populate_field field, @csv_data[i]
    end
  end

  def populate_field(field, value)
    send "#{field}=", clean(value)
  end

  def clean(value)
    return unless value
    value.strip
  end


end