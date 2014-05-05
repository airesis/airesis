class ProposalCommentsRankCounter < ActiveRecord::Migration
  def up
    add_column :proposal_comments, :rank, :integer, default: 0, null: false
    add_column :proposal_comments, :valutations, :integer, default: 0, null: false
    
    
    ProposalComment.all.each do |comment| 
        nvalutations = comment.rankings.count
        num_pos = comment.rankings.positives.count
        ranking = 0
        res = num_pos.to_f / nvalutations.to_f
        ranking = res*100 if nvalutations > 0            
        comment.update_column(:valutations,nvalutations)
        comment.update_column(:rank,ranking.round)
    end
  end

  def down
    remove_column :proposal_comments, :rank
    remove_column :proposal_comments, :valutations
  end
end
