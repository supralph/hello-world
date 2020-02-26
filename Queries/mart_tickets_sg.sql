WITH

    funnel AS (
SELECT
DATE(ticket_created_at_local) AS date,
COUNT(DISTINCT ticket_id) AS total_tickets_created,
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
),

    context AS (
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
),

    plan AS (
SELECT
DATE(ticket_created_at_local) AS date,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'daily' THEN ticket_id ELSE NULL END) AS daily_plan_tickets,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'roomy' THEN ticket_id ELSE NULL END) AS roomy_plan_tickets,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'fancy' THEN ticket_id ELSE NULL END) AS fancy_plan_tickets
FROM full_tickets
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),

    status AS (
SELECT
DATE(audit_created_at_local) AS date,
COUNT(DISTINCT CASE WHEN new_status_id = 95 THEN ticket_id ELSE NULL END) AS new_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 96 THEN ticket_id ELSE NULL END) AS assigned_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 97 THEN ticket_id ELSE NULL END) AS fail_contact_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 98 THEN ticket_id ELSE NULL END) AS contacted_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 99 THEN ticket_id ELSE NULL END) AS pending_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 100 THEN ticket_id ELSE NULL END) AS viewing_scheduled_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 101 THEN ticket_id ELSE NULL END) AS collection_scheduled_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 102 THEN ticket_id ELSE NULL END) AS meetup_scheduled_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 103 THEN ticket_id ELSE NULL END) AS listed_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 105 THEN ticket_id ELSE NULL END) AS in_auction_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 106 THEN ticket_id ELSE NULL END) AS re_auction_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 107 THEN ticket_id ELSE NULL END) AS closed_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 108 THEN ticket_id ELSE NULL END) AS delisted_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 109 THEN ticket_id ELSE NULL END) AS deposit_collected_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 110 THEN ticket_id ELSE NULL END) AS subscribed_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 111 THEN ticket_id ELSE NULL END) AS to_reassign_tickets,
COUNT(DISTINCT CASE WHEN new_status_id = 127 THEN ticket_id ELSE NULL END) AS converted_lead_tickets
FROM
    (
    SELECT
    ticket_id,
    ticket_created_at_local,
    (audits.created_at + INTERVAL '8 hour') AS audit_created_at_local,
    audits.new_status_id

    FROM dbt_test_schema.full_tickets
    INNER JOIN
        (
        SELECT
        id AS audit_id,
        created_at,
        CAST(new_status_id AS INT) AS new_status_id,
        last.auditable_id
        FROM wholesalerr.audits_tickets_status_view
        INNER JOIN
            (
            SELECT
            auditable_id,
            MAX(id) AS audit_id
            FROM wholesalerr.audits_tickets_status_view
            GROUP BY auditable_id
            ) AS last ON audits_tickets_status_view.auditable_id = last.auditable_id
        ) audits ON full_tickets.ticket_id = audits.auditable_id
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2020-01-01'
    ) AS status
GROUP BY DATE(audit_created_at_local)
)


SELECT *
FROM funnel
LEFT JOIN source ON funnel.date = source.date
LEFT JOIN context ON funnel.date = context.date
LEFT JOIN plan ON funnel.date = plan.date
LEFT JOIN status ON funnel.date = status.date
ORDER BY funnel.date DESC
;