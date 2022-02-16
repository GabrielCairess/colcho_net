class RoomsController < ApplicationController
  PER_PAGE = 10
  before_action :require_authentication, only: %i[ new edit create update destroy ]
  before_action :set_room, only: [:show]

  def index
    @search_query = params[:q]

    rooms = Room.search(@search_query).page(params[:page]).per(PER_PAGE)
    @rooms = rooms.most_recent.map do |room|
      RoomPresenter.new(room, self, false)
    end
  end

  def show
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
    @room = current_user.rooms.friendly.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url, notice: t('flash.notice.room_destroyed') }
    end
  end

  private
    def room_params
      params.require(:room).permit(:title, :location, :description)
    end

    def set_room
      room_model = Room.friendly.find(params[:id])
      @room = RoomPresenter.new(room_model, self)
    end
end
