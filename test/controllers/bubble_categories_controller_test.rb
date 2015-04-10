require 'test_helper'

class BubbleCategoriesControllerTest < ActionController::TestCase
  setup do
    @bubble_category = bubble_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bubble_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bubble_category" do
    assert_difference('BubbleCategory.count') do
      post :create, bubble_category: { name: @bubble_category.name }
    end

    assert_redirected_to bubble_category_path(assigns(:bubble_category))
  end

  test "should show bubble_category" do
    get :show, id: @bubble_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bubble_category
    assert_response :success
  end

  test "should update bubble_category" do
    patch :update, id: @bubble_category, bubble_category: { name: @bubble_category.name }
    assert_redirected_to bubble_category_path(assigns(:bubble_category))
  end

  test "should destroy bubble_category" do
    assert_difference('BubbleCategory.count', -1) do
      delete :destroy, id: @bubble_category
    end

    assert_redirected_to bubble_categories_path
  end
end
