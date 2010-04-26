require 'test_helper'

class PostofficeTest < ActionMailer::TestCase
  test "welcome" do
    @expected.subject = 'Postoffice#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Postoffice.create_welcome(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'Postoffice#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Postoffice.create_forgot_password(@expected.date).encoded
  end

  test "share" do
    @expected.subject = 'Postoffice#share'
    @expected.body    = read_fixture('share')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Postoffice.create_share(@expected.date).encoded
  end

  test "email_todos" do
    @expected.subject = 'Postoffice#email_todos'
    @expected.body    = read_fixture('email_todos')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Postoffice.create_email_todos(@expected.date).encoded
  end

end
