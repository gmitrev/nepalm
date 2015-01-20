require 'test_helper'

class StacksControllerTest < ActionController::TestCase
  setup do
    @stack = stacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stack" do
    assert_difference('Stack.count') do
      post :create, stack: { name: @stack.name, project_id: @stack.project_id }
    end

    assert_redirected_to stack_path(assigns(:stack))
  end

  test "should show stack" do
    get :show, id: @stack
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stack
    assert_response :success
  end

  test "should update stack" do
    patch :update, id: @stack, stack: { name: @stack.name, project_id: @stack.project_id }
    assert_redirected_to stack_path(assigns(:stack))
  end

  test "should destroy stack" do
    assert_difference('Stack.count', -1) do
      delete :destroy, id: @stack
    end

    assert_redirected_to stacks_path
  end
end
