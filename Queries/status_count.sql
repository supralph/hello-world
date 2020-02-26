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
    new_status_id,
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