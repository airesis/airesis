require 'test_helper'

class ProposalsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "all" do
    proposal = Proposal.new    
    assert !proposal.save, "Can't save empty Proposal"
    #proposal.
  end
  
 
end
