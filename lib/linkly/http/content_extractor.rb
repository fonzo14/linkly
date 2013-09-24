module Linkly
  module HTTP
    class ContentExtractor
      include HTTP::Helper

      def initialize(memento)
        @memento = memento
      end

      def extract(body, url)
        html = Nokogiri::parse(body, url)

        domain = domain(url)

        url = c18n(url)

        title = html.at_css("head title").text rescue nil
        title = @memento.memorize(domain, "head:title", title)

        canonical = c18n extract_link(html, "canonical")

        image = extract_link(html, "image_src")

        meta = %w{description}.inject({}) do |h, property|
          h[property] = extract_meta(html, property)
          h[property] = @memento.memorize(domain, "meta:#{property}", h[property])
          h
        end

        og = %w{url title description image}.inject({}) do |h, property|
          attribute = "og:#{property}"
          h[property] = extract_meta(html, attribute)
          if property != 'url'
            h[property] = @memento.memorize(domain, attribute, h[property])
          end
          h
        end

        og['url'] = c18n(og['url'])

        twitter = %w{url title description image}.inject({}) do |h, property|
          attribute = "twitter:#{property}"
          h[property] = extract_meta(html, attribute)
          if property != 'url'
            h[property] = @memento.memorize(domain, attribute, h[property])
          end
          h
        end

        twitter['url'] = c18n(twitter['url'])

        meta.merge!({
                        'url' => canonical,
                        'title' => title,
                        'image' => image
                    })

        c = Content.new
        c.url = url
        c.meta = meta
        c.opengraph = og
        c.twitter = twitter

        c
      end

      private
      def extract_meta(html, name)
        (html.at_css("meta[property='#{name}']") || html.at_css("meta[name='#{name}']"))['content'] rescue nil
      end

      def extract_link(html, name)
        html.at_css("link[rel=#{name}]")['href'] rescue nil
      end
    end
  end
end

