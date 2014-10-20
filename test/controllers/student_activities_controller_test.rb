require 'test_helper'

class StudentActivitiesControllerTest < ActionController::TestCase
  setup do
    @student_activity = student_activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_activity" do
    assert_difference('StudentActivity.count') do
      post :create, student_activity: { active: @student_activity.active, activity_id: @student_activity.activity_id, game_id: @student_activity.game_id, poset_id: @student_activity.poset_id, score: @student_activity.score, status: @student_activity.status }
    end

    assert_redirected_to student_activity_path(assigns(:student_activity))
  end

  test "should show student_activity" do
    get :show, id: @student_activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_activity
    assert_response :success
  end

  test "should update student_activity" do
    patch :update, id: @student_activity, student_activity: { active: @student_activity.active, activity_id: @student_activity.activity_id, game_id: @student_activity.game_id, poset_id: @student_activity.poset_id, score: @student_activity.score, status: @student_activity.status }
    assert_redirected_to student_activity_path(assigns(:student_activity))
  end

  test "should destroy student_activity" do
    assert_difference('StudentActivity.count', -1) do
      delete :destroy, id: @student_activity
    end

    assert_redirected_to student_activities_path
  end
end
