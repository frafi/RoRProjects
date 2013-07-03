require 'test_helper'

class ArcsControllerTest < ActionController::TestCase
  setup do
    @arc = arcs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:arcs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create arc" do
    assert_difference('Arc.count') do
      post :create, arc: { arc_type: @arc.arc_type, from_node_id: @arc.from_node_id, to_node_id: @arc.to_node_id, train_id: @arc.train_id, transit_time: @arc.transit_time }
    end

    assert_redirected_to arc_path(assigns(:arc))
  end

  test "should show arc" do
    get :show, id: @arc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @arc
    assert_response :success
  end

  test "should update arc" do
    put :update, id: @arc, arc: { arc_type: @arc.arc_type, from_node_id: @arc.from_node_id, to_node_id: @arc.to_node_id, train_id: @arc.train_id, transit_time: @arc.transit_time }
    assert_redirected_to arc_path(assigns(:arc))
  end

  test "should destroy arc" do
    assert_difference('Arc.count', -1) do
      delete :destroy, id: @arc
    end

    assert_redirected_to arcs_path
  end
end
