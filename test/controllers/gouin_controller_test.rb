require 'test_helper'

class GouinControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gouin_index_url
    assert_response :success
  end

end
