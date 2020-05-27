namespace :airesis do
  namespace :seed do
    namespace :more do
      desc 'Create more public proposals in debate'
      task :public_proposals, [:number] => :environment do |_task, args|
        require 'faker'
        require 'factory_bot_rails'
        number = (args[:number] || 1).to_i
        FactoryBot.create_list(:public_proposal, number, current_user_id: FactoryBot.create(:user).id)
      end

      desc 'Create more public proposals in vote for the next three days'
      task :votable_proposals, %i[number num_solutions] => :environment do |_task, args|
        require 'faker'
        require 'factory_bot_rails'
        number = (args[:number] || 1).to_i
        num_solutions = (args[:num_solutions] || 2).to_i

        Timecop.travel(2.days.ago) do
          FactoryBot.create_list(:in_vote_public_proposal, number, num_solutions: num_solutions)
        end
      end

      desc 'Create more abadoned proposals'
      task :abandoned_proposals, [:number] => :environment do |_task, args|
        require 'faker'
        require 'factory_bot_rails'
        number = (args[:number] || 1).to_i

        Timecop.travel(10.days.ago) do
          FactoryBot.create_list(:abadoned_public_proposal, number)
        end
      end

      desc 'clear all the proposals'
      task clear_proposals: :environment do
        Proposal.destroy_all
      end
    end
  end
end
