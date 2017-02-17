class UserGroup

  attr_accessor :alma_name, :banner_name, :exp_date_days, :weight, :institution

  def initialize(institution, banner_name = nil, fs_codes = nil)

    self.institution = institution

    data = nil

    if banner_name

      self.banner_name = banner_name

      data = institution.groups_settings[banner_name]


    elsif fs_codes

      fs_codes.each do |fs_code|

        if institution.groups_data.has_key? fs_code

          alma_name = institution.groups_data[fs_code]
          group_settings = institution.groups_settings[alma_name]
          data = group_settings if !data || group_settings['weight'] > data['weight']

        end

      end

    end

    if data &&
        data['alma_name'] &&
        data['weight'] &&
        data['exp_date_days']
      self.alma_name = data['alma_name']
      self.weight = data['weight'].to_i
      self.exp_date_days = data['exp_date_days']
    else
      raise StandardError.new
    end

    self

  end

  def is_heavier_than?(user_group)

    user_group.weight < weight

  end

  def to_s
    alma_name
  end

end