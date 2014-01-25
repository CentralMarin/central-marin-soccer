namespace :user do
  desc "Allows you to set the password for a given account"
  task :set_password, [:email, :password] => [:environment] do |t,args|

    user = AdminUser.find_by_email(args.email)
    if not user.nil?
      user.password = args.password
      user.save
    else
      puts "Unable to find #{args.email}"
    end
  end

end
