require 'test_helper'

class FamiliesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get families_show_url
    assert_response :success
  end

  test "should get new" do
    get families_new_url
    assert_response :success
  end

  test "should get create" do
    get families_create_url
    assert_response :success
  end

  test "should get add_patient" do
    get families_add_patient_url
    assert_response :success
  end

  test "should get rem_patient" do
    get families_rem_patient_url
    assert_response :success
  end

end
