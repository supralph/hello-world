tickets_mart_sql = '''
    SELECT
        *
    FROM tickets
    WHERE
        YEAR(created_at) >= 2019;
    '''

inventory_auction_mart_sql = '''
  SELECT
	make AS car_make,
	model AS car_model,
	submodel AS car_submodel,
	a.title AS car_name,
	manufacture_year AS car_manufacture_year,
	JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.original_registration_date")) AS car_registration_date,
	ROUND((DATEDIFF(now(),JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.original_registration_date"))) / 365), 1) AS car_age_years,
	CASE 
	WHEN i.type = "new" THEN 1 
	WHEN i.type = "used" THEN 0 
	END AS car_new_used,
	color AS car_colour,
	engine_capacity AS car_engine_displacement,
	fuel_type AS car_fuel_type,
	ROUND(JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.omv")), 0) AS car_omv,
	ROUND(JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.arf")), 0) AS car_arf,
	ROUND(JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.coe_qp")), 0) AS car_coe_qp,
	IFNULL(IF(JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.coe_category")) = "null", NULL, NULL), CASE WHEN engine_capacity > 1600 THEN "B" WHEN engine_capacity <= 1600 THEN "A" END) AS car_coe,
	ROUND(JSON_UNQUOTE(JSON_EXTRACT(i.registration_data, "$.transfer_count")), 0) AS car_owner_count,
	COUNT(DISTINCT a.id) AS auction_count,
	ROUND(AVG(TIMESTAMPDIFF(HOUR, a.time_start, a.time_end)), 0) AS auction_duration_hours,
	COUNT(DISTINCT b.id) AS bid_count,
	ROUND(AVG(b.amount), 0) AS avg_bid_price,
	ROUND(AVG(bb.amount), 0) AS highest_bid_price
FROM
	inventories AS i
LEFT JOIN
	auction_inventory AS ai
	ON ai.inventory_id = i.id
LEFT JOIN
	auctions AS a 
	ON ai.auction_id = a.id
LEFT JOIN
	bids AS b
	ON a.id = b.auction_id
LEFT JOIN	
	bids AS bb
	ON a.highest_bid_id = bb.id
WHERE
	i.deleted_at IS NULL 
	AND a.deleted_at IS NULL 
	AND b.id IS NOT NULL
GROUP BY
	i.id;
'''

2. Test double test files

