module Linkly
  module Builders
    class Vine < Abstract

      def build(response)
        html = parse(response.url.url, response.body)

        twitter = %w{title description image player}.inject({}) do |h, property|
          attribute = "twitter:#{property}"
          h[property] = extract_meta(html, attribute)
          h
        end

        doc = Document.new

        url = twitter['player'].gsub("/card","")

        doc.url = Url.new(url, :force => true)
        doc.title = to_text twitter['title']
        doc.text = to_text twitter['description']
        doc.image = twitter['image']

        doc.type = Linkly::DocumentType::VINE
        doc.platform = Linkly::Platform::VINE

        doc
      end
    end
  end
end