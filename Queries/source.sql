SELECT
DATE(ticket_created_at_local) AS source_date,
COUNT(DISTINCT CASE WHEN ticket_creator_id >= 1 THEN ticket_id ELSE NULL END) AS  wholesale_created_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'facebook' THEN ticket_id ELSE NULL END) AS facebook_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'google' THEN ticket_id ELSE NULL END) AS google_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IN ('instagram','Instagram') THEN ticket_id ELSE NULL END) AS instagram_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = '101_Carro_General' THEN ticket_id ELSE NULL END) AS direct_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IS NULL THEN ticket_id ELSE NULL END) AS carro_source
FROM full_tickets
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2019-01-01'
GROUP BY DATE(ticket_created_at_local)