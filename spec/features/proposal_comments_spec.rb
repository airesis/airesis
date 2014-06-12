require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe "create proposal comments", type: :feature, js: true do
  before :each do

  end

  after :each do

  end

  it "creates comments in public proposals" do
    @user = create(:default_user)
    @ability = Ability.new(@user)
    @public_proposal = create(:public_proposal, quorum: BestQuorum.public.first, current_user_id: @user.id)

    login_as @user, scope: :user

    visit proposal_path(@public_proposal)
    page_should_be_ok
    expect(page).to have_content @public_proposal.title
    @ability.should be_able_to(:show, @public_proposal)
    @ability.should be_able_to(:participate, @public_proposal)

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end
    expect(page).to have_content comment

    visit proposal_path(@public_proposal)
    expect(page).to have_content comment

    #open side panels
    i = 0
    max = 3
    comments = []
    page.all(:css, '.contributeButton').each do |el|
      el.click
      within('.suggestion_right') do
        icomment = Faker::Lorem.sentence
        comments << icomment
        fill_in I18n.t('pages.proposals.show.add_contribute'), with: icomment
        click_button I18n.t('pages.proposals.show.send_contribute_button')
      end
      expect(page).to have_content comment
      i+=1
      break if i > max
    end

    visit proposal_path(@public_proposal)
    expect(page).to have_content comment
    i = 0
    page.all(:css, '.contributeButton').each do |el|
      el.click
      expect(page).to have_content comments[i]
      i+=1
      break if i > max
    end
  end

  it "create comments in proposals inside his group" do
    @user = create(:default_user)
    @ability = Ability.new(@user)
    @group = create(:default_group, current_user_id: @user.id)
    @proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: @user.id, group_proposals: [GroupProposal.new(group: @group)])
    
    login_as @user, scope: :user

    visit group_proposal_path(@group,@proposal)
    page_should_be_ok
    expect(page).to have_content @proposal.title
    @ability.should be_able_to(:show, @proposal)
    @ability.should be_able_to(:participate, @proposal)

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end
    expect(page).to have_content comment

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment

    #open side panels
    i = 0
    max = 3
    comments = []
    page.all(:css, '.contributeButton').each do |el|
      el.click
      within('.suggestion_right') do
        icomment = Faker::Lorem.sentence
        comments << icomment
        fill_in 'proposal_comment_content', with: icomment
        click_button I18n.t('pages.proposals.show.send_contribute_button')
      end
      expect(page).to have_content comment
      i+=1
      break if i > max
    end

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment
    i = 0
    page.all(:css, '.contributeButton').each do |el|
      el.click
      expect(page).to have_content comments[i]
      i+=1
      break if i > max
    end
  end

  it "create comments in proposals inside a group where has permissions to participate" do
    @user = create(:default_user)


    @user2 = create(:second_user)
    @group = create(:default_group, current_user_id: @user2.id)
    @proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: @user2.id, group_proposals: [GroupProposal.new(group: @group)])

    create_participation(@user,@group)

    login_as @user, scope: :user

    @ability = Ability.new(@user)

    visit group_proposal_path(@group,@proposal)
    page_should_be_ok
    expect(page).to have_content @proposal.title
    @ability.should be_able_to(:show, @proposal)
    @ability.should be_able_to(:participate, @proposal)

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end
    expect(page).to have_content comment

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment

    #open side panels
    i = 0
    max = 3
    comments = []
    page.all(:css, '.contributeButton').each do |el|
      el.click
      within('.suggestion_right') do
        icomment = Faker::Lorem.sentence
        comments << icomment
        fill_in 'proposal_comment_content', with: icomment
        click_button I18n.t('pages.proposals.show.send_contribute_button')
      end
      expect(page).to have_content comment
      i+=1
      break if i > max
    end

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment
    i = 0
    page.all(:css, '.contributeButton').each do |el|
      el.click
      expect(page).to have_content comments[i]
      i+=1
      break if i > max
    end
  end

end