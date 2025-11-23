-- Created a new table with snake_case column name to copy the old table to the new table

CREATE TABLE crypto_support_tickets_clean (
    ticket_id               INT PRIMARY KEY,
    ticket_date             DATE NOT NULL,
    channel_type            VARCHAR(10) NOT NULL,         -- 'chat' / 'email'
    agent_name              VARCHAR(100) NOT NULL,
    created_time            TIME NOT NULL,
    end_time                TIME NOT NULL,
    resolution_time_min     INT NOT NULL,                 -- e.g. 76
    first_response_time_min INT NOT NULL,                 -- e.g. 10
    csat_score              TINYINT NOT NULL,
    sla_met                 TINYINT(1) NOT NULL,          -- 1 = Yes, 0 = No
    issue_severity          VARCHAR(10) NOT NULL,         -- Low / Medium / High / Urgent
    escalated               TINYINT(1) NOT NULL,          -- 1 = Yes, 0 = No
    cor                     VARCHAR(3) NOT NULL,          -- country code
    user_type               VARCHAR(20) NOT NULL,         -- Retail / VIP / etc.
    main_category           VARCHAR(50) NOT NULL,
    sub_category            VARCHAR(100) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
INSERT INTO crypto_support_tickets_clean (
    ticket_id,
    ticket_date,
    channel_type,
    agent_name,
    created_time,
    end_time,
    resolution_time_min,
    first_response_time_min,
    csat_score,
    sla_met,
    issue_severity,
    escalated,
    cor,
    user_type,
    main_category,
    sub_category
)
SELECT
	ticket_id  AS ticket_id,
    CAST(`Date` AS DATE) AS ticket_date,
    `type` AS channel_type,
    `agent name` AS agent_name,
    CAST(`created time` AS TIME) AS created_time,
    CAST(`end time` AS TIME) AS end_time,
    CAST(REPLACE(`resolution time`, ' min', '') AS UNSIGNED) AS resolution_time_min,
    CAST(`First Response Time (min)` AS UNSIGNED) AS first_response_time_min,
    CAST(`csat score` AS UNSIGNED) AS csat_score,
    CASE WHEN `SLA Met` = 'Yes' THEN 1 ELSE 0 END AS sla_met,
    `Issue Severity` AS issue_severity,
    CASE WHEN `Escalated` = 'Yes' THEN 1 ELSE 0 END AS escalated,
    `COR` AS cor,
    `User Type` AS user_type,
    `main category` AS main_category,
    `sub category` AS sub_category
FROM crypto_cs_tickets;

DROP TABLE crypto_cs_tickets;

-- ------------------------------------------------------------------------------------------ --
SELECT * FROM crypto_support_tickets_clean;
-- ------------------------------------------------------------------------------------------ --

-- What is the percentage of total ticket (Chat & email) received a good & bad survey?

SELECT	CASE WHEN csat_score <= 3 THEN "bad" ELSE "good" END AS survey,
		COUNT(*) AS total_tickets,
        ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM crypto_support_tickets_clean),2) AS survey_percentage
FROM crypto_support_tickets_clean
GROUP BY CASE WHEN csat_score <= 3 THEN "bad" ELSE "good" END;

-- ------------------------------------------------------------------------------------------ --
/* | good %67.48 | bad 32.53 |
-- ------------------------------------------------------------------------------------------ --



