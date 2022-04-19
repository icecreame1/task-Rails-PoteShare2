class ReservationsController < ApplicationController

  before_action :set_user, only: [:destroy]
  before_action :set_reservation, only: [:show, :destroy]
  before_action :set_room, only: [:new, :create]


  def index
    @reservations = current_user.reservations.all.order(:check_in)
  end

  def new
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    if @reservation.invalid?
      render 'rooms/show'
    else
      @reservation.total_day = @reservation.total_day_calc.to_i
      @reservation.total_price = @room.price * @reservation.people * @reservation.total_day
      #binding.pry
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      flash[:notice] = "予約が完了しました"
      redirect_to reservation_path(@reservation)
    else
      params[:back] || !@reservation.save || @reservation.invalid?
      render 'rooms/show'
      flash[:notice] ="予約が出来ませんでした"
    end
  end

  def show
  end

  def destroy
    if @reservation.check_in < Date.today
      flash[:notice] = "キャンセル可能日を過ぎています"
      return
    else
      @reservation.destroy
      redirect_to reservations_path(@reservation)
      flash[:notice] = "予約をキャンセルしました"
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :people, :total_day, :total_price, :user_id, :room_id)
  end

  def set_user
    @reservation = Reservation.find(params[:id])
    if @reservation.user_id != current_user.id
      flash[:alert] = "キャンセル出来ません"
      return
    end
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:reservation][:room_id])
  end

end
