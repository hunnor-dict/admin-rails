#encoding: utf-8
require "test_helper"

class PrivControllerTest < ActionController::TestCase

	test "list unauthorized" do
		get :list, {:lang => "hu", :letter => "c", :stat => "1"}, nil, nil
		assert_response :success
		assert_nil assigns(:lang)
		assert_nil assigns(:entries)
		assert_equal " ", @response.body
	end

	test "list lang invalid" do
		get :list, {:lang => "de", :letter => "a", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_nil assigns(:lang)
		assert_nil assigns(:entries)
		assert_equal " ", @response.body
	end

	test "list lang hu letter invalid" do
		get :list, {:lang => "hu", :letter => "đ", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu term csap" do
		get :list, {:lang => "hu", :term => "csap", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 14, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu term csp" do
		get :list, {:lang => "hu", :term => "csp", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu term cs" do
		get :list, {:lang => "hu", :term => "cs", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu term c" do
		get :list, {:lang => "hu", :term => "c", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter cs" do
		get :list, {:lang => "hu", :letter => "cs", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter c" do
		get :list, {:lang => "hu", :letter => "c", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter c term empty" do
		get :list, {:lang => "hu", :letter => "c", :term => "", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter c term c" do
		get :list, {:lang => "hu", :letter => "c", :term => "c", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter cs term c" do
		get :list, {:lang => "hu", :letter => "cs", :term => "c", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter invalid term c" do
		get :list, {:lang => "hu", :letter => "đ", :term => "c", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter empty term c" do
		get :list, {:lang => "hu", :letter => "", :term => "c", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 17, nil, nil
		entries.push Entry.new :hu, 18, nil, nil
		entries.push Entry.new :hu, 19, nil, nil
		entries.push Entry.new :hu, 15, nil, nil
		entries.push Entry.new :hu, 12, nil, nil
		entries.push Entry.new :hu, 10, nil, nil
		entries.push Entry.new :hu, 11, nil, nil
		entries.push Entry.new :hu, 14, nil, nil
		entries.push Entry.new :hu, 13, nil, nil
		entries.push Entry.new :hu, 16, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter empty term empty" do
		get :list, {:lang => "hu", :letter => "", :term => "", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter a stat 1" do
		get :list, {:lang => "hu", :letter => "a", :stat => "1"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 30, nil, nil
		entries.push Entry.new :hu, 31, nil, nil
		entries.push Entry.new :hu, 34, nil, nil
		entries.push Entry.new :hu, 33, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter a stat nil" do
		get :list, {:lang => "hu", :letter => "a"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 30, nil, nil
		entries.push Entry.new :hu, 31, nil, nil
		entries.push Entry.new :hu, 34, nil, nil
		entries.push Entry.new :hu, 33, nil, nil
		entries.push Entry.new :hu, 32, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter a stat empty" do
		get :list, {:lang => "hu", :letter => "a", :stat => ""}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 30, nil, nil
		entries.push Entry.new :hu, 31, nil, nil
		entries.push Entry.new :hu, 34, nil, nil
		entries.push Entry.new :hu, 33, nil, nil
		entries.push Entry.new :hu, 32, nil, nil
		assert_equal entries, assigns(:entries)
	end

	test "list lang hu letter a stat invalid" do
		get :list, {:lang => "hu", :letter => "a", :stat => "9"}, {:hn_id => "ardavan"}, nil
		assert_response :success
		assert_equal "hu", assigns(:lang)
		entries = []
		entries.push Entry.new :hu, 30, nil, nil
		entries.push Entry.new :hu, 31, nil, nil
		entries.push Entry.new :hu, 34, nil, nil
		entries.push Entry.new :hu, 33, nil, nil
		entries.push Entry.new :hu, 32, nil, nil
		assert_equal entries, assigns(:entries)
	end

end

