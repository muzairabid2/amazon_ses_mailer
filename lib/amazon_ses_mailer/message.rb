require 'aws-sdk-sesv2'
module AmazonSesMailer
  class Message
    attr_reader :message

    class << self
      attr_accessor :ses_client
    end

    def ses_client
      self.class.ses_client ||= ::Aws::SESV2::Client.new(:region => "us-east-1")
    end

    def initialize(options, interceptors, delivery_proc)
      @message = build_message(options)
      @interceptors = interceptors ||= []
      @delivery_proc = delivery_proc || Proc.new { |message|
        ses_client.send_email(message)
      }
    end

    def deliver
      @delivery_proc.call(@message) if delivering?(@message)
    end

    private

    def build_message(options)
      {
        from_email_address: "#{options[:from_name]} <#{options[:from_email]}>",
        destination: {
          to_addresses: ensure_array(options[:to])
        },
        reply_to_addresses: ensure_array(options[:reply_to]),
        content: {
          template: {
            template_name: options[:template],
            template_data: options[:merge_vars]
          },
        },
        configuration_set_name: options[:configuration_set_name],
        list_management_options: build_list_management_options(options)
      }.keep_if{|k, v| !!v}
    end

    def ensure_array(array_or_string)
      if array_or_string.is_a?(Array)
        array_or_string
      elsif array_or_string.is_a?(String)
        [array_or_string]
      else
        []
      end
    end

    def build_list_management_options(options)
      if options[:contact_list_name]
        {
          contact_list_name: options[:contact_list_name],
          topic_name: options[:topic_name] # nil is allowed
        }
      end
    end

    def delivering?(message)
      @interceptors.all?{ |interceptor|
        interceptor.delivering_email(message)
      }
    end
  end
end
