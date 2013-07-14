class NodeDetailsController < ApplicationController
  # GET /node_details
  # GET /node_details.json
  def index
    @node_details = NodeDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @node_details }
    end
  end

  # GET /node_details/1
  # GET /node_details/1.json
  def show
    @node_detail = NodeDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @node_detail }
    end
  end

  # GET /node_details/new
  # GET /node_details/new.json
  def new
    @node_detail = NodeDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @node_detail }
    end
  end

  # GET /node_details/1/edit
  def edit
    @node_detail = NodeDetail.find(params[:id])
  end

  # POST /node_details
  # POST /node_details.json
  def create
    @node_detail = NodeDetail.new(params[:node_detail])

    respond_to do |format|
      if @node_detail.save
        format.html { redirect_to @node_detail, notice: 'Node detail was successfully created.' }
        format.json { render json: @node_detail, status: :created, location: @node_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @node_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /node_details/1
  # PUT /node_details/1.json
  def update
    @node_detail = NodeDetail.find(params[:id])

    respond_to do |format|
      if @node_detail.update_attributes(params[:node_detail])
        format.html { redirect_to @node_detail, notice: 'Node detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @node_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /node_details/1
  # DELETE /node_details/1.json
  def destroy
    @node_detail = NodeDetail.find(params[:id])
    @node_detail.destroy

    respond_to do |format|
      format.html { redirect_to node_details_url }
      format.json { head :no_content }
    end
  end
end
