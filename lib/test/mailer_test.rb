require 'minitest/autorun'
require './lib/classes/institution'

class MailerTest < Minitest::Test

  def setup

    @institution = Institution.new('test_sif')

  end

  def test_mailer_created

    assert_kind_of Mailer, @institution.mailer

  end

  def test_add_file_error_to_mailer

    error = 'The Job Totally Failed due to a file error'

    @institution.mailer.add_file_error_message error

    assert_equal [error], @institution.mailer.file_errors

  end

  def test_add_script_error_to_mailer

    error = 'The Job Totally Failed due to a script error'

    @institution.mailer.add_script_error_message error

    assert_equal [error], @institution.mailer.script_errors

  end

  def test_add_result_to_mailer

    result = 'The Job ran perfectly'

    @institution.mailer.add_result_message result

    assert_equal [result], @institution.mailer.results

  end

end