namespace :airesis do
  namespace :seed do

    namespace :more do
      desc 'Create more public proposals'
      task :public_proposals, [:number] => :environment do |task, args|
        require 'faker'
        require 'factory_girl'
        number = (args[:number] || 1).to_i
        FactoryGirl.create_list(:public_proposal, number, current_user_id: FactoryGirl.create(:user).id)
      end
    end
  end
end
