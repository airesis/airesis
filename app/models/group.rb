class Group < ActiveRecord::Base

  REQ_BY_PORTAVOCE = 'p'
  REQ_BY_VOTE = 'v'
  REQ_BY_BOTH = 'b'

  #has_many :meetings_organizations, :class_name => 'MeetingsOrganization'
  attr_accessible :partecipant_tokens, :name, :description, :accept_requests, :portavoce, :porta_id

  has_many :group_partecipations, :class_name => 'GroupPartecipation', :dependent => :destroy
  has_many :group_follows, :class_name => 'GroupFollow', :dependent => :destroy
  has_many :post_publishings, :class_name => 'PostPublishing', :dependent => :destroy
  has_many :partecipants,:through => :group_partecipations, :source => :user, :class_name => 'User'
  has_many :followers,:through => :group_follows, :source => :user, :class_name => 'User'
  has_many :posts,:through => :post_publishings, :source => :blog_post, :class_name => 'BlogPost'
  has_many :partecipation_requests, :class_name => 'GroupPartecipationRequest', :dependent => :destroy
  #has_many :partecipation_roles, :class_name => 'PartecipationRole'

  attr_reader :partecipant_tokens, :porta_id
  def partecipant_tokens=(ids)
    self.partecipant_ids = ids.split(",")
  end

  def porta_id
    partecipation = self.group_partecipations.first(:conditions => {:partecipation_role_id => 2})
    if (partecipation)
    return partecipation.user_id
    end
  end

  def porta_id=(id)
    if (!id.empty?)
      partecipation = self.group_partecipations.first(:conditions => {:partecipation_role_id => 2})
      if (partecipation)
      partecipation.partecipation_role_id = 1
      partecipation.save
      end
      partecipation = self.group_partecipations.first(:conditions => {:user_id => id})
      partecipation.partecipation_role_id = 2
      partecipation.save
    end
  end

  attr_accessor :portavoce

  def portavoce
    partecipation = self.group_partecipations.first(:conditions => {:partecipation_role_id => 2})
    if (partecipation)
    return partecipation.user
    end
  end

  def request_by_vote?
    return true if self.accept_requests == REQ_BY_VOTE
    return false
  end

  def request_by_portavoce?
    return true if self.accept_requests == REQ_BY_PORTAVOCE
    return false
  end

  def request_by_both?
    return true if self.accept_requests == REQ_BY_BOTH
    return false
  end

end
