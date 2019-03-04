require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get indes" do
    get topics_indes_url
    assert_response :success
  end

  test "should get show" do
    get topics_show_url
    assert_response :success
  end

  test "should get new" do
    get topics_new_url
    assert_response :success
  end

  test "should get create" do
    get topics_create_url
    assert_response :success
  end

  test "should get refresh" do
    get topics_refresh_url
    assert_response :success
  end

  test "should get log" do
    get topics_log_url
    assert_response :success
  end

  test "should get deactivate" do
    get topics_deactivate_url
    assert_response :success
  end

end
