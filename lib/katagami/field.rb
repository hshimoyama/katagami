require "axiom.rb"
require "active_support/time_with_zone"
require "katagami/field/field_option_parser"

module Katagami
  module Field
    extend ActiveSupport::Concern

    class_methods do
      def fields_for(model, options = {})
        model = model.to_s.constantize

        attribute_names =
          if options[:only].present?
            options[:only]
          else
            options[:excludes] ||= []
            options[:excludes].map(&:to_sym)
            options[:excludes].concat %i[id created_at updated_at]

            model.attribute_names.reject do |an|
              options[:excludes].include?(an.to_sym)
            end
          end.map(&:to_sym)
        options = options.slice!(:only, :excludes)

        attribute_names.each do |attribute_name|
          field_for_model(attribute_name.to_sym, options.merge(for: model))
        end
      end

      def field(*args)
        fop = FieldOptionParser.new(args)
        if fop.type.blank? && for_model?(fop.options)
          fop.fields.each do |f|
            field_for_model(f, fop.options)
          end
        elsif fop.type.present?
          fop.fields.each do |f|
            attribute(f, fop.type, fop.options)
            validates_aggregated(f) if fop.type.include?(Katagami)
          end
        else
          raise ArgumentError, "field requires 'type' or 'for:' argument."
        end
      end

      def for_model?(options)
        options.instance_of?(Hash) && options.try!(:keys).try!(:include?, :for)
      end

      def field_for_model(field_name, options)
        model = options[:for].to_s.constantize
        options = options.slice!(:for)
        raise ArgumentError, "Unknown attribute[#{field_name}] for [#{model}]." unless model.attribute_names.include?(field_name.to_s)

        type = detect_type(model.attribute_types[field_name.to_s])

        attribute(field_name, type, options)

        validates_inherited(field_name, from: model)
      end

      ATTRIBUTE_TYPE_TO_TYPE = {
        boolean: Axiom::Types::Boolean,
        text: String,
        datetime: ActiveSupport::TimeWithZone
      }.freeze
      def detect_type(attribute_type)
        ATTRIBUTE_TYPE_TO_TYPE[attribute_type.type] ||
          attribute_type.type.to_s.camelize.constantize
      end

      def field_names
        attribute_set.to_a.map do |attr|
          if validation_aggregated?(attr.name)
            { attr.name => attr.primitive.field_names }
          else
            attr.name
          end
        end
      end
    end
  end
end
