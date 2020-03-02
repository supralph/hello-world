SELECT
DATE(appointment_created_at) AS appointment_date,
COUNT(DISTINCT CASE WHEN appointment_id >= 1 THEN ticket_id ELSE NULL END) AS tickets_appointment,
COUNT(DISTINCT CASE WHEN appointment_type_id = 1 THEN ticket_id ELSE NULL END) AS ticket_inspection_appointment,
COUNT(DISTINCT CASE WHEN appointment_type_id = 2 THEN ticket_id ELSE NULL END) AS ticket_meetup_appointment,
COUNT(DISTINCT CASE WHEN appointment_type_id = 3 THEN ticket_id ELSE NULL END) AS ticket_workshop_appointment,
COUNT(DISTINCT CASE WHEN appointment_type_id = 4 THEN ticket_id ELSE NULL END) AS ticket_verification_appointment,
COUNT(DISTINCT CASE WHEN appointment_type_id = 5 THEN ticket_id ELSE NULL END) AS ticket_viewing_appointment,
COUNT(DISTINCT CASE WHEN appointment_type_id = 19 THEN ticket_id ELSE NULL END) AS ticket_handover_appointment
FROM full_tickets
INNER JOIN base_appointments ON base_appointments.appointable_id = full_tickets.ticket_id
WHERE
appointable_type = 'App\Modules\Ticket\Models\Ticket' AND
ticket_country_id = 1 AND
ticket_created_at_local >= '2019-01-01'
GROUP BY DATE(appointment_created_at)