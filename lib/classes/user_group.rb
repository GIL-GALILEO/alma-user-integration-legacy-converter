require './lib/errors/no_group_mapping_error'

# functionality for patron user_group including support for weighting
class UserGroup
  attr_accessor :type, :alma_name, :banner_name, :weight, :institution, :exp_days

  def initialize(institution, campus, banner_name = nil, fs_codes = nil, class_code = nil)
    self.institution = institution
    create_group_data banner_name, fs_codes, campus, class_code
    copy_config_values
  end

  def heavier_than?(user_group)
    user_group.weight < weight
  end

  def to_s
    alma_name
  end

  def facstaff?
    type == 'facstaff'
  end

  def student?
    type == 'student'
  end

  private

  def copy_config_values
    if @data && @data['alma_name'] && @data['weight']
      self.alma_name = @data['alma_name']
      self.weight = @data['weight'].to_i
      self.type = @data['type']
      self.exp_days = @data['exp_days']
    else
      fail NoGroupMappingError, 'Insufficient data to properly map group, using default.'
    end
  end

  def create_group_data(banner_name, fs_codes, campus, class_code)
    @data = nil
    if banner_name && banner_name != ''
      create_from_banner banner_name, campus
    elsif fs_codes
      fail(
        NotImplementedError,
        'FS Codes cannot be translated to User Groups if a Campus has been provided.'
      ) if campus
      create_from_fs_codes fs_codes, class_code
    end
  end

  def create_from_banner(banner_name, campus = nil)
    groups_settings = if campus
                        campus.groups_settings
                      else
                        institution.groups_settings
                      end
    self.banner_name = banner_name
    @data = groups_settings[banner_name]
  end

  def create_from_fs_codes(fs_codes, class_code)
    # ug students who are staff should be set as ug students
    if (fs_codes.include?('00') || fs_codes.include?('65') ) && fs_codes.include?('02') && (class_code == 'U' || class_code == 'G')
      @data = institution.groups_settings[institution.groups_data['00']]
    else
      fs_codes.each do |fs_code|
        next unless institution.groups_data.key? fs_code
        alma_name = institution.groups_data[fs_code]
        group_settings = institution.groups_settings[alma_name]
        if fs_code == '00' && (class_code == 'G' || class_code == 'P')
          group_settings = institution.groups_settings[institution.groups_data['ZZ']]
        end
        if !@data || group_settings['weight'] > @data['weight']
          @data = group_settings
        end
      end
    end
  end

end