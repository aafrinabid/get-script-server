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
    is_deleted BOOLEAN NOT NULL,
    PRIMARY KEY (producer_id)
);




CREATE TABLE scriptwriter (
    scriptwriter_id uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    firstName VARCHAR NOT NULL,
    lastName VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    PRIMARY KEY (scriptwriter_id)
);

CREATE TABLE producerDetails (
    producer_id uuid,
    companyName VARCHAR NOT NULL,
    experience VARCHAR NOT NULL,
    noOfProduced VARCHAR NOT NULL,
    address VARCHAR NOT NULL,
    country VARCHAR NOT NULL,
    FOREIGN KEY (producer_id),
    REFERENCES producers(producer_id)
);

CREATE TABLE scripts(
    scriptwriter_id uuid,
    script_id uuid DEFAULT uuid_generate_v4 (),
    is_deleted BOOLEAN NOT NULL,
    PRIMARY KEY (script_id)
    FOREIGN KEY (scriptwriter_id)
    REFERENCES scriptwriter(scriptwriter_id)

);

CREATE TABLE script_detail(
    script_id uuid,
    script_title VARCHAR NOT NULL,
    entertainment VARCHAR NOT NULL,
    script_type VARCHAR NOT NULL,
    genres TEXT[scrip] NOT NULL,
    languages VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    FOREIGN KEY (script_id)
    REFERENCES scripts(script_id)



);

CREATE TABLE script_pitch(
    script_id uuid,
    the_origin VARCHAR NOT NULL,
    human_hook VARCHAR NOT NULL,
    desires VARCHAR NOT NULL,
   obstacles VARCHAR NOT NULL,
    highlights VARCHAR NOT NULL,
   open_road VARCHAR NOT NULL,
   is_deleted BOOLEAN NOT NULL,
   FOREIGN KEY (script_id)
   REFERENCES scripts(script_id)



);

CREATE TABLE script_media(
    script_id uuid,
    script_pdf_url VARCHAR NOT NULL,
    script_poster VARCHAR NOT NULL,
    script_mini_poster VARCHAR NOT NULL,
    script_video VARCHAR,  
    FOREIGN KEY (script_id)
    REFERENCES scripts(script_id)
 


);


CREATE TABLE message(
  message_id uuid,
  reciever_id uuid,
  updated_time VARCHAR NOT NULL,
  FOREIGN KEY (message_id)
   REFERENCES scriptwriter(scriptwriter_id)
   FOREIGN KEY(reciever_id)
   REFERENCES scriptwriter(scriptwriter_id)

)

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    firstName VARCHAR NOT NULL,
    lastName VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    TYPE VARCHAR NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE messages(
  message_id uuid,
  reciever_id uuid,
  updated_time VARCHAR NOT NULL,
  FOREIGN KEY (message_id)
   REFERENCES users(id)
   FOREIGN KEY(reciever_id)
   REFERENCES users(id)

)


CREATE TABLE script(
    scriptwriter_id uuid,
    script_id uuid DEFAULT uuid_generate_v4 (),
    featured BOOLEAN NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    PRIMARY KEY (script_id)
    FOREIGN KEY (scriptwriter_id)
    REFERENCES users(id)

);


CREATE TABLE msg(
  message_id uuid DEFAULT uuid_generate_v4 (),
  sender_id uuid,
  reciever_id uuid,
  updated_time VARCHAR NOT NULL,
  last_msg VARCHAR NOT NULL,
  PRIMARY KEY (message_id)
   FOREIGN KEY (sender_id)
   REFERENCES users(id)
   FOREIGN KEY(reciever_id)
   REFERENCES users(id)

)

CREATE TABLE payment(
    script_id uuid,
    method VARCHAR NOT NULL
    FOREIGN KEY (script_id)
    REFERENCES script(script_id)   
)


CREATE TABLE paytm(
    TXNID VARCHAR NOT NULL,
    BANKTXNID VARCHAR ,
    STATUS VARCHAR,
    ORDERID uuid,
    TXNAMOUNT VARCHAR ,
    TXNTYPE VARCHAR,
    GATEWAYNAME VARCHAR,
    RESPCODE VARCHAR,
    RESPMSG VARCHAR ,
    BANKNAME VARCHAR,
    MID VARCHAR,
    PAYMENTMODE VARCHAR,
    REFUNDAMT VARCHAR,
    TXNDATE VARCHAR,
    PRIMARY KEY (TXNID),
    FOREIGN KEY (ORDERID)
   REFERENCES script(script_id)


)

CREATE TABLE script_details(
    script_id uuid,
    script_title VARCHAR NOT NULL,
    entertainment VARCHAR NOT NULL,
    script_type VARCHAR NOT NULL,
    genres TEXT[] NOT NULL,
    languages VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    FOREIGN KEY (script_id)
    REFERENCES script(script_id)



);

CREATE TABLE script_pitch_table(
    script_id uuid,
    the_origin VARCHAR NOT NULL,
    human_hook VARCHAR NOT NULL,
    desires VARCHAR NOT NULL,
   obstacles VARCHAR NOT NULL,
    highlights VARCHAR NOT NULL,
   open_road VARCHAR NOT NULL,
   is_deleted BOOLEAN NOT NULL,
   FOREIGN KEY (script_id)
   REFERENCES script(script_id)



);

CREATE TABLE script_medias(
    script_id uuid,
    script_pdf_url VARCHAR NOT NULL,
    script_poster VARCHAR NOT NULL,
    script_mini_poster VARCHAR NOT NULL,
    script_video VARCHAR,  
    FOREIGN KEY (script_id)
    REFERENCES script(script_id)
 


);


CREATE TABLE stripe(
    payment_intent_id VARCHAR,
    amount VARCHAR,
    currency VARCHAR,
    customer_id VARCHAR,
    status VARCHAR,
    orderid uuid,
    payment_method VARCHAR,
    email VARCHAR,
    client_secret_key VARCHAR,
    PRIMARY KEY (payment_intent_id),
    FOREIGN KEY (orderid)
   REFERENCES script(script_id)


)


CREATE TABLE stripe_charges(
    orderid uuid,
    charge_id VARCHAR,
    paid BOOLEAN,
    txnid VARCHAR,
    receipt_url VARCHAR,
    PRIMARY KEY (charge_id),
    FOREIGN KEY (orderid)
    REFERENCES script(script_id)



);





TXNID: '20220806111212800110168630503941675',
  BANKTXNID: '19839495930',
  ORDERID: '80cc1818-4012-4aa4-a2fe-0d363c88bb3f',
  TXNAMOUNT: '500.00',
  STATUS: 'TXN_SUCCESS',
  TXNTYPE: 'SALE',
  GATEWAYNAME: 'SBI',
  RESPCODE: '01',
  RESPMSG: 'Txn Success',
  BANKNAME: 'State Bank of India',
  MID: 'bjywcZ23080149756724',
  PAYMENTMODE: 'NB',
  REFUNDAMT: '0.00',
  TXNDATE: '2022-08-06 12:26:18.0'

-- CREATE TABLE lastmsg (
--     message_id uuid DEFAULT uuid_generate_v4 (),
--     sender_id  
-- )