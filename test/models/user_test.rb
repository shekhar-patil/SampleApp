require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	def setup
		@user = User.new(name: "Shekhar patil" , email: "shekhar.patil@gmail.com",
					    password: "foobar", password_confirmation: "foobar")
	end

	test "Should be valid" do
		assert @user.valid?
	end

	test "Name should be present" do

		@user.name = "   "
		assert_not @user.valid?
	end
	test "Email should be present" do 
		@user.email = ""
		assert_not @user.valid?
	end

	test "Length should have max Length 50" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "Email should have max Length 256" do 
		@user.email = "a" * 256 + "@gmail.com"
		assert_not @user.valid?
	end
	test "email validation should reject invalid addresses" do
	    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
	                           foo@bar_baz.com foo@bar+baz.com]
	    invalid_addresses.each do |invalid_address|
	      @user.email = invalid_address
	      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
	    end
  	end
  	test "Duplicate User is not valid" do
  		duplicate_user = @user.dup
  		duplicate_user.email = @user.email.upcase
		@user.save
  		assert_not duplicate_user.valid?
  	end
	test "email addresses should be saved as lower-case" do
	    mixed_case_email = "Foo@ExAMPle.CoM"
	    @user.email = mixed_case_email
	    @user.save
	    assert_equal mixed_case_email.downcase, @user.reload.email
	end
	
	test "password should be present (nonblank)" do
	    @user.password = @user.password_confirmation = " " * 6
	    assert_not @user.valid?
	end
    
	test "password should have a minimum length" do
	    @user.password = @user.password_confirmation = "a" * 5
	    assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
	    assert_not @user.authenticated?(:remember , '')
	end

	test "associated microposts should be destroyed" do
		@user.save
		@user.microposts.create!(content: "Lorem ipsum")
		assert_difference 'Micropost.count', -1 do
			@user.destroy
		end
	end
		test "should follow and unfollow a user" do
		michael = users(:shekhar)
		archer  = users(:archer)
		assert_not michael.following?(archer)
		michael.follow(archer)
		assert michael.following?(archer)
		michael.unfollow(archer)
		assert_not michael.following?(archer)
	end

end
