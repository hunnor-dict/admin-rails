#encoding: utf-8
require "mysql2"

def db_connect
	$DB_LINK = Mysql2::Client.new(
		:host => ENV["DB_MYSQL_HOST"],
		:username => ENV["DB_MYSQL_USER"],
		:password => ENV["DB_MYSQL_PASS"],
		:database => ENV["DB_MYSQL_DB"])
	puts "Database #{ENV["DB_MYSQL_DB"]}: Connected."
end

def db_disconnect
	$DB_LINK.close
	puts "Disconnected."
end

def populate_hun_c
	$DB_LINK.query "INSERT INTO hn_hun_segment (id, entry, orth, pos, par, seq, status) VALUES " \
		"('10', '10', 'család', 'fn', '0', '1', '2')," \
		"('11', '11', 'csalán', 'fn', '0', '1', '2')," \
		"('12', '12', 'csabafű', 'fn', '0', '1', '1')," \
		"('13', '13', 'csütörtök', 'fn', '0', '1', '2')," \
		"('14', '14', 'csapol', 'ige', '0', '1', '1')," \
		"('15', '15', 'civilizálatlan', 'mn', '0', '1', '2')," \
		"('16', '16', 'cukor', 'fn', '0', '1', '1')," \
		"('17', '17', 'cápa', 'fn', '0', '1', '2')," \
		"('18', '18', 'címszó', 'fn', '0', '1', '2')," \
		"('19', '19', 'civakodik', 'ige', '0', '1', '1');"
	$DB_LINK.query "INSERT INTO hn_hun_tr_nob_tmp (id, trans) VALUES " \
		"('10', '<senseGrp><sense><trans>familie</trans></sense></senseGrp>')," \
		"('11', '<senseGrp><sense><trans>brennesle</trans></sense></senseGrp>')," \
		"('12', '<senseGrp><sense><trans>gjeldkarve</trans></sense></senseGrp>')," \
		"('13', '<senseGrp><sense><trans>torsdag</trans></sense></senseGrp>')," \
		"('14', '<senseGrp><sense><trans>tappe</trans></sense></senseGrp>')," \
		"('15', '<senseGrp><sense><trans>usivilisert</trans></sense></senseGrp>')," \
		"('16', '<senseGrp><sense><trans>sukker</trans></sense></senseGrp>')," \
		"('17', '<senseGrp><sense><trans>hai</trans></sense></senseGrp>')," \
		"('18', '<senseGrp><sense><trans>oppslagsord</trans></sense></senseGrp>')," \
		"('19', '<senseGrp><sense><trans>krangle</trans></sense></senseGrp>');"
end

def populate_hun_k
	$DB_LINK.query "INSERT INTO hn_hun_segment (id, entry, orth, pos, par, seq, status) VALUES " \
		"('20', '20', 'konferencia', 'fn', '0', '1', '1')," \
		"('21', '21', 'kolléga', 'fn', '0', '1', '1')," \
		"('22', '22', 'kollégium', 'fn', '0', '1', '1')," \
		"('23', '23', 'koncentrál', 'ige', '0', '1', '2')," \
		"('24', '24', 'koncentráció', 'fn', '0', '1', '2')," \
		"('25', '25', 'kombájn', 'fn', '0', '1', '1')," \
		"('26', '26', 'kommunikáció', 'fn', '0', '1', '2')," \
		"('27', '27', 'korrigál', 'ige', '0', '1', '2')," \
		"('28', '28', 'kommunista', 'fn', '0', '1', '2')," \
		"('29', '29', 'kormány', 'fn', '0', '1', '1');"
	$DB_LINK.query "INSERT INTO hn_hun_tr_nob_tmp (id, trans) VALUES " \
		"('20', '<senseGrp><sense><trans>konferanse</trans></sense></senseGrp>')," \
		"('21', '<senseGrp><sense><trans>kollega</trans></sense></senseGrp>')," \
		"('22', '<senseGrp><sense><trans>studenthjem</trans></sense></senseGrp>')," \
		"('23', '<senseGrp><sense><trans>konsentrere</trans></sense></senseGrp>')," \
		"('24', '<senseGrp><sense><trans>konsentrasjon</trans></sense></senseGrp>')," \
		"('25', '<senseGrp><sense><trans>skurtresker</trans></sense></senseGrp>')," \
		"('26', '<senseGrp><sense><trans>kommunikasjon</trans></sense></senseGrp>')," \
		"('27', '<senseGrp><sense><trans>korrigere</trans></sense></senseGrp>')," \
		"('28', '<senseGrp><sense><trans>kommunist</trans></sense></senseGrp>')," \
		"('29', '<senseGrp><sense><trans>regjering</trans></sense></senseGrp>');"
