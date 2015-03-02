require 'action_pack'
require 'payu_india'

module PayuIndia #:nodoc:
  ActionViewHelperError = Class.new(StandardError)

  module ActionViewHelper
    # This Helper creates form with all parameters added.
    #
    #  <% payment_form_for_payu 'YOUR_KEY', 'YOUR_SALT',
    #       :txnid => @cart.id,
    #       :amount => @cart.total_price,
    #       :productinfo => 'Book',
    #       :firstname => 'abc',
    #       :email => 'abc@example.com',
    #       :phone => '1234567890',
    #       :surl => 'http://localhost:3000/payu_callback',
    #       :furl => 'http://localhost:3000/payu_callback',
    #       :html => { :id => 'payment-form' } %>

    def payment_form_for_payu(key, salt, options = {})

      form_options = options.delete(:html) || {}
      service = PayuIndia::Helper.new(key, salt, options)
      result = []

      result << form_tag(PayuIndia.service_url, form_options.merge(:method => :post))

      result << hidden_field_tag('key', key)

      service.form_fields.each do |field, value|
        result << hidden_field_tag(field, value)
      end

      result << '<input type=submit value=" Pay with PayU ">'
      result << '</form>'
      result= result.join("\n")

      concat(result.respond_to?(:html_safe) ? result.html_safe : result)
      nil
    end
  end
end
