require 'alma_api'

class Api

  HOST = 'https://api-na.hosted.exlibrisgroup.com'.freeze

  attr_reader :client

  def initialize(institution)
    @client = AlmaApi::Client.new(apikey: institution.apikey, host: HOST)
  end

  def exists?(primary_id)
    user(primary_id)
  end

  def user(primary_id)
    @client.users(primary_id).get
  end

  def update(primary_id, user_xml)
    response = put "/v1/users/#{primary_id}", user_xml
    response
  end

  def create(user_xml)
    response = post '/v1/users', user_xml
    response
  end

  private

  def post(path, xml)
    @client.http(:post, path, xml)
  end

  def put(path, xml)
    @client.http(:put, path, xml)
  end

end