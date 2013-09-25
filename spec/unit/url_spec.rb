# encoding: utf-8
require 'spec_helper'

module Linkly
  describe Url do

    it "should check the url validity" do
      Url.new("http://www.lemonde.fr/toto.html").valid?.should be_true
      Url.new("https://www.lemonde.fr/toto.html").valid?.should be_true
      Url.new("ftp://www.lemonde.fr/toto.html").valid?.should be_false
      Url.new("http:/127.0.0.1/toto.html").valid?.should be_false
      Url.new("http:/0.0.0.0/toto.html").valid?.should be_false
      Url.new("http:/localhost/toto.html").valid?.should be_false
      Url.new(nil).valid?.should be_false
    end

    it "should force the url" do
      Url.new("http://www.lemonde.fr:80/toto.html", :force => true).url.should eq "http://www.lemonde.fr:80/toto.html"
      Url.new("http://www.lemonde.fr:80/toto.html", :force => false).url.should eq "http://www.lemonde.fr/toto.html"
    end

    it "should define a canonical url" do
      u1 = Url.new("http://www.LEmonde.fr/toto.html")
      u1.canonical.should eq "http://lemonde.fr/toto.html"

      u2 = Url.new("https://lemonde.fr/toto.html")
      u2.canonical.should eq u1.canonical
    end

    it "should define a numeric ID" do
      u1 = Url.new("http://www.lemonde.fr/toto.html")
      u1.id.should eq 151229629298312522934959243871111090804

      u2 = Url.new("https://lemonde.fr/toto.html")
      u2.id.should eq u1.id
    end

    it "should return the domain" do
      Url.new("http://www.lemonde.fr/toto.html").domain.should eq "www.lemonde.fr"
      Url.new("https://lemonde.fr/toto.html").domain.should eq "www.lemonde.fr"
    end

    it "should c18n the url" do
      %w(
        http://www.lemonde.fr/toto.html
        http://www.lemonde.fr:80/toto.html
        http://www.lemonde.fr/toto.html:
        https://www.lemonde.fr/toto.html
        http://www.lemonde.fr/toto.html#foo
        http://www.lemonde.fr/toto.html?
        http://www.lemonde.fr/toto.html#
        http://www.lemonde.fr/toto.html/
        http://www.lemonde.fr/toto.html?utm_medium=xx
        http://www.lemonde.fr/toto.html?utm_medium=xx&&utm_campaign=xx
      ).each do |u|
        url = Url.new(u)
        url.url.should eq "http://www.lemonde.fr/toto.html"
      end

      embedded_url = "http://news.google.com/news/url?sa=t&fd=R&usg=AFQjCNGSlY3LT2l2kmBu8SUqr3Y3QjSNVQ&url=http://www.metronews.fr/people/photos-24-heures-dans-la-vie-des-people/mmiy!Ypxj2OklaCXvg/"
      Url.new(embedded_url).url.should eq "http://www.metronews.fr/people/photos-24-heures-dans-la-vie-des-people/mmiy!Ypxj2OklaCXvg"
    end

  end
end