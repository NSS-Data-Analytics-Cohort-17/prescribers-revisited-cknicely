WITH opioid_spending_city AS (SELECT ((total_drug_cost / total_day_supply) * 30 * total_30_day_fill_count) AS total_spent,
		county
	FROM prescription
		LEFT JOIN drug ON prescription.drug_name = drug.drug_name
		LEFT JOIN prescriber ON prescription.npi = prescriber.npi 
		LEFT JOIN fips_county ON prescriber.nppes_provider_state = fips_county.state
	WHERE opioid_drug_flag = 'Y'
	GROUP BY county)
-- SELECT ROUND(SUM(total_spent), 2) AS total_spent_opioids,
-- 	opioid_spending_city.county
-- FROM opioid_spending_city


-- 	WITH total_spent_npi AS (SELECT ((total_drug_cost / total_day_supply) * 30 * total_30_day_fill_count) AS total_spent, npi
-- 		FROM prescription)
-- SELECT 
-- FROM prescription
-- LEFT JOIN total_spent_npi ON prescription.npi = total_spent_npi.npi
-- LEFT JOIN drug ON prescription.drug_name = drug.drug_name
-- LEFT JOIN prescriber ON prescription.npi = prescriber.npi 
-- LEFT JOIN fips_county ON prescriber.nppes_provider_state = fips_county.state
-- WHERE opioid_drug_flag = 'Y'

	WITH total_spent_npi AS (SELECT ((total_drug_cost / total_day_supply) * 30 * total_30_day_fill_count) AS total_spent, npi
		FROM prescription
		LEFT JOIN drug ON prescription.drug_name = drug.drug_name
		WHERE opioid_drug_flag = 'Y')
SELECT ROUND(SUM(total_spent),2) AS money_spent, fipscounty
FROM total_spent_npi
INNER JOIN prescriber ON total_spent_npi.npi = prescriber.npi
INNER JOIN zip_fips ON prescriber.nppes_provider_zip5 = zip_fips.zip
GROUP BY fipscounty
ORDER BY money_spent DESC

	WITH total_spent_npi AS (
  		SELECT ((total_drug_cost / total_day_supply) * 30 * total_30_day_fill_count) AS total_spent, npi
 	 	FROM prescription
  		LEFT JOIN drug ON prescription.drug_name = drug.drug_name
  		WHERE opioid_drug_flag = 'Y'
	)
SELECT 
  ROUND(SUM(total_spent_npi.total_spent * zip_fips.bus_ratio), 2) AS money_spent, 
  zip_fips.fipscounty
FROM total_spent_npi
INNER JOIN prescriber ON total_spent_npi.npi = prescriber.npi
INNER JOIN zip_fips ON prescriber.nppes_provider_zip5 = zip_fips.zip
GROUP BY zip_fips.fipscounty
ORDER BY money_spent DESC
