with ctr_iae as (
    select
        ctr.id as id,
        ctr.unite_mesure,
        ctr.complement_dispositif_public,
        ctr.id_employeur_assure
    from ddadtcontrat as ctr
    -- uniquement structures de l'IAE
    where
        ctr.id = 189806231

)

select id_assure
from ctr_iae as ctr
-- jointure avec la table de correspondance id_assure
left join ddadtemployeur_assure as empass
    on empass.id = ctr.id_employeur_assure
-- jointure avec la table employeur
left join ddadtemployeur as emp
    on emp.id = empass.id_employeur