module Blog
  module Routes
    class Posts < Base
      error Models::NotFound do
        error 404
      end

      get '/apple-touch-icon*' do
        404
      end

      get '/feed', provides: 'application/atom+xml' do
        @posts = Post.all
        builder :feed
      end

      get '/page/:number' do
        number = Integer(params[:number])
        @posts = Post.paginate(number)

        erb :index
      end

      get '/:slug' do
        @post = Post.find!(params[:slug])
        erb :post
      end

      get '/' do
        @posts = Post.paginate
        erb :index
      end
    end
  end
end