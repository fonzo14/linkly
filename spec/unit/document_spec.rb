# encoding: utf-8
require 'spec_helper'

module Linkly
  describe Document do

    it "should return the document hash" do
      doc = Document.new
      doc.title = "mytitle"
      doc.text = 'mytext'
      doc.image = 'myimage'
      doc.type = DocumentType::ARTICLE
      doc.platform = Platform::TWITTER
      doc.url = Url.new("http://www.lemonde.fr/toto.html")
      doc.to_h.should eq({
        :id=>94009941251302587138215505806018425383091714260914781779882807741867564196443333220072808395232,
        :url=>"http://www.lemonde.fr/toto.html",
        :title=>"mytitle",
        :text=>"mytext",
        :image=>"myimage",
        :platform=>Platform::TWITTER,
        :type=>:article})
    end

    it 'should check the document validity' do
      doc = Document.new
      doc.url = Url.new("http://www.lemonde.fr/toto.html")
      doc.valid?.should be_false
      doc.type = DocumentType::ARTICLE
      doc.valid?.should be_false
      doc.platform = Platform::UNKNOWN
      doc.valid?.should be_false
      doc.title = "   "
      doc.valid?.should be_false
      doc.title = "mytitle"
      doc.valid?.should be_true
    end

  end
end