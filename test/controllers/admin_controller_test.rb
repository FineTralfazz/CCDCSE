require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_index_url
    assert_response :success
  end

  test "should get reset_points" do
    get admin_reset_points_url
    assert_response :success
  end

  test "should get game_status" do
    get admin_game_status_url
    assert_response :success
  end

end
