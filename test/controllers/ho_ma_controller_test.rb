require 'test_helper'

class HoMaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ho_ma_index_url
    assert_response :success
  end

end
