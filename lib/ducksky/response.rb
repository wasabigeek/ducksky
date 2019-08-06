require 'ducksky/data_point'

module Ducksky
  class Response
    attr_reader(
      :latitude,
      :longitude,
      :timezone,
      :currently,
      :hourly,
      :daily
    )

    def initialize(response_hash)
      @latitude = response_hash["latitude"]
      @longitude = response_hash["longitude"]
      @timezone = response_hash["timezone"]
      @currently = Ducksky::DataPoint.new(response_hash["currently"])
      @hourly = response_hash["hourly"]["data"].map { |slice| Ducksky::DataPoint.new(slice) }
      @daily = response_hash["daily"]["data"].map { |slice| Ducksky::DataPoint.new(slice) }
    end
  end
end
