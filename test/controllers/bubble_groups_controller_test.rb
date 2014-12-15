require 'test_helper'

class BubbleGroupsControllerTest < ActionController::TestCase
  setup do
    @bubble_group = bubble_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bubble_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bubble_group" do
    assert_difference('BubbleGroup.count') do
      post :create, bubble_group: { backward_poset_id: @bubble_group.backward_poset_id, description: @bubble_group.description, forward_poset_id: @bubble_group.forward_poset_id, full_poset_id: @bubble_group.full_poset_id, name: @bubble_group.name }
    end

    assert_redirected_to bubble_group_path(assigns(:bubble_group))
  end

  test "should show bubble_group" do
    get :show, id: @bubble_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bubble_group
    assert_response :success
  end

  test "should update bubble_group" do
    patch :update, id: @bubble_group, bubble_group: { backward_poset_id: @bubble_group.backward_poset_id, description: @bubble_group.description, forward_poset_id: @bubble_group.forward_poset_id, full_poset_id: @bubble_group.full_poset_id, name: @bubble_group.name }
    assert_redirected_to bubble_group_path(assigns(:bubble_group))
  end

  test "should destroy bubble_group" do
    assert_difference('BubbleGroup.count', -1) do
      delete :destroy, id: @bubble_group
    end

    assert_redirected_to bubble_groups_path
  end
end
