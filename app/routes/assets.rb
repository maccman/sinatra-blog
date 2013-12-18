module Blog
  module Routes
    class Assets < Base
      configure do
        set :assets, assets = Sprockets::Environment.new(settings.root)

        assets.append_path('app/assets/javascripts')
        assets.append_path('app/assets/stylesheets')
        assets.append_path('app/assets/images')
        assets.append_path('vendor/assets/javascripts')
        assets.append_path('vendor/assets/stylesheets')

        Stylus.setup(assets)

        set :asset_host, ''
      end

      configure :development do
        assets.cache = Sprockets::Cache::FileStore.new('./tmp')
      end

      configure :production do
        assets.js_compressor  = Closure::Compiler.new
        assets.css_compressor = YUI::CssCompressor.new
      end

      get '/assets/*' do
        env['PATH_INFO'].sub!(%r{^/assets}, '')
        settings.assets.call(env)
      end
    end
  end
end