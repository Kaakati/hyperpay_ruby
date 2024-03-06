module HyperPay
  class Configuration
    attr_accessor :authorization, :environment

    def initialize
      @environment = :sandbox # Default to sandbox
    end
  end
end
