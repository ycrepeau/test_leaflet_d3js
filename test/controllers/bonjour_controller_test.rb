require 'test_helper'

class BonjourControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bonjour_index_url
    assert_response :success
  end

end
