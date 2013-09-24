module Linkly
  module Builders
    class Youtube < Abstract
      include HTTP::Helper

      def build(url, body)
        html = parse(url, body)

        twitter = %w{url title description image}.inject({}) do |h, property|
          attribute = "twitter:#{property}"
          h[property] = extract_meta(html, attribute)
          h
        end

        doc = Document.new
        doc.url = twitter['url']
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