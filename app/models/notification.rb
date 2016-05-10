class Notification < ActiveRecord::Base
  translates :subject, :body
  accepts_nested_attributes_for :translations
end
