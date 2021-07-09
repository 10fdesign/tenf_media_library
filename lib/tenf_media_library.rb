require "tenf_media_library/version"
require "tenf_media_library/railtie"

require 'administrate/field/active_storage'

module TenfMediaLibrary
  class Engine < Rails::Engine
    initializer 'administrate.assets.precompile' do |app|
      app.config.assets.precompile << 'bootstrap.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'bootstrap.js' if defined?(Administrate::Engine)

      app.config.assets.precompile << 'jquery-ui-dist/jquery-ui.js' if app.config.respond_to? :assets
      Administrate::Engine.add_javascript 'jquery-ui-dist/jquery-ui.js' if defined?(Administrate::Engine)

	    app.config.assets.precompile << 'administrate/media_objects.js' if app.config.respond_to? :assets
	      Administrate::Engine.add_javascript 'administrate/media_objects.js' if defined?(Administrate::Engine)
	    end

    initializer "administrate.assets.precompile" do |app|
      app.config.assets.precompile += %w( media_library.css )
      Administrate::Engine.add_stylesheet 'media_library.css' if defined?(Administrate::Engine)
    end
  end
end
