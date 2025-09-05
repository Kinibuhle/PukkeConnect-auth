CREAE DATABASE pukkeconnect;
\c pukkeconnect;// connect to the database
CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR(100) NOT NULL,
    