json.proposal do
  json.id @proposal.id
  json.created_at @proposal.created_at
  json.updated_at @proposal.updated_at
  json.proposal_category_id @proposal.proposal_category_id
  json.title @proposal.title
  json.short_content @proposal.short_content
  json.rank @proposal.rank
  json.valutations @proposal.valutations
  json.percentage @proposal.percentage
  json.anonymous @proposal.is_anonima?
  json.private @proposal.private?
  json.area_private @proposal.area_private?
  json.visible_outside @proposal.visible_outside?
  json.users @proposal.users_j
  json.interest_borders @proposal.interest_borders do |interest_border|
    json.territory_id interest_border.territory_id
    json.territory_type interest_border.territory_type
    json.description interest_border.description
  end
  json.groups @proposal.groups do |group|
    json.id group.id
    json.name group.name
    json.image_url group.image.url
  end
  json.sections @proposal.sections do |section|
    json.seq section.seq
    json.title section.title
    json.paragraphs section.paragraphs do |paragraph|
      json.content paragraph.content
    end
  end
  json.solutions @proposal.solutions do |solution|
    json.seq solution.seq
    json.title solution.title
    json.sections solution.sections do |section|
      json.seq section.seq
      json.title section.title
      json.paragraphs section.paragraphs do |paragraph|
        json.content paragraph.content
      end
    end
  end
end
