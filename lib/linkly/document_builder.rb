module Linkly
  class DocumentBuilder

    BUILDERS = {
        /youtube\.com\/.*v=/ => Linkly::Builders::Youtube.new,
        /instagram\.com\/p\// => Linkly::Builders::Instagram.new,
    }.freeze

    def initialize(memento)
      @generic = Linkly::Builders::Generic.new(memento)
    end

    def build(url, body)
      pattern = BUILDERS.keys.find { |r| url =~ r }

      builder = pattern ? BUILDERS[pattern] : @generic

      document = builder.build(url, body)
      document
    end

  end
end