SELECT
tickets.date as funnel_date,
tickets_created,
ticket_inventories_created,
same_day_ticket_inventories_created,
ticket_auctions_created,
same_day_ticket_auctions_created,
same_day_ticket_auctions_started,
sell_ticket_successful,
subscription_ticket_successful
FROM
    (
    SELECT
    DATE(ticket_created_at_local) AS date,
    COUNT(DISTINCT ticket_id) AS tickets_created
    FROM full_tickets
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2019-01-01'
    GROUP BY DATE(ticket_created_at_local)
    ) tickets
LEFT JOIN
    (
    SELECT
    DATE(inventory_created_at_local) AS date,
    COUNT(DISTINCT CASE WHEN inventory_id >= 1 THEN ticket_id ELSE NULL END) AS ticket_inventories_created,
    COUNT(DISTINCT CASE WHEN (DATE(ticket_created_at_local) = DATE(inventory_created_at_local)) THEN ticket_id ELSE NULL END) AS same_day_ticket_inventories_created
    FROM staging_tickets_inventories
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2019-01-01'
    GROUP BY DATE(inventory_created_at_local)
    ) inventories ON tickets.date = inventories.date
LEFT JOIN
    (
    SELECT
    DATE(auction_created_at_local) AS date,
    COUNT(DISTINCT CASE WHEN auction_id >= 1 THEN ticket_id ELSE NULL END) AS ticket_auctions_created,
    COUNT(DISTINCT CASE WHEN (DATE(ticket_created_at_local) = DATE(auction_created_at_local)) THEN ticket_id ELSE NULL END) AS same_day_ticket_auctions_created,
    COUNT(DISTINCT CASE WHEN (DATE(ticket_created_at_local) = DATE(auction_start_at_local)) THEN ticket_id ELSE NULL END) AS same_day_ticket_auctions_started,
    COUNT(DISTINCT CASE WHEN auction_status_id IN (18,26,27) THEN ticket_id ELSE NULL END) AS sell_ticket_successful,
    COUNT(DISTINCT CASE WHEN auction_status_id IN (110) THEN ticket_id ELSE NULL END) AS subscription_ticket_successful
    FROM staging_tickets_inventories
    LEFT JOIN base_auction_inventory ON staging_tickets_inventories.inventory_id = base_auction_inventory.auction_inventory_inventory_id
    LEFT JOIN full_auctions ON base_auction_inventory.auction_inventory_auction_id = full_auctions.auction_id
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2019-01-01'
    GROUP BY DATE(auction_created_at_local)
    ) auctions ON tickets.date = auctions.date
ORDER BY tickets.date DESC