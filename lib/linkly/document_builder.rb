module Linkly
  class DocumentBuilder

    BUILDERS = {
        /youtube\.com\/.*v=/ => Linkly::Builders::Youtube.new,
        /instagram\.com\/p\// => Linkly::Builders::Instagram.new,
        /dailymotion\.com\/video\// => Linkly::Builders::Dailymotion.new,
        /vine\.co\/v\// => Linkly::Builders::Vine.new,
    }.freeze

    def initialize(memento)
      @generic = Linkly::Builders::Generic.new(memento)
    end

    def build(response)
      select_builder(response).build(response)
    end

    private
    def select_builder(response)
      pattern = BUILDERS.keys.find { |r| response.url.url =~ r }
      pattern ? BUILDERS[pattern] : @generic
    end

  end
end