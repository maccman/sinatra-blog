module Blog
  module Routes
    autoload :Assets, 'app/routes/assets'
    autoload :Base, 'app/routes/base'
    autoload :Static, 'app/routes/static'
    autoload :Posts, 'app/routes/posts'
  end
end