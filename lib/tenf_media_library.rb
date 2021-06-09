require "tenf_media_library/version"
require "tenf_media_library/railtie"

require 'administrate/field/active_storage'

module TenfMediaLibrary
  class Engine < Rails::Engine
    initializer 'administrate.assets.precompile' do |app|
      app.config.assets.precompile << 'bootstrap.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'bootstrap.js' if defined?(Administrate::Engine)

      app.config.assets.precompile << 'jquery-ui.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'jquery-ui.js' if defined?(Administrate::Engine)

			app.config.assets.precompile << 'jquery-ui/ui/widgets/mouse.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'jquery-ui/ui/widgets/mouse.js' if defined?(Administrate::Engine)

			app.config.assets.precompile << 'jquery-ui/ui/data.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'jquery-ui/ui/data.js' if defined?(Administrate::Engine)

			app.config.assets.precompile << 'jquery-ui/ui/widgets/sortable.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'jquery-ui/ui/widgets/sortable.js' if defined?(Administrate::Engine)

      # app.config.assets.precompile << 'tenf_media_library/tenf_media_library.js' if app.config.respond_to? :assets
      # Administrate::Engine.add_javascript(
      #   "tenf_media_library/tenf_media_library",
      # )

      # app.config.assets.precompile << 'jquery-ui.min.js' if app.config.respond_to? :assets
      # Administrate::Engine.add_javascript 'jquery-ui.min.js' if defined?(Administrate::Engine)

	    app.config.assets.precompile << 'administrate/many_media_objects_field.js' if app.config.respond_to? :assets
	      Administrate::Engine.add_javascript 'administrate/many_media_objects_field.js' if defined?(Administrate::Engine)
	    end

    initializer "administrate.assets.precompile" do |app|
      app.config.assets.precompile += %w( media_library.css )
      Administrate::Engine.add_stylesheet 'media_library.css' if defined?(Administrate::Engine)
    end
  end
end
