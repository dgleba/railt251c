
# http://railscasts.com/episodes/126-populating-a-database?autoplay=true

# rails g scaffold Contact1  name address active:boolean updatetime:datetime
# rails destroy  scaffold Contact1


namespace :db do
  desc "fill database"
  
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    #[Contact1].each(&:delete_all)
 
    Customer.populate 43 do |a|
      a.name    = Faker::Name.name
      a.address  = Faker::Address.street_address
      a.phone = Faker::PhoneNumber.phone_number
      a.discount = [0.0, 0.1, 0.15, 0.2]
    end
  
    # Contact1.populate 2 do |a|
      # a.name    = Faker::Name.name
      # a.address  = Faker::Address.street_address
      # a.updatetime = Time.now
      # a.active = Faker::Boolean.boolean
    # end
    
  end
  
end

 