{{ config(materialized='table') }}

WITH

    funnel AS (
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
    FROM {{ref('full_tickets')}}
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2020-01-01'
    GROUP BY DATE(ticket_created_at_local)
    ) tickets
LEFT JOIN
    (
    SELECT
    DATE(inventory_created_at_local) AS date,
    COUNT(DISTINCT CASE WHEN inventory_id >= 1 THEN ticket_id ELSE NULL END) AS ticket_inventories_created,
    COUNT(DISTINCT CASE WHEN (DATE(ticket_created_at_local) = DATE(inventory_created_at_local)) THEN ticket_id ELSE NULL END) AS same_day_ticket_inventories_created
    FROM {{ref('staging_tickets_inventories')}}
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2020-01-01'
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
    FROM {{ref('staging_tickets_inventories')}}
    LEFT JOIN {{ref('base_auction_inventory')}} ON staging_tickets_inventories.inventory_id = base_auction_inventory.auction_inventory_inventory_id
    LEFT JOIN {{ref('full_auctions')}} ON base_auction_inventory.auction_inventory_auction_id = full_auctions.auction_id
    WHERE
    ticket_country_id = 1 AND
    DATE(ticket_created_at_local) >= '2020-01-01'
    GROUP BY DATE(auction_created_at_local)
    ) auctions ON tickets.date = auctions.date
