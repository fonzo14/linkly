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

    it "should return the original url" do
      Url.new("http://www.lemonde.fr/toto.html#foo").original_url.should eq "http://www.lemonde.fr/toto.html#foo"
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

    it "should define the same numeric ID" do
      u1 = Url.new("http://www.lemonde.fr/toto.html")
      u1.id.should be_a_kind_of(Numeric)

      u2 = Url.new("https://lemonde.fr/toto.html")
      u2.id.should eq u1.id
    end

    it "should return the domain" do
      Url.new("http://www.lemonde.fr/toto.html").domain.should eq "lemonde.fr"
      Url.new("https://lemonde.fr/toto.html").domain.should eq "lemonde.fr"
      Url.new("https://www.theguardian.co.uk/toto.html").domain.should eq "theguardian.co.uk"
      Url.new("https://theguardian.co.uk/toto.html").domain.should eq "theguardian.co.uk"
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

    it "should compute the url's handicap" do
      Url.new("http://www.lemonde.fr/toto.html", :force => true).handicap.should eq 0
      Url.new("http://www.lemonde.fr/toto.html?q=foo", :force => true).handicap.should eq -1
      Url.new("http://www.lemonde.fr/toto.html#foo", :force => true).handicap.should eq -1
      Url.new("http://www.lemonde.fr/toto.html?q=foo#foo", :force => true).handicap.should eq -2
      Url.new("", :force => true).handicap.should eq -5
      Url.new("http://feedproxy.com/toto.html", :force => true).handicap.should eq -2
      Url.new("http://feedfoo.com/toto.html", :force => true).handicap.should eq -1
    end

    it "should return an (almost unique ID) for the url's canonical" do
      urls, count, collision = {}, 0, 0
      canonicals = {}

      IO.foreach(File.join(ROOT_SPEC, "unit", "uniq-urls.txt")).each do |u|
        count += 1
        url = Url.new(u)
        id = url.id
        unless canonicals.include?(url.canonical)
          canonicals[url.canonical] = true
          if urls.include?(id)
            p [:collision, id, url.original_url, urls[id][0].original_url]
            collision += 1
          end
          urls[id] ||= []
          urls[id] << url
        end
      end

      p [collision, canonicals.size, count]
      collision.should eq 0
    end

  end
end