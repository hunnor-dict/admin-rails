#encoding: utf-8
require "test_helper"

class PrivControllerTest < ActionController::TestCase

	test "delete unauthorized" do
		get :delete, {:entrylang => "nb", :id => 10}, nil, nil
		assert_response :success
		assert_nil assigns(:errors)
		assert_nil assigns(:sql)
		assert_equal " ", @response.body
	end

	test "delete not found" do
		get :delete, {:entrylang => "nb", :id => 4242}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal false, assigns(:deleted)
		assert_equal "A megadott szócikk (nb, 4242) nem létezik.", assigns(:error)
		assert_equal [], assigns(:sql)
		assert_not_nil assigns(:clock)

	end

	test "delete blocked" do
		get :delete, {:entrylang => "nb", :id => 20}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal false, assigns(:deleted)
		assert_equal "A megadott szócikk nem tötölhető, mert a következő szócikkek hivatkoznak rá: vann (21)", assigns(:error)
		assert_equal [], assigns(:sql)
		assert_not_nil assigns(:clock)
	end

	test "delete success" do
		get :delete, {:entrylang => "nb", :id => 21}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal true, assigns(:deleted)
		assert_equal "", assigns(:error)
		assert_equal ["DELETE FROM hn_nob_segment WHERE id = '21'",
			"DELETE FROM hn_nob_tr_hun_tmp WHERE id = '21'"], assigns(:sql)
		assert_not_nil assigns(:clock)
	end

end

