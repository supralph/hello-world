WITH
    funnel AS (
SELECT
DATE(ticket_created_at_local) AS date,
COUNT(DISTINCT ticket_id) AS tickets_created,
COUNT(DISTINCT CASE WHEN ticket_inventory_id >= 1 THEN ticket_id ELSE NULL END) AS tickets_with_inventory,
COUNT(DISTINCT CASE WHEN auction_id >= 1 THEN ticket_id ELSE NULL END) AS tickets_with_auction,
COUNT(DISTINCT CASE WHEN bid_id >= 1 THEN ticket_id ELSE NULL END) AS tickets_with_bid
FROM full_tickets
LEFT JOIN base_auction_inventory ON full_tickets.ticket_inventory_id = base_auction_inventory.auction_inventory_inventory_id
LEFT JOIN full_auctions ON base_auction_inventory.auction_inventory_auction_id = full_auctions.auction_id
LEFT JOIN full_bids ON full_auctions.auction_id = full_bids.bid_auction_id
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),

    source AS (
SELECT
DATE(ticket_created_at_local) AS date,
COUNT(DISTINCT CASE WHEN ticket_creator_id >= 1 THEN ticket_id ELSE NULL END) AS  ticket_from_wholesale,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'facebook' THEN ticket_id ELSE NULL END) AS ticket_facebook_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'google' THEN ticket_id ELSE NULL END) AS ticket_google_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IN ('instagram','Instagram') THEN ticket_id ELSE NULL END) AS ticket_instagram_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = '101_Carro_General' THEN ticket_id ELSE NULL END) AS ticket_direct_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IS NULL THEN ticket_id ELSE NULL END) AS ticket_carro_source
FROM full_tickets
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),

    context AS (
SELECT
COUNT(DISTINCT CASE WHEN ticket_context_id IN (1,2,3,18,19,93) THEN ticket_id ELSE NULL END) AS sell_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (79,80) THEN ticket_id ELSE NULL END) AS subscription_tickets,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (9, 6, 7, 4, 38, 5, 94, 8, 21, 42) THEN ticket_id ELSE NULL END) AS buytickets,
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


/*    status AS (

)*/

SELECT *
FROM funnel
LEFT JOIN source ON funnel.date = source.date
ORDER BY funnel.date DESC
;