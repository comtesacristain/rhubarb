require 'test_helper'

class PowerstationsControllerTest < ActionController::TestCase
  setup do
    @powerstation = powerstations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:powerstations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create powerstation" do
    assert_difference('Powerstation.count') do
      post :create, :powerstation => @powerstation.attributes
    end

    assert_redirected_to powerstation_path(assigns(:powerstation))
  end

  test "should show powerstation" do
    get :show, :id => @powerstation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @powerstation.to_param
    assert_response :success
  end

  test "should update powerstation" do
    put :update, :id => @powerstation.to_param, :powerstation => @powerstation.attributes
    assert_redirected_to powerstation_path(assigns(:powerstation))
  end

  test "should destroy powerstation" do
    assert_difference('Powerstation.count', -1) do
      delete :destroy, :id => @powerstation.to_param
    end

    assert_redirected_to powerstations_path
  end
end
