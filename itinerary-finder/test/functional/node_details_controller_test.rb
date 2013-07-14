require 'test_helper'

class NodeDetailsControllerTest < ActionController::TestCase
  setup do
    @node_detail = node_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:node_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create node_detail" do
    assert_difference('NodeDetail.count') do
      post :create, node_detail: { event_time: @node_detail.event_time, original_event_time: @node_detail.original_event_time, station_name: @node_detail.station_name, station_num: @node_detail.station_num }
    end

    assert_redirected_to node_detail_path(assigns(:node_detail))
  end

  test "should show node_detail" do
    get :show, id: @node_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @node_detail
    assert_response :success
  end

  test "should update node_detail" do
    put :update, id: @node_detail, node_detail: { event_time: @node_detail.event_time, original_event_time: @node_detail.original_event_time, station_name: @node_detail.station_name, station_num: @node_detail.station_num }
    assert_redirected_to node_detail_path(assigns(:node_detail))
  end

  test "should destroy node_detail" do
    assert_difference('NodeDetail.count', -1) do
      delete :destroy, id: @node_detail
    end

    assert_redirected_to node_details_path
  end
end
