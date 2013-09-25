module Linkly
  module HTTP
    module Helper

      def to_text(html, options = {})
        return "" if html.to_s.empty?
        text = []
        options = {:max_length => 25, :replacement => '[...]'}.merge(options)
        Nokogiri::HTML(html).traverse do |node|
          text << node.text unless node.children.size > 0
        end
        text = text.compact.join(' ').gsub("<br />",'').gsub("<br/>",'').gsub(/\s+/,' ').strip
        text = text.split(' ').map do |word|
          (word =~ /[[:alnum:]][^[:alnum:]]+[[:alnum:]]/ && (real_length(word) > options[:max_length])) ? options[:replacement] : word
        end
        text = text.join(' ')
        if !options.key?(:second_call) && text.match(/<.*\/?>/)
          text = to_text(text, options.merge(:second_call => true))
        end
        text
      end

      private
      def real_length(word)
        word.gsub(/^\W+/,'').gsub(/\W+$/,'').size
      end

    end
  end
end