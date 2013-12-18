xml.instruct! :xml, :version => '1.0'
xml.feed('xml:lang' => 'en-US', 'xmlns' => 'http://www.w3.org/2005/Atom') do
  xml.id 'tag:blog.myblog.io,2013:/feed'
  xml.title 'MyBlog'
  xml.link(rel: 'alternate', type: 'text/html', href: 'http://blog.myblog.io')
  xml.link(rel: 'self', type: 'application/atom+xml', href: 'http://blog.myblog.io/feed')
  xml.updated @posts.first && @posts.first.date.xmlschema

  @posts.each do |post|
    xml.entry do
      xml.id "tag:blog.myblog.io,2013:Post/#{post.slug}"
      xml.title post.title
      xml.link rel: 'alternate', type: 'text/html', href: "http://blog.myblog.io/#{post.slug}"
      xml.published post.date.xmlschema
      xml.updated post.date.xmlschema
      xml.author do
        xml.name post.author
      end
      xml.content post.render, type: 'html'
    end
  end
end