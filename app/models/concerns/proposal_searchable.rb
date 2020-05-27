module ProposalSearchable
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model

    pg_search_scope :search,
                    against: { title: 'A', content: 'B' },
                    order_within_rank: 'proposals.updated_at DESC, proposals.created_at DESC',
                    using: { tsearch: { normalization: 2,
                                        prefix: true,
                                        dictionary: 'english' } }

    pg_search_scope :search_similar,
                    against: %i[title content],
                    associated_against: { tags: :text },
                    order_within_rank: 'proposals.updated_at DESC, proposals.created_at DESC',
                    using: { tsearch: { normalization: 2, any_word: true } }
  end
end
