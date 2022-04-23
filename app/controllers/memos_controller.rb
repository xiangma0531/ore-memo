class MemosController < ApplicationController
  def index
    @memos = Memo.includes(:user).find_by(user_id: current_user.id)
  end

  def new
    @memo = Memo.new
  end

  def create
    @memo = Memo.new(memo_params)
    if @memo.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def memo_params
    params.require(:memo).permit(:title, :content).merge(user_id: current_user.id)
  end
end
