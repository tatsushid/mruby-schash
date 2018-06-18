module Schash
  module Schema
    module Rule
      class MapOf < Base
        def initialize(schema_key, schema_value)
          @schema_key = schema_key
          @schema_value = schema_value
        end

        def validate(target, position = [])
          return [Error.new(position, "is not Map")] unless target.is_a?(::Hash)

          value_rule = @schema_value
          value_rule = Rule::Hash.new(value_rule) if value_rule.is_a?(::Hash)

          errors = []

          target.each do |key, value|
            errors << @schema_key.validate(key, position + ["#{key} key"])
            errors << value_rule.validate(value, position + [key.to_s])
          end

          errors.flatten.compact
        end
      end
    end
  end
end
