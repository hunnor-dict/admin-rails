require 'test_helper'

class EditorTest < ActiveSupport::TestCase

	test "authorize_ardavan_facebook" do
		editor = Editor.new "facebook", "570487915"
		assert editor.id == "ardavan"
		assert editor.authorized?
	end
	test "authorize_ardavan_linkedin" do
		editor = Editor.new "linkedin", "TRpE2vvpzM"
		assert editor.id == "ardavan"
		assert editor.authorized?
	end

end

