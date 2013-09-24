module Linkly
  module HTTP
    class Response
      attr_reader :url, :body, :code, :headers

      def initialize(uri, body, code, headers={})
        @url, @body, @code, @headers = uri.to_s, body, code.to_i, headers
      end

      def success?
        code > 0 && code < 400
      end

      def failure?
        !success?
      end

      def to_s
        [url, code].join(' : ')
      end
    end
  end
end