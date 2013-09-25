module Linkly
  module Builders
    class Youtube < Abstract

      def build(response)
        html = parse(response.url.url, response.body)

        twitter = %w{url title description image}.inject({}) do |h, property|
          attribute = "twitter:#{property}"
          h[property] = extract_meta(html, attribute)
          h
        end

        doc = Document.new
        doc.url = Url.new(twitter['url'], :force => true)
        doc.title = to_text twitter['title']
        doc.text = to_text twitter['description']
        doc.image = twitter['image']

        doc.type = :video
        doc.platform = :youtube

        doc
      end
    end
  end
end