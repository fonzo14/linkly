module Linkly
  class Connection

    def initialize(opts)
      opts = {
          :http_client => :synchrony,
          :memento => :null,
          :cache => :null
      }.merge(opts)

      require_relative "http/clients/#{opts[:http_client].to_s}"
      @http_client = eval "::Linkly::HTTP::Clients::#{camelize(opts[:http_client].to_s)}.new"

      require_relative "mementos/#{opts[:memento]}"
      memento = eval "::Linkly::Mementos::#{camelize(opts[:memento].to_s)}.new"

      require_relative "caches/#{opts[:cache].to_s}"
      @cache = eval "::Linkly::Caches::#{camelize(opts[:cache].to_s)}.new"

      @builder   = Linkly::DocumentBuilder.new(memento)
    end

    def get_document(url)
      document = nil

      url = Url.new(url)

      if url.valid?
        document = @cache.fetch(url.canonical) do |canonical|
          document = nil

          response = @http_client.get(url.url)

          if response.success?
            document = @builder.build(response).to_h
          else
           puts "#{response.code}: #{url.url}"
          end

          document
        end
      end

      document
    end

    private
    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end
  end
end