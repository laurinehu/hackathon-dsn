with ctr_iae as (
    select
        ctr.id,
        ctr.unite_mesure,
        ctr.complement_dispositif_public,
        ctr.id_employeur_assure
    from ddadtcontrat as ctr
    -- uniquement structures de l'IAE
    where
        ctr.complement_dispositif_public = '02' or
        ctr.complement_dispositif_public = '03' or
        ctr.complement_dispositif_public = '04' or
        ctr.complement_dispositif_public = '05'
)

select
    distinct
    ctr.id                      as id,
    empass.id_assure                as id_salarie,
    empass.id_employeur             as id_employeur,
    date_debut_paie                 as date_debut_paie,
    date_fin_paie                   as date_fin_paie,
    activite.mesure                 as mesure,
    -- dans le cas ou l'unité de mesure est en jours (!= 10) on converti en heures
    -- sinon on prend la mesure telle que
    case
        when activite.unite_mesure != '10' then activite.mesure*4.8 -- 24(heures semaine)/5(jours ds la semaine)
        else activite.mesure
    end as nb_heures_activite

from ctr_iae as ctr
-- jointure avec la table de correspondance id_assure
left join ddadtemployeur_assure as empass
    on empass.id = ctr.id_employeur_assure
-- jointure avec la table employeur
left join ddadtemployeur as emp
    on emp.id = empass.id_employeur
-- jointure avec la table
left join ddadtversement as vers
    on vers.id_employeur_assure = ctr.id_employeur_assure
-- jointure avec la table rembrute
left join ddadtrem_brute_ac as rem
    on rem.id_versement = vers.id
-- jointure avec la table actvite
left join ddadtactivite as activite
    on activite.id_remuneration_brute_ac = rem.id
-- on retire les 40 parcequ'ils correspondent aux cas de subrogation de la sécurité sociale
where empass.id_assure = 15197801
--    empass.id_assure,
--    empass.id_employeur