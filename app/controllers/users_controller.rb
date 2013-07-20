class UsersController < ApplicationController
  def index
    # TODO
  end

  def me
    unless current_user
      return render(nothing: true, status: :unauthorized)
    end

    redirect_to current_user
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    # TODO
  end

  def update
    # TODO
  end

  def promote
    @user = User.find(params[:id])
    @user.promote!

    redirect_to @user
  end

  def demote
    @user = User.find(params[:id])
    @user.demote!

    redirect_to @user
  end

  def edit
    # TODO
  end
end
