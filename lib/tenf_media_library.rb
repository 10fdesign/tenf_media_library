require "tenf_media_library/version"
require "tenf_media_library/railtie"

require 'administrate/field/active_storage'

module TenfMediaLibrary
  puts "hey"
  class Engine < Rails::Engine
    initializer "administrate.assets.precompile" do |app|
      app.config.assets.precompile += %w( media_library.css )
      Administrate::Engine.add_stylesheet 'media_library.css' if defined?(Administrate::Engine)
    end
  end
end
