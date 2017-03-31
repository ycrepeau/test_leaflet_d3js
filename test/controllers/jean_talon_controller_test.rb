require 'test_helper'

class JeanTalonControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jean_talon_index_url
    assert_response :success
  end

end
