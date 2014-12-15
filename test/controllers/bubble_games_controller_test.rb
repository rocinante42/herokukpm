require 'test_helper'

class BubbleGamesControllerTest < ActionController::TestCase
  setup do
    @bubble_game = bubble_games(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bubble_games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bubble_game" do
    assert_difference('BubbleGame.count') do
      post :create, bubble_game: { bubble_id: @bubble_game.bubble_id, game_id: @bubble_game.game_id, game_params: @bubble_game.game_params, scoring_params: @bubble_game.scoring_params, skin: @bubble_game.skin }
    end

    assert_redirected_to bubble_game_path(assigns(:bubble_game))
  end

  test "should show bubble_game" do
    get :show, id: @bubble_game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bubble_game
    assert_response :success
  end

  test "should update bubble_game" do
    patch :update, id: @bubble_game, bubble_game: { bubble_id: @bubble_game.bubble_id, game_id: @bubble_game.game_id, game_params: @bubble_game.game_params, scoring_params: @bubble_game.scoring_params, skin: @bubble_game.skin }
    assert_redirected_to bubble_game_path(assigns(:bubble_game))
  end

  test "should destroy bubble_game" do
    assert_difference('BubbleGame.count', -1) do
      delete :destroy, id: @bubble_game
    end

    assert_redirected_to bubble_games_path
  end
end
