class StatNumProposal < ActiveRecord::Base

  def self.extract
    self.connection.select_all "select  year || '-' || month || '-01'   as date, sum(value)
            from stat_num_proposals
            group by year, month
            having (year != #{Date.today.year} or month != #{Date.today.month})
            order by year, month"
  end
end
