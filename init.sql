CREATE TABLE adminPanel (
    admin_id uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    PRIMARY KEY (admin_id)
);


CREATE TABLE producers (
    producer_id uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    firstName VARCHAR NOT NULL,
    lastName VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    PRIMARY KEY (producer_id)
);


CREATE TABLE scriptwriter (
    producer_id uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    firstName VARCHAR NOT NULL,
    lastName VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    PRIMARY KEY (producer_id)
);

CREATE TABLE producerDetails (
    producer_id VARCHAR NOT NULL,
    companyName VARCHAR NOT NULL,
    experience VARCHAR NOT NULL,
    noOfProduced VARCHAR NOT NULL,
    address VARCHAR NOT NULL,
    country VARCHAR NOT NULL,
    FOREIGN KEY (producer_id),
    REFRENCES producers(producer_id)
);

