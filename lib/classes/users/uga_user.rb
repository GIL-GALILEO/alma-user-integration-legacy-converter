require './lib/classes/user'
require 'csv'

class UgaUser < User

  attr_accessor :name

  # todo: distinguish between a value where we want to use a default string value, and one we want to leave blank/nil
  MAPPING = {
      primary_id:                       0,
      name:                             1,
      gender:                           nil,
      user_group:                       2,
      campus_code:                      nil,
      status:                           nil,
      primary_address_line_1:           3,
      primary_address_line_2:           nil,
      primary_address_city:             4,
      primary_address_state_province:   5,
      primary_address_postal_code:      6,
      primary_address_country:          nil,
      primary_address_phone:            7,
      email:                            14,
      secondary_id:                     22,
  }

  def initialize(line_data, institution)
    @institution = institution
    @parsed_line = CSV.parse_line(line_data, col_sep: '|')
    MAPPING.each do |attr, index|
      if index
        value = @parsed_line[index]
        self.send("#{attr}=", value ? value.strip : '')
      else
        self.send("#{attr}=", 'DEFAULT_VALUE')
      end
    end
  end

  def name=(full_name)
    @name = full_name
    names = full_name.split(',')
    names.map!(&:strip)
    self.last_name = names[0]
    other_names = names[1].split(' ')
    self.first_name = other_names[0]
    self.middle_name = other_names[1] if other_names[1]
  end

  def user_group=(user_group)
    cc = class_code
    dept = department

    if dept
      # obviously staff or faculty?
    end

    # undergrad_ccs = @institution
    #
    # if undergrad_ccs.include? cc.to_i
    #   # we have an undergrad
    # elsif undergrad_ccs.include? cc.to_i
    #   # we have a grad
    # else
    #   # we have nothing. staff?
    # end

  end

  def class_code
    @class_code = @parsed_line[16]
  end

  def department
    @department = @parsed_line[20]
  end

end