require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      @params.merge!(route_params.stringify_keys)
      @params.merge!(parse_www_encoded_form(req.query_string)) unless req.query_string.nil?
      @params.merge!(parse_www_encoded_form(req.body)) unless req.body.nil?
    end

    def [](key)
      @params[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      decoded = URI::decode_www_form(www_encoded_form)
      decoded.each do |key_val_pair|
        key_string = key_val_pair.first
        val = key_val_pair.last
        key_list = parse_key(key_string)
        target = params
        key_list.each_with_index do |key, idx|
          if idx == (key_list.length - 1)
            target[key] = val
          else
            target[key] ||= {}
            target = target[key]
          end
        end
      end
      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

# class Hash
#   def self.recursive
#     self.new { |hash, key| hash[key] = self.recursive }
#   end
# end
