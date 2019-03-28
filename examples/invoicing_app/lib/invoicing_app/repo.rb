require 'sequel'

module InvoicingApp
  class Repo
    class << self
      def get_by(schema, field, value)
        dataset = dataset(schema)
        field_values = dataset.where(field => value).first
        return unless field_values

        schema.new(field_values)
      end

      def get(schema, id)
        get_by(schema, :id, id)
      end

      def insert(record)
        schema = record.class
        schema_definition = schema.schema_definition
        now = DateTime.now
        if schema_definition.fields.include?(:inserted_at)
          record.inserted_at = now
        end
       if schema_definition.fields.include?(:updated_at)
          record.updated_at = now
        end
        dataset = dataset(schema)
        fields = schema_definition.fields - [:id]
        field_values = fields.map { |f| [f, record.send(f)] }.to_h
        id = dataset.insert(field_values)
        record.id = id

        record
      end

      def update(record)
        schema = record.class
        schema_definition = schema.schema_definition
        if schema_definition.fields.include?(:updated_at)
          record.updated_at = DateTime.now
        end
        dataset = dataset(schema)
        fields = schema.schema_definition.fields - [:id]
        field_values = fields.map { |f| [f, record.send(f)] }.to_h
        dataset.where(id: record.id).update(field_values)
      end

      def inc(record, field, amount)
        schema = record.class
        schema_definition = schema.schema_definition
        record.send("#{field}=", record.send(field) + amount)
        if schema_definition.fields.include?(:updated_at)
          record.updated_at = DateTime.now
        end
        dataset = dataset(schema)
        dataset.where(id: record.id).update(field => Sequel[field] + amount)
      end

      def transaction(&block)
        db.transaction do
          block.call
        end
      end

      private

      def dataset(schema)
        db[schema.schema_definition.table_name.to_sym]
      end

      def db_url
        'postgres://postgres@localhost/invoicing_app_repo'
      end

      def db
        return @db if defined? @db

        create_database
        @db = Sequel.connect(db_url)
        create_schema
        @db
      end

      def create_database
        db = Sequel.connect(db_url.split("/")[0..-2].join('/'))
        db_name = db_url.split("/")[-1]
        db.execute("DROP DATABASE IF EXISTS #{db_name}")
        db.execute("CREATE DATABASE #{db_name}")
      end

      def create_schema
        db.drop_table? :customers_accounts,
          :inventory_products,
          :sales_invoices,
          :analytics_customer_invoice_counters

        db.create_table :customers_accounts do
          primary_key :id
          column :inserted_at, DateTime, null: false
          column :updated_at, DateTime, null: false
          column :name, String, null: false
          column :active, :boolean, null: false, default: false
        end

        db.create_table :inventory_products do
          primary_key :id
          column :inserted_at, DateTime, null: false
          column :updated_at, DateTime, null: false
          column :stock, Integer, null: false, default: 0
          constraint(:stock_cannot_be_negative) {stock >= 0}
        end

        db.create_table :sales_invoices do
          primary_key :id
          column :inserted_at, DateTime, null: false
          column :updated_at, DateTime, null: false
          foreign_key :product_id, :inventory_products, null: false
          foreign_key :customer_id, :customers_accounts, null: false
          column :number, String, null: false, unique: true
        end

        db.create_table :analytics_customer_invoice_counters do
          primary_key :id
          foreign_key :customer_id, :customers_accounts, null: false, unique: true
          column :invoice_count, Integer, null: false, default: 0
        end
      end
    end
  end
end
