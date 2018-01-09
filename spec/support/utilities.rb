def create_simple_vote(user, proposal, vote_type = VoteType::POSITIVE)
  vote = UserVote.new(user: user, proposal: proposal)
  vote.vote_type_id = vote_type unless proposal.secret_vote
  vote.save

  if vote_type == VoteType::POSITIVE
    proposal.vote.positive += 1
  elsif vote_type == VoteType::NEGATIVE
    proposal.vote.negative += 1
  elsif vote_type == VoteType::NEUTRAL
    proposal.vote.neutral += 1
  end
  proposal.vote.save
end

def create_area_participation(user, group_area)
  group_area.area_participations.build(user: user, area_role_id: group_area.area_role_id)
  group_area.save
end

def create_participation(user, group, participation_role_id = nil)
  group.participation_requests.build(user: user, group_participation_request_status_id: GroupParticipationRequestStatus::ACCEPTED)
  group.group_participations.build(user: user, participation_role_id: (participation_role_id || group.participation_role_id))
  group.save
end

def create_proposal_in_area(visible_outside = true)
  user = create(:user)
  group = create(:group, current_user_id: user.id)
  group.enable_areas = true
  group.save
  area = create(:group_area, group: group)
  expect(Ability.new(user)).to be_able_to(:insert_proposal, area)
  create(:group_proposal, current_user_id: user.id, groups: [group], group_area_id: area.id, visible_outside: visible_outside).reload
end


def create_public_proposal(user_id)
  create(:public_proposal, current_user_id: user_id)
end

def activate_areas(group)
  group.enable_areas = true
  create(:group_area, group: group)
  create(:group_area, group: group)
  group.save
  group.reload
end

def add_solution(proposal)
  solution = proposal.build_solution
  solution.seq = 2
  proposal.solutions << solution
  proposal.save
end
