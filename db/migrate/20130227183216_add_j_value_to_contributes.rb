class AddJValueToContributes < ActiveRecord::Migration
  def up
    add_column :proposal_comments, :j_value, :decimal, :null => false, :default => 0

    ProposalComment.contributes.each do |proposal_comment|
      num_pos = ProposalCommentRanking.count(:conditions => ["proposal_comment_id = ? AND ranking_type_id = ?",proposal_comment.id,POSITIVE_VALUTATION])
      num_neg = ProposalCommentRanking.count(:conditions => ["proposal_comment_id = ? AND ranking_type_id = ?",proposal_comment.id,NEGATIVE_VALUTATION])
      j = num_pos+num_neg > 0 ? ((num_pos.to_f - num_neg.to_f)**2)/(num_pos+num_neg) : 0
      proposal_comment.update_column(:j_value,j.round(2))
    end
  end

  def down
    remove_column :proposal_comments, :j_value
  end
end
