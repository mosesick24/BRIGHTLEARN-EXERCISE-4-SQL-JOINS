CREATE CATALOG IF NOT EXISTS joins;

CREATE SCHEMA IF NOT EXISTS joins.bl;

-- CREATE TABLE 1: USERS
CREATE TABLE joins.bl.users (
    user_id INT,
    user_name STRING,
    country STRING
);

INSERT INTO joins.bl.users VALUES
(1,'Nomvula','Johannesburg'),
(2,'David','Cape Town'),
(3,'Anele','Durban'),
(4,'Kabelo','Pretoria'),
(5,'Lerato','Port Elizabeth');

SELECT * FROM joins.bl.users;

-- CREATE TABLE 2: PLANS
CREATE TABLE joins.bl.plans (
    plan_id INT,
    plan_name STRING,
    monthly_price INT
);

INSERT INTO joins.bl.plans VALUES
(10,'Basic',79),
(11,'Standard',129),
(12,'Premium',199),
(13,'Family',249),
(14,'Mobile',59);

SELECT * FROM joins.bl.plans;

-- CREATE TABLE 3: SUBSCRIPTIONS
CREATE TABLE joins.bl.subscriptions (
    subscription_id INT,
    user_id INT,
    plan_id INT,
    start_date DATE
);

INSERT INTO joins.bl.subscriptions VALUES
(501,1,10,'2026-01-15'),
(502,2,11,'2026-02-01'),
(503,1,12,'2026-03-10'),
(504,6,11,'2026-03-20'),
(505,3,13,'2026-04-05');

SELECT * FROM joins.bl.subscriptions;

-- CREATE TABLE 4: SHOWS
CREATE TABLE joins.bl.shows (
    show_id INT,
    show_title STRING,
    genre STRING
);

INSERT INTO joins.bl.shows VALUES
(701,'Comedy hour','Comedy'),
(702,'Crime Time','Drama'),
(703,'Tech Tales','Documentary'),
(704,'Cooking Lab','Lifestyle'),
(706,'Wild Earth','Documentary');

SELECT * FROM joins.bl.shows;

-- CREATE TABLE 5: VIEWING SESSIONS
CREATE TABLE joins.bl.viewing_sessions (
    session_id INT,
    user_id INT,
    show_id INT,
    watch_minutes INT
);

INSERT INTO joins.bl.viewing_sessions VALUES
(901,1,701,45),
(902,2,703,30),
(903,1,702,60),
(904,7,701,20),
(905,3,705,90);

SELECT * FROM joins.bl.viewing_sessions;


-- INNER JOIN --

-- Q1: Show every user who has a subscription. Match users to subscriptions.
SELECT A.user_id, A.user_name, B.subscription_id, B.start_date
FROM joins.bl.users AS A
INNER JOIN joins.bl.subscriptions AS B
ON A.user_id = B.user_id;


-- Q2: Show every subscription with its matching plan name and monthly price.
SELECT A.subscription_id, A.user_id, B.plan_name, B.monthly_price
FROM joins.bl.subscriptions AS A
INNER JOIN joins.bl.plans AS B
ON A.plan_id = B.plan_id;


-- Q3: Show every viewing session that has a matching show. Include the show title and genre.
SELECT A.session_id, A.user_id, B.show_title, B.genre, A.watch_minutes
FROM joins.bl.viewing_sessions AS A
INNER JOIN joins.bl.shows AS B
ON A.show_id = B.show_id;


-- Q4: Show every viewing session with the user who watched it. Only show sessions with a matching user.
SELECT A.user_name, A.country, B.session_id, B.show_id, B.watch_minutes
FROM joins.bl.users AS A
INNER JOIN joins.bl.viewing_sessions AS B
ON A.user_id = B.user_id;


