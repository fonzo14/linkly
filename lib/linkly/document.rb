module Linkly
  class Document
    attr_reader :title, :text
    attr_accessor :image, :type, :platform, :url

    def title=(t)
      @title = truncate(t.to_s.strip, 255)
    end

    def text=(t)
      @text = truncate(t.to_s.strip, 400)
    end

    def valid?
      title && !title.empty? && url && Linkly::Platform::ALL.include?(platform) && Linkly::DocumentType::ALL.include?(type)
    end

    def to_h
      {
          :id => url.id,
          :url => url.url,
          :title => title,
          :text => text,
          :image => image,
          :platform => platform,
          :type => type
      }
    end

    def to_s
      to_h.to_s
    end

    private
    def truncate(text, length, options = {})
      text = text.dup
      options[:omission] ||= "..."

      length_with_room_for_omission = length - options[:omission].length
      chars = text
      stop = options[:separator] ?
          (chars.rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission) : length_with_room_for_omission

      (chars.length > length ? chars[0...stop] + options[:omission] : text).to_s
    end
  end
end