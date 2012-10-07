module WithoutScope
  module ActsAsRevisable
    module Validations
      def validates_uniqueness_of(*args)
        options = args.extract_options!
        (options[:scope] ||= []) << :revisable_is_current
        super(*(args << options))
      end

      def validates(*args)
        options = args.extract_options!

        if options.include?(:uniqueness)
          options[:uniqueness] = {} if options[:uniqueness] == true
          options[:uniqueness][:scope] = options[:uniqueness][:scope].to_a << :revisable_is_current
        end
        super(*(args << options))
      end
    end
  end
end
