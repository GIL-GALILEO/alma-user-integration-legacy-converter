class UserGroup

  attr_accessor :alma_name, :banner_name, :exp_date_days, :weight, :institution

  def initialize(institution, campus, banner_name = nil, fs_codes = nil)

    self.institution = institution

    data = nil

    groups_settings = campus ? campus.groups_settings : institution.groups_settings

    if banner_name

      self.banner_name = banner_name

      data = groups_settings[banner_name]

    elsif fs_codes

      raise NotImplementedError.new('FS Codes cannot be translated to User Groups if a Campus has been provided.') if campus

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

  end

  def is_heavier_than?(user_group)

    user_group.weight < weight

  end

  def to_s
    alma_name
  end

end