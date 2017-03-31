require 'test_helper'

class MercierControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mercier_index_url
    assert_response :success
  end

end
