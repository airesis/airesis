class Search < ActiveRecord::Base

  attr_accessor :groups, :proposals, :user_id

  def find
    self.groups = Group.search do
      fulltext self.q

      order_by :score, :desc
      order_by :group_partecipations_count, :desc
      order_by :created_at, :desc

      paginate :page => 1, :per_page => 5
    end.results

    self.proposals = Proposal.search do
      fulltext self.q
        all_of do
          without(:proposal_type_id, 11) #TODO removed petitions
          any_of do
            with(:private, false)
            with(:visible_outside, true)
            if self.user_id
              all_of do
                with(:presentation_group_ids, User.find(self.user_id).groups.pluck(:id))
                with(:presentation_area_ids, nil)

              end
            end
          end
        end
      adjust_solr_params do |params|
        params[:bq] = " presentation_group_ids_im:(#{User.find(self.user_id).groups.pluck(:id).join(' OR ')})^20"
      end
      #order_by :presentation_group_ids, :desc
      order_by :score, :desc
      order_by :updated_at, :desc
      paginate :page => 1, :per_page => 5
    end.results
  end
end
