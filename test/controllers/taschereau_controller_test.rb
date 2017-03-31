require 'test_helper'

class TaschereauControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get taschereau_index_url
    assert_response :success
  end

end
