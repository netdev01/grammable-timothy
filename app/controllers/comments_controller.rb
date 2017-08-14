class CommentsController < ApplicationController

  before_action :authenticate_user!, only: [:create]

	def create

		@gram = Gram.find_by_id(params[:gram_id])
		return render_not_found if @gram.blank?
		@gram.comments.create(comment_params.merge(user: current_user))

		# Comment.create(comment_params.merge(:user => current_user, :gram_id => params[:gram_id])

		# @gram = Gram.find_by_id(params[:gram_id])
		# @gram.comments.new(comment_params)
		# @gram.user = current_user
		# @gram.save

		redirect_to root_path
	end

	private

  helper_method :current_gram
  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

  helper_method :current_comment
  def current_comment
    @current_comment ||= Comment.find_by_id(params[:id])
  end

	def comment_params
		params.require(:comment).permit(:message)
	end

end

