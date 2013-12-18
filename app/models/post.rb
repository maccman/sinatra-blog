require 'pathname'

module Blog
  module Models
    class Post
      def self.path
        Pathname(App.settings.root) + 'posts'
      end

      def self.all
        paths = Dir[(path + '*.md').to_s]
        posts = paths.map {|p| self.new(p) }
        posts.sort_by {|p| p.date || Date.current }.reverse
      end

      def self.[](slug)
        slug  = slug.underscore.gsub(/\W/, '')
        paths = Dir[(path + "#{slug}.md").to_s]
        paths.first && self.new(paths.first)
      end

      def self.find!(slug)
        self[slug] || raise(NotFound.new)
      end

      attr_reader :path

      def initialize(path)
        @path = Pathname(path)
        render
      end

      def slug
        @path.basename('.md').to_s.dasherize
      end

      def content
        @content ||= @path.read
      end

      def title(value = nil)
        @title = value if value
        @title
      end

      def date(value = nil)
        @date = Date.parse(value) if value
        @date
      end

      def author(value = nil)
        @author = value if value
        @author
      end

      def render
        @render ||= begin
          eruby = Erubis::EscapedEruby.new(content)
          body  = eruby.result(binding)
          RDiscount.new(body).to_html
        end
      end
    end
  end
end