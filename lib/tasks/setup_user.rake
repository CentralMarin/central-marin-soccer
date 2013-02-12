namespace :user do
  desc "Allows you to set the "
  task :set_password, [:email, :password] => [:environment] do |t,args|
    user = User.find_by_email(args.email)
    if not user.nil?
      user.password = args.password
      user.save
    end
  end

end
