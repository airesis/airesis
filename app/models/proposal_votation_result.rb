class ProposalVotationResult < ActiveRecord::Base
  belongs_to :proposal
  validates :proposal, presence: true, uniqueness: true

  def beat_couples
    @beat_couples ||= JSON.parse data['beat_couples']
  end

  def calculated
    @calculated = data['calculated'] == 'true' if @calculated.nil?
    @calculated
  end

  def elements
    @elements ||= json_val('elements')
  end

  def limit
    @limit ||= data['limit'].to_i
  end

  def ranks
    @ranks ||= json_val('ranks')
  end

  def winners
    @winners ||= json_val('winners')
  end

  def classifications
    @classifications ||= json_val('classifications')
  end

  private

  def json_val(key)
    JSON.parse data[key]
  end
end
