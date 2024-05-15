with ctr_iae as (
    select
        ctr.id as id,
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
    empass.id_assure as id,
    motif,
    date_debut,
    date_fin
from ctr_iae as ctr
left join ddadtsuspension_contrat as susp
    on ctr_iae.id = susp.id
left join id_employeur_assure as empass
    on empass.id = ctr.id_employeur_assure