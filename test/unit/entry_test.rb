require "test_helper"

class EntryTest < ActiveSupport::TestCase

	test "entry has to xml method" do
		entry = Entry.new :nb, 35317, {:trans => true}, nil
		assert entry.respond_to? :to_xml_doc
	end

	test "nb lastebil" do
		entry = Entry.new :nb, 35317, {:trans => true}, nil
		expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
			"<hnDict xmlns=\"http://dict.hunnor.net\">\n" +
			"\t<entryGrp>\n" +
			"\t\t<entry id=\"35317\">\n" +
			"\t\t\t<formGrp>\n" +
			"\t\t\t\t<form primary=\"yes\">\n" +
			"\t\t\t\t\t<orth>lastebil</orth>\n" +
			"\t\t\t\t\t<pos>subst</pos>\n" +
			"\t\t\t\t\t<inflCode type=\"bob\">m1</inflCode>\n" +
			"\t\t\t\t\t<inflCode type=\"suff\">-en</inflCode>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-0\">lastebilen</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-1\">lastebiler</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-2\">lastebilene</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t</form>\n" +
			"\t\t\t</formGrp>\n" +
			"\t\t\t<senseGrp>\n" +
			"\t\t\t\t<sense>\n" +
			"\t\t\t\t\t<trans>teherautó</trans>\n" +
			"\t\t\t\t\t<trans>kamion</trans>\n" +
			"\t\t\t\t</sense>\n" +
			"\t\t\t</senseGrp>\n" +
			"\t\t</entry>\n" +
			"\t</entryGrp>\n" +
			"</hnDict>\n"
		doc = entry.to_xml_doc
		actual = doc.to_xml(:encoding => "UTF-8", :indent_text => "\t", :indent => 1)
		assert_equal actual, expected
	end

	test "nb vann" do
		entry = Entry.new :nb, 68706, {:trans => true}, nil
		expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
			"<hnDict xmlns=\"http://dict.hunnor.net\">\n" +
			"\t<entryGrp>\n" +
			"\t\t<entry id=\"68706\">\n" +
			"\t\t\t<formGrp>\n" +
			"\t\t\t\t<form primary=\"yes\">\n" +
			"\t\t\t\t\t<orth>varmtvann</orth>\n" +
			"\t\t\t\t\t<pos>subst</pos>\n" +
			"\t\t\t\t\t<inflCode type=\"bob\">n1</inflCode>\n" +
			"\t\t\t\t\t<inflCode type=\"suff\">-et</inflCode>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-0\">varmtvannet</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-1\">varmtvann</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-2\">varmtvanna</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-0\">varmtvannet</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-1\">varmtvann</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-2\">varmtvannene</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t</form>\n" +
			"\t\t\t</formGrp>\n" +
			"\t\t\t<senseGrp>\n" +
			"\t\t\t\t<sense>\n" +
			"\t\t\t\t\t<trans>melegvíz</trans>\n" +
			"\t\t\t\t</sense>\n" +
			"\t\t\t</senseGrp>\n" +
			"\t\t</entry>\n" +
			"\t</entryGrp>\n" +
			"</hnDict>\n"
		doc = entry.to_xml_doc
		actual = doc.to_xml(:encoding => "UTF-8", :indent_text => "\t", :indent => 1)
		assert_equal actual, expected
	end

	test "nb vanne vatne" do
		entry = Entry.new :nb, 68392, {:trans => true}, nil
		expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
			"<hnDict xmlns=\"http://dict.hunnor.net\">\n" +
			"\t<entryGrp>\n" +
			"\t\t<entry id=\"68392\">\n" +
			"\t\t\t<formGrp>\n" +
			"\t\t\t\t<form primary=\"yes\">\n" +
			"\t\t\t\t\t<orth>vanne</orth>\n" +
			"\t\t\t\t\t<pos>verb</pos>\n" +
			"\t\t\t\t\t<inflCode type=\"bob\">v1</inflCode>\n" +
			"\t\t\t\t\t<inflCode type=\"suff\">-et/-a</inflCode>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-0\">vanner</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-1\">vanna</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-2\">vanna</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-0\">vanner</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-1\">vannet</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-2\">vannet</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t</form>\n" +
			"\t\t\t\t<form primary=\"no\">\n" +
			"\t\t\t\t\t<orth>vatne</orth>\n" +
			"\t\t\t\t\t<inflCode type=\"bob\">v1</inflCode>\n" +
			"\t\t\t\t\t<inflCode type=\"suff\">-et/-a</inflCode>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-0\">vatner</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-1\">vatna</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"0-2\">vatna</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t\t<inflPar>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-0\">vatner</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-1\">vatnet</inflSeq>\n" +
			"\t\t\t\t\t\t<inflSeq form=\"1-2\">vatnet</inflSeq>\n" +
			"\t\t\t\t\t</inflPar>\n" +
			"\t\t\t\t</form>\n" +
			"\t\t\t</formGrp>\n" +
			"\t\t\t<senseGrp>\n" +
			"\t\t\t\t<sense>\n" +
			"\t\t\t\t\t<trans>öntöz</trans>\n" +
			"\t\t\t\t\t<trans>locsol</trans>\n" +
			"\t\t\t\t</sense>\n" +
			"\t\t\t</senseGrp>\n" +
			"\t\t</entry>\n" +
			"\t</entryGrp>\n" +
			"</hnDict>\n"
		doc = entry.to_xml_doc
		actual = doc.to_xml(:encoding => "UTF-8", :indent_text => "\t", :indent => 1)
		assert_equal actual, expected
	end

	test "hu teherauto" do
		entry = Entry.new :hu, 10852, {:trans => true}, nil
		expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
			"<hnDict xmlns=\"http://dict.hunnor.net\">\n" +
			"\t<entryGrp>\n" +
			"\t\t<entry id=\"10852\">\n" +
			"\t\t\t<formGrp>\n" +
			"\t\t\t\t<form primary=\"yes\">\n" +
			"\t\t\t\t\t<orth>teherautó</orth>\n" +
			"\t\t\t\t\t<pos>fn</pos>\n" +
			"\t\t\t\t</form>\n" +
			"\t\t\t</formGrp>\n" +
			"\t\t\t<senseGrp>\n" +
			"\t\t\t\t<sense>\n" +
			"\t\t\t\t\t<trans>lastebil</trans>\n" +
			"\t\t\t\t</sense>\n" +
			"\t\t\t</senseGrp>\n" +
			"\t\t</entry>\n" +
			"\t</entryGrp>\n" +
			"</hnDict>\n"
		doc = entry.to_xml_doc
		actual = doc.to_xml(:encoding => "UTF-8", :indent_text => "\t", :indent => 1)
		assert_equal actual, expected
	end

	test "additional ids" do
		entry = Entry.new :nb, 4783, {:trans => true}, nil
		expected = [74132, 4782, 74140]
		actual = entry.get_ids_from_entry
		assert_equal actual, expected
	end

end
