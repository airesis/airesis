require 'spec_helper'
require 'requests_helper'

describe 'view proposal revisions', type: :feature, js: true, seeds: true do
  let!(:user) { create(:user) }
  let!(:proposal) { create(:proposal, current_user_id: user.id) }

  before :each do
    login_as user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it 'views the proposal history' do
    content = Faker::Lorem.paragraph
    section = proposal.sections.first
    paragraph = section.paragraphs.first

    params = { sections_attributes: { '0' => { id: section.id, paragraphs_attributes: { '0' => { id: paragraph.id, content: content, content_dirty: content } } } } }
    proposal.current_user_id = user.id
    saved = proposal.update(params)
    expect(saved).to be(true)
    expect(proposal.proposal_revisions.count).to eq(1)
  end
end
