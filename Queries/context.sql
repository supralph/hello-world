SELECT
DATE(ticket_created_at_local) AS date,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (1,2,3,18,19,93) THEN ticket_id ELSE NULL END) AS sell_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (79,80) THEN ticket_id ELSE NULL END) AS subscription_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (9, 6, 7, 4, 38, 5, 94, 8, 21, 42) THEN ticket_id ELSE NULL END) AS buy_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (10) THEN ticket_id ELSE NULL END) AS coe_renewal_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (33) THEN ticket_id ELSE NULL END) AS contact_system_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (97) THEN ticket_id ELSE NULL END) AS trade_in_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (24) THEN ticket_id ELSE NULL END) AS export_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (12,13) THEN ticket_id ELSE NULL END) AS carro_enquiry_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (31,32) THEN ticket_id ELSE NULL END) AS genie_enquiry_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (29,30) THEN ticket_id ELSE NULL END) AS insurance_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (25,26) THEN ticket_id ELSE NULL END) AS lease_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (11,28) THEN ticket_id ELSE NULL END) AS loan_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (82) THEN ticket_id ELSE NULL END) AS lto_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (20) THEN ticket_id ELSE NULL END) AS warranty_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (22,23) THEN ticket_id ELSE NULL END) AS workshop_tickets
FROM full_tickets
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
ORDER BY DATE DESC
