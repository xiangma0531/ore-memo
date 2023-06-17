class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: [:show, :edit, :update]
  before_action :move_to_index, except: [:index, :new, :create]

  def index
    if user_signed_in?
      @memos = current_user.memos.order("created_at DESC")
    end
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

  def show
  end

  def edit
  end

  def update
    if @memo.update(memo_params)
      redirect_to memo_path(@memo.id)
    else
      render :edit
    end
  end

  def destroy
    memo = Memo.find(params[:id])
    memo.destroy
    redirect_to root_path
  end

  private
  def memo_params
    params.require(:memo).permit(:title, :content, :image).merge(user_id: current_user.id)
  end

  def set_memo
    @memo = Memo.find(params[:id])
  end

  def move_to_index
    @memo = Memo.find(params[:id])
    unless current_user.id == @memo.user_id
      redirect_to root_path
    end
  end
end
