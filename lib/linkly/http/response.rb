module Linkly
  module HTTP
    class Response
      attr_reader :url, :body, :code, :headers

      def initialize(url, body, code, headers={})
        @url, @body, @code, @headers = Linkly::Url.new(url), body, code.to_i, headers
      end

      def success?
        code > 0 && code < 400
      end

      def failure?
        !success?
      end

      def to_s
        [url.url, code].join(' : ')
      end
    end
  end
end