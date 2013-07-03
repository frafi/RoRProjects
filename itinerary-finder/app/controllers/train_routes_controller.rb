class TrainRoutesController < ApplicationController
  # GET /train_routes
  # GET /train_routes.json
  def index
    @train_routes = TrainRoute.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @train_routes }
    end
  end

  # GET /train_routes/1
  # GET /train_routes/1.json
  def show
    @train_route = TrainRoute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @train_route }
    end
  end

  # GET /train_routes/new
  # GET /train_routes/new.json
  def new
    @train_route = TrainRoute.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @train_route }
    end
  end

  # GET /train_routes/1/edit
  def edit
    @train_route = TrainRoute.find(params[:id])
  end

  # POST /train_routes
  # POST /train_routes.json
  def create
    @train_route = TrainRoute.new(params[:train_route])

    respond_to do |format|
      if @train_route.save
        format.html { redirect_to @train_route, notice: 'Train route was successfully created.' }
        format.json { render json: @train_route, status: :created, location: @train_route }
      else
        format.html { render action: "new" }
        format.json { render json: @train_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /train_routes/1
  # PUT /train_routes/1.json
  def update
    @train_route = TrainRoute.find(params[:id])

    respond_to do |format|
      if @train_route.update_attributes(params[:train_route])
        format.html { redirect_to @train_route, notice: 'Train route was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @train_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /train_routes/1
  # DELETE /train_routes/1.json
  def destroy
    @train_route = TrainRoute.find(params[:id])
    @train_route.destroy

    respond_to do |format|
      format.html { redirect_to train_routes_url }
      format.json { head :no_content }
    end
  end
end
