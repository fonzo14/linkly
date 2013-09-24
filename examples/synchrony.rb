require_relative "examples_helper"

EM.synchrony do
  urls = %w(
    http://www.youtube.com/watch?v=5N4VmVLO_Co
    http://www.lemonde.fr/societe/article/2013/09/24/bettencourt-les-poursuites-contre-sarkozy-validees_3483423_3224.html?toto=zut
    http://tempsreel.nouvelobs.com/faits-divers/20130924.OBS8194/lyon-au-moins-trois-morts-dans-le-crash-d-un-avion-de-tourisme.html
    http://www.agoravox.fr/actualites/economie/article/ces-jobs-inutiles-141312
    http://www.motomag.com/Nouveaute-2014-Suzuki-devoile-son-V-Strom-1000.html
  )

  urls.each do |url|
    linkly = Linkly.new :cache => :null, :memento => :sqlite3
    document = linkly.get_document url
    p document
  end

  EM.stop
end