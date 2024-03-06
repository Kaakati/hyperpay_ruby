# frozen_string_literal: true

require_relative "HyperPay/version"
require_relative "HyperPay/configuration"
require_relative "HyperPay/copy_and_pay"

module HyperPay
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end

end