-- Q5: Show users along with their subscriptions, the plan name, and the price.
-- Use only users who have both a subscription and a valid plan.
SELECT A.user_name, A.country, C.plan_name, C.monthly_price, B.start_date
FROM joins.bl.users AS A
INNER JOIN joins.bl.subscriptions AS B
ON A.user_id = B.user_id
INNER JOIN joins.bl.plans AS C
ON B.plan_id = C.plan_id;


-- PART B: LEFT JOIN --

-- Q6: Show every user and any subscriptions they have.
-- Users without subscriptions must still appear.
SELECT A.user_id, A.user_name, B.subscription_id, B.start_date
FROM joins.bl.users AS A
LEFT JOIN joins.bl.subscriptions AS B
ON A.user_id = B.user_id;


-- Q7: Show every plan and the subscriptions on it.
-- Plans with no subscribers must still appear.
SELECT A.plan_id, A.plan_name, B.subscription_id, B.user_id
FROM joins.bl.plans AS A
LEFT JOIN joins.bl.subscriptions AS B
ON A.plan_id = B.plan_id;


-- Q8: Show every show and any viewing sessions on it.
-- Shows that were never watched must still appear.
SELECT A.show_id, A.show_title, B.session_id, B.watch_minutes
FROM joins.bl.shows AS A
LEFT JOIN joins.bl.viewing_sessions AS B
ON A.show_id = B.show_id;


-- Q9: Show every viewing session and the user who watched it.
-- Sessions referencing users that do not exist must still appear.
SELECT A.session_id, A.show_id, A.watch_minutes, B.user_id, B.user_name
FROM joins.bl.viewing_sessions AS A
LEFT JOIN joins.bl.users AS B
ON A.user_id = B.user_id;


-- Q10: Show every user, the plan they are on (if any), and the monthly price.
-- Users without a subscription must still appear.
SELECT A.user_name, A.country, C.plan_name, C.monthly_price
FROM joins.bl.users AS A
LEFT JOIN joins.bl.subscriptions AS B
ON A.user_id = B.user_id
LEFT JOIN joins.bl.plans AS C
ON B.plan_id = C.plan_id;


-- PART C: FULL OUTER JOIN --

-- Q11: Show every user and every subscription, including users without subscriptions
-- AND subscriptions referencing users that do not exist.
SELECT A.user_id, A.user_name, B.subscription_id, B.start_date
FROM joins.bl.users AS A
FULL OUTER JOIN joins.bl.subscriptions AS B
ON A.user_id = B.user_id;


-- Q12: Show every plan and every subscription, including plans without subscribers
-- AND any subscription referencing a plan that does not exist.
SELECT A.plan_id, A.plan_name, B.subscription_id, B.user_id
FROM joins.bl.plans AS A
FULL OUTER JOIN joins.bl.subscriptions AS B
ON A.plan_id = B.plan_id;


-- Q13: Show every show and every viewing session, including shows that were never watched
-- AND sessions referencing shows that do not exist.
SELECT A.show_id, A.show_title, B.session_id, B.watch_minutes
FROM joins.bl.shows AS A
FULL OUTER JOIN joins.bl.viewing_sessions AS B
ON A.show_id = B.show_id;


-- Q14: Show every user and every viewing session, including users with no sessions
-- AND sessions referencing users who do not exist.
SELECT A.user_id, A.user_name, B.session_id, B.show_id, B.watch_minutes
FROM joins.bl.users AS A
FULL OUTER JOIN joins.bl.viewing_sessions AS B
ON A.user_id = B.user_id;


-- Q15: Show every user, every subscription, and every plan in one query.
-- Use FULL OUTER JOIN throughout and get all gaps visible at once.
SELECT A.user_id, A.user_name, B.subscription_id, B.plan_id, C.plan_name
FROM joins.bl.users AS A
FULL OUTER JOIN joins.bl.subscriptions AS B
ON A.user_id = B.user_id
FULL OUTER JOIN joins.bl.plans AS C
ON B.plan_id = C.plan_id;
