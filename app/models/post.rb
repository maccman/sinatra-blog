require 'pathname'

module Blog
  module Models
    class Post
      def self.path
        Pathname(App.settings.root) + 'posts'
      end

      def self.all
        paths = Dir[(path + '**' + '*.md').to_s]
        posts = paths.map {|p| self.new(p) }
        posts.reject! {|p| p.draft? }
        posts.sort_by {|p| p.date || Date.current }.reverse
      end

      def self.paginate(number = 0, limit = 10)
        page = number * limit
        all[page..(page + limit)] || []
      end

      def self.[](slug)
        slug  = slug.underscore.gsub(/\W/, '')
        paths = Dir[(path + '**' + "#{slug}.md").to_s]
        paths.first && self.new(paths.first)
      end

      def self.find!(slug)
        self[slug] || raise(NotFound.new)
      end

      def self.cache
        @dalli ||= Dalli::Client.new
      end

      attr_reader :path

      def initialize(path)
        @path = Pathname(path)
        setup
      end

      def slug
        path.basename('.md').to_s.dasherize
      end

      def content
        @content ||= path.read
      end

      def markdown
        @markdown ||= begin
          eruby = Erubis::EscapedEruby.new(content)
          eruby.result(binding)
        end
      end

      def html
        @html ||= begin
          renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
          renderer.render(markdown)
        end
      end

      def title(value = nil)
        @title = value if value
        @title
      end

      def date(value = nil)
        @date = Date.parse(value) if value
        @date
      end

      def description
        (markdown[0..60] || '').strip
      end

      def author(value = nil)
        @author = value if value
        @author
      end

      def draft!
        @draft = true
      end

      def draft?
        @draft || parent_draft?
      end

      def mtime
        path.mtime
      end

      def key
        [slug, mtime.to_i].join(':')
      end

      def render
        self.class.cache.fetch(key) do
          html
        end
      end

      alias_method :setup, :markdown

      protected

      def parent_draft?
        path.parent.basename.to_s == 'drafts'
      end
    end
  end
end