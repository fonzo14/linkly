module Linkly
  class DocumentBuilder

    BUILDERS = {
        /youtube\.com\/.*v=/ => Linkly::Builders::Youtube.new,
        /instagram\.com\/p\// => Linkly::Builders::Instagram.new,
    }.freeze

    def initialize(memento)
      @generic = Linkly::Builders::Generic.new(memento)
    end

    def build(response)
      pattern = BUILDERS.keys.find { |r| response.url.url =~ r }

      builder = pattern ? BUILDERS[pattern] : @generic

      document = builder.build(response)
      document
    end

  end
end