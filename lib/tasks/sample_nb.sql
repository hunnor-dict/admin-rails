SET NAMES 'utf8';

TRUNCATE TABLE hn_nb_forms;
TRUNCATE TABLE hn_nb_trans;

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('1', '1', 'lastebil', 'subst', '700', '1'),
	('1', '1', 'lastebilen', 'subst', '700', '2'),
	('1', '1', 'lastebiler', 'subst', '700', '3'),
	('1', '1', 'lastebilene', 'subst', '700', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('1', 'hu', '<senseGrp><sense><trans>teherautó</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('2', '2', 'jente', 'subst', '702', '1'),
	('2', '2', 'jenten', 'subst', '702', '2'),
	('2', '2', 'jenter', 'subst', '702', '3'),
	('2', '2', 'jentene', 'subst', '702', '4'),
	('2', '2', 'jente', 'subst', '902', '1'),
	('2', '2', 'jenta', 'subst', '902', '2'),
	('2', '2', 'jenter', 'subst', '902', '3'),
	('2', '2', 'jentene', 'subst', '902', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('2', 'hu', '<senseGrp><sense><trans>lány</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('3', '3', 'bonde', 'subst', '760', '1'),
	('3', '3', 'bonden', 'subst', '760', '2'),
	('3', '3', 'bønder', 'subst', '760', '3'),
	('3', '3', 'bøndene', 'subst', '760', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('3', 'hu', '<senseGrp><sense><trans>paraszt</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('4', '4', 'bjørk', 'subst', '700', '1'),
	('4', '4', 'bjørken', 'subst', '700', '2'),
	('4', '4', 'bjørker', 'subst', '700', '3'),
	('4', '4', 'bjørkene', 'subst', '700', '4'),
	('4', '4', 'bjørk', 'subst', '900', '1'),
	('4', '4', 'bjørka', 'subst', '900', '2'),
	('4', '4', 'bjørker', 'subst', '900', '3'),
	('4', '4', 'bjørkene', 'subst', '900', '4');
INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('5', '4', 'bjerk', 'subst', '700', '1'),
	('5', '4', 'bjerken', 'subst', '700', '2'),
	('5', '4', 'bjerker', 'subst', '700', '3'),
	('5', '4', 'bjerkene', 'subst', '700', '4'),
	('5', '4', 'bjerk', 'subst', '900', '1'),
	('5', '4', 'bjerka', 'subst', '900', '2'),
	('5', '4', 'bjerker', 'subst', '900', '3'),
	('5', '4', 'bjerkene', 'subst', '900', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('4', 'hu', '<senseGrp><sense><trans>fenyő</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('6', '6', 'barn', 'subst', '800', '1'),
	('6', '6', 'barnet', 'subst', '800', '2'),
	('6', '6', 'barn', 'subst', '800', '3'),
	('6', '6', 'barna', 'subst', '800', '4'),
	('6', '6', 'barn', 'subst', '810', '1'),
	('6', '6', 'barnet', 'subst', '810', '2'),
	('6', '6', 'barn', 'subst', '810', '3'),
	('6', '6', 'barnene', 'subst', '810', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('6', 'hu', '<senseGrp><sense><trans>gyerek</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('7', '7', 'bil', 'subst', '700', '1'),
	('7', '7', 'bilen', 'subst', '700', '2'),
	('7', '7', 'biler', 'subst', '700', '3'),
	('7', '7', 'bilene', 'subst', '700', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('7', 'hu', '<senseGrp><sense><trans>autó</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('8', '8', 'brekke', 'verb', '281', '1'),
	('8', '8', 'brekker', 'verb', '281', '2'),
	('8', '8', 'brekkes', 'verb', '281', '3'),
	('8', '8', 'brakk', 'verb', '281', '4'),
	('8', '8', 'brukket', 'verb', '281', '5'),
	('8', '8', 'brukket', 'adj', '281', '6'),
	('8', '8', 'brukket', 'adj', '281', '7'),
	('8', '8', 'brukne', 'adj', '281', '8'),
	('8', '8', 'brukne', 'adj', '281', '9'),
	('8', '8', 'brekkende', 'adj', '281', '10'),
	('8', '8', 'brekk', 'verb', '281', '11'),
	('8', '8', 'brekke', 'verb', '282', '1'),
	('8', '8', 'brekker', 'verb', '282', '2'),
	('8', '8', 'brekkes', 'verb', '282', '3'),
	('8', '8', 'brakk', 'verb', '282', '4'),
	('8', '8', 'brukket', 'verb', '282', '5'),
	('8', '8', 'brukket', 'adj', '282', '6'),
	('8', '8', 'brukken', 'adj', '282', '7'),
	('8', '8', 'brukne', 'adj', '282', '8'),
	('8', '8', 'brukne', 'adj', '282', '9'),
	('8', '8', 'brekkende', 'adj', '282', '10'),
	('8', '8', 'brekk', 'verb', '282', '11');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('8', 'hu', '<senseGrp><sense><trans>tör</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('9', '9', 'bjørn', 'subst', '700', '1'),
	('9', '9', 'bjørnen', 'subst', '700', '2'),
	('9', '9', 'bjørner', 'subst', '700', '3'),
	('9', '9', 'bjørnene', 'subst', '700', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('9', 'hu', '<senseGrp><sense><trans>medve</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('10', '10', 'koloni', 'subst', '700', '1'),
	('10', '10', 'kolonien', 'subst', '700', '2'),
	('10', '10', 'kolonier', 'subst', '700', '3'),
	('10', '10', 'koloniene', 'subst', '700', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('10', 'hu', '<senseGrp><sense><trans>kolónia</trans></sense></senseGrp>');

INSERT INTO hn_nb_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('11', '11', 'kondensator', 'subst', '700', '1'),
	('11', '11', 'kondensatoren', 'subst', '700', '2'),
	('11', '11', 'kondensatorer', 'subst', '700', '3'),
	('11', '11', 'kondensatorene', 'subst', '700', '4');
INSERT INTO hn_nb_trans
	(id, lang, trans)
VALUES
	('11', 'hu', '<senseGrp><sense><trans>kondenzátor</trans></sense></senseGrp>');
