class TrainsController < ApplicationController
  # GET /trains
  # GET /trains.json
  def index
    @trains = Train.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trains }
    end
  end

  # GET /trains/1
  # GET /trains/1.json
  def show
    @train = Train.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @train }
    end
  end

  # GET /trains/new
  # GET /trains/new.json
  def new
    @train = Train.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @train }
    end
  end

  # GET /trains/1/edit
  def edit
    @train = Train.find(params[:id])
  end

  # POST /trains
  # POST /trains.json
  def create
    @train = Train.new(params[:train])

    respond_to do |format|
      if @train.save
        format.html { redirect_to @train, notice: 'Train was successfully created.' }
        format.json { render json: @train, status: :created, location: @train }
      else
        format.html { render action: "new" }
        format.json { render json: @train.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trains/1
  # PUT /trains/1.json
  def update
    @train = Train.find(params[:id])

    respond_to do |format|
      if @train.update_attributes(params[:train])
        format.html { redirect_to @train, notice: 'Train was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @train.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trains/1
  # DELETE /trains/1.json
  def destroy
    @train = Train.find(params[:id])
    @train.destroy

    respond_to do |format|
      format.html { redirect_to trains_url }
      format.json { head :no_content }
    end
  end
end
