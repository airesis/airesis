#encoding: utf-8
class BlogPostVersion < PaperTrail::Version
  self.table_name = :blog_post_versions
  self.sequence_name = :blog_post_version_id_seq
end
