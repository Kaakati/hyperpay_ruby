
# HyperPay Gem

HyperPay is a powerful payment gateway, transforming the online buying experience in the MENA region. HyperPay enable internet businesses to accept and manage payments online, with more flexibility, security and ease.

HyperPay have been processing online payments since 2014. Today, HyperPay go beyond the payment gateway, as we provide merchants across almost every industry, a full-suite of online payment solutions, to serve every need.


## Installation

```ruby
gem 'HyperPay'
```

## Configuration

`config/initializers/hyperpay.rb`
```ruby
require 'hyper_pay'

HyperPay.configure do |config|
  config.authorization = "HYPER_PAY_AUTH_TOKEN"
  config.environment = :sandbox
end
```

# Usage example

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
{"result"=>{"code"=>"000.200.100", "description"=>"successfully created checkout"}, "buildNumber"=>"a58fee65f51ad5776b3c44e9929ca39a62a7cb43@2024-03-04 12:55:38 +0000", "timestamp"=>"2024-03-05 13:50:22+0000", "ndc"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03", "id"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03"}
```

### Get Payment Status for Checkout ID
```ruby
  checkout = HyperPay::CopyAndPay.new.get_status(entity_id: "", checkout_id: "")
  p checkout['id']
  p checkout['result']['code']
  p checkout['result']['description']
```

### Response
```ruby
{"result"=>{"code"=>"000.200.000", "description"=>"transaction pending"}, "buildNumber"=>"a58fee65f51ad5776b3c44e9929ca39a62a7cb43@2024-03-04 12:55:38 +0000", "timestamp"=>"2024-03-05 13:50:29+0000", "ndc"=>"ABCE449B5FC84ED5A1C7174840C7A3F8.uat01-vm-tx03"}
```

## Backoffce Operations

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
