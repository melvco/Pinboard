class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @pins = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end



  def index
    if params[:tag].present? 
      @pins = Pin.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 12)
    else
      @pins = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 12)
    end  
end
  

  def show
  end

  def new
    @pin = current_user.pins.build
  end

  def edit
  end

  def create
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to @pin, notice: 'Item added to corkboard.'
    else
      render action: 'new'
    end
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: 'Item updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @pin.destroy
    redirect_to pins_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "Not authorized to edit this item" if @pin.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
  def pin_params
      params.require(:pin).permit(:description, :image, :tag_list)
    end
   end