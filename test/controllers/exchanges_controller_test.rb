require 'test_helper'

class ExchangesControllerTest < ActionController::TestCase
  setup do
    @exchange = exchanges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exchanges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exchange" do
    assert_difference('Exchange.count') do
      post :create, exchange: { deadline: @exchange.deadline, description: @exchange.description, name: @exchange.name, owner_id: @exchange.owner_id }
    end

    assert_redirected_to exchange_path(assigns(:exchange))
  end

  test "should show exchange" do
    get :show, id: @exchange
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exchange
    assert_response :success
  end

  test "should update exchange" do
    patch :update, id: @exchange, exchange: { deadline: @exchange.deadline, description: @exchange.description, name: @exchange.name, owner_id: @exchange.owner_id }
    assert_redirected_to exchange_path(assigns(:exchange))
  end

  test "should destroy exchange" do
    assert_difference('Exchange.count', -1) do
      delete :destroy, id: @exchange
    end

    assert_redirected_to exchanges_path
  end
end
