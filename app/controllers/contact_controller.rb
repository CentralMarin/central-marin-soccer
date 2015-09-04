class ContactController < CmsController
  def index
    init_web_parts('Contacts')

    @contacts_by_category = Contact.by_category
  end
end
