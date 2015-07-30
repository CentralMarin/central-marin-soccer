namespace :user do
  desc "Allows you to set the password for a given account"
  task :set_password, [:email, :password] => [:environment] do |t,args|

    user = AdminUser.find_by(email: args.email)
    if not user.nil?
      user.password = args.password
      user.save
      puts "Updated password"
    else
      puts "Unable to find #{args.email}.. creating"
      AdminUser.create!(:email => args.email, :password => args.password, :password_confirmation => args.password)
    end
  end

end
