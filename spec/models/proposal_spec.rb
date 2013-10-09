require 'spec_helper'

describe Proposal do
  before(:each) do    
    @proposal= Proposal.new(:id=>2500,:proposal_category_id=> 19,:title=>"new",:content=>"",:vote_period_id=>nil,:subtitle=>"",:problems=>"",:objectives=>"",:private=>true,:quorum_id=> 9517,:anonima=>false,:visible_outside=>false,:secret_vote=>false,:proposal_type_id=> 9,:proposal_votation_type_id=> 1)    
  end 


 it "should not save proposal without a title" do   
   @proposal.title=""
   @proposal.should_not be_valid
 end

 it "should not save proposal without a proposal_category_id" do   
   @proposal.proposal_category_id=nil
   @proposal.should_not be_valid
 end

 it "should not save proposal without a quorum_id" do   
   @proposal.quorum_id=nil
   @proposal.should_not be_valid
 end

 it "should not take quorum_id as string" do  
   @proposal.quorum_id="abcdef"
   @proposal.quorum_id.equal?(0)
 end

 it "should not take proposal_state_id as string" do  
   @proposal.proposal_state_id="abcdef"
   @proposal.proposal_state_id.equal?(0)
 end

 it "should not take proposal_type_id as string" do  
   @proposal.proposal_type_id="abcdef"
   @proposal.proposal_type_id.equal?(0)
 end

 it "should not take proposal_votation_type_id as string" do  
   @proposal.proposal_votation_type_id="abcdef"
   @proposal.proposal_votation_type_id.equal?(0)
 end

 it "should save_tags before saving a proposal" do
   Proposal.stub(:save_tags) 
   proposal = FactoryGirl.build(:proposal, title: "public2")
 end

it "should populate_fake_url before creating a proposal" do
  Proposal.stub(:populate_fake_url) 
  proposal = FactoryGirl.build(:proposal, url: "")
  proposal.url.should_not be_nil
end

 it "should create a proposal with valid parameters" do 
  proposal = FactoryGirl.build(:proposal, id: 2500, proposal_category_id: 19)
  proposal.errors_on(:proposal).should be_blank      
 end

it "should not accept already taken title" do
  error=[]
  proposal1 = FactoryGirl.build(:proposal, title: "taken", proposal_category_id: 19) 
  proposal2 = FactoryGirl.build(:proposal, title: "taken", proposal_category_id: 19) 
  if proposal2.title == proposal1.title
    error=proposal2.errors_on(:proposal2)
    error<<"already taken."
  end    
  error.to_s.should =~ /already taken/  
end

it "should be in votation after recent creation" do
 proposal = FactoryGirl.build(:proposal, proposal_state_id: 2)
 (2..3).to_a.include?(proposal.proposal_state_id).should be_true
end

it "should be in votation when proposal_state_id is between 2 and 3" do
 proposal = FactoryGirl.build(:proposal, proposal_state_id: 2)
 (2..3).to_a.include?(proposal.proposal_state_id).should be_true
end

it "should be in voting when proposal_state_id is 4" do
 proposal = FactoryGirl.build(:proposal, title: "in voting", proposal_state_id: 4)
 proposal.proposal_state_id.should eql(4)
end

it "should be accepted when proposal_state_id is 6" do
 proposal = FactoryGirl.build(:proposal, title: "accepted", proposal_state_id: 6)
 proposal.proposal_state_id.should eql(6)
end

it "should be voted when proposal_state_id is between 5 and 6" do
 proposal = FactoryGirl.build(:proposal, title: "voted", proposal_state_id: 6)
 (5..6).to_a.include?(proposal.proposal_state_id).should be_true
end

it "should be rejected when proposal_state_id is 5" do
 proposal = FactoryGirl.build(:proposal, title: "rejected", proposal_state_id: 5)
 proposal.proposal_state_id.should eql(5)
end

it "should be abandoned when proposal_state_id is 8" do
 proposal = FactoryGirl.build(:proposal, title: "abandoned", proposal_state_id: 8)
 proposal.proposal_state_id.should eql(8)
end

it "should be in revision when proposal_state_id is 8" do
 proposal = FactoryGirl.build(:proposal, title: "revision", proposal_state_id: 8)
 proposal.proposal_state_id.should eql(8)
end

it "should be in votation when proposal_state_id is 1" do
 proposal = FactoryGirl.build(:proposal, title: "votation", proposal_state_id: 1)
 proposal.proposal_state_id.should eql(1)
end

it "should be public when not within group" do
 proposal = FactoryGirl.build(:proposal, title: "public", private: false)
 proposal.private.should be_false
end

it "should be private when within the group" do
 proposal = FactoryGirl.build(:proposal, title: "public", private: true)
 proposal.private.should be_true
end

it "should save_proposal_history before update" do
 proposal = FactoryGirl.build(:proposal, title: "public1", private: true) 
 Proposal.stub(:save_proposal_history) 
 proposal = FactoryGirl.build(:proposal, title: "public2", private: true) 
end

it "should mark_integrated_contributes after update " do
  proposal = FactoryGirl.build(:proposal, title: "public1") 
  proposal = FactoryGirl.build(:proposal, title: "public2")
  Proposal.stub(:mark_integrated_contributes) 
end

it "should have standard proposal_type" do
  proposal = FactoryGirl.build(:proposal, title: "public1") 
  proposal.proposal_type.name = "STANDARD".should eql("STANDARD")
end

it "should have polling enabled in proposal_type" do
  proposal = FactoryGirl.build(:proposal, title: "public1") 
  proposal.proposal_type.name = "POLL".should eql("POLL")
end

it "should be current when proposal_state_id is in between 1,2,3,4 " do
  for i in (1..4).to_a
    proposal = FactoryGirl.build(:proposal, title: "public1", proposal_state_id: i)
    proposal.proposal_state_id.should eql(i)     
  end
end


end
