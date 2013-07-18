class MissingCategoriesTranslation < ActiveRecord::Migration
  def up
    I18n.locale = :us

    ProposalCategory.find(5).update_attribute(:description,"Uncategorized")
    ProposalCategory.find(7).update_attribute(:description,"Education, Research")
    ProposalCategory.find(8).update_attribute(:description,"Health, Hygiene")
    ProposalCategory.find(9).update_attribute(:description,"Information, Communication")
    ProposalCategory.find(10).update_attribute(:description,"Commerce, Finance, Taxes")
    ProposalCategory.find(11).update_attribute(:description,"Work and Self-realization")
    ProposalCategory.find(12).update_attribute(:description,"Security and Justice")
    ProposalCategory.find(13).update_attribute(:description,"World, Migration")
    ProposalCategory.find(14).update_attribute(:description,"Minorities, Handicap")
    ProposalCategory.find(15).update_attribute(:description,"Ethics, Solidarity, Spirituality")
    ProposalCategory.find(16).update_attribute(:description,"Sexuality, Family, Children")
    ProposalCategory.find(17).update_attribute(:description,"Art and Culture")
    ProposalCategory.find(18).update_attribute(:description,"Social, Sport, Entertainment")
    ProposalCategory.find(19).update_attribute(:description,"Internal organization")
    ProposalCategory.find(20).update_attribute(:description,"Water, Food, Agriculture")
    ProposalCategory.find(21).update_attribute(:description,"Territory, Nature, Animals")
    ProposalCategory.find(22).update_attribute(:description,"Urbanism, Mobility, Construction")
    ProposalCategory.find(23).update_attribute(:description,"Energy, Climate")
    ProposalCategory.find(24).update_attribute(:description,"Industry, Materials and Waste")
    ProposalCategory.find(25).update_attribute(:description,"Democracy, Institutions")
  end

  def down
  end
end
