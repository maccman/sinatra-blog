module Blog
  module Routes
    class Posts < Base
      error Models::NotFound do
        error 404
      end

      get '/' do
        @posts = Post.all
        erb :index
      end

      get '/:slug' do
        @post = Post.find!(params[:slug])
        erb :post
      end
    end
  end
end