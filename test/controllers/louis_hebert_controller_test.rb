require 'test_helper'

class LouisHebertControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get louis_hebert_index_url
    assert_response :success
  end

end
