class WebPartController < ApplicationController
  def save

    # verify the current user has the appropriate permissions
    #if not can?(:manage, WebPart)
    #  render :json => { :errors => 'Unable to update - #1'}, :status => 422
    #  return
    #end

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
