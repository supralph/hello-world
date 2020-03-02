SELECT
DATE(discussion_created_at) AS discuss_date,
COUNT(DISTINCT CASE WHEN discussion_id >= 1 THEN ticket_id ELSE NULL END) AS tickets_discuss
FROM full_tickets
INNER JOIN base_discussions ON base_discussions.discussable_id = full_tickets.ticket_id
WHERE
discussable_type = 'App\Modules\Ticket\Models\Ticket' AND
ticket_country_id = 1 AND
ticket_created_at_local >= '2019-01-01'
GROUP BY DATE(discussion_created_at)

