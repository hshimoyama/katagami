module Katagami::Field
  class FieldOptionParser
    def initialize(args)
      @args = args
    end

    def has_options?
      @args[-1].instance_of?(Hash)
    end

    def options
      return @args[-1] if has_options?
      {}
    end

    def has_type?
      !type.nil?
    end

    def type
      if !has_options? && @args[-1].instance_of?(Class)
        @args[-1]
      elsif has_options? && @args[-2].instance_of?(Class)
        @args[-2]
      end
    end

    def fields
      e = -1
      e -= 1 if has_options?
      e -= 1 if has_type?
      @args[0..e]
    end
  end
end
