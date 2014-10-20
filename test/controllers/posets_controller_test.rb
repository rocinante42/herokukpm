require 'test_helper'

class PosetsControllerTest < ActionController::TestCase
  setup do
    @poset = posets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create poset" do
    assert_difference('Poset.count') do
      post :create, poset: { name: @poset.name }
    end

    assert_redirected_to poset_path(assigns(:poset))
  end

  test "should show poset" do
    get :show, id: @poset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @poset
    assert_response :success
  end

  test "should update poset" do
    patch :update, id: @poset, poset: { name: @poset.name }
    assert_redirected_to poset_path(assigns(:poset))
  end

  test "should destroy poset" do
    assert_difference('Poset.count', -1) do
      delete :destroy, id: @poset
    end

    assert_redirected_to posets_path
  end
end
