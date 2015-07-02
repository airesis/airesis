class GroupVersion < PaperTrail::Version
  self.table_name = :group_versions
  self.sequence_name = :group_version_id_seq
end
