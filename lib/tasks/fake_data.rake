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
      task :votable_proposals, [:number] => :environment do |task, args|
        require 'faker'
        require 'factory_girl'
        number = (args[:number] || 1).to_i

        quorum = FactoryGirl.create(:best_quorum, percentage: 0, days_m: 2) # min participants is 10% and good score is 50%. vote quorum 0, 50%+1
        user = FactoryGirl.create(:user)
        proposals = Timecop.travel(2.days.ago) do
          FactoryGirl.create_list(:public_proposal, number,
                                  quorum: quorum,
                                  current_user_id: user.id, votation: { choise: 'new',
                                                                        end: 5.days.from_now })
        end
        Timecop.travel(1.day.ago) do
          proposals.each do |proposal|
            proposal.solutions.create(seq: 2)
            proposal.rankings.create(user: user, ranking_type_id: RankingType::POSITIVE)
          end
        end
        proposals.each do |proposal|
          proposal.check_phase(true)
          proposal.reload
          proposal.vote_period.start_votation
        end
      end

      desc 'clear all the proposals'
      task clear_proposals: :environment do
        Proposal.destroy_all
      end
    end
  end
end
