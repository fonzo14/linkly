module Linkly
  module Builders
    class Instagram < Abstract

      def build(response)
        html = parse(response.url.url, response.body)

        og = %w{url title description image}.inject({}) do |h, property|
          attribute = "og:#{property}"
          h[property] = extract_meta(html, attribute)
          h
        end

        doc = Document.new
        doc.url = Url.new(og['url'], :force => true)
        doc.image = og['image']

        doc.type = :image
        doc.platform = :instagram

        doc
      end
    end
  end
end