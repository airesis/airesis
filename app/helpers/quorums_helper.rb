module QuorumsHelper

  def desc_percentage(percentage)
    return "1" unless percentage && percentage > 0
    ret = "#{percentage}%"
    ret +="+1" if percentage < 100
    ret
  end


  def dates_panel(quorum)
    ret = ""
    if quorum.instance_of? OldQuorum
      if quorum.time_left? #if time set and time left
        if quorum.valutations_left? #if two parameters and valutations left
          ret += "<div class=\"time_end\">#{I18n.t('pages.proposals.show.debate_ends_html')}:</div>"
          ret += "<div class=\"end-debate\"></div>"
          ret += "<div class=\"join_clause\">#{quorum.or? ? t('pages.proposals.show.debate_ends_valutations_or') : t('pages.proposals.show.debate_ends_valutations_and')}:</div>"
          ret += "<b>#{quorum.valutations_left}</b>"
        else #only time
          ret += "<div class=\"time_end\">#{t('pages.proposals.show.debate_ends_html')}:</div>"
          ret += "<div id=end_debate></div>"
        end
      elsif quorum.valutations_left? #only valutations
        ret += "<div class=\"time_end\">#{t('pages.proposals.show.debate_ends_valutations')}:</div>"
        ret += "<b>#{quorum.valutations_left}</b>"
      else #stalled
        ret += "End of debate:<br/>rank superior to <b>#{quorum.good_score}%</b><br/>" #TODO:I18n
        ret += "Abandoned:<br/>rank inferior to <b>#{quorum.bad_score}%</b>"
      end
    else
        if quorum.time_left? #if time set and time left
            ret += "<div class=\"time_end\">#{t('pages.proposals.show.debate_ends_html')}:</div>"
            ret += "<div class=\"end-debate\"></div>"
        else #stalled
          ret += "End of debate:<br/>rank superior to <b>#{quorum.good_score}%</b><br/>" #TODO:I18n
        end
    end
    ret.html_safe
  end
end
