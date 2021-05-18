# A lot of this file has been copied verbatim from:
# https://github.com/thoughtbot/administrate/blob/abb0790afcb784708e13f5dc64a02668865495fd/lib/generators/administrate/dashboard/dashboard_generator.rb

require "rails/generators/base"
require "rails/generators/active_record"
require "rails/generators/migration"

module TenfMediaLibrary
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      ATTRIBUTE_TYPE_MAPPING = {
        boolean: "Field::Boolean",
        date: "Field::Date",
        datetime: "Field::DateTime",
        enum: "Field::Select",
        float: "Field::Number",
        integer: "Field::Number",
        time: "Field::Time",
        text: "Field::Text",
        string: "Field::String",
        uuid: "Field::String",
      }

      ATTRIBUTE_OPTIONS_MAPPING = {
        # procs must be defined in one line!
        enum: {  searchable: false,
                 collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys } },
        float: { decimals: 2 },
      }

      class_option :namespace, type: :string, default: :admin

      def create_resource_controllers
        destination = Rails.root.join(
          "app/controllers/#{namespace}/media_objects_controller.rb",
        )
        template("media_objects_controller.rb.erb", destination)

        destination = Rails.root.join(
          "app/controllers/#{namespace}/media_directories_controller.rb",
        )
        template("media_directories_controller.rb.erb", destination)
      end

      def create_media_library_migration
        migration_template("migration.rb", "db/migrate/create_media_library_tables.rb", migration_version: migration_version)
      end

      def create_admin_views
        destination = Rails.root.join(
          "app/views/#{namespace}/media_objects/",
        )
        directory("admin_views", destination)
      end

      def add_bootstrap_to_yarn
        system "yarn add bootstrap @popperjs/core jquery"
      end

      private

      # including Rails::Generators::Migration expects this method to be implemented
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end

      def namespace
        options[:namespace]
      end

      def attributes
        klass.reflections.keys +
          klass.columns.map(&:name) -
          redundant_attributes
      end

      def form_attributes
        attributes - READ_ONLY_ATTRIBUTES
      end

      def redundant_attributes
        klass.reflections.keys.flat_map do |relationship|
          redundant_attributes_for(relationship)
        end.compact
      end

      def redundant_attributes_for(relationship)
        case association_type(relationship)
        when "Field::Polymorphic"
          [relationship + "_id", relationship + "_type"]
        when "Field::BelongsTo"
          relationship + "_id"
        end
      end

      def field_type(attribute)
        type = column_type_for_attribute(attribute.to_s)

        if type
          ATTRIBUTE_TYPE_MAPPING.fetch(type, DEFAULT_FIELD_TYPE) +
            options_string(ATTRIBUTE_OPTIONS_MAPPING.fetch(type, {}))
        else
          association_type(attribute)
        end
      end

      def column_type_for_attribute(attr)
        if enum_column?(attr)
          :enum
        else
          column_types(attr)
        end
      end

      def enum_column?(attr)
        klass.respond_to?(:defined_enums) &&
          klass.defined_enums.keys.include?(attr)
      end

      def column_types(attr)
        klass.columns.find { |column| column.name == attr }.try(:type)
      end

      def association_type(attribute)
        relationship = klass.reflections[attribute.to_s]
        if relationship.has_one?
          "Field::HasOne"
        elsif relationship.collection?
          "Field::HasMany"
        elsif relationship.polymorphic?
          "Field::Polymorphic"
        else
          "Field::BelongsTo"
        end
      end

      def klass
        @klass ||= Object.const_get(class_name)
      end

      def options_string(options)
        if options.any?
          ".with_options(#{inspect_hash_as_ruby(options)})"
        else
          ""
        end
      end

      def inspect_hash_as_ruby(hash)
        hash.map do |key, value|
          v_str = value.respond_to?(:call) ? proc_string(value) : value.inspect
          "#{key}: #{v_str}"
        end.join(", ")
      end

      def proc_string(value)
        source = value.source_location
        proc_string = IO.readlines(source.first)[source.second - 1]
        proc_string[/->[^}]*} | (lambda|proc).*end/x]
      end

    end

  end
end
