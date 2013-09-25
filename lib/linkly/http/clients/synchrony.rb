require "em-synchrony"
require "em-synchrony/em-http"

module Linkly
  module HTTP
    module Clients
      class Synchrony

        def initialize
          @request_options = {
              :redirects => 7
          }
        end

        def get(url)
          http = ::EventMachine::HttpRequest.new(url).get(@request_options)

          last_url = http.last_effective_url ? http.last_effective_url.to_s : url

          HTTP::Response.new(last_url, http.response, http.response_header.status, http.response_header)
        end
      end
    end
  end
end