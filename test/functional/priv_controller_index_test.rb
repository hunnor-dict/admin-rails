#encoding: utf-8
require "test_helper"

class PrivControllerTest < ActionController::TestCase

	test "index unauthorized" do
		get :index, nil, nil, nil
		assert_redirected_to :controller => "auth", :action => "index"
	end

	test "index authorized" do
		get :index, nil, {:hn_id => "ardavan", :hn_omniauth_name => "Ádám Z. Kövér", :hn_omniauth_uid => "TRpE2vvpzM", :hn_omniauth_provider => "linkedin"}, nil
		assert_response :success
		assert_equal "Ádám Z. Kövér", assigns(:name)
		assert_equal "TRpE2vvpzM", assigns(:uid)
		assert_equal "linkedin", assigns(:provider)
	end

end

