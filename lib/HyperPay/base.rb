# frozen_string_literal: true

require "httparty"
require "HyperPay/configuration"

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
      request(:post, path, body: encoded_payload, headers: { "Content-Type" => "application/x-www-form-urlencoded" })
    end

    def put(path, payload = {})
      request(:put, path, payload)
    end

    def delete(path)
      request(:delete, path)
    end

    def request(method, path, options = {})
      prepare_headers(options)
      prepare_body(options)
      response = self.class.send(method, path, options)
      JSON.parse(response.body)
    rescue HTTParty::Error, StandardError => e
      { error: e.message }
    end


    def parse_response(response)
      JSON.parse(response.body)
    end

    def base_url
      HyperPay.configuration.environment == :sandbox ? "https://eu-test.oppwa.com" : "https://eu-prod.oppwa.com"
    end

    private

    def prepare_headers(options)
      content_type = options.dig(:headers, "Content-Type") == "application/x-www-form-urlencoded" ?
                       "application/x-www-form-urlencoded" : "application/json"
      default_headers = {
        "Authorization" => "Bearer #{HyperPay.configuration.authorization}",
        "Accept" => "application/json",
        "Content-Type" => content_type
      }
      options[:headers] = default_headers.merge(options[:headers] || {})
    end

    def prepare_body(options)
      if options[:body] && options[:headers]["Content-Type"] == "application/json"
        options[:body] = options[:body].to_json unless options[:body].is_a?(String)
      end
    end
  end
end
