require 'test_helper'

class MajorProjectsControllerTest < ActionController::TestCase
  setup do
    @major_project = major_projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:major_projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create major_project" do
    assert_difference('MajorProject.count') do
      post :create, :major_project => @major_project.attributes
    end

    assert_redirected_to major_project_path(assigns(:major_project))
  end

  test "should show major_project" do
    get :show, :id => @major_project.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @major_project.to_param
    assert_response :success
  end

  test "should update major_project" do
    put :update, :id => @major_project.to_param, :major_project => @major_project.attributes
    assert_redirected_to major_project_path(assigns(:major_project))
  end

  test "should destroy major_project" do
    assert_difference('MajorProject.count', -1) do
      delete :destroy, :id => @major_project.to_param
    end

    assert_redirected_to major_projects_path
  end
end
