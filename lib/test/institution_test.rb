require 'minitest/autorun'
require 'yaml'
require 'net/smtp'
require 'uri'
require './lib/classes/institution'

class InstitutionTest < MiniTest::Test

  def setup

    @inst = Institution.new('test_sif')

  end

  def test_error_on_missing_config

    assert_raises StandardError do
      Institution.new('zoia')
    end

  end

  def test_has_code

    assert_equal @inst.code, 'test_sif'

  end

  def test_barcode_separator

    assert_equal @inst.barcode_separator, '|'

  end

  def test_default_user_group

    assert_equal @inst.default_user_group, 'DEFAULT'

  end

  def test_default_exp_date_days

    assert_equal @inst.default_exp_date_days, 365

  end

  def test_has_array_of_notification_emails

    emails = @inst.notification_emails

    assert_kind_of Array, emails
    assert_match URI::MailTo::EMAIL_REGEXP, emails[0]

  end

  def test_has_nil_for_path_if_no_path_set

    assert_nil @inst.path

  end

  def test_returns_nil_if_no_parent

    assert_nil @inst.parent_inst

  end

  def test_has_path

    inst = Institution.new('test_sif_campus2')

    assert_equal 'campus2', inst.path

  end

  def test_can_have_parent_institution

    inst = Institution.new('test_sif_campus2')

    assert_kind_of Institution, inst.parent_inst
    assert_equal 'test_sif', inst.parent_inst.code

  end

  def test_has_logger

    assert_kind_of Logger, @inst.logger

  end

  def test_has_groups_data_hash

    assert_kind_of Hash, @inst.groups_data

  end

  def test_has_boolean_methods

    bools = [true, false]

    assert_includes bools, @inst.expect_sif?
    assert_includes bools, @inst.expect_txt?
    assert_includes bools, @inst.process_facstaff?
    assert_includes bools, @inst.expect_barcodes?
    assert_includes bools, @inst.expect_exp_date?
    assert_includes bools, @inst.autoexpire_missing_users?

  end

  def test_has_alma_archive_path

    assert_equal '/gilftpfiles/test_sif/archive', @inst.alma_archive_path

  end

  def test_has_raw_archive_path

    assert_equal '/gilftpfiles/test_sif/archive/raw', @inst.raw_archive_path

  end

end