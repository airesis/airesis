#encoding: utf-8
class NewCategories < ActiveRecord::Migration
  def up
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Acqua, Cibo, Agricoltura" ){ |c| c.id = 20 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Territorio, Natura, Animali" ){ |c| c.id = 21 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Urbanistica, Mobilità, Edilizia" ){ |c| c.id = 22 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Energia, Clima" ){ |c| c.id = 23 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Industria, Materiali e Rifiuti" ){ |c| c.id = 24 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Democrazia, Istituzioni" ){ |c| c.id = 25 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Educazione, Ricerca" ){ |c| c.id = 7 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Salute, Igiene" ){ |c| c.id = 8 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Informazione, Comunicazione" ){ |c| c.id = 9 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Commercio, Finanza, Fisco" ){ |c| c.id = 10 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Lavoro e Auto-realizzazione" ){ |c| c.id = 11 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Sicurezza e Giustizia" ){ |c| c.id = 12 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Mondo, Migrazione" ){ |c| c.id = 13 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Minoranze, Handicap" ){ |c| c.id = 14 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Etica, Solidarietà, Spiritualità" ){ |c| c.id = 15 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Sessualità, Famiglia, Bambini" ){ |c| c.id = 16 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Arte e Cultura" ){ |c| c.id = 17 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Socialità, Sport, Divertimento" ){ |c| c.id = 18 }.save
    ProposalCategory.create( parent_proposal_category_id: nil, description: "Organizzazione interna" ){ |c| c.id = 19 }.save
    
    Proposal.all.each do |proposal|
      if (proposal.proposal_category_id == 1) #ambiente
        proposal.proposal_category_id = 21 #animali
      elsif (proposal.proposal_category_id == 2) #tecnologie
        proposal.proposal_category_id = 9 #comunicazione
      elsif (proposal.proposal_category_id == 3) #società
        proposal.proposal_category_id = 18
      elsif (proposal.proposal_category_id == 4) #economia
        proposal.proposal_category_id = 10        
      elsif (proposal.proposal_category_id == 5) #nessuna categoria
        #niente...rimane lì
      elsif (proposal.proposal_category_id == 6) #energia
         proposal.proposal_category_id = 24
      end
      proposal.save!(validate: false)
    end     
  end

  def down
  end
end
