module Linkly
  module HTTP
    module Helper

      c18ndb_ = YAML.load_file(File.dirname(__FILE__) + '/c18n.yml')

      C18N_ = {}
      C18N_[:global] = c18ndb_[:all].freeze
      C18N_[:global_values] = c18ndb_[:values].map { |v| v.split('=') }.freeze
      C18N_[:hosts] = c18ndb_[:hosts].inject({}) { |h, (k, v)| h[/#{Regexp.escape(k)}$/.freeze] = v; h }

      def c18n(url)
        return nil if url.to_s.empty?

        begin
          u = Addressable::URI.parse(url)

          if q = u.query_values(Array)
            q.delete_if { |k, v| C18N_[:global].include?(k) }
            q.delete_if { |k, v| C18N_[:global_values].include?([k, v]) }
            q.delete_if { |k, v| C18N_[:hosts].find { |r, p| u.host =~ r && p.include?(k) } }
          end

          u.query_values = q

          u.fragment = nil

          url = Addressable::URI.unencode(u).to_s.gsub /(https?:\/\/.*?)(:[0-9]+)(\/.*)/, '\1\3' # rm port :80, :8080 ...
                                                                                                 #url.downcase!
                                                                                                 #url.gsub!("//www.","//")

          ["?", "/"].each do |car|
            url = url.chop if url.end_with?(car)
          end

          [
              "/default.html",
              "/default.htm",
              "/default.aspx",
              "/default.asp",
              "/index.php",
              "/index.html",
              "/index.htm",
              "/index.aspx",
              "/index.asp"
          ].each do |eof|
            url.gsub(/(.*?)#{eof}$/, '\1')
          end

          url.gsub!('https', 'http')

        rescue Exception => e
          puts ["UrlCleaner : Error on c18n #{url}", e.message].join("\n")
        end

        url
      end

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

      def domain(url)
        host = Addressable::URI.parse(url).host
        elements = host.split('.')
        host = ['www', *elements].join('.') if elements.size == 2
        host
      end

      private
      def real_length(word)
        word.gsub(/^\W+/,'').gsub(/\W+$/,'').size
      end

    end
  end
end