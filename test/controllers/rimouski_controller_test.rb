require 'test_helper'

class RimouskiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rimouski_index_url
    assert_response :success
  end

end
