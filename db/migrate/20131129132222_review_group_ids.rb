class ReviewGroupIds < ActiveRecord::Migration
  def up
    execute " alter table supporters drop constraint supporters_group_id_fk;
              alter table proposal_supports drop constraint proposal_supports_group_id_fk;
              alter table post_publishings drop constraint post_publishings_group_id_fk;
              alter table participation_roles drop constraint participation_roles_group_id_fk;
              alter table group_tags drop constraint group_tags_group_id_fk;
              alter table group_quorums drop constraint group_quorums_group_id_fk;
              alter table group_proposals drop constraint group_proposals_group_id_fk;
              alter table group_participations drop constraint group_participations_group_id_fk;
              alter table group_participation_requests drop constraint group_participation_requests_group_id_fk;
              alter table group_invitation_emails drop constraint group_invitation_emails_group_id_fk;
              alter table group_elections drop constraint group_elections_group_id_fk;
              alter table group_areas drop constraint group_areas_group_id_fk;
              alter table action_abilitations drop constraint action_abilitations_group_id_fk;

              alter table supporters add constraint supporters_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table proposal_supports add constraint proposal_supports_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table post_publishings add constraint post_publishings_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table participation_roles add constraint participation_roles_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_tags add constraint group_tags_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_quorums add constraint group_quorums_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_proposals add constraint group_proposals_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_participations add constraint group_participations_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_participation_requests add constraint group_participation_requests_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_invitation_emails add constraint group_invitation_emails_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_elections add constraint group_elections_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table group_areas add constraint group_areas_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table action_abilitations add constraint action_abilitations_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table meeting_organizations add constraint meeting_organizations_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table frm_groups add constraint frm_groups_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;

              delete from frm_forums where group_id not in (select id from groups);
              delete from frm_categories where group_id not in (select id from groups);

              alter table frm_forums add constraint frm_forums_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;
              alter table frm_categories add constraint frm_categories_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE NO ACTION;"
  end

  def down
    #there is no back!!!
  end
end
