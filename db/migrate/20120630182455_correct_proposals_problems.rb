class CorrectProposalsProblems < ActiveRecord::Migration
  def up
    Proposal.all.each do |proposal|
      proposal.objectives="Non inseriti" if (proposal.objectives.empty?)
      proposal.problems="Non inseriti" if (proposal.problems.empty?)
      proposal.save
    end
    
    execute "update tags t set proposals_count = (select count(*) from proposal_tags pt where pt.tag_id = t.id)"

    execute "update tags t set blog_posts_count = (select count(*) from blog_post_tags pt where pt.tag_id = t.id)"
  end

  def down
  end
end
