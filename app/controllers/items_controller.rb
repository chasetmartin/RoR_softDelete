class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  # Update index method to only return active items useing the active scope from Item model
  def index
    @items = Item.active
  end

  # GET /items/deleted or /items/deleted.json
  def deleted
    @items = Item.where.not(deleted_at: nil)
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  # Update destroy method to soft_delete item
  def destroy
    @item = Item.find(params[:id])
    @item.soft_delete

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully soft-deleted." }
      format.json { head :no_content }
    end
  end

  # PUT /items/1/restore
  # Add restore method to restore soft-deleted item
  def restore
    @item = Item.find(params[:id])
    @item.restore

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully restored." }
      format.json { head :no_content }
    end
  end

  # GET /items/deleted or /items/deleted.json
  # Added controller action to GET soft-deleted trash can items
  def deleted
    @items = Item.where.not(deleted_at: nil)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through, only name is required.
    def item_params
      params.require(:item).permit(:name)
    end
end
