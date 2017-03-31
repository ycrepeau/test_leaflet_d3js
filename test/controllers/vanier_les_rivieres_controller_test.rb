require 'test_helper'

class VanierLesRivieresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vanier_les_rivieres_index_url
    assert_response :success
  end

end
