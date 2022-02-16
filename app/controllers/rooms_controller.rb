class RoomsController < ApplicationController
  before_action :require_authentication, only: %i[ new edit create update destroy ]

  def index
    @rooms = Room.most_recent
  end

  def show
    @room = Room.find(params[:id])

    if user_signed_in?
      @user_review = @room.reviews.find_or_initialize_by(user_id: current_user.id)
    end
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
    @room = current_user.rooms.find(params[:id])
  end

  def create
    @room = current_user.rooms.build(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to room_url(@room), notice: t('flash.notice.room_created') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @room = current_user.rooms.find(params[:id])

    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to room_url(@room), notice: t('flash.notice.room_updated') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @room = current_user.rooms.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url, notice: t('flash.notice.room_destroyed') }
    end
  end

  private
    def room_params
      params.require(:room).permit(:title, :location, :description)
    end
end
