SELECT
DATE(ticket_created_at_local) AS date,
COUNT(DISTINCT CASE WHEN ticket_creator_id >= 1 THEN ticket_id ELSE NULL END) AS  wholesale_created_ticket,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'facebook' THEN ticket_id ELSE NULL END) AS ticket_facebook_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'google' THEN ticket_id ELSE NULL END) AS ticket_google_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IN ('instagram','Instagram') THEN ticket_id ELSE NULL END) AS ticket_instagram_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = '101_Carro_General' THEN ticket_id ELSE NULL END) AS ticket_direct_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'dbs' THEN ticket_id ELSE NULL END) AS ticket_dbs_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IS NULL THEN ticket_id ELSE NULL END) AS ticket_carro_source
FROM full_tickets
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
ORDER BY DATE DESC