ORDER BY tickets.date DESC
),

    source AS (
SELECT
DATE(ticket_created_at_local) AS source_date,
COUNT(DISTINCT CASE WHEN ticket_creator_id >= 1 THEN ticket_id ELSE NULL END) AS  wholesale_created_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'facebook' THEN ticket_id ELSE NULL END) AS facebook_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = 'google' THEN ticket_id ELSE NULL END) AS google_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IN ('instagram','Instagram') THEN ticket_id ELSE NULL END) AS instagram_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source = '101_Carro_General' THEN ticket_id ELSE NULL END) AS direct_source,
COUNT(DISTINCT CASE WHEN ticket_utm_source IS NULL THEN ticket_id ELSE NULL END) AS carro_source
FROM {{ref('full_tickets')}}
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),

    context AS (
SELECT
DATE(ticket_created_at_local) AS context_date,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (1,2,3,18,19,93) THEN ticket_id ELSE NULL END) AS sell_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (79,80) THEN ticket_id ELSE NULL END) AS subscription_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (9, 6, 7, 4, 38, 5, 94, 8, 21, 42) THEN ticket_id ELSE NULL END) AS buy_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (10) THEN ticket_id ELSE NULL END) AS coe_renewal_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (33) THEN ticket_id ELSE NULL END) AS contact_system_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (97) THEN ticket_id ELSE NULL END) AS trade_in_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (24) THEN ticket_id ELSE NULL END) AS export_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (12,13) THEN ticket_id ELSE NULL END) AS carro_enquiry_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (31,32) THEN ticket_id ELSE NULL END) AS genie_enquiry_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (29,30) THEN ticket_id ELSE NULL END) AS insurance_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (25,26) THEN ticket_id ELSE NULL END) AS lease_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (11,28) THEN ticket_id ELSE NULL END) AS loan_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (82) THEN ticket_id ELSE NULL END) AS lto_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (20) THEN ticket_id ELSE NULL END) AS warranty_context,
COUNT(DISTINCT CASE WHEN ticket_context_id IN (22,23) THEN ticket_id ELSE NULL END) AS workshop_context
FROM {{ref('full_tickets')}}
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),

    plan AS (
SELECT
DATE(ticket_created_at_local) AS plan_date,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'daily' THEN ticket_id ELSE NULL END) AS daily_plan,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'roomy' THEN ticket_id ELSE NULL END) AS roomy_plan,
COUNT(DISTINCT CASE WHEN ticket_additional_data_interested_plan = 'fancy' THEN ticket_id ELSE NULL END) AS fancy_plan
FROM {{ref('full_tickets')}}
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),

    photo AS (
SELECT
DATE(ticket_created_at_local) AS photo_date,
COUNT(DISTINCT CASE WHEN file_photos_count >= 1 THEN ticket_id ELSE NULL END) AS tickets_with_photos
FROM {{ref('staging_tickets_inventories')}}
LEFT JOIN {{ref('base_files')}} ON staging_tickets_inventories.ticket_id = base_files.file_model_id
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
),


    status AS (
SELECT
DATE(audit_created_at_local) AS status_date,
COUNT(DISTINCT CASE WHEN new_status_id = 95 THEN ticket_id ELSE NULL END) AS new_status,
COUNT(DISTINCT CASE WHEN new_status_id = 96 THEN ticket_id ELSE NULL END) AS assigned_status,
COUNT(DISTINCT CASE WHEN new_status_id = 97 THEN ticket_id ELSE NULL END) AS fail_contact_status,
COUNT(DISTINCT CASE WHEN new_status_id = 98 THEN ticket_id ELSE NULL END) AS contacted_status,
COUNT(DISTINCT CASE WHEN new_status_id = 99 THEN ticket_id ELSE NULL END) AS pending_status,
COUNT(DISTINCT CASE WHEN new_status_id = 100 THEN ticket_id ELSE NULL END) AS viewing_scheduled_status,
COUNT(DISTINCT CASE WHEN new_status_id = 101 THEN ticket_id ELSE NULL END) AS collection_scheduled_status,
COUNT(DISTINCT CASE WHEN new_status_id = 102 THEN ticket_id ELSE NULL END) AS meetup_scheduled_status,
COUNT(DISTINCT CASE WHEN new_status_id = 103 THEN ticket_id ELSE NULL END) AS listed_status,
COUNT(DISTINCT CASE WHEN new_status_id = 105 THEN ticket_id ELSE NULL END) AS in_auction_status,
COUNT(DISTINCT CASE WHEN new_status_id = 106 THEN ticket_id ELSE NULL END) AS re_auction_status,
COUNT(DISTINCT CASE WHEN new_status_id = 107 THEN ticket_id ELSE NULL END) AS closed_status,
COUNT(DISTINCT CASE WHEN new_status_id = 108 THEN ticket_id ELSE NULL END) AS delisted_status,
COUNT(DISTINCT CASE WHEN new_status_id = 109 THEN ticket_id ELSE NULL END) AS deposit_collected_status,
COUNT(DISTINCT CASE WHEN new_status_id = 110 THEN ticket_id ELSE NULL END) AS subscribed_status,
COUNT(DISTINCT CASE WHEN new_status_id = 111 THEN ticket_id ELSE NULL END) AS to_reassign_status,
COUNT(DISTINCT CASE WHEN new_status_id = 127 THEN ticket_id ELSE NULL END) AS converted_lead_status
FROM
    (
    SELECT
    ticket_id,
    ticket_created_at_local,
    (audits.created_at + INTERVAL '8 hour') AS audit_created_at_local,
    audits.new_status_id

    FROM {{ref('full_tickets')}}
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
),

    closed AS (
SELECT
DATE(ticket_created_at_local) AS closed_date,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 19 THEN ticket_id ELSE NULL END) AS seller_no_interest_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 20 THEN ticket_id ELSE NULL END) AS buyer_no_interest_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 21 THEN ticket_id ELSE NULL END) AS seller_insincere_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 22 THEN ticket_id ELSE NULL END) AS seller_unresponsive_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 23 THEN ticket_id ELSE NULL END) AS buyer_unresponsive_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 24 THEN ticket_id ELSE NULL END) AS buyer_insincere_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 25 THEN ticket_id ELSE NULL END) AS auction_successful_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 26 THEN ticket_id ELSE NULL END) AS auction_failed_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 27 THEN ticket_id ELSE NULL END) AS listing_successful_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 28 THEN ticket_id ELSE NULL END) AS listing_failed_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 29 THEN ticket_id ELSE NULL END) AS spam_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 30 THEN ticket_id ELSE NULL END) AS test_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 31 THEN ticket_id ELSE NULL END) AS enquiry_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 32 THEN ticket_id ELSE NULL END) AS bought_by_carro_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 33 THEN ticket_id ELSE NULL END) AS sold_by_carro_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 34 THEN ticket_id ELSE NULL END) AS bought_outside_carro_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 35 THEN ticket_id ELSE NULL END) AS rejected_by_carro_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 36 THEN ticket_id ELSE NULL END) AS seller_reject_carro_offer_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 37 THEN ticket_id ELSE NULL END) AS buyer_seller_disagree_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 38 THEN ticket_id ELSE NULL END) AS buyer_reject_seller_offer_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 39 THEN ticket_id ELSE NULL END) AS bought_from_carro_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 40 THEN ticket_id ELSE NULL END) AS seller_sold_outside_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 41 THEN ticket_id ELSE NULL END) AS car_no_stock_closed,
COUNT(DISTINCT CASE WHEN ticket_reason_id = 42 THEN ticket_id ELSE NULL END) AS archived_closed
FROM {{ref('full_tickets')}}
WHERE
ticket_country_id = 1 AND
DATE(ticket_created_at_local) >= '2020-01-01'
GROUP BY DATE(ticket_created_at_local)
)


SELECT *
FROM funnel
LEFT JOIN source ON funnel.funnel_date = source.source_date
LEFT JOIN context ON funnel.funnel_date = context.context_date
LEFT JOIN plan ON funnel.funnel_date = plan.plan_date
LEFT JOIN photo ON funnel.funnel_date = photo.photo_date
LEFT JOIN status ON funnel.funnel_date = status.status_date
LEFT JOIN closed on funnel.funnel_date = closed.closed_date
ORDER BY funnel.funnel_date DESC
