# frozen_string_literal: true

module Onebox
  module Engine
    class VinOnebox
      include Engine

      VIN_REGEX = /\Avin:([A-HJ-NPR-Z0-9]{17})\z/i
      matches_regexp VIN_REGEX

      always_https
      requires_content_type

      def vin
        @vin ||= @url.match(VIN_REGEX)[1].upcase
      end

      def to_html
        result = fetch_data

        if result[:year] && result[:make] && result[:model]
          <<~HTML
            <div class="onebox vin-onebox">
              <strong>🚗 #{result[:year]} #{result[:make]} #{result[:model]}</strong><br>
              <code>VIN: #{vin}</code>
            </div>
          HTML
        else
          <<~HTML
            <div class="onebox vin-onebox">
              Could not decode VIN: #{vin}
            </div>
          HTML
        end
      end

      private

      def fetch_data
        api_url = "https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin/#{vin}?format=json"
        response = Onebox::Helpers.fetch_response(api_url, { 'Accept' => 'application/json' })

        json = ::MultiJson.load(response.body)
        result = {}

        json['Results'].each do |r|
          case r['Variable']
          when 'Model Year'
            result[:year] = r['Value']
          when 'Make'
            result[:make] = r['Value']
          when 'Model'
            result[:model] = r['Value']
          end
        end

        result
      rescue => e
        Rails.logger.error("VIN Onebox error: #{e}")
        {}
      end
    end
  end
end
