require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    @activity = activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, activity: { complete_score: @activity.complete_score, enjoy_score: @activity.enjoy_score, fail_counter: @activity.fail_counter, level: @activity.level, max_level: @activity.max_level, name: @activity.name, pass_counter: @activity.pass_counter, weight: @activity.weight }
    end

    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should show activity" do
    get :show, id: @activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity
    assert_response :success
  end

  test "should update activity" do
    patch :update, id: @activity, activity: { complete_score: @activity.complete_score, enjoy_score: @activity.enjoy_score, fail_counter: @activity.fail_counter, level: @activity.level, max_level: @activity.max_level, name: @activity.name, pass_counter: @activity.pass_counter, weight: @activity.weight }
    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, id: @activity
    end

    assert_redirected_to activities_path
  end
end
