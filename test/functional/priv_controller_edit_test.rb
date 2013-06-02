#encoding: utf-8
require "test_helper"

class PrivControllerTest < ActionController::TestCase

	test "edit unauthorized" do
		get :edit, {:lang => "hu", :id => "N"}, nil, nil
		assert_response :success
		assert_nil assigns(:id)
		assert_nil assigns(:entry)
		assert_equal " ", @response.body
	end

	test "edit lang invalid" do
		get :edit, {:lang => "de", :id => "N"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:lang)
		assert_nil assigns(:entries)
		assert_equal " ", @response.body
	end

	test "edit lang hu id nil" do
		get :edit, {:lang => "hu"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:lang)
		assert_nil assigns(:entries)
		assert_equal " ", @response.body
	end

	test "edit lang hu id empty" do
		get :edit, {:lang => "hu", :id => ""}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:lang)
		assert_nil assigns(:entries)
		assert_equal " ", @response.body
	end

	test "edit lang hu id 10" do
		get :edit, {:lang => "hu", :id => "10"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		entry = Entry.new :hu, 10, {:trans => true}, {:term => ""}
		assert_equal entry, assigns(:entry)
	end

	test "edit lang hu id N" do
		get :edit, {:lang => "hu", :id => "N"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		entry = Entry.new :hu, "N", {:trans => true}, nil
		assert_equal entry, assigns(:entry)
	end

	test "edit lang hu id N term empty" do
		get :edit, {:lang => "hu", :id => "N", :term => ""}, {:hn_id => "ardavan"}, nil
		assert_response :success
		entry = Entry.new :hu, "N", {:trans => true}, nil
		assert_equal entry, assigns(:entry)
	end

	test "edit lang hu id N term ablak" do
		get :edit, {:lang => "hu", :id => "N", :term => "ablak"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		entry = Entry.new :hu, "N", {:trans => true}, {:term => "ablak"}
		assert_equal entry, assigns(:entry)
	end

end

