class ContactController < ApplicationController
  def index
    @contacts_by_category = Contact.by_category
  end
end
