-- Schema-only dump for PukkeConnect
-- Generated for portability (no data included)

-- STUDENT USER
CREATE TABLE student_user (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    interests TEXT,
    study_field VARCHAR(100),
    availability VARCHAR(100),
    email_address VARCHAR(150) UNIQUE,
    phone_number VARCHAR(20)
);

-- SOCIETY ADMIN
CREATE TABLE society_admin (
    society_admin_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email_address VARCHAR(150) UNIQUE
);

-- UNIVERSITY ADMIN
CREATE TABLE university_admin (
    university_admin_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email_address VARCHAR(150) UNIQUE
);

-- SOCIETY
CREATE TABLE society (
    society_id SERIAL PRIMARY KEY,
    society_name VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    society_admin_id INT,
    university_admin_id INT,
    CONSTRAINT fk_society_admin FOREIGN KEY (society_admin_id) REFERENCES society_admin(society_admin_id),
    CONSTRAINT fk_society_university_admin FOREIGN KEY (university_admin_id) REFERENCES university_admin(university_admin_id)
);

-- MEMBERSHIP STATUS (Lookup)
CREATE TABLE membership_status (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

-- MEMBERSHIP
CREATE TABLE membership (
    student_id INT NOT NULL,
    society_id INT NOT NULL,
    status_id INT,
    join_date TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (student_id, society_id),
    CONSTRAINT fk_membership_student FOREIGN KEY (student_id) REFERENCES student_user(student_id),
    CONSTRAINT fk_membership_society FOREIGN KEY (society_id) REFERENCES society(society_id),
    CONSTRAINT fk_membership_status FOREIGN KEY (status_id) REFERENCES membership_status(status_id)
);

-- EVENT
CREATE TABLE event (
    event_id SERIAL PRIMARY KEY,
    event_title VARCHAR(200),
    description TEXT,
    datetime TIMESTAMP,
    society_id INT,
    CONSTRAINT fk_event_society FOREIGN KEY (society_id) REFERENCES society(society_id)
);

-- EVENT ATTENDANCE STATUS (Lookup)
CREATE TABLE event_attendance_status (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

-- EVENT ATTENDANCE
CREATE TABLE event_attendance (
    student_id INT NOT NULL,
    event_id INT NOT NULL,
    status_id INT,
    attendance_num INT,
    PRIMARY KEY (student_id, event_id),
    CONSTRAINT fk_event_attendance_student FOREIGN KEY (student_id) REFERENCES student_user(student_id),
    CONSTRAINT fk_event_attendance_event FOREIGN KEY (event_id) REFERENCES event(event_id),
    CONSTRAINT fk_event_attendance_status FOREIGN KEY (status_id) REFERENCES event_attendance_status(status_id)
);

-- EVENT LIKE
CREATE TABLE event_like (
    event_like_id SERIAL PRIMARY KEY,
    student_id INT,
    event_id INT,
    CONSTRAINT fk_event_like_student FOREIGN KEY (student_id) REFERENCES student_user(student_id),
    CONSTRAINT fk_event_like_event FOREIGN KEY (event_id) REFERENCES event(event_id)
);

-- POST
CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    content TEXT,
    description TEXT,
    society_id INT,
    datetime TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_post_society FOREIGN KEY (society_id) REFERENCES society(society_id)
);

-- POST LIKE
CREATE TABLE post_like (
    post_like_id SERIAL PRIMARY KEY,
    student_id INT,
    post_id INT,
    CONSTRAINT fk_post_like_student FOREIGN KEY (student_id) REFERENCES student_user(student_id),
    CONSTRAINT fk_post_like_post FOREIGN KEY (post_id) REFERENCES post(post_id)
);

-- REPORT
CREATE TABLE report (
    report_id SERIAL PRIMARY KEY,
    status VARCHAR(50),
    reason TEXT,
    datetime TIMESTAMP DEFAULT NOW(),
    post_id INT,
    CONSTRAINT fk_report_post FOREIGN KEY (post_id) REFERENCES post(post_id)
);

-- NOTIFICATION TYPE (Lookup)
CREATE TABLE notification_type (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE NOT NULL
);

-- NOTIFICATION
CREATE TABLE notification (
    notification_id SERIAL PRIMARY KEY,
    message TEXT,
    type_id INT,
    seen BOOLEAN DEFAULT FALSE,
    datetime TIMESTAMP DEFAULT NOW(),
    student_id INT,
    CONSTRAINT fk_notification_type FOREIGN KEY (type_id) REFERENCES notification_type(type_id),
    CONSTRAINT fk_notification_student FOREIGN KEY (student_id) REFERENCES student_user(student_id)
);

-- ANNOUNCEMENT
CREATE TABLE announcement (
    announcement_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    description TEXT,
    datetime TIMESTAMP DEFAULT NOW(),
    admin_id INT,
    CONSTRAINT fk_announcement_admin FOREIGN KEY (admin_id) REFERENCES university_admin(university_admin_id)
);

-- QUIZ
CREATE TABLE quiz (
    quiz_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    description TEXT,
    due_time TIMESTAMP,
    society_id INT,
    student_id INT,
    CONSTRAINT fk_quiz_society FOREIGN KEY (society_id) REFERENCES society(society_id),
    CONSTRAINT fk_quiz_student FOREIGN KEY (student_id) REFERENCES student_user(student_id)
);

-- QUIZ RESPONSE
CREATE TABLE quiz_response (
    quiz_response_id SERIAL PRIMARY KEY,
    event_id INT,
    answer_description TEXT,
    datetime TIMESTAMP DEFAULT NOW(),
    quiz_id INT,
    student_id INT,
    CONSTRAINT fk_quiz_response_event FOREIGN KEY (event_id) REFERENCES event(event_id),
    CONSTRAINT fk_quiz_response_quiz FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id),
    CONSTRAINT fk_quiz_response_student FOREIGN KEY (student_id) REFERENCES student_user(student_id)
);
