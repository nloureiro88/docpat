require 'test_helper'

class UpdatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get updates_index_url
    assert_response :success
  end

end
