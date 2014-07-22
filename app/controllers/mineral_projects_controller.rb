class MineralProjectsController < ApplicationController
  # GET /mineral_projects
  # GET /mineral_projects.json
  def index
    @mineral_projects = MineralProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mineral_projects }
    end
  end

  # GET /mineral_projects/1
  # GET /mineral_projects/1.json
  def show
    @mineral_project = MineralProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mineral_project }
    end
  end

  # GET /mineral_projects/new
  # GET /mineral_projects/new.json
  def new
    @mineral_project = MineralProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mineral_project }
    end
  end

  # GET /mineral_projects/1/edit
  def edit
    @mineral_project = MineralProject.find(params[:id])
  end

  # POST /mineral_projects
  # POST /mineral_projects.json
  def create
    @mineral_project = MineralProject.new(params[:mineral_project])

    respond_to do |format|
      if @mineral_project.save
        format.html { redirect_to @mineral_project, notice: 'Mineral project was successfully created.' }
        format.json { render json: @mineral_project, status: :created, location: @mineral_project }
      else
        format.html { render action: "new" }
        format.json { render json: @mineral_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mineral_projects/1
  # PUT /mineral_projects/1.json
  def update
    @mineral_project = MineralProject.find(params[:id])

    respond_to do |format|
      if @mineral_project.update_attributes(params[:mineral_project])
        format.html { redirect_to @mineral_project, notice: 'Mineral project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mineral_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mineral_projects/1
  # DELETE /mineral_projects/1.json
  def destroy
    @mineral_project = MineralProject.find(params[:id])
    @mineral_project.destroy

    respond_to do |format|
      format.html { redirect_to mineral_projects_url }
      format.json { head :no_content }
    end
  end
end
