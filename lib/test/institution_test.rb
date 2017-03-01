require 'minitest/autorun'
require 'yaml'
require 'net/smtp'
require 'uri'
require './lib/classes/institution'

class InstitutionTest < MiniTest::Test

  def setup

    @inst = Institution.new('test_sif')
    @multi_campus_inst = Institution.new('test_multi_campus')

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

  def test_has_array_of_notification_emails

    emails = @inst.notification_emails

    assert_kind_of Array, emails
    assert_match URI::MailTo::EMAIL_REGEXP, emails[0]

  end

  def test_has_logger

    assert_kind_of Logger, @inst.logger

  end

  def test_has_groups_data_hash

    assert_kind_of Hash, @inst.groups_data

  end

  def test_has_boolean_methods

    bools = [true, false]

    assert_includes bools, @inst.expect_barcodes?

  end

  def test_has_alma_archive_path

    assert_equal '/gilftpfiles/test_sif/archive', @inst.alma_archive_path

  end

  def test_has_raw_archive_path

    assert_equal '/gilftpfiles/test_sif/archive/raw', @inst.raw_archive_path

  end

  # multi-campus

  def test_has_campuses

    assert_kind_of Array, @multi_campus_inst.campuses
    assert_kind_of Campus, @multi_campus_inst.campuses.first

  end

end