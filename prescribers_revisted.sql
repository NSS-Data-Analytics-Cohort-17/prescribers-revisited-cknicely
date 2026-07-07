SELECT drug.drug_name, 
	(total_drug_cost / total_day_supply) * 30 * total_30_day_fill_count AS total_spent,
	prescription.npi
FROM prescription
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE opioid_drug_flag = 'Y'

