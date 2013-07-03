class ArcsController < ApplicationController
  # GET /arcs
  # GET /arcs.json
  def index
    @arcs = Arc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @arcs }
    end
  end

  # GET /arcs/1
  # GET /arcs/1.json
  def show
    @arc = Arc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @arc }
    end
  end

  # GET /arcs/new
  # GET /arcs/new.json
  def new
    @arc = Arc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @arc }
    end
  end

  # GET /arcs/1/edit
  def edit
    @arc = Arc.find(params[:id])
  end

  # POST /arcs
  # POST /arcs.json
  def create
    @arc = Arc.new(params[:arc])

    respond_to do |format|
      if @arc.save
        format.html { redirect_to @arc, notice: 'Arc was successfully created.' }
        format.json { render json: @arc, status: :created, location: @arc }
      else
        format.html { render action: "new" }
        format.json { render json: @arc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /arcs/1
  # PUT /arcs/1.json
  def update
    @arc = Arc.find(params[:id])

    respond_to do |format|
      if @arc.update_attributes(params[:arc])
        format.html { redirect_to @arc, notice: 'Arc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @arc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arcs/1
  # DELETE /arcs/1.json
  def destroy
    @arc = Arc.find(params[:id])
    @arc.destroy

    respond_to do |format|
      format.html { redirect_to arcs_url }
      format.json { head :no_content }
    end
  end
end
