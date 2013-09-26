require_relative "examples_helper"

EM.synchrony do
  urls = %w(
    http://feedproxy.google.com/~r/Woork/~3/EyjdJihzUAQ
  )

  linkly = Linkly.new :cache => :null, :memento => :null

  urls.each do |url|
    document = linkly.get_document url
    p document
  end

  EM.stop
end