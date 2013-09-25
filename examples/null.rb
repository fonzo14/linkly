require_relative "examples_helper"

EM.synchrony do
  urls = %w(
    http://www.lequipe.fr/Football/Actualites/Messi-polemique-avec-la-presse/403825
  )

  linkly = Linkly.new :cache => :null, :memento => :null

  urls.each do |url|
    document = linkly.get_document url
    p document
  end

  EM.stop
end