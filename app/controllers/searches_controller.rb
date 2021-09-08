class SearchesController < ApplicationController
  def search
    serch_keyword = params[:serch_keyword]
    case params[:serch_model]
    when "book"
      serch_models = Book.all
      serch_colomn = "title"
    when "user"
      serch_models = User.all
      serch_colomn = "name"
    end

    @serched_models = case params[:serch_parameter]
    when "exact_match"
      serch_models.where("#{serch_colomn} = ?","#{serch_keyword}")
    when "forward_match"
      serch_models.where("#{serch_colomn} LIKE?","#{serch_keyword}%")
    when "backward_match"
      serch_models.where("#{serch_colomn} LIKE?","%#{serch_keyword}")
    when "pattern_match"
      serch_models.where("#{serch_colomn} LIKE?","%#{serch_keyword}%")
    end
  end
end