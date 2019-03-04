require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get patients_show_url
    assert_response :success
  end

  test "should get doctors" do
    get patients_doctors_url
    assert_response :success
  end

  test "should get add_fam" do
    get patients_add_fam_url
    assert_response :success
  end

  test "should get rem_fam" do
    get patients_rem_fam_url
    assert_response :success
  end

  test "should get add_doctor" do
    get patients_add_doctor_url
    assert_response :success
  end

  test "should get rem_doctor" do
    get patients_rem_doctor_url
    assert_response :success
  end

end
