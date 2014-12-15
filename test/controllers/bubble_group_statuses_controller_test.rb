require 'test_helper'

class BubbleGroupStatusesControllerTest < ActionController::TestCase
  setup do
    @bubble_group_status = bubble_group_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bubble_group_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bubble_group_status" do
    assert_difference('BubbleGroupStatus.count') do
      post :create, bubble_group_status: { bubble_group_id: @bubble_group_status.bubble_group_id, fail_counter: @bubble_group_status.fail_counter, kid_id: @bubble_group_status.kid_id, pass_counter: @bubble_group_status.pass_counter, poset_id: @bubble_group_status.poset_id }
    end

    assert_redirected_to bubble_group_status_path(assigns(:bubble_group_status))
  end

  test "should show bubble_group_status" do
    get :show, id: @bubble_group_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bubble_group_status
    assert_response :success
  end

  test "should update bubble_group_status" do
    patch :update, id: @bubble_group_status, bubble_group_status: { bubble_group_id: @bubble_group_status.bubble_group_id, fail_counter: @bubble_group_status.fail_counter, kid_id: @bubble_group_status.kid_id, pass_counter: @bubble_group_status.pass_counter, poset_id: @bubble_group_status.poset_id }
    assert_redirected_to bubble_group_status_path(assigns(:bubble_group_status))
  end

  test "should destroy bubble_group_status" do
    assert_difference('BubbleGroupStatus.count', -1) do
      delete :destroy, id: @bubble_group_status
    end

    assert_redirected_to bubble_group_statuses_path
  end
end
