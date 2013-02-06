ActiveAdmin.register WebPart do
  menu :if => proc{ can?(:manage, WebPart) }

  actions :index, :show, :new, :create, :update, :edit
end
