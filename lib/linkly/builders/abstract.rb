module Linkly
  module Builders
    class Abstract
      include Linkly::HTTP::Helper

      protected
      def parse(url, body)
        begin
          Nokogiri::HTML(body, url)
        rescue Exception
          body.encode!('UTF-8', 'UTF-8', :invalid => :replace)
          Nokogiri::HTML(body, url)
        end
      end

      def extract_meta(html, name)
        (html.at_css("meta[property='#{name}']") || html.at_css("meta[name='#{name}']"))['content'] rescue nil
      end

      def extract_link(html, name)
        html.at_css("link[rel=#{name}]")['href'] rescue nil
      end
    end
  end
end