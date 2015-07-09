# an old version of a comment
class ProposalCommentVersion < PaperTrail::Version
  self.table_name = :proposal_comment_versions
  self.sequence_name = :proposal_comment_version_id_seq
end
