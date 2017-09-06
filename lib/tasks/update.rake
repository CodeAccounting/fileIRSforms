namespace :update do
  desc "Make that user dejansabados@yahoo.com be admin"
  task :create_admin => :environment do
    User.where(:email => 'dejansabados@yahoo.com').each do |t|
      t.update_attributes(admin: true)
    end
  end
end

