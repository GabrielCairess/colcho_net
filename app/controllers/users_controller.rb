class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[ new create ]
  before_action :can_change, only: %i[ edit update show ]

  def teste
  end 
  
  def new 
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "Usuário atualizado com sucesso" }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        SignupMailer.confirm_email(@user).deliver
        format.html { redirect_to user_url(@user), notice: "Usuário Cadastrado com sucesso" }
      else
        format.html { render :new }
      end
    end
  end

  private 

  def user_params
    params.require(:user).permit(:full_name, :location, :email, :password, :password_confirmation, :bio)
  end

  def can_change
    unless user_signed_in? && current_user == user
      redirect_to user_path(params[:id])
    end
  end

  def user
    @user ||= User.find(params[:id])
  end
end