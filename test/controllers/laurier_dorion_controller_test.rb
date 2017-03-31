require 'test_helper'

class LaurierDorionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get laurier_dorion_index_url
    assert_response :success
  end

end
