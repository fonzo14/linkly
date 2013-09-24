module Linkly
  module Builders
    class Instagram < Abstract
      include HTTP::Helper

      def build(url, body)
          html = parse(url, body)

        og = %w{url title description image}.inject({}) do |h, property|
          attribute = "og:#{property}"
          h[property] = extract_meta(html, attribute)
          h
        end

        doc = Document.new
        doc.url = og['url']
        doc.image = og['image']

        doc.type = :image
        doc.platform = :instagram

        doc
      end
    end
  end
end