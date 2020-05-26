require 'rails_helper'

RSpec.describe ProposalRevision do
  let!(:user) { create(:user) }
  let!(:proposal) { create(:proposal, current_user_id: user.id) }

  it 'views the proposal history' do
    content = Faker::Lorem.paragraph
    section = proposal.sections.first
    paragraph = section.paragraphs.first

    params = { sections_attributes: {
      '0' => { id: section.id,
               paragraphs_attributes: {
                 '0' => { id: paragraph.id, content: content, content_dirty: content }
               } }
    } }
    proposal.current_user_id = user.id
    expect(proposal.update(params)).to be(true)
    expect(proposal.proposal_revisions.count).to eq(1)
  end
end
