namespace :airesis do
  namespace :seed do

    namespace :more do
      desc 'Create more public proposals in debate'
      task :public_proposals, [:number] => :environment do |task, args|
        require 'faker'
        require 'factory_girl'
        number = (args[:number] || 1).to_i
        FactoryGirl.create_list(:public_proposal, number, current_user_id: FactoryGirl.create(:user).id)
      end

      desc 'Create more public proposals in vote for the next three days'
      task :votable_proposals, [:number, :num_solutions] => :environment do |task, args|
        require 'faker'
        require 'factory_girl'
        number = (args[:number] || 1).to_i
        num_solutions = (args[:num_solutions] || 2).to_i

        Timecop.travel(2.days.ago) do
          FactoryGirl.create_list(:in_vote_public_proposal, number, num_solutions: num_solutions)
        end
      end

      desc 'clear all the proposals'
      task clear_proposals: :environment do
        Proposal.destroy_all
      end
    end
  end
end
