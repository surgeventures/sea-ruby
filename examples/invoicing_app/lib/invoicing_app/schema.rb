module InvoicingApp
  class Schema
    class SchemaDefinition
      attr_reader :table_name, :fields, :field_defaults

      def initialize(table_name)
        @table_name = table_name
        @fields = [:id]
        @field_defaults = {}
      end

      def field(name, opts = {})
        @fields << name
        @field_defaults[name] = opts[:default] if opts.key?(:default)
      end

      def timestamps
        field(:inserted_at)
        field(:updated_at)
      end
    end

    def initialize(field_values = {})
      super()

      self.class.schema_definition.field_defaults.each do |f, d|
        send("#{f}=", d)
      end

      field_values.each do |f, v|
        send("#{f}=", v)
      end
    end

    class << self
      def schema_definition
        @schema_definition
      end

      def schema(table_name, &block)
        @schema_definition = SchemaDefinition.new(table_name)
        @schema_definition.instance_eval(&block)
        attr_accessor(*@schema_definition.fields)
        @schema_definition
      end
    end
  end
end
