# frozen_string_literal: true

class ResponseCodeInterpreter
  CONSTANTS = {
    transaction_succeeded: /^(000.000.|000.100.1|000.[36]|000.400.1[12]0)/,
    transaction_succeeded_review: /^(000.400.0[^3]|000.400.100)/,
    transaction_pending: /^(000\.200)/,
    transaction_declined: /^(800\.[17]00|800\.800\.[123])/,
    rejected_communication_error: /^(900\.[1234]00|000\.400\.030)/,
    rejected_system_error: /^(800\.[56]|999\.|600\.1|800\.800\.[84])/,
    rejected_for_risk: /^(100\.400\.[0-3]|100\.380\.100|100\.380\.11|100\.380\.4|100\.380\.5)/,
    reject_blacklist: /^(800\.[32])/,
    reject_risk_validation: /^(800\.1[123456]0)/,
    reject_due_validation: /^(600\.[23]|500\.[12]|800\.121)/
  }.freeze

  def self.interpret(code)
    CONSTANTS.find { |_status, regex| code.match?(regex) }&.first || :unknown_code
  end
end
