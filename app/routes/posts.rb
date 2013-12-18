module Blog
  module Routes
    class Posts < Base
      error Models::NotFound do
        error 404
      end

      get '/feed' do
        @posts = Post.all
        builder :feed
      end

      get '/:slug' do
        @post = Post.find!(params[:slug])
        erb :post
      end

      get '/' do
        @posts = Post.all
        erb :index
      end
    end
  end
end