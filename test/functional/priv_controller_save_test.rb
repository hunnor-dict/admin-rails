#encoding: utf-8
require "test_helper"

class PrivControllerTest < ActionController::TestCase

	test "save unauthorized" do
		get :save, {:lang => "hu", :id => "N"}, nil, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "save lang invalid" do
		get :save, {:lang => "de", :id => "N"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "save lang hu id nil" do
		get :save, {:lang => "hu"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "save lang hu id empty" do
		get :save, {:lang => "hu", :id => ""}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "save lang hu id invalid text" do
		get :save, {:lang => "hu", :id => "Nebuchadnezzar"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "save lang hu id invalid number" do
		get :save, {:lang => "hu", :id => -10}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "save lang hu id 10 pos invalid" do
		get :save, {:entrylang => "hu", :id => 10, :pos => "subst"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal ["A(z) 'hu' nyelvben nincs 'subst' szófaj."], assigns(:errors)
		assert_equal [], assigns(:sql)
	end

	test "save lang hu id 4242" do
		get :save, {:entrylang => "hu", :id => 4242, :pos => "subst"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal ["A(z) 'hu' nyelvben nincs '4242' azonosítójú szócikk."], assigns(:errors)
		assert_equal [], assigns(:sql)
	end

	test "save lang hu id 10 trans no change" do
		get :save, {:entrylang => "hu", :id => 10, :entry => 10, :pos => "fn", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: család\n", :trans => "<senseGrp><sense><trans>familie</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal [], assigns(:errors)
		sql_a = assigns(:sql)
		sql_log = sql_a.pop
		assert_equal [], sql_a
		assert_match(/INSERT INTO hn_log_edit \(editor_id, lang, entry_id, action, timestamp\) VALUES \('ardavan', 'hu', '10', 'update', '(\d)+'\)/, sql_log)
	end

	test "save lang hu id 10 trans malformed" do
		get :save, {:entrylang => "hu", :id => 10, :entry => 10, :pos => "fn", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: család\n", :trans => "<senseGrp><sense><trans>familie<trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal 7, assigns(:errors).size
		assert_equal [], assigns(:sql)
	end

	test "save lang hu id 10 trans invalid" do
		get :save, {:entrylang => "hu", :id => 10, :entry => 10, :pos => "fn", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: család\n", :trans => "<senseGrp><sense><tr>familie</tr></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "Element '{http://dict.hunnor.net}tr': This element is not expected.", assigns(:errors).first.to_s
		assert_equal [], assigns(:sql)
	end

	test "save lang hu id 11 trans valid" do
		get :save, {:entrylang => "hu", :id => 11, :entry => 11, :pos => "fn", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: csalán\n", :trans => "<senseGrp><sense><trans>BRENNESLE</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal [], assigns(:errors)
		sql_a = assigns(:sql)
		sql_log = sql_a.pop
		assert_equal ["UPDATE hn_hun_tr_nob_tmp SET trans = '<senseGrp><sense><trans>BRENNESLE</trans></sense></senseGrp>' WHERE id = '11'"], sql_a
		assert_match(/INSERT INTO hn_log_edit \(editor_id, lang, entry_id, action, timestamp\) VALUES \('ardavan', 'hu', '11', 'update', '(\d)+'\)/, sql_log)
		# Undo.
		get :save, {:entrylang => "hu", :id => 11, :entry => 11, :pos => "fn", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: csalán\n", :trans => "<senseGrp><sense><trans>brennesle</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
	end

	test "save lang hu id 11 entry invalid" do
		get :save, {:entrylang => "hu", :id => 11, :entry => 4242, :pos => "fn", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: csalán\n", :trans => "<senseGrp><sense><trans>brennesle</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal ["A(z) 'hu' nyelvben nem hivatkozhatsz '4242' azonosítójú szócikkre."], assigns(:errors)
		assert_equal [], assigns(:sql)
	end

	test "save lang hu id 11 pos invalid" do
		get :save, {:entrylang => "hu", :id => 11, :entry => 11, :pos => "naboo", :status => "2", :forms => "--- \n? \"0\"\n: \n  1: csalán\n", :trans => "<senseGrp><sense><trans>brennesle</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal ["A(z) 'hu' nyelvben nincs 'naboo' szófaj."], assigns(:errors)
		assert_equal [], assigns(:sql)
	end

	test "save lang hu id 11 status invalid" do
		get :save, {:entrylang => "hu", :id => 11, :entry => 11, :pos => "fn", :status => 4242, :forms => "--- \n? \"0\"\n: \n  1: csalán\n", :trans => "<senseGrp><sense><trans>brennesle</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal ["Érvénytelen státusz: '4242'."], assigns(:errors)
		assert_equal [], assigns(:sql)
	end

	test "save lang no id 10 add remove forms" do
		get :save, {:entrylang => "nb", :id => 10, :entry => 10, :pos => "subst", :status => 2, :forms => "--- \n? \"700\"\n: \n  1: bil\n  2: bilen\n? \"900\"\n: \n  1: bil\n  2: bila\n  3: biler\n  4: bilene\n", :trans => "<senseGrp><sense><trans>autó</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal [], assigns(:errors)
		sql_a = assigns(:sql)
		sql_log = sql_a.pop
		assert_equal ["DELETE FROM hn_nob_segment WHERE id = '10' AND par = '700' AND seq = '3' AND orth = 'biler'",
			"DELETE FROM hn_nob_segment WHERE id = '10' AND par = '700' AND seq = '4' AND orth = 'bilene'",
			"INSERT INTO hn_nob_segment (id, entry, orth, pos, par, seq, status) VALUES ('10', '10', 'bil', 'subst', '900', '1', '2')",
			"INSERT INTO hn_nob_segment (id, entry, orth, pos, par, seq, status) VALUES ('10', '10', 'bila', 'subst', '900', '2', '2')",
			"INSERT INTO hn_nob_segment (id, entry, orth, pos, par, seq, status) VALUES ('10', '10', 'biler', 'subst', '900', '3', '2')",
			"INSERT INTO hn_nob_segment (id, entry, orth, pos, par, seq, status) VALUES ('10', '10', 'bilene', 'subst', '900', '4', '2')"], sql_a
		assert_match(/INSERT INTO hn_log_edit \(editor_id, lang, entry_id, action, timestamp\) VALUES \('ardavan', 'nb', '10', 'update', '(\d)+'\)/, sql_log)
		# Undo.
		get :save, {:entrylang => "nb", :id => 10, :entry => 10, :pos => "subst", :status => 2, :forms => "--- \n? \"700\"\n: \n  1: bil\n  2: bilen\n  3: biler\n  4: bilene\n", :trans => "<senseGrp><sense><trans>autó</trans></sense></senseGrp>"}, {:hn_id => "ardavan"}, nil
	end

end

