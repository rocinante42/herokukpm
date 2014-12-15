require 'test_helper'

class BubbleStatusesControllerTest < ActionController::TestCase
  setup do
    @bubble_status = bubble_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bubble_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bubble_status" do
    assert_difference('BubbleStatus.count') do
      post :create, bubble_status: { active: @bubble_status.active, bubble_id: @bubble_status.bubble_id, kid_id: @bubble_status.kid_id, passed: @bubble_status.passed }
    end

    assert_redirected_to bubble_status_path(assigns(:bubble_status))
  end

  test "should show bubble_status" do
    get :show, id: @bubble_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bubble_status
    assert_response :success
  end

  test "should update bubble_status" do
    patch :update, id: @bubble_status, bubble_status: { active: @bubble_status.active, bubble_id: @bubble_status.bubble_id, kid_id: @bubble_status.kid_id, passed: @bubble_status.passed }
    assert_redirected_to bubble_status_path(assigns(:bubble_status))
  end

  test "should destroy bubble_status" do
    assert_difference('BubbleStatus.count', -1) do
      delete :destroy, id: @bubble_status
    end

    assert_redirected_to bubble_statuses_path
  end
end
