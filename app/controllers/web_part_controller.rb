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

    name = params[:name]
    render :json => { :errors => "Unable to update - #2"}, :status => 422 unless save_content(:en, name, params[:en_html])
    render :json => { :errors => "Unable to update - #3"}, :status => 422 unless save_content(:es, name, params[:es_html])

    head :ok
  end

  protected

  def save_content(locale, name, html)
    I18n.with_locale(locale) do
      web_part = WebPart.find_by(name: name)
      return false if web_part.nil?

      web_part.html = html;
      return true if web_part.save
    end

    false

  end
end
