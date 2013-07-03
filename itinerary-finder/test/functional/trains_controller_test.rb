require 'test_helper'

class TrainsControllerTest < ActionController::TestCase
  setup do
    @train = trains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create train" do
    assert_difference('Train.count') do
      post :create, train: { loop_id: @train.loop_id, operates_day_10: @train.operates_day_10, operates_day_11: @train.operates_day_11, operates_day_12: @train.operates_day_12, operates_day_13: @train.operates_day_13, operates_day_14: @train.operates_day_14, operates_day_1: @train.operates_day_1, operates_day_2: @train.operates_day_2, operates_day_3: @train.operates_day_3, operates_day_4: @train.operates_day_4, operates_day_5: @train.operates_day_5, operates_day_6: @train.operates_day_6, operates_day_7: @train.operates_day_7, operates_day_8: @train.operates_day_8, operates_day_9: @train.operates_day_9, train_category: @train.train_category }
    end

    assert_redirected_to train_path(assigns(:train))
  end

  test "should show train" do
    get :show, id: @train
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @train
    assert_response :success
  end

  test "should update train" do
    put :update, id: @train, train: { loop_id: @train.loop_id, operates_day_10: @train.operates_day_10, operates_day_11: @train.operates_day_11, operates_day_12: @train.operates_day_12, operates_day_13: @train.operates_day_13, operates_day_14: @train.operates_day_14, operates_day_1: @train.operates_day_1, operates_day_2: @train.operates_day_2, operates_day_3: @train.operates_day_3, operates_day_4: @train.operates_day_4, operates_day_5: @train.operates_day_5, operates_day_6: @train.operates_day_6, operates_day_7: @train.operates_day_7, operates_day_8: @train.operates_day_8, operates_day_9: @train.operates_day_9, train_category: @train.train_category }
    assert_redirected_to train_path(assigns(:train))
  end

  test "should destroy train" do
    assert_difference('Train.count', -1) do
      delete :destroy, id: @train
    end

    assert_redirected_to trains_path
  end
end
