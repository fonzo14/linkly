# encoding: utf-8
require 'spec_helper'

module Linkly
  module HTTP
    describe Helper do

      class Toto
        include HTTP::Helper
      end

      let(:toto) { Toto.new }

      it "should convert the html to text" do
        toto.to_text("<p>toto</p>").should eq "toto"
        toto.to_text("<p>toto<br /></p>").should eq "toto"
        toto.to_text("<p>toto<br/></p>").should eq "toto"
        toto.to_text("atteinte à la liberté d&#39;expression, s&#39;est pourvu en justice. &lt;br /&gt; Le ministère").should eq "atteinte à la liberté d'expression, s'est pourvu en justice. Le ministère"
        toto.to_text("atteinte à la liberté d&#39;expression, s&#39;est pourvu en justice. &lt;br/&gt; Le ministère").should eq "atteinte à la liberté d'expression, s'est pourvu en justice. Le ministère"
        toto.to_text("<div><p>toto</p>tutu</div>").should eq "toto tutu"
        toto.to_text("La victime, qui dit avoir &#xE9;t&#xE9; viol&#xE9;e par plusieurs ados en 2009, les a retrouv&#xE9;s sur le r&#xE9;seau social.").should eq 'La victime, qui dit avoir été violée par plusieurs ados en 2009, les a retrouvés sur le réseau social.'
        html=<<-EOS
<table border=\"0\" cellpadding=\"2\" cellspacing=\"7\"; style=\"vertical-align:top\"> <tr> <td width=\"200\" align=\"center\" valign=\"top\"> <img alt=\"img\" [...] width=\"200\" height=\"100\"/> </td> <td valign=\"top\">A un an des municipales, Gérard Collomb est bien parti pour préserver sa place face à une droite divisée. Reportage. </td> </tr> </table>
        EOS
        toto.to_text(html).should eq "A un an des municipales, Gérard Collomb est bien parti pour préserver sa place face à une droite divisée. Reportage."
        html=<<-EOS
&lt;table border="0" cellpadding="2" cellspacing="7"; style="vertical-align:top"&gt;
          &lt;tr&gt;
                        &lt;td width="200" align="center" valign="top"&gt;
              &lt;img alt="img" src="http://www.bfmtv.com/i/200/100/448838.jpg" width="200" height="100"/&gt;
            &lt;/td&gt;
                        &lt;td valign="top"&gt;A un an des municipales, G&#xE9;rard Collomb est bien parti pour pr&#xE9;server sa place face &#xE0; une droite divis&#xE9;e. Reportage. &lt;/td&gt;
          &lt;/tr&gt;
        &lt;/table&gt;
        EOS
        toto.to_text(html).should eq "A un an des municipales, Gérard Collomb est bien parti pour préserver sa place face à une droite divisée. Reportage."
        toto.to_text(nil).should eq ''
        toto.to_text('').should eq ''
      end

      it "should let text as text" do
        txt = "il fait beau aujourd'hui c'est une agréable journée ..."
        toto.to_text(txt).should eq txt
      end

      it "should remove / replace too long words" do
        txt = "il fait beau ???blablabla c'est une agré=able journée ... anticonst=itutionnellementtttt"
        toto.to_text(txt).should eq "il fait beau ???blablabla c'est une agré=able journée ... [...]"
        toto.to_text(txt, :max_length => 7, :replacement => 'AAA').should eq "il fait beau ???blablabla c'est une AAA journée ... AAA"
      end

      it "shouls work on a real example" do
        input = %q(le sujet tombe � pic ! br /A six mois
  des �lections de 2012, la d�fiance (...)\n\n\n-\na href=\"http://www.elunet.org/spip/IMG/article_PDF/spip.php?rubrique1841\"
  rel=\"directory\"Cidefil 04 novembre 2011/a\n\n/ \na href=\"http://www.elunet.org/spip/IMG/article_PDF/spip.php?mot246\"
  rel=\"tag\"AMF/a, \na href=\"http://www.elunet.org/spip/IMG/article_PDF/spip.php?mot440\"
  rel=\"tag\"en_avant/a)
        output = %q(le sujet tombe � pic ! br /A six mois des �lections de 2012, la d�fiance (...)\n\n\n-\na [...] rel=\"directory\"Cidefil 04 novembre 2011/a\n\n/ \na [...] rel=\"tag\"AMF/a, \na [...] rel=\"tag\"en_avant/a)
        toto.to_text(input).should eq output
      end

      it "should trim the text" do
        toto.to_text("   ").should eq ""
      end

    end
  end
end