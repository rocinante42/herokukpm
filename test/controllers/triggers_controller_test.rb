require 'test_helper'

class TriggersControllerTest < ActionController::TestCase
  setup do
    @trigger = triggers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:triggers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trigger" do
    assert_difference('Trigger.count') do
      post :create, trigger: { destination_id: @trigger.destination_id, poset_id: @trigger.poset_id, source_id: @trigger.source_id }
    end

    assert_redirected_to trigger_path(assigns(:trigger))
  end

  test "should show trigger" do
    get :show, id: @trigger
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trigger
    assert_response :success
  end

  test "should update trigger" do
    patch :update, id: @trigger, trigger: { destination_id: @trigger.destination_id, poset_id: @trigger.poset_id, source_id: @trigger.source_id }
    assert_redirected_to trigger_path(assigns(:trigger))
  end

  test "should destroy trigger" do
    assert_difference('Trigger.count', -1) do
      delete :destroy, id: @trigger
    end

    assert_redirected_to triggers_path
  end
end
