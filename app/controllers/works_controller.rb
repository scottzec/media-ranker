class WorksController < ApplicationController

  before_action :find_work, only: [:show, :edit, :update, :destroy]

  def index
    @works = Work.all
  end

  def show
    if @work.nil?
      redirect_to works_path
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save # returns true if db insert succeeds
      flash[:success] = "Your #{@work.category} has been added successfully to the ranker"
      redirect_to work_path(@work.id) # @work or @work.id?
      return
    else
      flash.now[:error] = "Something's gone awry. Your #{@work.category} hasn't been added"
      render :new, status: :bad_request # look at bad_request
      return
    end
  end

  def edit
    if @work.nil?
      head :not_found
      return
    end
  end


  def update
    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      flash[:success] = "Your #{@work.category} #{@work.title} has been successfully updated."
      redirect_to work_path(@work.id)
      return
    else
      flash.now[:warning] = "There was a problem. We couldn't update your #{@work.category}."
      render :edit
      return
    end

  end

  def destroy
    if @work.nil?
      head :not_found
      return
    end

    @work.destroy
    flash[:success] = "Successfully destroyed #{@work.category} #{@work.title}"
    redirect_to works_path
    return
  end

  private

  def find_work
    @work = Work.find_by_id(params[:id])
  end

  def work_params
    return params.require(:work).permit(:title, :category, :creator, :publication_year, :description)
  end

end
