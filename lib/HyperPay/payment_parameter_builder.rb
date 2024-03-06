module HyperPay
  class PaymentParameterBuilder
    REQUIRED_PARAMETERS = %w[entityId customer.email customer.mobile customer.givenName customer.surname billing.street1 billing.city billing.state billing.country billing.postcode customParameters[3DS2_enrolled] merchantTransactionId paymentType currency amount].freeze

    attr_reader :parameters

    def initialize
      @parameters = {}
    end

    # Implementation of `add` method returns `self` to allow chaining
    def add(key, value)
      @parameters[key] = value
      self # Return self to allow chaining
    end

    def validate!
      missing_params = REQUIRED_PARAMETERS - @parameters.keys
      unless missing_params.empty?
        raise ArgumentError, "Missing required parameters: #{missing_params.join(', ')}"
      end
    end
  end
end
