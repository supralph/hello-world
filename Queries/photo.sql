SELECT
DATE(ticket_created_at_local) AS photo_date,
COUNT(DISTINCT CASE WHEN file_photos_count >= 1 THEN ticket_id ELSE NULL END) AS tickets_with_photos
FROM staging_tickets_inventories
LEFT JOIN base_files ON staging_tickets_inventories.ticket_id = base_files.file_model_id
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2019-01-01'
GROUP BY DATE(ticket_created_at_local)