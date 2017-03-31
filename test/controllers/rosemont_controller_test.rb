require 'test_helper'

class RosemontControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rosemont_index_url
    assert_response :success
  end

end
