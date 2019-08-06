require 'httparty'
require "ducksky/version"
require "ducksky/response"
require "ducksky/data_point"

module Ducksky
  class Error < StandardError; end

  class Client
    include HTTParty
    base_uri 'https://api.darksky.net'

    def initialize(api_key:)
      @api_key = api_key
    end

    def time_machine_request(lat:, lon:, time:)
      response = self.class.get("/forecast/#{api_key}/#{lat},#{lon},#{time.iso8601}")

      # TODO: catch error if response.code is not 2XX

      Ducksky::Response.new(response.parsed_response)
    end

    private

    attr_reader :api_key
  end

end
