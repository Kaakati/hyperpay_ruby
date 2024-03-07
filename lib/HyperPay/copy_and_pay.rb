# frozen_string_literal: true

require "HyperPay/payment_parameter_builder"
require "HyperPay/base"

module HyperPay
  class CopyAndPay < HyperPay::Base
    # Generate HyperPay Checkout ID
    #
    # Parameters:
    # @entity_id Entity ID that was used to generate the Checkout ID
    # @return [Hash] {"result"=>{"code"=>"000.200.100", "description"=>"successfully created checkout"}, "buildNumber"=>"a58fee65f51ad5776b3c44e9929ca39a62a7cb43@2024-03-04 12:55:38 +0000", "timestamp"=>"2024-03-05 13:50:22+0000", "ndc"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03", "id"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03"}
    def create_checkout_id(&block)
      builder = PaymentParameterBuilder.new
      yield(builder) if block_given?
      builder.validate! # Perform validations
      post("/v1/checkouts", builder.parameters)
    end

    # Get HyperPay payment status for a given checkout
    #
    # Parameters:
    # @entity_id Entity ID that was used to generate the Checkout ID
    # @checkout_id HyperPay Checkout ID
    # @return [Hash] {"result"=>{"code"=>"000.200.000", "description"=>"transaction pending"}, "buildNumber"=>"a58fee65f51ad5776b3c44e9929ca39a62a7cb43@2024-03-04 12:55:38 +0000", "timestamp"=>"2024-03-05 13:50:29+0000", "ndc"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03"}
    # @return [Hash] {"id"=>"8ac7a4a08e10b158018e1486506e0397",
    #  "paymentType"=>"DB", "paymentBrand"=>"VISA", "amount"=>"600.00", "currency"=>"SAR", "descriptor"=>"9539.3104.2548 Group",
    #  "merchantTransactionId"=>"139895288", "result"=>{"code"=>"000.000.000", "description"=>"Transaction succeeded"},
    #  "resultDetails"=>{"ExtendedDescription"=>"Successfully processed", "ProcStatus"=>"0", "clearingInstituteName"=>"NCB BANK", "AuthCode"=>"f2e7a815c3",
    #                    "ConnectorTxID1"=>"8ac7a4a08e10b158018e1486506e0397", "ConnectorTxID3"=>"10b158018e1486506e0397", "ConnectorTxID2"=>"8ac7a4a0", "AcquirerResponse"=>"00",
    #                    "EXTERNAL_SYSTEM_LINK"=>"https://csi-test.retaildecisions.com/RS60/TransDetail.aspx?oid=000194001101S2E20110926045038668&support=Link+to+Risk+Details", "TermID"=>"71F00820",
    #                    "OrderID"=>"8316384413"},
    #  "card"=>{"bin"=>"411111", "binCountry"=>"PL", "last4Digits"=>"1111", "holder"=>"DFGY", "expiryMonth"=>"05", "expiryYear"=>"2025", "issuer"=>{"bank"=>"CONOTOXIA SP. Z O.O"}, "type"=>"DEBIT", "level"=>"CLASSIC", "country"=>"PL", "maxPanLength"=>"16", "binType"=>"PERSONAL", "regulatedFlag"=>"N"}, "customer"=>{"givenName"=>"mohammad", "surname"=>"kassab", "mobile"=>"966544299944", "email"=>"mohammad.a.kassab@gmail.com", "ip"=>"213.204.77.158", "ipCountry"=>"LB"}, "billing"=>{"street1"=>"Saudi Arabia", "city"=>"Jeddah", "country"=>"SA"}, "threeDSecure"=>{"eci"=>"05", "xid"=>"CAACCVVUlwCXUyhQNlSXAAAAAAA=", "authenticationStatus"=>"Y"}, "customParameters"=>{"SHOPPER_MSDKIntegrationType"=>"Checkout UI", "SHOPPER_device"=>"samsung samsung SM-S918B", "CTPE_DESCRIPTOR_TEMPLATE"=>"", "SHOPPER_OS"=>"Android 14", "SHOPPER_MSDKVersion"=>"4.12.0", "3DS2_enrolled"=>"true"}, "risk"=>{"score"=>"100"}, "buildNumber"=>"e41989c9076807bb305850f77ce20740230863b9@2024-03-05 14:10:27 +0000", "timestamp"=>"2024-03-06 16:08:56+0000", "ndc"=>"67F1CF7891ADB9400CD013BC77A4CE5C.uat01-vm-tx03"}
    def get_status(entity_id:, checkout_id:)
      get("/v1/checkouts/#{checkout_id}/payment"+"?entityId=#{entity_id}")
    end

    # Capture an authorization
    # A capture is used to request clearing for previously authorized funds.
    # Captures can be for full or partial amounts and multiple capture requests against the same PA are allowed.
    #
    # Parameters:
    # @entity_id Entity ID that was used to generate the Checkout ID
    # @checkout_id HyperPay Checkout ID
    # @amount Amount
    # @currency Currency
    def capture_payment(entity_id:, checkout_id:, amount:, currency:)
      post("/v1/payments/#{checkout_id}", { entityId: entity_id, paymentType: "CP", currency: currency, amount: amount })
    end

    # Refund a payment
    # A refund is performed against a previous payment, referencing its `payment.id` by
    # sending a POST request over HTTPS to the /payments/{id} endpoint.
    # A refund can be performed against debit (DB) or captured pre-authorization (PA->CP) payment types.
    # Where supported, the amount field can be used to process a partial or full amount.
    #
    # Parameters:
    # @entity_id Entity ID that was used to generate the Checkout ID
    # @checkout_id HyperPay Checkout ID
    # @amount Amount
    # @currency Currency
    def refund_payment(entity_id:, checkout_id:, amount:, currency:)
      post("/v1/payments/#{checkout_id}", { entityId: entity_id, amount: amount, currency: currency, paymentType: "RF" })
    end

    # Reverse a payment
    # A reversal is performed against a previous payment, referencing its payment.id
    # by sending a POST request over HTTPS to the /payments/{id} endpoint.
    # A reversal should be sent against pre-authorization (PA) payment type.
    # When reversing a card payment and if sent within the time-frame the authorization is not captured yet,
    # the reversal causes an authorization reversal request to be sent to the card issuer
    # to clear the funds held against the authorization.
    #
    # Parameters:
    # @entity_id Entity ID that was used to generate the Checkout ID
    # @checkout_id HyperPay Checkout ID
    def reverse_payment(entity_id:, checkout_id:)
      post("/v1/payments/#{checkout_id}", { entityId: entity_id, paymentType: "RV" })
    end
  end
end

