#encoding: utf-8
module AffinityHelper
  
  #questo algoritmo viene eseguito ogni notte per determinare le affinità tra utenti e gruppi
  def self.calculate_user_group_affinity
    @msg = "Calcolo affinità utenti-gruppi:<br/>\n"
    #seleziono gli utenti che hanno cambiato i propri confini di interesse nelle ultime 26 ore
    #seleziono i gruppi che hanno cambiato i propri confini di interesse nelle ultime 26 ore
    users = User.all
    groups = Group.all
    affinities = {}
    users.each do |user|
      @msg += "<b>#{user.login}</b><br/>\n"
      unless user.interest_borders.empty?
        @msg += user.interest_borders.collect{|ib| ib.description}.join(" , ")
        @msg += "<ul>\n"
        groups.each do |group|
          key =user.interest_borders.map{ |ib| ib.territory_type + "-" + ib.territory_id.to_s}.join("") + "--" + group.interest_border.description
          affinity = user.group_affinities.find_or_create_by_group_id(group.id)
          if affinities[key]
            affinity.value = affinities[key]
            @msg += "<li><b>#{group.name}</b> - #{group.interest_border.description} - cached affinity: #{affinity.value}\n"
          else
            affinity.value = user_group_aff(user,group)
            @msg += "<li><b>#{group.name}</b> - #{group.interest_border.description} - affinity: #{affinity.value}\n"
            @msg += "add key-value affinity pair: #{key}:#{affinity.value}\n"
            affinities[key] = affinity.value
          end          
          affinity.save
          @msg += "</li>\n"
        end
        @msg += "</ul><br/>"
        @msg += "Suggested groups: <br/>\n"
        @msg += user.suggested_groups.collect{|g| g.name}.join(",") + "<br/>\n"
      end
      @msg += "-------<br/>\n"
    end
    ResqueMailer.admin_message(@msg).deliver
    #puts @msg
  end
  
  PERFECT_HIT = 100
  COMUNE_IN_PROVINCIA = 90
  COMUNE_IN_REGIONE = 80
  PROVINCIA_IN_REGIONE = 90
  PROVINCIA_HAS_COMUNE = 50
  REGIONE_HAS_PROVINCIA = 50
  REGIONE_HAS_COMUNE = 40
  NO_AFFINITY = 0
  #calcola un valore di affinità tra un gruppo ed un utente
  def self.user_group_aff(user,group)
    ib_conf_g = group.interest_border
    ib_conf_u = user.interest_borders
    return PERFECT_HIT if ib_conf_u.include?(ib_conf_g)
    conf_g = ib_conf_g.territory
    c_conf_u = ib_conf_u.collect{ |ib| ib.territory if ib.territory_type == InterestBorder::COMUNE}.compact
    p_conf_u = ib_conf_u.collect{ |ib| ib.territory if ib.territory_type == InterestBorder::PROVINCIA}.compact
    r_conf_u = ib_conf_u.collect{ |ib| ib.territory if ib.territory_type == InterestBorder::REGIONE}.compact
    if (ib_conf_g.territory_type == InterestBorder::COMUNE)
      p_conf_g = conf_g.provincia
      r_conf_g = p_conf_g.regione
      return COMUNE_IN_PROVINCIA if p_conf_u.include?(p_conf_g) #è un comune compreso in una delle province di interesse
      return COMUNE_IN_REGIONE if r_conf_u.include? (r_conf_g)  #è un comune compreso in una delle regioni di interesse
    elsif (ib_conf_g.territory_type == InterestBorder::PROVINCIA)
        r_conf_g = conf_g.regione
        return PROVINCIA_IN_REGIONE if r_conf_u.include?(r_conf_g) #è una provincia compresa in una delle regioni di interesse
        pc_conf_u = c_conf_u.collect{ |comune| comune.provincia}
        return PROVINCIA_HAS_COMUNE if pc_conf_u.include?(conf_g) #è una provincia che comprende uno dei comuni di interesse
    elsif (ib_conf_g.territory_type == InterestBorder::REGIONE)
      rp_conf_u = p_conf_u.collect{ |provincia| provincia.regione}
      return REGIONE_HAS_PROVINCIA if rp_conf_u.include?(conf_g) #è una regione che comprende una delle province di interesse
      rpc_conf_u = c_conf_u.collect{ |comune| comune.provincia.regione}
      return REGIONE_HAS_COMUNE if rpc_conf_u.include?(conf_g) 
    end
    return NO_AFFINITY
  end
end
