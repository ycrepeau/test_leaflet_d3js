require 'test_helper'

class LabelleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get labelle_index_url
    assert_response :success
  end

end
