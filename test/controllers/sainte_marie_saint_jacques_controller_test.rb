require 'test_helper'

class SainteMarieSaintJacquesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sainte_marie_saint_jacques_index_url
    assert_response :success
  end

end
