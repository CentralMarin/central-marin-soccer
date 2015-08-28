class WebPartController < ApplicationController
  def show
    html = nil
    I18n.with_locale(params[:locale].to_sym) do
      web_part = WebPart.find_by(name: params[:name])
      html = web_part.html unless web_part.nil?
    end

    render json: {html: html}
  end

  def update

    # verify the current user has the appropriate permissions
    if session[:edit_pages] != true
     render :json => { :errors => 'Unable to update - #1'}, :status => 422
     return
    end

    # Lookup the name
    web_part = WebPart.find_by(name: params[:name])
    if web_part.nil?
      render :json => { :errors => "Unable to update - #2"}, :status => 422
      return
    end

    web_part.html = params[:html]
    if web_part.save
      head :ok
    else
      render :json => { :errors => "Unable to update - #3"}, :status => 422
    end
  end
end
