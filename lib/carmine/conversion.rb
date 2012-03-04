class Carmine
  # Internal: Query string conversion utilities.
  module Conversion
    extend self

    # Public: Jsonifies the request :query values to a query string.
    #
    # Examples
    #
    #   Converter.to_param :options => { :cssclass => :color }
    #   # => options=%7B%22cssclass%22%3A%22color%22%7D
    #
    # Returns the uri encoded query string.
    def to_params(query)
      params = query.map { |key, value| normalize_param key, value }.join
      params.chop!
      params
    end

    private

    def normalize_param(key, value)
      [Array, Hash].each { |kind| value = value.to_json if value.is_a? kind }
      HTTParty::HashConversions.normalize_param key, value
    end
  end
end
