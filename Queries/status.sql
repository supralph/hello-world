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