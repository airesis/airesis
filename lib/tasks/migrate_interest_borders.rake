namespace :airesis do
  namespace :migrate_interest_borders do
    task groups: :environment do
      Group.find_each do |group|
        group.update(interest_border_tkn: group.interest_border.key, updated_at: group.updated_at)
      end
    end

    task proposals: :environment do
      Proposal.find_each do |proposal|
        current_user = proposal.users.first || proposal.proposal_lives.last.users.first
        # puts "#{proposal.id}: setting user to #{current_user}"
        if current_user.nil?
          puts "could not fix proposal #{proposal.id}. destroyed."
          proposal.destroy
        else
          proposal.update(current_user_id: current_user.id,
                          interest_borders_tkn: proposal.interest_borders.map(&:key).join(','),
                          updated_at: proposal.updated_at)
        end
      end
    end

    task users: :environment do
      User.find_each do |user|
        next if user.interest_borders.empty?

        user.update(interest_borders_tokens: user.interest_borders.map(&:key).join(','),
                    updated_at: user.updated_at)
      end
    end
  end
end
