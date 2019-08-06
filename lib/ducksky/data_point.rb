module Ducksky
  class DataPoint
    attr_reader(
      :summary,
      :humidity,
      :precip_probability,
      :precip_type
    )

    def initialize(weather_hash, temperature_convertor: CelciusConvertor)
      @time = weather_hash["time"]
      @summary = weather_hash["summary"]
      @temperature = weather_hash["temperature"]
      @temperature_high = weather_hash["temperatureHigh"]
      @temperature_low = weather_hash["temperatureLow"]
      @apparent_temperature_high = weather_hash["apparentTemperatureHigh"]
      @apparent_temperature_low = weather_hash["apparentTemperatureLow"]
      @humidity = weather_hash["humidity"]
      @precip_probability = weather_hash["precipProbability"]
      @precip_type = weather_hash["precipType"]

      @temperature_convertor = temperature_convertor
    end

    def date
      Time.at(@time)
    end

    def temperature_high
      @temperature_convertor.new(@temperature_high).convert
    end

    def temperature_low
      @temperature_convertor.new(@temperature_low).convert
    end

    def apparent_temperature_high
      @temperature_convertor.new(@apparent_temperature_high).convert
    end

    def apparent_temperature_low
      @temperature_convertor.new(@apparent_temperature_low).convert
    end
  end

  class CelciusConvertor
    FAHRENHEIT = 'fahrenheit'

    def initialize(temperature, unit: FAHRENHEIT)
      @temperature = temperature
      @unit = unit
    end

    def convert
      if @unit == FAHRENHEIT
        (@temperature - 32) * 5/9
      else
        raise "Conversion to #{@unit} is not supported"
      end
    end
  end
end
  