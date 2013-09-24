module Linkly
  module Builders
    class Generic < Abstract
      def initialize(memento)
        @memento = memento
      end

      def build(url, body)
        html = parse(url, body)

        domain = domain(url)

        url = c18n(url)

        title = html.at_css("head title").text rescue nil
        title = @memento.memorize(domain, url, "head:title", title)

        canonical = c18n extract_link(html, "canonical")

        image = extract_link(html, "image_src")

        meta = %w{description}.inject({}) do |h, property|
          h[property] = extract_meta(html, property)
          h[property] = @memento.memorize(domain, url, "meta:#{property}", h[property])
          h
        end

        og = %w{url title description image}.inject({}) do |h, property|
          attribute = "og:#{property}"
          h[property] = extract_meta(html, attribute)
          if property != 'url'
            h[property] = @memento.memorize(domain, url, attribute, h[property])
          end
          h
        end

        og['url'] = c18n(og['url'])

        twitter = %w{url title description image}.inject({}) do |h, property|
          attribute = "twitter:#{property}"
          h[property] = extract_meta(html, attribute)
          if property != 'url'
            h[property] = @memento.memorize(domain, url, attribute, h[property])
          end
          h
        end

        twitter['url'] = c18n(twitter['url'])

        meta.merge!({
                        'url' => canonical,
                        'title' => title,
                        'image' => image
                    })

        doc = Document.new
        doc.url = find_url(url, meta, og, twitter)
        doc.title = find_title(meta, og, twitter)
        doc.text = find_text(doc.title, meta, og, twitter)
        doc.image = find_image(meta, og, twitter)

        doc.type = :article
        doc.platform = :unknown

        doc
      end

      private
      def find_url(url, meta, og, twitter)
        candidates = [url, meta['url'], og['url'], twitter['url']].compact.select { |url| url.to_s.start_with?('http') }
        candidates.min_by { |url| url.size }
      end

      def find_title(meta, og, twitter)
        to_text([og['title'], twitter['title'], meta['title']].compact.reject { |desc| desc.to_s.empty? }.first)
      end

      def find_text(title, meta, og, twitter)
        [og['description'], twitter['description'], meta['description']].compact.reject { |desc| desc.to_s.empty? || desc.to_s.size < 10 }.map do |text|
          to_text(text)
        end.reject { |text| Hotwater.jaro_winkler_distance(title, text) > 0.95 }.first
      end

      def find_image(meta, og, twitter)
        [og['image'], twitter['image'], meta['image']].compact.select { |img| img.to_s.start_with?('http') }.reject { |u| u.include?('logo') }.first
      end
    end
  end
end