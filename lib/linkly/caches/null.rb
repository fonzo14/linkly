module Linkly
  module Caches
    class Null
      def fetch(url, &blk)
        blk.call(url)
      end
    end
  end
end