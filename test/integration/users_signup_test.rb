require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	test "invalid signup information" do
	    get signup_path
	    assert_no_difference 'User.count' do
	    post users_path, params: { user: { name:  "patil",
	                                         email: "patilshekar900",
	                                         password:              "she123",
	                                         password_confirmation: "shekhar123" } }
	    end
			assert_template 'users/new'
			assert_select 'div#error_explanation'
			assert_select 'div.field_with_errors'

		end
		

		test "valid signup information" do
			get signup_path
			assert_difference 'User.count', 1 do
			post users_path, params: { user: { name:  "shekhar patil",
							email: "patilshekar900@gmail.com",
							password:              "shekhar123",
							password_confirmation: "shekhar123" } }
			end
			follow_redirect!
			# assert_template 'users/show'
			# assert is_logged_in?
		end
end
