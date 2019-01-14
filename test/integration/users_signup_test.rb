require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	
  def setup
    ActionMailer::Base.deliveries.clear
  end
	
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
		

		test "valid signup information with account activation" do
			get signup_path
			assert_difference 'User.count', 1 do
			post users_path, params: { user: { name:  "shekhar patil",
																					email: "patilshekar@gmail.com",
																					password:              "shekhar123",
																					password_confirmation: "shekhar123" } }
			end

			assert_equal 0, ActionMailer::Base.deliveries.size
			user = assigns(:user)
			assert_not user.activated?
			# Try to log in before activation.
			log_in_as(user)
			assert_not is_logged_in?
			# Invalid activation token
			get edit_account_activation_path("invalid token", email: user.email)
			assert_not is_logged_in?
			# Valid token, wrong email
			get edit_account_activation_path(user.activation_token, email: 'wrong')
			assert_not is_logged_in?
			# Valid activation token
			get edit_account_activation_path(user.activation_token, email: user.email)
			assert user.reload.activated?
			follow_redirect!
			assert_template 'users/show'
			assert is_logged_in?
		end
end
