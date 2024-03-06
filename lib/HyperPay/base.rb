require 'httparty'
require 'HyperPay/configuration'

module HyperPay
  class Base
    include HTTParty

    def initialize
      self.class.base_uri base_url
    end

    private

    def get(path)
      request(:get, path)
    end

    def post(path, payload = {})
      encoded_payload = URI.encode_www_form(payload)
      request(:post, path, body: encoded_payload, headers: {'Content-Type' => 'application/x-www-form-urlencoded'})
    end

    def put(path, payload = {})
      request(:put, path, payload)
    end

    def delete(path)
      request(:delete, path)
    end
    # Other private methods remain unchanged

    def request(method, path, options = {})
      default_headers = {
        'Authorization' => "Bearer #{HyperPay.configuration.authorization}",
        'Accept' => 'application/json'
      }

      # If the Content-Type is not explicitly set to 'application/x-www-form-urlencoded',
      # assume JSON payload and set the Content-Type to 'application/json'.
      unless options[:headers] && options[:headers]['Content-Type'] == 'application/x-www-form-urlencoded'
        default_headers['Content-Type'] = 'application/json'
        # Convert the body to JSON unless it's already encoded as a URL-encoded string
        options[:body] = options[:body].to_json if options[:body] && !options[:body].is_a?(String)
      end

      # Merge the headers with the default headers, giving precedence to the options passed in
      options[:headers] = default_headers.merge(options[:headers] || {})

      response = self.class.send(method, path, options)
      JSON.parse(response.body)
    rescue HTTParty::Error => e
      { error: e.message }
    rescue StandardError => e
      { error: e.message }
    end

    def parse_response(response)
      JSON.parse(response.body)
    end

    def base_url
      HyperPay.configuration.environment == :sandbox ? 'https://eu-test.oppwa.com' : 'https://eu-prod.oppwa.com'
    end
  end
end

