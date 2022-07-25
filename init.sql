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
  CREATE TABLE onlineusers(
    user_id uuid,
    online_status BOOLEAN,
    FOREIGN KEY(user_id)
    REFERENCES users(id)
  )

-- CREATE TABLE lastmsg (
--     message_id uuid DEFAULT uuid_generate_v4 (),
--     sender_id  
-- )