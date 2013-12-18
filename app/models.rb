module Blog
  module Models
    class NotFound < StandardError; end

    autoload :Post, 'app/models/post'
  end
end