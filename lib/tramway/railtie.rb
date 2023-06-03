module Tramway
  class Railtie < ::Rails::Railtie
    initializer 'tramway.require_files' do
      Dir[File.join(File.dirname(__FILE__), '../../app/**/*.rb')].each do |file|
        require file
      end
    end
  end
end
