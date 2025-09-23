--1 Create STUDENT_USER table
CREATE TABLE STUDENT_USER (
    student_number INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    interests TEXT,
    study_field VARCHAR(255),
    availability VARCHAR(255),
    email_address VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(255),
    username VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);


-- Create SOCIETY_ADMIN table
CREATE TABLE SOCIETY_ADMIN (
    society_admin_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Create UNIVERSITY_ADMIN table
CREATE TABLE UNIVERSITY_ADMIN (
    university_admin_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Create SOCIETY table
CREATE TABLE SOCIETY (
    society_id SERIAL PRIMARY KEY,
    society_name VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    society_admin_id INT,
    university_admin_id INT,
    CONSTRAINT fk_society_admin
        FOREIGN KEY (society_admin_id)
        REFERENCES SOCIETY_ADMIN(society_admin_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_university_admin
        FOREIGN KEY (university_admin_id)
        REFERENCES UNIVERSITY_ADMIN(university_admin_id)
        ON DELETE SET NULL
);

-- Create POSTS table
CREATE TABLE POSTS (
    post_id SERIAL PRIMARY KEY,
    description VARCHAR(150),
    content TEXT NOT NULL,
    date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    society_id INT NOT NULL,
    CONSTRAINT fk_post_society
        FOREIGN KEY (society_id)
        REFERENCES SOCIETY(society_id)
        ON DELETE CASCADE
);

-- Create EVENTS table
CREATE TABLE EVENTS (
    event_id SERIAL PRIMARY KEY,
    society_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    event_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_society
        FOREIGN KEY (society_id)
        REFERENCES SOCIETY(society_id)
        ON DELETE CASCADE
);
-- ================================
-- Create EVENT_RSVP table
-- ================================
CREATE TABLE EVENT_RSVP (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL, -- e.g., 'going', 'interested', 'waitlisted'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Foreign keys
    event_id INT NOT NULL,
    student_number INT NOT NULL,

    CONSTRAINT fk_rsvp_event FOREIGN KEY (event_id)
        REFERENCES EVENTS(event_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_rsvp_student FOREIGN KEY (student_number)
        REFERENCES STUDENT_USER(student_number)
        ON DELETE CASCADE,

    CONSTRAINT unique_event_student UNIQUE (event_id, student_number)
);

-- =========================
--2 ALTER TABLES
-- =========================
-- Add a new column
ALTER TABLE STUDENT_USER ADD COLUMN profile_picture VARCHAR(255);

-- Drop an existing column
ALTER TABLE STUDENT_USER DROP COLUMN profile_picture;

-- Modify a column (e.g., change data type)
ALTER TABLE STUDENT_USER ALTER COLUMN phone_number TYPE VARCHAR(20);

-- Add a new foreign key constraint (example: linking POSTS to STUDENT_USER)
ALTER TABLE POSTS
ADD COLUMN created_by INT,
ADD CONSTRAINT fk_post_student FOREIGN KEY (created_by)
REFERENCES STUDENT_USER(student_number)
ON DELETE SET NULL;

-- =========================
--3 DROP TABLES
-- =========================
-- Drop a whole table (deletes all data too)
DROP TABLE IF EXISTS EVENTS CASCADE;
DROP TABLE IF EXISTS POSTS CASCADE;
DROP TABLE IF EXISTS SOCIETY CASCADE;
DROP TABLE IF EXISTS UNIVERSITY_ADMIN CASCADE;
DROP TABLE IF EXISTS SOCIETY_ADMIN CASCADE;
DROP TABLE IF EXISTS STUDENT_USER CASCADE;
-- =========================
--4 INSERT INTO TABLES
-- =========================
-- Insert into STUDENT_USER
INSERT INTO STUDENT_USER (student_number, first_name, last_name, interests, study_field, availability, email_address, phone_number, username, password_hash)
VALUES (2025001, 'Madara', 'Uchiha', 'Tech, Sports', 'Computer Science', 'Weekends', 'MadaraUchiha@gmail.com', '0649583584', 'GhostOfTheUchiha', 'WakeUpToReality');

-- Insert into SOCIETY_ADMIN
INSERT INTO SOCIETY_ADMIN (first_name, last_name, email, username, password_hash)
VALUES ('Hashirama', 'Senju', 'hashiramaSenju@gmail.com', 'TheGodOfShinobi', '1stHokage');

-- Insert into UNIVERSITY_ADMIN
INSERT INTO UNIVERSITY_ADMIN (first_name, last_name, email, username, password_hash)
VALUES ('Jiraiya', 'Sanin', 'JiraiyaLegendarySanin@gmail.com', 'PervySage', 'PerfectWorld');

-- Insert into SOCIETY
INSERT INTO SOCIETY (society_name, description, category, society_admin_id, university_admin_id)
VALUES ('Hidden Lief', 'A society for tech enthusiasts.', 'Technology', 1, 1);

-- Insert into POSTS
INSERT INTO POSTS (description, content, society_id)
VALUES ('Welcome Post', 'Welcome to the Tech Society!', 1);

-- Insert into EVENTS
INSERT INTO EVENTS (society_id, title, description, event_date)
VALUES (1, 'Tech Meetup', 'Monthly gathering for tech discussions.', '2025-09-15 18:00:00');

-- =========================
--5 UPDATE TABLES
-- =========================
-- Update a student’s availability
UPDATE STUDENT_USER
SET availability = 'Weekdays and Weekends'
WHERE student_number = 2025001;

-- Update society description
UPDATE SOCIETY
SET description = 'Updated description of Tech Society'
WHERE society_id = 1;

-- Update post content
UPDATE POSTS
SET content = 'Updated content for the welcome post'
WHERE post_id = 1;

-- Reschedule an event
UPDATE EVENTS
SET event_date = '2025-09-20 19:00:00'
WHERE event_id = 1;
