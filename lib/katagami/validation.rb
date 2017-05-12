module Katagami
  module Validation
    extend ActiveSupport::Concern

    class_methods do
      def validates_aggregated(field_name)
        validate do |record|
          field = record.send(field_name)
          return if field.valid?
          record.errors.add(field_name, field.errors.messages)
        end
        validation_aggregated_fields << field_name.to_sym
      end

      def validation_aggregated?(field_name)
        validation_aggregated_fields.include?(field_name.to_sym)
      end

      def validation_aggregated_fields
        @validation_aggregated_fields ||= []
      end

      def validates_inherited(field_name, from:)
        from = from.to_s.constantize
        from._validators[field_name].each do |validator|
          options = validator.options.dup
          validates_with(
            convert_validator(validator.class),
            options.merge(attributes: [field_name.to_sym])
          )
        end
      end

      def convert_validator(validator_class)
        if validator_class.to_s.match(/\AActiveRecord::/)
          return validator_class.to_s.gsub('ActiveRecord', 'ActiveModel').constantize
        end
        validator_class
      end

      def validate_fields(fields)
        of = new(fields)
        of.valid?

        fields.each_with_object(FormResult.new(self)) do |(field_name, v), r|
          if validation_aggregated?(field_name)
            field = of.send(field_name)
            r[field_name] = field.class.validate_fields(v).result
          else
            messages = of.errors.messages[field_name.to_sym]
            r[field_name] = {
              status:  messages.present? ? "invalid" : "valid",
              message: messages.present? ? messages.join(",") : nil
            }
          end
        end
      end
    end
  end
end
