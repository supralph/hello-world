SELECT
DATE(ticket_created_at_local) AS plan_date,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'daily' THEN ticket_id ELSE NULL END) AS daily_plan,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'roomy' THEN ticket_id ELSE NULL END) AS roomy_plan,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'fancy' THEN ticket_id ELSE NULL END) AS fancy_plan
FROM full_tickets
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2019-01-01'
GROUP BY DATE(ticket_created_at_local)