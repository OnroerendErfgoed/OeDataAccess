SELECT sector, count(*) AS n_species
FROM oe.species
GROUP BY sector;
