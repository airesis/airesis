class ProposalTag < ActiveRecord::Base
  belongs_to :proposal, class_name: 'Proposal'
  belongs_to :tag, class_name: 'Tag'

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  private

  def decrement_counter_cache
    add_to_counters(-1)
  end

  def increment_counter_cache
    add_to_counters(1)
  end

  protected

  def add_to_counters(val)
    if proposal.solr_country_ids.present?
      proposal.solr_country_ids.each do |stato_id|
        tag_counter = tag.tag_counters.find_or_create_by(territory: Country.find(stato_id))
        tag_counter.update(:proposals_count, tag_counter.proposals_count + val)
      end
    else
      proposal.solr_continent_ids.each do |continent_id|
        tag_counter = tag.tag_counters.find_or_create_by(territory: Continent.find(continent_id))
        tag_counter.update(:proposals_count, tag_counter.proposals_count + val)
      end
    end
  end
end