end

def populate_hun_a
        $DB_LINK.query "INSERT INTO hn_hun_segment (id, entry, orth, pos, par, seq, status) VALUES " \
                "('30', '30', 'ablak', 'fn', '0', '1', '2')," \
                "('31', '31', 'abortál', 'ige', '0', '1', '2')," \
                "('32', '32', 'állami', 'mn', '0', '1', '0')," \
                "('33', '33', 'Afrika', 'fn', '0', '1', '2')," \
                "('34', '34', 'ábrándozik', 'ige', '0', '1', '1');"
        $DB_LINK.query "INSERT INTO hn_hun_tr_nob_tmp (id, trans) VALUES " \
                "('30', '<senseGrp><sense><trans>vindu</trans></sense></senseGrp>')," \
                "('31', '<senseGrp><sense><trans>abortere</trans></sense></senseGrp>')," \
                "('32', '<senseGrp><sense><trans>statslig</trans></sense></senseGrp>')," \
                "('33', '<senseGrp><sense><trans>Afrika</trans></sense></senseGrp>')," \
                "('34', '<senseGrp><sense><trans>dagdrømme</trans></sense></senseGrp>');"
end

def populate_nob_b
	$DB_LINK.query "INSERT INTO hn_nob_segment (id, entry, orth, pos, par, seq, status) VALUES " \
		"('10', '10', 'bil', 'subst', '700', '1', '2')," \
		"('10', '10', 'bilen', 'subst', '700', '2', '2')," \
		"('10', '10', 'biler', 'subst', '700', '3', '2')," \
		"('10', '10', 'bilene', 'subst', '700', '4', '2');"
	$DB_LINK.query "INSERT INTO hn_nob_tr_hun_tmp (id, trans) VALUES " \
		"('10', '<senseGrp><sense><trans>autó</trans></sense></senseGrp>');"
end

def populate_nob_v
	$DB_LINK.query "INSERT INTO hn_nob_segment (id, entry, orth, pos, par, seq, status) VALUES " \
		"('20', '20', 'vann', 'subst', '800', '1', '2')," \
		"('20', '20', 'vannet', 'subst', '800', '2', '2')," \
		"('20', '20', 'vann', 'subst', '800', '3', '2')," \
		"('20', '20', 'vanna', 'subst', '800', '4', '2')," \
		"('20', '20', 'vann', 'subst', '810', '1', '2')," \
		"('20', '20', 'vannet', 'subst', '810', '2', '2')," \
		"('20', '20', 'vann', 'subst', '810', '3', '2')," \
		"('20', '20', 'vannene', 'subst', '810', '4', '2')," \
		"('21', '20', 'vann', 'subst', '800', '1', '2')," \
		"('21', '20', 'vannet', 'subst', '800', '2', '2')," \
		"('21', '20', 'vann', 'subst', '800', '3', '2')," \
		"('21', '20', 'vanna', 'subst', '800', '4', '2')," \
		"('21', '20', 'vann', 'subst', '810', '1', '2')," \
		"('21', '20', 'vannet', 'subst', '810', '2', '2')," \
		"('21', '20', 'vann', 'subst', '810', '3', '2')," \
		"('21', '20', 'vannene', 'subst', '810', '4', '2');"
	$DB_LINK.query "INSERT INTO hn_nob_tr_hun_tmp (id, trans) VALUES " \
		"('20', '<senseGrp><sense><trans>víz</trans><trans>dihidrogén-monoxid</trans></sense><sense><trans>tó</trans></sense></senseGrp>');"
end

def populate_editors
	$DB_LINK.query "INSERT INTO hn_adm_editors (id, provider, uid) VALUES " \
		"('ardavan', 'facebook', '570487915')," \
		"('ardavan', 'google_oauth2', '104643950896552677888')," \
		"('ardavan', 'linkedin', 'TRpE2vvpzM')," \
		"('ardavan', 'twitter', '68137658');"
end

namespace :hn do

	desc "Import sample data for testing"
	task :fixtures do |t, args|
		db_connect
		$DB_LINK.query "TRUNCATE TABLE hn_adm_editors"
		populate_editors
		$DB_LINK.query "TRUNCATE TABLE hn_hun_segment"
		$DB_LINK.query "TRUNCATE TABLE hn_hun_tr_nob_tmp"
		populate_hun_c
		populate_hun_k
		populate_hun_a
		$DB_LINK.query "TRUNCATE TABLE hn_nob_segment"
		$DB_LINK.query "TRUNCATE TABLE hn_nob_tr_hun_tmp"
		populate_nob_b
		populate_nob_v
		db_disconnect
	end

end

