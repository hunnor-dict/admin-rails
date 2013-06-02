SET NAMES 'utf8';

TRUNCATE TABLE hn_nn_forms;
TRUNCATE TABLE hn_nn_trans;

INSERT INTO hn_nn_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('1', '1', 'koloni', 'subst', '700', '1'),
	('1', '1', 'kolonien', 'subst', '700', '2'),
	('1', '1', 'koloniar', 'subst', '700', '3'),
	('1', '1', 'kolokiane', 'subst', '700', '4');
INSERT INTO hn_nn_trans
	(id, lang, trans)
VALUES
	('1', 'hu', '<senseGrp><sense><trans>kolónia</trans></sense></senseGrp>');

INSERT INTO hn_nn_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('2', '2', 'korleis', 'adv', '680', '0');
INSERT INTO hn_nn_trans
	(id, lang, trans)
VALUES
	('2', 'hu', '<senseGrp><sense><trans>hogyan</trans></sense></senseGrp>');

INSERT INTO hn_nn_forms
	(id, entry, orth, pos, par, seq)
VALUES
	('3', '3', 'korkje', 'adv', '689', '0');
INSERT INTO hn_nn_trans
	(id, lang, trans)
VALUES
	('3', 'hu', '<senseGrp><sense><trans>sem</trans></sense></senseGrp>');
