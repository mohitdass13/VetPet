
CREATE TABLE IF NOT EXISTS users(
    name VARCHAR,
    emailid  VARCHAR PRIMARY KEY,
    role VARCHAR
);

CREATE TABLE IF NOT EXISTS otpstore(
    emailid VARCHAR PRIMARY KEY,
    otp INTEGER,
    request_time TIMESTAMP,
    FOREIGN KEY(emailid) references users(emailid)
);

CREATE TABLE IF NOT EXISTS logged_in (
    emailid VARCHAR PRIMARY KEY,
    api_key VARCHAR,
    login_time TIMESTAMP,
    FOREIGN KEY(emailid) references users(emailid)
);
CREATE TABLE IF NOT EXISTS owner (
    name VARCHAR,
    emailid VARCHAR PRIMARY KEY,
    phone_number VARCHAR,
    FOREIGN KEY(emailid) references users(emailid)
);

CREATE TABLE IF NOT EXISTS pet (
    pet_id INTEGER PRIMARY KEY,
    name VARCHAR,
    age INTEGER,
    breed VARCHAR,
    weight FLOAT,
    owner_emailid VARCHAR,
    FOREIGN KEY(owner_emailid) references owner(emailid)
);
CREATE TABLE IF NOT EXISTS clinic (
    clinic_id INTEGER PRIMARY KEY,
    name VARCHAR,
    address VARCHAR,
    phone_number INTEGER,
    latitute FLOAT,
    longitude FLOAT
);
CREATE TABLE IF NOT EXISTS vet (
    vetid VARCHAR PRIMARY KEY,
    name VARCHAR,
    emailid VARCHAR,
    phone_number VARCHAR,
    clinic_id INTEGER,
    working_time VARCHAR,
    FOREIGN KEY(emailid) references users(emailid),
    FOREIGN KEY(clinic_id) references clinic(clinic_id)
);


CREATE TABLE IF NOT EXISTS appointment (
    appointment_id INTEGER PRIMARY KEY,
    pet_id INTEGER,
    vetid VARCHAR,
    appointment_time TIMESTAMP,
    FOREIGN KEY(pet_id) references pet(pet_id),
    FOREIGN KEY(vetid) references vet(vetid)
);
