
# HyperPay & PeachPayments

This Ruby Gem will work with any of the payment gateways provided by **Open Payment Platform (OPP) COPYandPAY**, such as HyperPay and PeachPayments,
Initially, it was built to work with HyperPay, but it can be easily used to work with PeachPayments.

<img src="peachpayments-logo.svg" height="70">
<br/>
<br/>
<img src="Hyperpay-logo-svg-1.png" height="120">

HyperPay is a powerful payment gateway, transforming the online buying experience in the MENA region. HyperPay enable internet businesses to accept and manage payments online, with more flexibility, security and ease.

HyperPay have been processing online payments since 2014. Today, HyperPay go beyond the payment gateway, as we provide merchants across almost every industry, a full-suite of online payment solutions, to serve every need.

---

- [HyperPay API Documentation](https://wordpresshyperpay.docs.oppwa.com/)
- [PeachPayments API Documentation](https://peachpayments.docs.oppwa.com/)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage Example](#usage-example)
- [Generate Checkout ID Response](#response)
- [Payment Success Response](#success-response)
- [Response Code Interpretation](#response-code-interpretation)
- [BackOffice Operations](#backoffice-operations)

---
## Installation

```ruby
gem 'HyperPay'
```

---

## Configuration

`config/initializers/hyperpay.rb`
```ruby
require 'hyper_pay'

HyperPay.configure do |config|
  config.authorization = "HYPER_PAY_AUTH_TOKEN"
  config.environment = :sandbox
end
```

---

## Usage example

### Generate Checkout ID
```ruby
  checkout = HyperPay::CopyAndPay.new.create_checkout_id do |params|
    params.add "entityId", "HYPER_PAY_ENTITY_ID"
    params.add "customer.email", "john@doe.com"
    params.add "customer.mobile", "9665xxxxxxxx"
    params.add "customer.givenName", "John"
    params.add "customer.surname", "Doe"
    params.add "billing.street1", "STREET_NAME"
    params.add "billing.country", "SA"
    params.add "billing.city", "Riyadh"
    params.add "billing.state", ""
    params.add "billing.postcode", "00000"
    params.add "customParameters[3DS2_enrolled]", "true"
    params.add "merchantTransactionId", "YOUR_INVOICE_NUMBER"
    params.add "paymentType", "DB"
    params.add "currency", "SAR"
    params.add "amount", "100" # On Sandbox, HyperPay Can process non-decimal numbers only.
  end

  p checkout['id']
  p checkout['result']['code']
  p checkout['result']['description']

```

### Response
```ruby
{
  "result"=>{
    "code"=>"000.200.100", 
    "description"=>"successfully created checkout"
  }, 
  "buildNumber"=>"a58fee65f51ad5776b3c44e9929ca39a62a7cb43@2024-03-04 12:55:38 +0000", 
  "timestamp"=>"2024-03-05 13:50:22+0000", 
  "ndc"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03", 
  "id"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03"
}
```

-----
### Get Payment Status for Checkout ID
[Code Interpretation](#response-code-interpretation)
```ruby
  checkout = HyperPay::CopyAndPay.new.get_status(entity_id: "", checkout_id: "")
  p checkout['id']
  p checkout['result']['code']
  p checkout['result']['description']
```

### Pending Response
```ruby
{
  "result"=>{
    "code"=>"000.200.000", 
    "description"=>"transaction pending"
  }, 
  "buildNumber"=>"a58fee65f51ad5776b3c44e9929ca39a62a7cb43@2024-03-04 12:55:38 +0000", 
  "timestamp"=>"2024-03-05 13:50:29+0000", 
  "ndc"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03"
}
```

### Success Response
```ruby
{ 
  "id"=>"8ac7a4a08e10b158018e1486506e0397",
  "paymentType"=>"DB", 
  "paymentBrand"=>"VISA", 
  "amount"=>"600.00", 
  "currency"=>"SAR", 
  "descriptor"=>"0000.0000.0000 Company Name",
  "merchantTransactionId"=>"139895288", 
  "result"=>{
    "code"=>"000.000.000", 
    "description"=>"Transaction succeeded"
  },
  "resultDetails"=>{
    "ExtendedDescription"=>"Successfully processed", 
    "ProcStatus"=>"0", 
    "clearingInstituteName"=>"NCB BANK", 
    "AuthCode"=>"f2e7a815c3",
    "ConnectorTxID1"=>"8ac7a4a08e10b158018e1486506e0397", 
    "ConnectorTxID3"=>"10b158018e1486506e0397", 
    "ConnectorTxID2"=>"8ac7a4a0", 
    "AcquirerResponse"=>"00",
    "EXTERNAL_SYSTEM_LINK"=>"https://csi-test.retaildecisions.com/RS60/TransDetail.aspx?oid=000194001101S2E20110926045038668&support=Link+to+Risk+Details", 
    "TermID"=>"71F00820",
    "OrderID"=>"8316384413"
  },
  "card"=>{
    "bin"=>"411111", 
    "binCountry"=>"PL", 
    "last4Digits"=>"1111", 
    "holder"=>"DFGY", 
    "expiryMonth"=>"05", 
    "expiryYear"=>"2025", 
    "issuer"=>{
      "bank"=>"CONOTOXIA SP. Z O.O"
    }, 
    "type"=>"DEBIT", 
    "level"=>"CLASSIC", 
    "country"=>"PL", 
    "maxPanLength"=>"16", 
    "binType"=>"PERSONAL", 
    "regulatedFlag"=>"N"
  }, 
  "customer"=>{
    "givenName"=>"Mohamad", 
    "surname"=>"Kaakati", 
    "mobile"=>"966540000000", 
    "email"=>"john@doe.com", 
    "ip"=>"0.0.0.0", 
    "ipCountry"=>"SA"
  }, 
  "billing"=>{
    "street1"=>"Saudi Arabia", 
    "city"=>"Jeddah", 
    "country"=>"SA"
  }, 
  "threeDSecure"=>{
    "eci"=>"05", 
    "xid"=>"CAACCVVUlwCXUyhQNlSXAAAAAAA=", 
    "authenticationStatus"=>"Y"
  }, 
  "customParameters"=>{
    "SHOPPER_MSDKIntegrationType"=>"Checkout UI", 
    "SHOPPER_device"=>"Apple iPhone 15 Pro", 
    "CTPE_DESCRIPTOR_TEMPLATE"=>"", 
    "SHOPPER_OS"=>"iOS 17.4", 
    "SHOPPER_MSDKVersion"=>"4.12.0", 
    "3DS2_enrolled"=>"true"
  }, 
  "risk"=>{
    "score"=>"100"
  }, 
  "buildNumber"=>"e41989c9076807bb305850f77ce20740230863b9@2024-03-05 14:10:27 +0000", 
  "timestamp"=>"2024-03-06 16:08:56+0000", 
  "ndc"=>"67F1CF7891ADB9400CD013BC77A4CE5C.uat01-vm-tx03"
}
```

## Response Code Interpretation

Now, anywhere in your application where you have a response code from HyperPay that you want to interpret, you can easily get its meaning:

```ruby
base = HyperPay::Base.new
result = base.interpret_response_code("000.100.1")
puts result # :transaction_succeeded

case result
when :transaction_succeeded
  # Do something
when :transaction_succeeded_review
  # Do something
when :transaction_declined
  # Do something
when :transaction_pending
  # Do something
when :transaction_failed
  # Do something
when :rejected_communication_error
  # Do something
when :rejected_system_error
  # Do something
when :rejected_for_risk
  # Do something
when :reject_blacklist
  # Do something
when :reject_risk_validation
  # Do something
when :reject_due_validation
  # Do something
else
  # Do something
end
```

---

## BackOffice Operations

### Capture Payment
```ruby
HyperPay::CopyAndPay.new.capture_payment(entity_id: "", checkout_id: "", amount: "", currency: "")
```

### Refund Payment
```ruby
HyperPay::CopyAndPay.new.refund_payment(entity_id: "", checkout_id: "", amount: "", currency: "")
```

### Reverse a payment
```ruby
HyperPay::CopyAndPay.new.reverse_payment(entity_id: "", checkout_id: "")
```


## Authors

- [Mohamad Kaakati (@kaakati)](https://www.github.com/kaakati)
