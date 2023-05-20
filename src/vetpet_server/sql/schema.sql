
CREATE TABLE IF NOT EXISTS users(
    emailid  VARCHAR PRIMARY KEY,
    role VARCHAR -- owner/vet
);

CREATE TABLE IF NOT EXISTS otpstore(
    emailid VARCHAR PRIMARY KEY,
    otp INTEGER,
    request_time TIMESTAMP,
    attempts INTEGER DEFAULT 5,
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
    state VARCHAR,
    FOREIGN KEY(emailid) references users(emailid)
);

CREATE TABLE IF NOT EXISTS pet (
    pet_id SERIAL PRIMARY KEY,
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
    name VARCHAR,
    emailid VARCHAR PRIMARY KEY,
    phone_number VARCHAR,
    -- clinic_id INTEGER,
    working_time VARCHAR,
    state VARCHAR,
    FOREIGN KEY(emailid) references users(emailid)
    -- FOREIGN KEY(clinic_id) references clinic(clinic_id)
);

CREATE TABLE IF NOT EXISTS appointment (
    appointment_id INTEGER PRIMARY KEY,
    pet_id INTEGER,
    vetid VARCHAR,
    appointment_time TIMESTAMP,
    FOREIGN KEY(pet_id) references pet(pet_id) ON DELETE CASCADE,
    FOREIGN KEY(vetid) references vet(emailid)
);

CREATE TABLE IF NOT EXISTS history_type (
    type VARCHAR PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS history (
    id SERIAL,
    pet_id INTEGER,
    name VARCHAR,
    description VARCHAR,
    date DATE,
    type VARCHAR,
    file_name VARCHAR,
    file_data BYTEA,
    PRIMARY KEY(id, pet_id),
    FOREIGN KEY(pet_id) references pet(pet_id) ON DELETE CASCADE,
    FOREIGN KEY(type) references history_type(type)
);

CREATE TABLE IF NOT EXISTS connections (
    pet_id INTEGER,
    vet_id VARCHAR,
    approved BOOLEAN,
    PRIMARY KEY(pet_id, vet_id),
    FOREIGN KEY(pet_id) references pet(pet_id) ON DELETE CASCADE,
    FOREIGN KEY(vet_id) references vet(emailid)
);

CREATE TABLE IF NOT EXISTS message (
    id SERIAL PRIMARY KEY,
    text VARCHAR,
    from_id VARCHAR,
    to_id VARCHAR,
    time TIMESTAMP default current_timestamp,
    FOREIGN KEY(from_id) references users(emailid),
    FOREIGN KEY(to_id) references users(emailid)
);
