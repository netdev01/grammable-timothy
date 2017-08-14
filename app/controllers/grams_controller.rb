class GramsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destory]

	def index
		@grams = Gram.all
	end

	def new
		@gram = Gram.new
	end

	def create
	  @gram = current_user.grams.create(gram_params)
	  if @gram.valid?
	    redirect_to root_path
	  else
	    render :new, status: :unprocessable_entity
	  end
	end

	def destroy
		@gram = Gram.find_by_id(params[:id])	
    return render_not_found if @gram.blank?
		if @gram.user != current_user
			# redirect_to edit_gram_path(@gram), alert: 'Only the author can delete this gram.'
	    return render_not_found(:forbidden)
		else
			@gram.delete
			redirect_to root_path
		end
	end

	def edit
		@gram = Gram.find_by_id(params[:id])
		return render_not_found if @gram.blank?		
		if @gram.user != current_user
			# redirect_to root_path, alert: 'Only the author can edit this gram.'
			return render_not_found(:forbidden)
		end
	end

	def update
		@gram = Gram.find_by_id(params[:id])
		return render_not_found if @gram.blank?
	  return render_not_found(:forbidden) if @gram.user != current_user
		@gram.update_attributes(gram_params)
		if @gram.valid?
	 		redirect_to root_path
	  else
	    return render :edit, status: :unprocessable_entity
	  end
	end

	def show
		@gram = Gram.find_by_id(params[:id])
		render_not_found if @gram.blank?
	end


  private

  helper_method :current_gram
  def current_gram
    @current_gram ||= Gram.find_by_id(params[:id])
  end

  def gram_params
    params.require(:gram).permit(:message, :image)
  end

end
