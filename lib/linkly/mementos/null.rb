module Linkly
  module Mementos
    class Null
      def memorize(domain, url, attribute, value)
        value
      end
    end
  end
end