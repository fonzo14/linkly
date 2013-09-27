require "nokogiri"
require "addressable/uri"
require "yaml"
require "digest/md5"
require "digest/sha2"
require "hotwater"
require 'json'

require_relative 'linkly/http/helper'
require_relative 'linkly/http/response'

require_relative 'linkly/url'
require_relative 'linkly/document'
require_relative 'linkly/builders/abstract'
require_relative 'linkly/builders/generic'
require_relative 'linkly/builders/instagram'
require_relative 'linkly/builders/youtube'
require_relative 'linkly/builders/dailymotion'
require_relative 'linkly/builders/vine'
require_relative 'linkly/document_builder'

require_relative 'linkly/connection'

module Linkly
  module Platform
    DAILYMOTION = :dailymotion
    YOUTUBE     = :youtube
    TWITTER     = :twitter
    INSTAGRAM   = :instagram
    VINE        = :vine
    UNKNOWN     = :unknown

    ALL = [DAILYMOTION, YOUTUBE, TWITTER, INSTAGRAM, UNKNOWN]
  end

  module DocumentType
    ARTICLE = :article
    VIDEO   = :video
    IMAGE   = :image
    VINE    = :vine

    ALL = [ARTICLE, VIDEO, IMAGE, VINE]
  end

  module HTTP
    module Clients
    end
  end

  module Mementos
  end

  module Caches
  end

  class << self
    def new(opts = {})
      Linkly::Connection.new(opts)
    end
  end
end