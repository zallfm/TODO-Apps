class TodoItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo_item, except: [:create]

  def create
    @todo_item = @todo_list.todo_items.build(todo_item_params)
    if @todo_item.save
      redirect_to @todo_list
    else
      render 'todo_lists/show', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @todo_item.update(todo_item_params)
      redirect_to @todo_list
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo_item = @todo_list.todo_items.find(params[:id])
    if @todo_item.destroy
      flash[:success] = "Todo List item was Deleted."
    else
      flash[:error] = "Todo List item couldn't be deleted."
    end
    redirect_to @todo_list
  end
  
  def complete
    @todo_item.update_attribute(:completed_at, Time.now)
    redirect_to @todo_list, notice: "Todo item Completed"
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:todo_list_id])
  end

  def set_todo_item
    @todo_item = @todo_list.todo_items.find(params[:id])
  end

  def todo_item_params
    params.require(:todo_item).require(:content)
    params.require(:todo_item).permit(:content)
  end
end
