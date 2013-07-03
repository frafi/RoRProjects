require 'test_helper'

class TrainRoutesControllerTest < ActionController::TestCase
  setup do
    @train_route = train_routes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:train_routes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create train_route" do
    assert_difference('TrainRoute.count') do
      post :create, train_route: { arrive_time_hhhmm: @train_route.arrive_time_hhhmm, depart_time_hhhmm: @train_route.depart_time_hhhmm, route_point_seq: @train_route.route_point_seq, station_name: @train_route.station_name, station_num: @train_route.station_num, train_id: @train_route.train_id }
    end

    assert_redirected_to train_route_path(assigns(:train_route))
  end

  test "should show train_route" do
    get :show, id: @train_route
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @train_route
    assert_response :success
  end

  test "should update train_route" do
    put :update, id: @train_route, train_route: { arrive_time_hhhmm: @train_route.arrive_time_hhhmm, depart_time_hhhmm: @train_route.depart_time_hhhmm, route_point_seq: @train_route.route_point_seq, station_name: @train_route.station_name, station_num: @train_route.station_num, train_id: @train_route.train_id }
    assert_redirected_to train_route_path(assigns(:train_route))
  end

  test "should destroy train_route" do
    assert_difference('TrainRoute.count', -1) do
      delete :destroy, id: @train_route
    end

    assert_redirected_to train_routes_path
  end
end
