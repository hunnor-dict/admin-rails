require 'test_helper'

class DictionaryTest < ActiveSupport::TestCase

	# params[:limit]

	test "suggest limit nil" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit nil
		assert_equal default, dictionary.limit
	end

	test "suggest limit string" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit ""
		assert_equal default, dictionary.limit
	end

	test "suggest limit string string" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit "limit"
		assert_equal default, dictionary.limit
	end

	test "suggest limit string integer valid" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit "10"
		assert_equal 10, dictionary.limit
	end

	test "suggest limit string integer negative" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit "-10"
		assert_equal default, dictionary.limit
	end

	test "suggest limit string integer large" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit "100"
		assert_equal default, dictionary.limit
	end

	test "suggest limit integer valid" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit 10
		assert_equal 10, dictionary.limit
	end

	test "suggest limit integer negative" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit -10
		assert_equal default, dictionary.limit
	end

	test "suggest limit integer large" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit 100
		assert_equal default, dictionary.limit
	end

	test "suggest limit float valid" do
		dictionary = Dictionary.new
		default = 20
		dictionary.set_limit default
		dictionary.set_limit 4.2
		assert_equal 4, dictionary.limit
	end

	# params[:lang]

	test "suggest lang nil" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang nil
		assert_equal default, dictionary.lang
	end

	test "suggest lang string" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang "lang"
		assert_equal dictionary.lang, default
	end

	test "suggest lang integer" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang 1
		assert_equal dictionary.lang, default
	end

	test "suggest lang array" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang []
		assert_equal dictionary.lang, {}
	end

	test "suggest lang array hu" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang ["hu"]
		assert_equal dictionary.lang, {:hu => {:hu => true}}
	end

	test "suggest lang array nn hu nb" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang ["nn", "hu", "nb"]
		assert_equal dictionary.lang, {:no => {:nn => true, :nb => true}, :hu => {:hu => true}}
	end

	test "suggest lang array de pl" do
		dictionary = Dictionary.new
		default = {:hu => {:hu => true}, :no => {:nb => true, :nn => true}}
		dictionary.set_lang ["hu", "nb", "nn"]
		dictionary.set_lang ["de", "pl"]
		assert_equal dictionary.lang, {}
	end

end

