require 'test_helper'

class MineralProjectsControllerTest < ActionController::TestCase
  setup do
    @mineral_project = mineral_projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mineral_projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mineral_project" do
    assert_difference('MineralProject.count') do
      post :create, mineral_project: {  }
    end

    assert_redirected_to mineral_project_path(assigns(:mineral_project))
  end

  test "should show mineral_project" do
    get :show, id: @mineral_project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mineral_project
    assert_response :success
  end

  test "should update mineral_project" do
    put :update, id: @mineral_project, mineral_project: {  }
    assert_redirected_to mineral_project_path(assigns(:mineral_project))
  end

  test "should destroy mineral_project" do
    assert_difference('MineralProject.count', -1) do
      delete :destroy, id: @mineral_project
    end

    assert_redirected_to mineral_projects_path
  end
end
