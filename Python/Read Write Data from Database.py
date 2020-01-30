import pandas as pd
import sqlalchemy

engine_in = sqlalchemy.create_engine('mysql+pymysql://trustylabs:4knanbBrACJpjboAKbyXMVhX@wholesale-rr.cyij8crywzth.ap-southeast-1.rds.amazonaws.com/dealer')
engine_out = sqlalchemy.create_engine('postgresql://jay_carro:Carro123!@localhost/jay_test')
query = '''
    SELECT
	t.id AS ticket_id,
	DATE(date_add(t.created_at, INTERVAL 8 HOUR)) AS ticket_created_at,
	date_add(t.created_at, INTERVAL 8 HOUR) AS ticket_created_time_at,
	IF(tc.id IN (1,2,3,18,19,93), 1, 0) AS sell_tickets,
	IF(tc.id IN (79,80), 1, 0) AS subs_tickets,
	IF(tc.id IN (97), 1, 0) AS trade_in_tickets, 
	tc.id AS context_id,
	tc.display_name AS ticket_context,
	CASE WHEN tc.id IN (1,2,3,18,19,93) THEN "Sell"
	WHEN tc.id IN (79,80) THEN "Subscription"
	WHEN tc.id IN (4,5,9, 94, 21) THEN "Buy"
	WHEN tc.id IN (10) THEN "COE Renewal"
	WHEN tc.id IN (33) THEN "Contact"
	WHEN tc.id IN (12,13) THEN "Carro General Enquiry"
	WHEN tc.id IN (32) THEN "Genie General Enquiry"
	WHEN tc.id IN (29,30) THEN "Insurance"
	WHEN tc.id IN (26) THEN "Lease"
	WHEN tc.id IN (28) THEN "Genie Loan"
	WHEN tc.id IN (11) THEN "Used Car Loan"
	WHEN tc.id IN (82) THEN "LTO"
	WHEN tc.id IN (97) THEN "Trade In"
	WHEN tc.id IN (20,23) THEN "Workshop Quote"
	ELSE "Unkown" END AS ticket_type,
	s.id AS status_id,
	s.display_name AS ticket_status,
	CASE WHEN s.id = 95 THEN t.id
	ELSE NULL END AS new_ticket_id,
	c.name AS username,
	c.phone AS userphone,
	c.email AS usermail,
	comms_summary.incoming_created_at,
	comms_summary.outgoing_created_at,
	comms_summary.incoming_count,
	comms_summary.outgoing_count,
	CASE WHEN comms_summary.outgoing_created_at IS NULL THEN -11111 ELSE TIMESTAMPDIFF(minute, comms_summary.incoming_created_at, comms_summary.outgoing_created_at) END AS response_duration,
	CASE 
		WHEN comms_summary.outgoing_created_at IS NULL OR TIMESTAMPDIFF(minute, comms_summary.incoming_created_at, comms_summary.outgoing_created_at) < 0 THEN 'Awaiting Response' 
		WHEN (comms_summary.incoming_created_at IS NOT NULL AND TIMESTAMPDIFF(minute, comms_summary.incoming_created_at, comms_summary.outgoing_created_at) <= 60) OR
			((HOUR(comms_summary.incoming_created_at) >= 19 OR HOUR(comms_summary.incoming_created_at) < 9) AND
			HOUR(comms_summary.outgoing_created_at) < 10 AND
			TIMESTAMPDIFF(HOUR, comms_summary.incoming_created_at, comms_summary.outgoing_created_at) < 24) THEN 'Responded within 1 hour'
		WHEN comms_summary.incoming_created_at IS NOT NULL AND TIMESTAMPDIFF(minute, comms_summary.incoming_created_at, comms_summary.outgoing_created_at) > 60 THEN 'Responded after 1 hour'
		WHEN (comms_summary.incoming_created_at IS NULL AND TIMESTAMPDIFF(minute, date_add(t.created_at, INTERVAL 8 HOUR), comms_summary.outgoing_created_at) <= 60) OR
			 (comms_summary.incoming_created_at IS NULL AND 
			 (HOUR(date_add(t.created_at, INTERVAL 8 HOUR)) >= 19 OR HOUR(date_add(t.created_at, INTERVAL 8 HOUR)) < 9) AND
			HOUR(comms_summary.outgoing_created_at) < 10 AND
			TIMESTAMPDIFF(HOUR, date_add(t.created_at, INTERVAL 8 HOUR), comms_summary.outgoing_created_at) < 24) THEN 'Responded within 1 hour'
		WHEN comms_summary.incoming_created_at IS NULL AND TIMESTAMPDIFF(minute, date_add(t.created_at, INTERVAL 8 HOUR), comms_summary.outgoing_created_at) > 60 THEN 'Responded after 1 hour'
	END AS response_status 
FROM tickets AS t
LEFT JOIN contacts AS c ON t.contact_id = c.id
LEFT JOIN ticket_contexts AS tc ON tc.id = t.context_id
LEFT JOIN statuses AS s ON s.id = t.status_id
LEFT JOIN
    (SELECT communicable_id AS ticket_id, 
	MAX(CASE WHEN direction = 'incoming' THEN DATE_ADD(created_at, INTERVAL 8 HOUR) ELSE NULL END) AS incoming_created_at,
	MAX(CASE WHEN direction = 'outgoing' THEN DATE_ADD(created_at, INTERVAL 8 HOUR) ELSE NULL END) AS outgoing_created_at,
	COUNT(CASE WHEN direction = 'incoming' THEN DATE_ADD(created_at, INTERVAL 8 HOUR) ELSE NULL END) AS incoming_count,
	COUNT(CASE WHEN direction = 'outgoing' THEN DATE_ADD(created_at, INTERVAL 8 HOUR) ELSE NULL END) AS outgoing_count
	FROM communications
	WHERE DATE(created_at) >= '2019-08-01' AND communicable_type = 'App\\Modules\\Ticket\\Models\\Ticket' AND type != 'outgoing'
	GROUP BY communicable_id
    ) comms_summary
ON t.id = comms_summary.ticket_id
WHERE
	DATE(date_add(t.created_at, INTERVAL 8 HOUR)) >= "2019-01-01" AND
	t.deleted_at IS NULL AND
	t.country_id = 1
ORDER BY ticket_created_time_at DESC;
    '''

df = pd.read_sql_query(query, engine_in)

df.to_sql(
    name = 'test_table',
    con = engine_out,
    index = False,
    if_exists = 'replace'
)