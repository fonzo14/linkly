require_relative "examples_helper"

EM.synchrony do
  urls = %w(
    http://www.youtube.com/watch?v=5N4VmVLO_Co
    http://www.lemonde.fr/societe/article/2013/09/24/bettencourt-les-poursuites-contre-sarkozy-validees_3483423_3224.html?toto=zut
    http://tempsreel.nouvelobs.com/faits-divers/20130924.OBS8194/lyon-au-moins-trois-morts-dans-le-crash-d-un-avion-de-tourisme.html
    http://www.agoravox.fr/actualites/economie/article/ces-jobs-inutiles-141312
    http://www.motomag.com/Nouveaute-2014-Suzuki-devoile-son-V-Strom-1000.html
    http://www.lequipe.fr/Football/Actualites/Trop-joueurs-les-verts/403471
    http://www.lequipe.fr/Football/Actualites/Schalke-sans-boateng-ni-draxler/403662
    http://www.lequipe.fr/Football/Actualites/Pirlo-averti-par-conte/403646
    http://www.lequipe.fr/Football/Actualites/Van-persie-de-retour-samedi/403632
    http://www.lequipe.fr/Football/Actualites/Ancelotti-bale-sera-la-samedi/403614
    http://www.lequipe.fr/Football/Actualites/-on-tire-dans-le-bon-sens/403803
    http://www.lequipe.fr/Football/Actualites/Messi-polemique-avec-la-presse/403825
    http://lequipe.fr/Football/Actualites/Messi-polemique-avec-la-presse/403825
  )

  linkly = Linkly.new :cache => :sqlite3, :memento => :sqlite3

  urls.each do |url|
    document = linkly.get_document url
    p document
  end

  EM.stop
end