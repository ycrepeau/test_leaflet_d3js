require 'test_helper'

class JeanLesageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jean_lesage_index_url
    assert_response :success
  end

end
