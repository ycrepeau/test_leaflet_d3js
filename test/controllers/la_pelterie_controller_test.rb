require 'test_helper'

class LaPelterieControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get la_pelterie_index_url
    assert_response :success
  end

end
