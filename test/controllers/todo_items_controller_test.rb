require 'test_helper'

class TodoItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo_list = todo_lists(:one)
    @todo_item = todo_items(:one)
  end

  test 'create requires todo_item param' do
    assert_raises(ActionController::ParameterMissing) do
      post todo_list_todo_items_path(@todo_list), params: {}
    end
  end

  test 'create requires content param' do
    assert_raises(ActionController::ParameterMissing) do
      post todo_list_todo_items_path(@todo_list), params: { todo_item: {} }
    end
  end

  test 'create with blank content renders errors' do
    assert_no_difference('TodoItem.count') do
      post todo_list_todo_items_path(@todo_list), params: { todo_item: { content: '' } }
    end
    assert_response :unprocessable_entity
    assert_select '#error_explanation'
  end

  test 'update requires todo_item param' do
    assert_raises(ActionController::ParameterMissing) do
      patch todo_list_todo_item_path(@todo_list, @todo_item), params: {}
    end
  end

  test 'update requires content param' do
    assert_raises(ActionController::ParameterMissing) do
      patch todo_list_todo_item_path(@todo_list, @todo_item), params: { todo_item: {} }
    end
  end

  test 'update with valid content changes item and redirects' do
    patch todo_list_todo_item_path(@todo_list, @todo_item), params: { todo_item: { content: 'Updated content' } }
    assert_redirected_to todo_list_path(@todo_list)
    assert_equal 'Updated content', @todo_item.reload.content
  end

  test 'update with blank content renders edit with errors' do
    original = @todo_item.content
    patch todo_list_todo_item_path(@todo_list, @todo_item), params: { todo_item: { content: '' } }
    assert_response :unprocessable_entity
    assert_select '#error_explanation'
    assert_equal original, @todo_item.reload.content
  end
end
