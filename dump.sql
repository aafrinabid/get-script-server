PGDMP\00\00\00\00\00'\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00z\00\00\00\00\00\00\00\00\00	\00\00\00getscript\00#\00\00\0014.5 (Ubuntu 14.5-0ubuntu0.22.04.1)\00#\00\00\0014.5 (Ubuntu 14.5-0ubuntu0.22.04.1)\00:\00\00\00\00\00\00\00\00\00\00\00\00\00\00\000\00\00\00\000\00\00\00\00ENCODING\00\00\00\00ENCODING\00\00\00\00\00\00\00\00SET client_encoding = 'UTF8';
\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\000\00\00\00\000\00
\00\00\00STDSTRINGS\00
\00\00\00STDSTRINGS\00\00\00\00\00(\00\00\00SET standard_conforming_strings = 'on';
\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\000\00\00\00\000\00
\00\00\00SEARCHPATH\00
\00\00\00SEARCHPATH\00\00\00\00\008\00\00\00SELECT pg_catalog.set_config('search_path', '', false);
\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\001262\00\00\00\0016389\00	\00\00\00getscript\00\00\00\00DATABASE\00\00\00\00\00^\00\00\00CREATE DATABASE getscript WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
\00\00\00\00DROP DATABASE getscript;
\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\003079\00\00\00\0016393\00	\00\00\00uuid-ossp\00	\00\00\00EXTENSION\00\00\00\00\00?\00\00\00CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
\00\00\00\00DROP EXTENSION "uuid-ossp";
\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\000\00\00\00\000\00\00\00\00EXTENSION "uuid-ossp"\00\00\00\00COMMENT\00\00\00\00\00W\00\00\00COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00false\00\00\00\002\00\00\00\00\00\00\00\00\00\00\00\00\D9\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016485\00\00\00\00email_verification\00\00\00\00TABLE\00\00\00\00\00\A5\00\00\00CREATE TABLE public.email_verification (
    users_id uuid,
    token uuid DEFAULT public.uuid_generate_v4(),
    password uuid DEFAULT public.uuid_generate_v4()
);
\00&\00\00\00DROP TABLE public.email_verification;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\002\00\00\00\002\00\00\00\00\00\00\00\00\00\00\00\00\E0\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016680\00\00\00\00episodes\00\00\00\00TABLE\00\00\00\00\00`\00\00\00CREATE TABLE public.episodes (
    script_id uuid,
    episode smallint,
    season smallint
);
\00\00\00\00DROP TABLE public.episodes;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\DD\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016621\00\00\00\00msg\00\00\00\00TABLE\00\00\00\00\00\CA\00\00\00CREATE TABLE public.msg (
    message_id uuid DEFAULT public.uuid_generate_v4(),
    sender_id uuid,
    reciever_id uuid,
    updated_time character varying NOT NULL,
    last_msg character varying
);
\00\00\00\00DROP TABLE public.msg;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\002\00\00\00\00\00\00\00\00\00\00\00\00\DA\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016495\00\00\00\00payment\00\00\00\00TABLE\00\00\00\00\00[\00\00\00CREATE TABLE public.payment (
    script_id uuid,
    method character varying NOT NULL
);
\00\00\00\00DROP TABLE public.payment;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\DB\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016505\00\00\00\00paytm\00\00\00\00TABLE\00\00\00\00\00\D5\00\00CREATE TABLE public.paytm (
    txnid character varying NOT NULL,
    banktxnid character varying,
    status character varying,
    orderid uuid,
    txnamount character varying,
    txntype character varying,
    gatewayname character varying,
    respcode character varying,
    respmsg character varying,
    bankname character varying,
    mid character varying,
    paymentmode character varying,
    refundamt character varying,
    txndate character varying
);
\00\00\00\00DROP TABLE public.paytm;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\DC\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016540\00\00\00\00producerdetails\00\00\00\00TABLE\00\00\00\00\00\00\00CREATE TABLE public.producerdetails (
    producer_id uuid,
    companyname character varying NOT NULL,
    experience character varying NOT NULL,
    noofproduced character varying NOT NULL,
    address character varying NOT NULL,
    country character varying NOT NULL
);
\00#\00\00\00DROP TABLE public.producerdetails;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\DE\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016637\00
\00\00\00saved_scripts\00\00\00\00TABLE\00\00\00\00\00L\00\00\00CREATE TABLE public.saved_scripts (
    user_id uuid,
    script_id uuid
);
\00!\00\00\00DROP TABLE public.saved_scripts;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\D3\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016420\00\00\00\00script\00\00\00\00TABLE\00\00\00\00\00\CA\00\00\00CREATE TABLE public.script (
    scriptwriter_id uuid,
    script_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    featured boolean NOT NULL,
    is_deleted boolean NOT NULL,
    main boolean
);
\00\00\00\00DROP TABLE public.script;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\002\00\00\00\00\00\00\00\00\00\00\00\00\D5\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016441\00\00\00\00script_details\00\00\00\00TABLE\00\00\00\00\00U\00\00CREATE TABLE public.script_details (
    script_id uuid,
    script_title character varying NOT NULL,
    entertainment character varying NOT NULL,
    script_type character varying NOT NULL,
    genres text[] NOT NULL,
    languages character varying NOT NULL,
    description character varying NOT NULL,
    is_deleted boolean NOT NULL
);
\00"\00\00\00DROP TABLE public.script_details;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\D4\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016431\00
\00\00\00script_medias\00\00\00\00TABLE\00\00\00\00\00\00\00CREATE TABLE public.script_medias (
    script_id uuid,
    script_pdf_url character varying NOT NULL,
    script_poster character varying NOT NULL,
    script_mini_poster character varying NOT NULL,
    script_video character varying,
    is_deleted boolean
);
\00!\00\00\00DROP TABLE public.script_medias;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\D6\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016451\00\00\00\00script_pitch_table\00\00\00\00TABLE\00\00\00\00\00\80\00\00CREATE TABLE public.script_pitch_table (
    script_id uuid,
    the_origin character varying NOT NULL,
    human_hook character varying NOT NULL,
    desires character varying NOT NULL,
    obstacles character varying NOT NULL,
    highlights character varying NOT NULL,
    open_road character varying NOT NULL,
    is_deleted boolean NOT NULL,
    "character" character varying
);
\00&\00\00\00DROP TABLE public.script_pitch_table;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\DF\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016667\00\00\00\00series_episodes\00\00\00\00TABLE\00\00\00\00\00U\00\00\00CREATE TABLE public.series_episodes (
    main_script uuid,
    child_script uuid
);
\00#\00\00\00DROP TABLE public.series_episodes;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\D7\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016461\00\00\00\00stripe\00\00\00\00TABLE\00\00\00\00\00N\00\00CREATE TABLE public.stripe (
    payment_intent_id character varying NOT NULL,
    amount character varying,
    currency character varying,
    customer_id character varying,
    status character varying,
    orderid uuid,
    payment_method character varying,
    email character varying,
    client_secret_key character varying
);
\00\00\00\00DROP TABLE public.stripe;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\D8\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016473\00\00\00\00stripe_charges\00\00\00\00TABLE\00\00\00\00\00\B5\00\00\00CREATE TABLE public.stripe_charges (
    orderid uuid,
    charge_id character varying NOT NULL,
    paid boolean,
    txnid character varying,
    receipt_url character varying
);
\00"\00\00\00DROP TABLE public.stripe_charges;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\00\00\00\00\00\00\00\00\00\D2\00\00\00\00\00\00\00\00\00\00\00\001259\00\00\00\0016412\00\00\00\00users\00\00\00\00TABLE\00\00\00\00\00\A1\00\00CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    password character varying,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    status character varying NOT NULL,
    email_verified boolean,
    is_deleted boolean NOT NULL,
    type character varying NOT NULL
);
\00\00\00\00DROP TABLE public.users;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00heap\00\00\00\00postgres\00\00\00\00false\00\00\00\002\00\00\00\00\00\00\00\00\00\00\00\00\F7
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016485\00\00\00\00email_verification\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00G\00\00\00COPY public.email_verification (users_id, token, password) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00217\00\00\00\CBL\00\00\00\00\00\00\00\FE
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016680\00\00\00\00episodes\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00>\00\00\00COPY public.episodes (script_id, episode, season) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00224\00\00\00\EFM\00\00\00\00\00\00\00\FB
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016621\00\00\00\00msg\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00Y\00\00\00COPY public.msg (message_id, sender_id, reciever_id, updated_time, last_msg) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00221\00\00\00P\00\00\00\00\00\00\00\F8
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016495\00\00\00\00payment\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\004\00\00\00COPY public.payment (script_id, method) FROM stdin;
\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00218\00\00\00\D7Q\00\00\00\00\00\00\00\F9
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016505\00\00\00\00paytm\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00\A6\00\00\00COPY public.paytm (txnid, banktxnid, status, orderid, txnamount, txntype, gatewayname, respcode, respmsg, bankname, mid, paymentmode, refundamt, txndate) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00219\00\00\00\EDR\00\00\00\00\00\00\00\FA
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016540\00\00\00\00producerdetails\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00o\00\00\00COPY public.producerdetails (producer_id, companyname, experience, noofproduced, address, country) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00220\00\00\00U\00\00\00\00\00\00\00\FC
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016637\00
\00\00\00saved_scripts\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00;\00\00\00COPY public.saved_scripts (user_id, script_id) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00222\00\00\00$U\00\00\00\00\00\00\00\F1
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016420\00\00\00\00script\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00X\00\00\00COPY public.script (scriptwriter_id, script_id, featured, is_deleted, main) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00211\00\00\00\E8V\00\00\00\00\00\00\00\F3
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016441\00\00\00\00script_details\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00\89\00\00\00COPY public.script_details (script_id, script_title, entertainment, script_type, genres, languages, description, is_deleted) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00213\00\00\00`Z\00\00\00\00\00\00\00\F2
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016431\00
\00\00\00script_medias\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00\00\00\00COPY public.script_medias (script_id, script_pdf_url, script_poster, script_mini_poster, script_video, is_deleted) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00212\00\00\00\C3k\00\00\00\00\00\00\00\F4
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016451\00\00\00\00script_pitch_table\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00\93\00\00\00COPY public.script_pitch_table (script_id, the_origin, human_hook, desires, obstacles, highlights, open_road, is_deleted, "character") FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00214\00\00\00\A5q\00\00\00\00\00\00\00\FD
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016667\00\00\00\00series_episodes\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00D\00\00\00COPY public.series_episodes (main_script, child_script) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00223\00\00\00\83z\00\00\00\00\00\00\00\F5
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016461\00\00\00\00stripe\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00\8D\00\00\00COPY public.stripe (payment_intent_id, amount, currency, customer_id, status, orderid, payment_method, email, client_secret_key) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00215\00\00\00|\00\00\00\00\00\00\00\F6
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016473\00\00\00\00stripe_charges\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00V\00\00\00COPY public.stripe_charges (orderid, charge_id, paid, txnid, receipt_url) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00216\00\00\00B}\00\00\00\00\00\00\00\F0
\00\00\00\00\00\00\00\00\00\000\00\00\00\0016412\00\00\00\00users\00
\00\00\00TABLE DATA\00\00\00\00\00\00\00\00\00\00\00}\00\00\00COPY public.users (id, username, email, password, firstname, lastname, status, email_verified, is_deleted, type) FROM stdin;
\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00210\00\00\00\A8~\00\00\00\00\00\00\00S
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016511\00\00\00\00paytm paytm_pkey\00
\00\00\00CONSTRAINT\00\00\00\00\00Q\00\00\00ALTER TABLE ONLY public.paytm
    ADD CONSTRAINT paytm_pkey PRIMARY KEY (txnid);
\00:\00\00\00ALTER TABLE ONLY public.paytm DROP CONSTRAINT paytm_pkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00219\00\00\00\00\00\00\00\00\00\00\00\00M
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016425\00\00\00\00script script_pkey\00
\00\00\00CONSTRAINT\00\00\00\00\00W\00\00\00ALTER TABLE ONLY public.script
    ADD CONSTRAINT script_pkey PRIMARY KEY (script_id);
\00<\00\00\00ALTER TABLE ONLY public.script DROP CONSTRAINT script_pkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00211\00\00\00\00\00\00\00\00\00\00\00\00Q
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016479\00"\00\00\00stripe_charges stripe_charges_pkey\00
\00\00\00CONSTRAINT\00\00\00\00\00g\00\00\00ALTER TABLE ONLY public.stripe_charges
    ADD CONSTRAINT stripe_charges_pkey PRIMARY KEY (charge_id);
\00L\00\00\00ALTER TABLE ONLY public.stripe_charges DROP CONSTRAINT stripe_charges_pkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00216\00\00\00\00\00\00\00\00\00\00\00\00O
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016467\00\00\00\00stripe stripe_pkey\00
\00\00\00CONSTRAINT\00\00\00\00\00_\00\00\00ALTER TABLE ONLY public.stripe
    ADD CONSTRAINT stripe_pkey PRIMARY KEY (payment_intent_id);
\00<\00\00\00ALTER TABLE ONLY public.stripe DROP CONSTRAINT stripe_pkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00215\00\00\00\00\00\00\00\00\00\00\00\00K
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016419\00\00\00\00users users_pkey\00
\00\00\00CONSTRAINT\00\00\00\00\00N\00\00\00ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
\00:\00\00\00ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00210\00\00\00\00\00\00\00\00\00\00\00\00Z
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016490\003\00\00\00email_verification email_verification_users_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\93\00\00\00ALTER TABLE ONLY public.email_verification
    ADD CONSTRAINT email_verification_users_id_fkey FOREIGN KEY (users_id) REFERENCES public.users(id);
\00]\00\00\00ALTER TABLE ONLY public.email_verification DROP CONSTRAINT email_verification_users_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00210\00\00\00\003403\00\00\00\00217\00\00\00\00\00\00\00\00\00\00\00\00d
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016683\00 \00\00\00episodes episodes_script_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\89\00\00\00ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_script_id_fkey FOREIGN KEY (script_id) REFERENCES public.script(script_id);
\00J\00\00\00ALTER TABLE ONLY public.episodes DROP CONSTRAINT episodes_script_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00224\00\00\00\003405\00\00\00\00211\00\00\00\00\00\00\00\00\00\00\00\00_
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016632\00\00\00\00msg msg_reciever_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00{\00\00\00ALTER TABLE ONLY public.msg
    ADD CONSTRAINT msg_reciever_id_fkey FOREIGN KEY (reciever_id) REFERENCES public.users(id);
\00B\00\00\00ALTER TABLE ONLY public.msg DROP CONSTRAINT msg_reciever_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00210\00\00\00\003403\00\00\00\00221\00\00\00\00\00\00\00\00\00\00\00\00^
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016627\00\00\00\00msg msg_sender_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00w\00\00\00ALTER TABLE ONLY public.msg
    ADD CONSTRAINT msg_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);
\00@\00\00\00ALTER TABLE ONLY public.msg DROP CONSTRAINT msg_sender_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00221\00\00\00\00210\00\00\00\003403\00\00\00\00\00\00\00\00\00\00\00\00[
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016500\00\00\00\00payment payment_script_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\87\00\00\00ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_script_id_fkey FOREIGN KEY (script_id) REFERENCES public.script(script_id);
\00H\00\00\00ALTER TABLE ONLY public.payment DROP CONSTRAINT payment_script_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00218\00\00\00\00211\00\00\00\003405\00\00\00\00\00\00\00\00\00\00\00\00\
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016512\00\00\00\00paytm paytm_orderid_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\00\00\00ALTER TABLE ONLY public.paytm
    ADD CONSTRAINT paytm_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.script(script_id);
\00B\00\00\00ALTER TABLE ONLY public.paytm DROP CONSTRAINT paytm_orderid_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\003405\00\00\00\00219\00\00\00\00211\00\00\00\00\00\00\00\00\00\00\00\00]
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016545\000\00\00\00producerdetails producerdetails_producer_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\93\00\00\00ALTER TABLE ONLY public.producerdetails
    ADD CONSTRAINT producerdetails_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES public.users(id);
\00Z\00\00\00ALTER TABLE ONLY public.producerdetails DROP CONSTRAINT producerdetails_producer_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00220\00\00\00\00210\00\00\00\003403\00\00\00\00\00\00\00\00\00\00\00\00a
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016645\00*\00\00\00saved_scripts saved_scripts_script_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\93\00\00\00ALTER TABLE ONLY public.saved_scripts
    ADD CONSTRAINT saved_scripts_script_id_fkey FOREIGN KEY (script_id) REFERENCES public.script(script_id);
\00T\00\00\00ALTER TABLE ONLY public.saved_scripts DROP CONSTRAINT saved_scripts_script_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00222\00\00\00\003405\00\00\00\00211\00\00\00\00\00\00\00\00\00\00\00\00`
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016640\00(\00\00\00saved_scripts saved_scripts_user_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\87\00\00\00ALTER TABLE ONLY public.saved_scripts
    ADD CONSTRAINT saved_scripts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
\00R\00\00\00ALTER TABLE ONLY public.saved_scripts DROP CONSTRAINT saved_scripts_user_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00222\00\00\00\00210\00\00\00\003403\00\00\00\00\00\00\00\00\00\00\00\00V
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016446\00,\00\00\00script_details script_details_script_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\95\00\00\00ALTER TABLE ONLY public.script_details
    ADD CONSTRAINT script_details_script_id_fkey FOREIGN KEY (script_id) REFERENCES public.script(script_id);
\00V\00\00\00ALTER TABLE ONLY public.script_details DROP CONSTRAINT script_details_script_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00211\00\00\00\00213\00\00\00\003405\00\00\00\00\00\00\00\00\00\00\00\00U
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016436\00*\00\00\00script_medias script_medias_script_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\93\00\00\00ALTER TABLE ONLY public.script_medias
    ADD CONSTRAINT script_medias_script_id_fkey FOREIGN KEY (script_id) REFERENCES public.script(script_id);
\00T\00\00\00ALTER TABLE ONLY public.script_medias DROP CONSTRAINT script_medias_script_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00212\00\00\00\003405\00\00\00\00211\00\00\00\00\00\00\00\00\00\00\00\00W
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016456\004\00\00\00script_pitch_table script_pitch_table_script_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\9D\00\00\00ALTER TABLE ONLY public.script_pitch_table
    ADD CONSTRAINT script_pitch_table_script_id_fkey FOREIGN KEY (script_id) REFERENCES public.script(script_id);
\00^\00\00\00ALTER TABLE ONLY public.script_pitch_table DROP CONSTRAINT script_pitch_table_script_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00211\00\00\00\003405\00\00\00\00214\00\00\00\00\00\00\00\00\00\00\00\00T
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016426\00"\00\00\00script script_scriptwriter_id_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\89\00\00\00ALTER TABLE ONLY public.script
    ADD CONSTRAINT script_scriptwriter_id_fkey FOREIGN KEY (scriptwriter_id) REFERENCES public.users(id);
\00L\00\00\00ALTER TABLE ONLY public.script DROP CONSTRAINT script_scriptwriter_id_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00210\00\00\00\00211\00\00\00\003403\00\00\00\00\00\00\00\00\00\00\00\00b
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016675\001\00\00\00series_episodes series_episodes_child_script_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\9D\00\00\00ALTER TABLE ONLY public.series_episodes
    ADD CONSTRAINT series_episodes_child_script_fkey FOREIGN KEY (child_script) REFERENCES public.script(script_id);
\00[\00\00\00ALTER TABLE ONLY public.series_episodes DROP CONSTRAINT series_episodes_child_script_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\003405\00\00\00\00211\00\00\00\00223\00\00\00\00\00\00\00\00\00\00\00\00c
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016688\000\00\00\00series_episodes series_episodes_main_script_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\9B\00\00\00ALTER TABLE ONLY public.series_episodes
    ADD CONSTRAINT series_episodes_main_script_fkey FOREIGN KEY (main_script) REFERENCES public.script(script_id);
\00Z\00\00\00ALTER TABLE ONLY public.series_episodes DROP CONSTRAINT series_episodes_main_script_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\00223\00\00\00\003405\00\00\00\00211\00\00\00\00\00\00\00\00\00\00\00\00Y
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016480\00*\00\00\00stripe_charges stripe_charges_orderid_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\91\00\00\00ALTER TABLE ONLY public.stripe_charges
    ADD CONSTRAINT stripe_charges_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.script(script_id);
\00T\00\00\00ALTER TABLE ONLY public.stripe_charges DROP CONSTRAINT stripe_charges_orderid_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\003405\00\00\00\00211\00\00\00\00216\00\00\00\00\00\00\00\00\00\00\00\00X
\00\00\00\00\00\00\00\00\00\00\002606\00\00\00\0016468\00\00\00\00stripe stripe_orderid_fkey\00
\00\00\00FK CONSTRAINT\00\00\00\00\00\81\00\00\00ALTER TABLE ONLY public.stripe
    ADD CONSTRAINT stripe_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.script(script_id);
\00D\00\00\00ALTER TABLE ONLY public.stripe DROP CONSTRAINT stripe_orderid_fkey;
\00\00\00\00\00\00\00public\00\00\00\00\00\00\00\00\00\00postgres\00\00\00\00false\00\00\00\003405\00\00\00\00211\00\00\00\00215\00\00\00\00\00\00\00\00\00\00\00\00\F7
\00\00\00\00\00x\9C\91\CBq\80!\84\CF\FE\BD\90y\DAK.(\D8	!7\86YX\BE\85\82u&]056t\F0Sr,,
\E7\BA2j\8A\C9}
I\B1\81\8BΜ
\F49\E5\DC\CFb<Aԅ<s\B5\E8 8\BF\84\A7wxaq}\8CYKIAU8!V\84\F8\A24\AD9m܇́\B6g\00\BF޹\A3\E5\A8(\B5\93ұfԙ"p\F8\CD\F6\B4\AE\EE \96\8A{\FBW\F1DLv\9B\E7&\D8,\8E\FB\DE\F1\D6R\8Fq#\D7ľ)u#\F0\C9\DED;ᚯ:D\F7\D2s\E3\F5Lk:\AC+L(}V=2\C9\EB{z7\90v\84|B\E1X\8BP\CC\CD\CD3zuW\E1\E9\EE\B8\BC邠߀.\C1tUF$\E2\BC+\E0`G\C81\FF\E9p\82\T\93\F0R\A6\EF\F7\E7\FB\BE?\AA\DAq\B0\00\00\00\00\00\00\FE
\00\00\00	\00\00x\9C-SK\92\E5 ['wq\F8\E6.\B3\C1\D8\DC\FF\A3\F7\BA+\9B\A4"dIǵf\D5"&\A4\87'\EDu\8Ax\DFnâs\EB\9E7m\8C\B0u\A9\F3	\D2ѝB\BC\E8\9CZ\B7\A7\9E\FC\D7\D9\DCv$y(\93\AE{i\97;\99\EA:\A7n\AA\D7\B7טy\A8V]\D2>\ED\99E	)\CEڽ\BE@\B6\EB\8BCi\EF\00n\A5\B0\B3h\F8\D5\D4;\AA̿\C0\EAnQ\BE\9Ct\F6Fk\8DF%[\83anد\C6j\C7}\F6$\E5\C0超\BC\96Rވ\915E\FE\80͆\83\B5S\8Ab\B4ۡ\DDp\EEV\B5\E4É\94~]{\DCu\A4S\8C\86xA-?B\FBf\B3\B2\F4/;\92k.bх\C0\DB$\DFFL\D8u\AAO\B5G\F4\C1\97\BF{\CC	\A1\BC\C92\F2=\B4\A5,At`\94\D7\E2\D6\DDӈg0
\E7\D5(>\CEح\AA\90\FB\B2}\94\C9ؤao\82\CD\CCýqͨ\FB\80}K\E3QA	8\A9T\D1\DAw\E1\93q|j\B7ݞ\F1\F8[\BB\CB̓*0\AEH\8E|.\F7\B6SZ޿f\AC\A1*\9B$\E3\A0=\F2ъf\BAI\A1[\CCF~\95\93\A7iЎ3{\F4\BC\F3eƆ\97s\F8q\00\97\A3PFX\80k\C0\F5\B8L\EEn.m\E5}̠\A0\A8(8>5KE2\8CRxJ\A0\9F8\F3\E1O)rG\C8>\E4\B6p\FCb\D7\9D\84\B9WC?\AC\FEj\B6e\EF\D0\C8\F0\A1Xs@2\D6\D2\E6@\CFbꗱ\AF3K\DC\CEOך-\DEIMV\C3\F9٣~/׿\9F\F7}\FFz\FE\DE\E2\00\00\00\00\00\00\FB
\00\00\00\BF\00\00x\9C\9Dӱn1\E0\D9~\8A{$\8A\A9{OAJ\A2`#\89S\D8\8A\BC}eth\87\BA7\FD\9FH\CAri\DEQ\89T\81\82P/ZwN\CCȻ\E6\99:Jj\98\83\8Aڡxl\8BZ!.Rc?\A5\E4Z\A8\C0\89{)F+7\F6k<\A0C\84\91\81|\F2qðEY\B3\E3\97\C3\F9\B2<Η\FB2>m\97\EBr\B6\9B-\AFף\CD\00\A7\B2\A7n\B1\98\B9Y5\A7Щ$\8ER\B5\81\A4]q\96\A3\96\F9f\98B\82\F1s\A9xPT\8D\82\A1q2\E7xg\F3\C9ō\F2\E6\F2JHO\E0eyӛ^gMSqS\F0)\93x\AA\C2\EC\C1y.c\90\A9\83J\AC\90$\9F\B1p\A2\B98i\9D\BA\D5Hf@8F*$\8A\CBֳXD\CE\9B\BC\DF\\DA(\AE9\FA\97\C3\E3\AC׷\FB\F2\FD\F9\B5\DC?\97\8F\AFz\9E\C5M\E5\EEm\D8\CE$\E7.\C8Ш+P\D3t\DC}#t>\B4\8Cs۽\A3sy\B4\E2\E4iø\F9\B0f\F6\CFi\CEQ\A6Rv\BC\C6S\A8p\E5Q
\C7\D9\C4\E3\00\C1\E2\A1\E6FJ\BDή\AFi\8F\91S\83l4\BC-\C8\B7Վ\98D\FFP\F0\E4d\8B\B8E^3\A5\DF;~\D7\FES\AF\CB\CD\F4\FD{y\BF\BCY{\8E\F0\B6\DC\EB\ED\F2\E31G\9DR\ECخ\FF\A3\BE\AE\C7\E3\F1\BC_\91\E6\00\00\00\00\00\00\F8
\00\00\00\00\00x\9C=\90;NE1k\EE^\8A'\B1\F7B\93\F8#Q =\C1k\D8=)\EE\A3q5\D2\8F\8Ai\E7ѐc(\D8VB\A4w\F0\8C\C69IJ\FA\DBc\FD>\BF\AEdo*\F0\C9ܬ@\BA;\9A\A7g7\A7\DCt\A3R\CB2\87\8F`\A6=N\CE<\92j\DChqS\CAJ\D0vر\A8\ECVr\A9\B6U\A8\DE\E8N\8A1\DD	\A6Y\B0\A6]\AA\8C\CDKo4\8A\89Lrp\DD-\ABAB\9E{\8F\D9Z\BD\A5\B2S\AD\F6(\EC\9AP\B1\86\95^z\F4\B0\EA/ԄcF(\CE`;\AEub\A9\EAJ\EA\A3o\AA\85\DE~\9Eߟ\8F\B8\D4։\B0\B2\B9\825+DЙ\D5,\D2Y\E2\C5\9D\90\BBLTNz*P\D1\EFzvƿ\ED\C7\FBu].Wx\B0\00\00\00\00\00\00\F9
\00\00\00
\00\00x\9C\BD\D4KkA\F0s\EF\A7Xr\AFP\AF~\D47\E4\90K6\82J@z\FA*\C4C"*\E2w\B7\96(\B8\F7\B620L3\F40\BF\AE#3\CED\C4\C4\91)\95Q̰d
\94M1\E5\C2\E1\EE\CD\ED\FB\FD뫫\EB\FD>Xi5	̔\B4\D5	\BE1\82\E6!:3\9C=\DC߆\BE\EB\EE\ED\AB닟a\BF\BB	H\E1\EE\DB\C3v\FF\A5\B5\F1\F8\F6O\F5ilw\F5\E1\D3\F6\F3\DC\DE<\F45\AC\BFm\EFX\B0 \A9\E5\982k\B8\DD\BCD\EC\FFX\80\F3\96q\89\BC_↟%\F6B\E2\FDR\A1\C8\D1bT\89G\92\A9]\ACЀ\9E5\83JC(\B1w\90>\FB\8C\AD\D3\\E9\AC\DB-R\CC\FF\96\A0\E5\EC¤^I\CE(\8EIG\92\C2X[/z\AATI\C0\FCmt\EA\AAi\8FsKx\A1\B8\F0\89\9A\A4BvHe\C2@Q\8DcA\8E\F9H\82\BDM&0\CDӥ*	\C2*8\AB\99T$>\B7DI'\D3E5\91\98I<]\\88\93\A4t\9C\AEu\D2H\B976&\A8\B7\D4\DC=l%\C5\C2%\ADZ\ED\FC\95\93\E9\E2\E8\87\EB\E9b
\E4\E7{\F8Tr\D5ߒ\81\AD\F8D蠼\BA\AB@\A6\D0约>\B2H<oǻDLɩ>I\E9w\9F\97\C4B\D1D/f\D7:\AD	\C1\9Ap\ED6\C1Ǚ@\9D㈣q\FF΋\E8\89!\BF\90\A8\F0s\C7\E7\9C\\92͇\D7\E1\E5qM\C8G\D5\CAZ\B1ⳗ\CC\AA+k\E3tΚ \D2\E5=\A4\EB\FEr\B3\D9\FC\BE\F2\8E\00\00\00\00\00\00\FA
\00\00\00
\00\00\00x\9C\8B\D1\E3\E2\E2\00\C5\00\A9\00\00\00\00\00\00\FC
\00\00\00\B4\00\00x\9C\AD\94˵ !ׯsa\8E\F27\97٨@\FE!/\B3\A5\B1^ʦ\CD:\82.\98\DBt\F0\93rl[\D8x\E5\E7\D4L\B5\B8\90+xڀ\FE\98\AE\E2\E8zx\AF\8F^H(\E5w\93\CF&m\86#w\81zqpi\A6\F8i\F9]\C2JP\AA\F8\EEw\91nO\E2\EA3\A3\E2\8DTz\D7$\90F\A3I\CC\E0\F7\E0=\84\EE\D9!X\9FGq\E5-@\CE\C60p\F6gt$\CBS\D0\D6O߁\96\CF\C6؀\E9p\89\00\8A\8A\92\B3\CE|#\85ݭ\B4\ADsxî\D1\D3KŜTt\FC~<#QIAU\B4\C7\EDD7\EE\EE\EC\A5P\98\E6\D69\9DZ\97&}\A7X5.\86\A4\E4ň7\92\E40\CBT\88\D1Np\B5\DB#\D6Fk\98\AD|#=\F9\F4D\9Ag\AD]e\AE\AC\81\E06\93\F6N\A1=\FC\8D\94\B3Wu0\E1\FA\F2_U\AC\A5-E;t\90/\AAķ\B8z\BC\DE\AEN\94\A5\A5;\A3}\DAy\D8z)R?t\E6\E4.tU\9A\A4\E8\B0\D5Hۥ:\B9\84\F4\CD\CC'\9EHBң+C\BB\8C\BD\BB\D9>\CC~w\84\E3\9CI#\BCΗ\BBDLVr\FE\AAB\B0X\F7\B5v!\AA\EF\FFH\FA\9F\FF\82\C7\DFrc\A6\DDO\F6\FC\FADM\A2\91`\E1B\A2\88\F4\FD\FD\F3}\DF?3\C9R\00\00\00\00\00\00\F1
\00\00\00h\00\00x\9C\95VA\8E\E48;w\FFE[\96l\E9/{\B1,\F9\F33ۻ\E7

(\A4*M\8B\CB+\B7\CE%\96*\CEE&v(\9A\D7u+\E5\E5_Zm\AD\AAI\D9\FC\92\94(\D9\\87\F6\BA\9BW\D3Z^_\9F\DF\DFc\CBl9\AD\B9\C9\EAF5Hc핫7>\FA\E5v\e\BAs:\C9ٗ\CCT\B1\BC\86\<\D3n~\FD\FE\8Bg\F1*\97\A7\90\F2e\F0띢\A7\C1-\A2\8F\96v\E3
\BF;\8F\F7!\8Dj\8D~"d\E7\C9n:N\EC\C4>\AF\F0$\87[/\CA%\8Bd\9CF\A6\994\F2\E6Փ\FDF\FF9\EFGx\B9Ξc/\B0x\B2i߆\95z\B3\F7qG\D8y\C3ϸ퓖\94s\A3\C8\D29\BE\E9T\F6\99\B7s\BD\D1#u\CEPX\A5\F3S\B5\89McX\D193\A4.0O\FE\F0\FB\AF%\F4\B8\DC\C9[\9DG\8F\A4
Y\DA\EEv\BBu~\C3/n\AF\B9\F2P\E1O\92\BE*\99\90ǦHn\83\C7z\CD9E\B6<\88
\FFM\83\F2rg\95\DA=\8E\F0\EE\9Az\F4I\D2Nb?a\DA\D2c2\AEP\867\F5\ABv\CCVO\DC\9C\B7\EDAV.\947b&L>\F4U\BF\8D\E8]V\D1P\83\BEl\B4\E7*\BDq\A3\\C7|ï\87{\B6\BDa\BD}g2\D9jI\CC5\F6.\85\C0\F6\CA/:\AD:\A4\C8\8B)\A2\AA\E1\F8\B7\AA%\CE\DB\F5
\9E[\?\A92\FC\9Cp6"l\A0\E9\E1\A7\C4|ӿ\AEg\A4/'\F2\E4_æ\FB\E1\BE\BBN\F5%\FF\F2\BB\F6\EFD\EE!\A3\A9\C7B\BE0o\E4Lm{
\F6\AF\BF\C1Ӹu\F7R\E2\95\F0\DF\976;\FA\CD`\953w\AB\AA7x\DC]P\A8ژ9t\E1j\E9:\8C\B5\A2\EE\BCcR\98G\8E)\A4XtI览7\84\9D\9D[\E3\E7\BEG\E3YA	\96\C8S\AC\F4}?\AC\97t\DD\ED\87\DFg\FD\86t\BAy\90zh:t\FC\EC\98oq\EB))\EB\AF\F4hm\87\8C\8D\81O\8C\A7\92\ADh\A5\E9(\A4-\F3x\83ڼT\82v4\E8;\8B\F2Nz\ACؐ\F7~\83\E7\A6"Jh<\E0\F9\84_&&\F1\00Ӯ6\9A\E7}S?\CC	d0q<\F9\9C\98\C4\C1~\CE\EE\C7\D6\F9\CF\CFƄ\83HQ\F1~e🈟S7\C5\EAM\FF"[4\831\D0\A5âF\EE\E0\87\B4\92`\F8q\FE\9F\A7\B5\AF\EA\9AI՟\E8xF\AB>\ADd\8F1O\DB_\95;b\EC\83\8E\FBb\C1\8D\8C\C5\FB\F7j\88j\AD\FF\F2\EF3<L\D8}V
DU@n\84A[c\C9O\FD>\C2\EB~V	b\E73D^՜wRް\CD\EAQ\FD\87\DF?\BF\BE\BF\BF\FF\00Ո\A2\A5\00\00\00\00\00\00\F3
\00\00\00\00\00\00x\9C\CDZێ\DCF\92}.a,\E0\97\A6\C0\FB\F3Ԓڲ<\96\D4\EB\D6\CA`\80E&3X\A4\9Bd\BCt\A9<\D8\DF\91\AC\EAn[miv¼H],2\99y2\E2\9C\91\95R\90\E7D\99o\82\B2\F6JR\BF\C8\F2\CAWy\AD\A2<H)/i\F7\BE!\EFu\DF.ji\ED\E0\BDR=\ED޼\FB\F0\FAj\F7\C6޵佰CE\E3\B2\FBǷ/'\D5+\EF
}{\F1\ED\ED\BCة\ADTw\BE\F4\BE\99ڮ\A3i\BB\F0?\BB\ABaߵs\B3\BB\EC\D4\E0\BD_\A7v\D8_x\CA{>\B5.{\BDZ\C2?mժ\E1\C2\FBն\C3\EC\E1\92WM\C7q\B1\FBI\8D\CD\D1[H\F5\DEb=CU;6\9D\EFxES\8F1ih\F7\98Se
=\F3~i\97F\BEl\A8=[{M;{5u\9D=<~\D5|\81[<\BD\B6\9D\991\9D^UM;\BF\A3\9ATu릀!\E7gv\F57eQ\95i\92\C5~\9De\A5\9FT\AA\F6\8B"M\FD$\A78\A9\F3\B0j\B3\FB\A9]\96\8E\BC7\ED<{7\EB0\F3\88O\E0\F8\C2\F6d\8Eg\D4\C3\FAniN\00\CE\F4jշ\DDQP02\D7eRw\D4y\AA\9A\EC\BC\C1f\D7a\99\8Eޡ\A1\81/\B4\93gԺo\8CxP\C32\F3c\A3\9A\85Q-\E4\B5\96\AFI\AD\CB\D7\F7\84{.\BCuP5xh\D4"#\FFj\D7i\A0\A3ר\99\E2\9D'\AF\B6\B2\BDC)\8DӤ\8E\B2\C4O\A3:B\AC\85\A1\AFê\F4\E3(\D0:\8CS\D4z\F7Bu\9D\D7\FB\A3wĐ\DE\DB/\8D\B6\9F-\B6\BB\A2\F3竏#MmO\C3r\8E\BF{\B0\AE\BA\D6r\9C-DV5]\005@eG\EA\85\B3L\FE]\D7\DE\F1\B7' \D3w\80\88\FA\D1N
0\AAyF\8C\93g\DEe\B74Hn\A8N\D4I\B6`\97G\AF}\F0̅\C7\EF\C6\F7
\A1YF\9E\E9\E3\8AI"Wx\B6\92dj0ؾ\96dC*\84\83\EC'Bz\F6\C4\ED\F2\88\D6YU\86q\F8\94\C7\E2.I\FC\A2\AA\B4\9F\A8 \8D+\AD\90޽~\FF~\97\95\CB\E7O\E7&\F2\D7N\93\FDc\AA\DE\00\A9A2\A8#\84\CFT\AF]ג\F1\90%\9D\99\F0\ADr\9B_\E1\E6]+\EC\8B\C3\E5`\A7y\F1\90\93\CD\D2\E3\A6\D9E\E25
\C3\F1\00<xO\E6F\8D\E4\B8z\C1>x\92\A9\C0Ƒ\D44?󘎶\AB\8A\91\AA6\8F\EE\DA/\9Bx\C7\E7\FB\99h\AA%\89\8Ff\90^b\E2\B2\C97y\92\FBI\~\91\E3Ǧ6uZ\99\B0\D6\E1\EE\AD\D5\D6\BF\C0n\9F\A7\BA֥j\BC7 \8FW\B7\83qQе5\D6ըa\D4\85i0\DF\88Ϟ\B7\C8-\00ʷ#\DAf\A64,\E0NG^'\EF:0qrJn
\95\BFe= 8ȝ\B8v\98ќĠG\99zg's\E1\FDm\ED\84lUͬ\80\FBԲ\80\F3\DC$\F5d9\BF\C0 \F8\EA(\F4ˀ*>\E3+d\B1\AF\E3\A0Ve\AB \8Cv\AF2/X\A9\9A\9E@\F1\89z\F1\ED
o*\A2\E6\FB\F6!\C6\F7 \FE\C2\F8\\81\A8\EC0\E7V\87\855JC\A6t'\C4\C5k\AC\D7e\9D$\ACj\85И$\\E9\A3\FF\F6\F2\E6\D2\DB΂\CE~\B43\8D
fdG\CEu\CEV5ߺЕ[8(G\C40\B8\BF\C6\FD\AA\B3@P\D2P9\ED\86\88e`[\00\CE1\8F}\C5\D76p\84\B6\D1"|Ҭ \A9\99\D13y\A5\B2X\E5PZ\95 \FA\E5\AB:(\82\B5	ø\8EuQ\ED^\AEOJ\C4\EFb\EF\93 ~fR\F3\F13\A0>֗{\88\AF\D5\DAy\97\CBDP\A4\F94\B5\85x\ECr\9A\D4-P\DA\E4L\8D\9E\9CS\EC94\C2\FF\BEd8\B4'\84\ED\86\C83\EF{ \E1W\84\BD\9D\A4\F3J\A7qYv `G\ACG͎L\90֝\E2\E0fJ\84\8EYV\8A\8EG\E5
'\8F\8E\AD\80rT\C40Q\A0*S\DFd\8A\FC$	c\BFĿ>\98)4I\92\D5aD\BBKf6{Wس?\B17\97O\C3\F6\F9\88\BD\94U\BDG~\DBY\88\AB\E5\D4ثN\E1\FE
\EA;\B9\F43\ED\CC\DF\C0\DA,,\AA\ABO\F8!\C0\93$:O\BA_\C1\A8\E1[\E85\877T\89z\CE\B5W\9C\AC6\EDp\D7\EE-\8F\B91\D0[\E6g\C5\D4\EDh\C0\89lkLjp\F8\95\95\82\DA\F8\85N\A0\D9e]\FB\8A\8A\C2O\93\A4\C4n\D7&)\9C?|W\D7m\85??\FC\F7
\B1n\ED\DCO\9B\9A'mLoa\93\8E\DE\94б22+\C7-/wl&\91ZP\9F\9Ad\CB\FBvV\80p\B2c-Β\DC _\C1\96\A02֗\F9\D8ݩ\A1U\E00\AC\AE9\A1\8A3\98ț\B6\AE\A1\FB\DE5\C4g¬\FBQ
G\E7[tR\96\9Bʧ\92\E0\91\C3<@\D2\E8F\91\A5ETd:Q\E5\8EÆ\87\ED\DB\CB\FF\D7\C2$Wc;\C37\FE1\98~\9F\AB\9F\CEɷ\ECB˛+n\8F>\C0\C0p\F8\B8\EDF,\90\E2\D5	\BCX\82\8A\B1\F5$Nyc\EF6\9B\DC!l\D1;\8E\00,\E0\B2:\FBn\EF\C0\F2"\F4\C9	\C8\DC8q|\EE\B7$\EDY↡]{A\D8B\8Cm&\9D>\C2IR`\8)~\C5q\A5uQF:\F1\F3\AC\81)8P\A7\F0\82YYN\EA\8C(-v?\B7\B0\DA<lo\A7\E5\F8g\B1u9\B4\BDz,Ə\A3\EDs\D9ɯrv\A2\ABlc;d\E4lA'#K$Oa\97\81\F5\\F0Jh\B3aL~g\FD\9C\96\E6\BBy\B3\E1p\84죽z\B2\BD+$x\F5{e\F6\B48I^\D4\ED\E6\FF\B0<d\E1\D0b ܼ\80z\8C\8F\C0\ABgL\F7
\C0ܫ\F4\BCN\E6w\DCq\FAm\95D*LM\CA3?	*\E3\EB\00ɫ\92Pg\FE\82\\EF\FE\EB\FA)\8E\FBs$\EF{\C2\C4l\BB\D2P9\88|oY#\EAZ\E6:\DCό#Q\94\A2\A3"\E6E\EAM\8E\8Fk5)p\B6X\CC\CEr`\89\80(\8CD*C(ssyIAUyh\FC$\D2\C8\CB@\C5~Ae\E2\9BZ\EB\CC\C0ǩ\D9Ab\BC׈\BAŕ\BD\E4\C5\E7\B3\F3w\E1󸸸\E1=\F4\8D\9D\F5\D1\C5\96\AE\B6\ABRj\89}畜\FD\A8\E4ŝxԅk\A7#4\AD\94\AF=Ѳ\B1\B3\9B&\8F\9E*+\85®g\8A\96!j4\EA$rd\FF\B1e\9A\E0̵,\DFO\C5\98\CD	\AE\BA\C3~\FDlu몋\E7\8AG倉u&\F2\98\EA\B4\F0\93,*|\95\E5\E4\C7*\88ZS\99\C6\D9\EE\AFRa\F4\9B\B5\87\8Fڢ\E7\CB\D0s\94\F29\BF\E6$:Ud\A7\B0;\FF\+C.C1\F3V\ED\F7\\BF\DDW\BA\A1\D2=\B4ǹ\86\B4q\9C\80\D6\CE4\C9Or\E6\8A\F4\CE\E5\E7\B97\ABx\B0ָ\EA\E2\E8\E0]%);\B6\CCn\AF@\EC^\A5\86k\9DV\A0xPG\97\DF\EE\C5[\E2\D1P\97\A5	\94\82\E1\A8a\8D3\F9E?\8A(V\8ARx\E3BTs\86\A7Ħ\CB4\B8\9AV\9Dc\D5ey\AA\E6xl:\BELS\C5,k\CB|\B59\E8\00\88[\EDW\92RMi\D2aa\85\B7\D5\FCj\F5\85\F7\8B\9B\90\A3*\E5\A8{\A1\A6ۭ\9Ez\94\E6.8?¸Aw\90\AD\87\A7Ti\AC3\9C\F9҄\00e4\BCc\EC\FE<\CE\BAf\A4\A8H\B3\82BH\82\89\E1Ғ"\AD|\D4\C6G\FD\98\A8\8AL\A6\BBN3\D0?\E2\E5\F6\9FN\E5\C7\C1\F8\C8x\B0\C7\E5*\C6;\AF\C6Ѐ\80\E3\D0j\B8\9D\D6q\D9D\9B\C5_L\D4CSE
a\B9$w\8Fn]\EC\8Eo\DD㦹\E7\8EƂr\D5\E0\8C'\B3_\BE\DB\E6/&\AB\D0uYš\AF\B3\00Ż)k\BF,\AA\81	RJ	\CB6;Ć \FE\92\94\F9\A7\DD\C5\EFs\FB?\A9T_o\89\81\DDwe\E2o\B6׈F5Z8\86\E3\C8V\F4ns`\90\A5\BB\F6\D5=\9C\FF\B4\EE\F7\9D\E4\E5\BC E\A7\F4pv\00m\94\CF\E5Ьj\82\AEIMv\C7\DC\E6l\AE\C1/\DC͏	\DC\EF\E3\AD\EDE=\82\FC\9B\E8\B2۴\EC\D7n\DBZXFQ\C32\ADbS\E6\A5\C5	\B7\E6\82\DC/LQEa\9E\A4\BB\E7\Z3\B8\CF\FF\D8~a\D9ϩ\84\88\F9\F20K\DC\99N\8D\BD\EF\F3HW\92\C5\E0p\EASV\AC:Ёi\E6Ĕ\A5G\BBn$\DB-IST\AE\B9\B8\F8\D4\E4\DC4\DA1\AAEYTG$B\9D\E7P\CFH\F9EW[\A8,	L\\C60\BB_\93\9B\DB#_\D3p2\F5\CEW\E1*\89\8BḪ\DC*OP\A0\BC\C6\00\C4\C5j~^T\AAk\AAU\9E\FAQn`{\AA\95JT\BE.`\AALD\F4\F56\9A۠=L\B6uT[\D7F\F6D\8C\AF\91׭;[\F9\C6\EA\DE®\CCn㿃\FF\A9p<\E0\DEGv\DCa\C0^\BE\D6S\8Fp\DC\F2\E2G\D4\D6l\9A
\8C\92X\A5\AAH('*}\94,1\C0\89r_\95\F9\91\9Ff\A9\A3 \FCj\E0\E0\F2/쓸\AC\A8B\ED\C6-\E9\85\CB\E9Ķs\C5\E5\C9f\904\80\E92\C1\E5\B9Ⱦ\AC\9A:c\CB\E1\EF\F7n	zE\95\C2\EDI\A9~G\B0\90m2R\EB\D2\CB\EC\DC\D5\FA\E2\C3n\B0\D1ޕˮ	\E7zp\EC\AD\E0\E3\9E\8F\83\97\B1\97&,SU\E0\EA8\83\D2\EB4\C7_1J㼊\C2 \A2\S\FDU0}\FA=s#"\B8ŝ sF\DA
sN\93(1\BBN\F1\\\C5\F1{\8D\E56ݼY.\93\8D4\B0:d\D8sl-W\C7\F8\B2;\ABU\D4r\AC?\ECV\F4\96M\AB4\BD\98\B0\BA\D5mP\87\96\DE\CFw\91\F3\C3\F2\C8O\FD\FCA\EE\92W\B2\91Rqe\A4}\A4\FD$&\F2KU\97\F8\F9<	S|\A5\D2{C\A9{\FB\ADq*]-(\D7\CC]{\B6\D2)eS\C4vI\F8 \94#\AD\97\8ABǭ[sj\88߫&/\96Tצ*|i5\A8`\E0\CB\A1U\C5QZQBE\F8/\ED\B5\FC(s\B1\DCk븈\B1 &\D41!{#\E507\83\AB\8DZ^\A4B\9Dh\AF&sj#\F3\DE\CD\EDo\FCqZ\FBm-i(\9D\C4ʏ\8Dfs\9A\E4\E7\A6Hc2iE\B1\AC\E5\F9\BB\BF\DD\FC?㩶\E6'{\A2f\91e>\F6\E8\E0fA\81+˭\AD*.Ć|`\A1\C1=\B2\97\94l\B8\E1\A2\E5\D5\E2\F2^W盁\91>0+=\C2\E5\FC\9C\81{fw\F6\F6|\D7b\C0\A6\F1\9Dr\BE"\B7Lˋa\F6@\BC\AC4?\CDƊ7|\F6\81\DB~\C1\A3\E3'C4\92\EB:'\91\89\F24Ѿ\D2D2+\BF0u\86\A4\8As\AD\A0\91U\FD;m\CBsL\88O\84\ECAN/0\CAs>=\CD4\96ϒht'P\B4\9D\D8\C9\D1\8Cϳ\BB\B9\97\C2\D2:J\DCp\A5\E4b\C1\97\FCf	\EF\F3\96\DF\80\92\AE\DC\D48u؞\84\FE\EFI\A5#\9DJ\B6yx-ܬ\FCU\F3n\92\i\92\90N}\94<؊2\83_\C9\EAUwM.\E2\A04_G>66\AF\D8P)1^\DCsg\A2\FE\8E\9A\E6\B1\E5\BD\D2x\9E\ED=\A3\B8\8E\8F\89\C8\00C\C1Zt:\AE\94>\AB\BDtX\F9\9CԸZ\C9i\C9\AAM+\8B\E3}\93\C2\B9¡j8n.\BCq\9D\DCy\80\88\90G;-\DC\E5\96\BB\AA\B2L'\DDHsS\D6$pzQkbMY\CEV\D6\EC\AEֱ\81\BA\AB\CFC\F7ɠ\FC\A2s\F7w\DBAS\CB\9BF\B1\C0z3
\CBݖ\95\CE\E5\90;Z_]k\9As\E84L\F5/\DE[\D8x`m\F5h8q=\94Ӄw\D7\DAs\FA\8B\F7Wh\AD;*T\B8h\C8J\A3\F3A!
i\F9(uR\99\B9\81m\93T\A3\80\D4HuX\FA Ϣ\A4\D2y\B2{1\81\AD?\C7g~\C8\F1\A0j\E6\A3\ED\C1\CDXr\E8\BAa31b+\B96\E1]\BE\EA\DAߔfQ\9FG\E9I-\96g\9B_\9AxזЎϼ\CDʭ\B4\AE$\BC\EB\93j\B6\A3\E2Ƨ9'z\F0\F9_;-
\80\8C\D2:V\95_\A4%|nQW\BE\8Au\E8\C7QRPP\99R\F1/\C7\E0{\D1\D7\F2m3\C9wIy:\9D\8FV\B6"v\ED?W\E2\B3\CB3*\AF_a\B7\FB\E1\DC]x\D8 \94\E3pwra\87\C7.k9pW\9A\87\A9\A4\E3\DAOe\95S\9B\A4wG\834\F5\CBH?\88\CB\00\92\87\9A\C2\DDM۵\CE\FB\00\8A\A3O4\D7?\D3Fy"~na\9E\B9A=K\93\A9G\C0s)7\F1Ou\B8o\FB\E7\FC\BC\D8l\CB\ED&\80p 9\ED\FE\8F0\B8\F7\A2%H^\A9;\D8\D8\E7\D4\CD\DB\EF"pcA<\B8\EB\9A\F8E\AF`M,\FF\C8O\D0\C7\CD\C7\00N\00\00\9F\A2\A5\92^\D7\DC\E6v+\B75C\A4\93r\FD\8Dy\E5\C3\9E\F6\C4i\C8d\D5\ED\B9<h\FASQ\E0:\85S'\854|L\A6Ӳ\F6Èu\91\85\F0nqA>\C8I'T\87	\F9UH\E8\F2\FE\B8\AC\81\80m\EEY\8DDҹ'#X|\98\99~|̡:)\8D\D4v\D8\C2\C6]m\DD!sG
\A2ǿ5\80\85Q\BA\DB~n\00\87\D2\F2˘\9F]{>,R\A3#\A0Q\C0f$y\F8e	\86\A6X%te\A9\F9w\F2g\BF\E0\9Aw\97\88V$\F2\E0\82O\F0\EFo:\BAk\99쐊2\C9\EDWC\\E6\BD+\DC\EF\FDuj\C7[s\97\BD\FA
\B7^\CBL?0i\C3\80\CD\F6+\C6Oh\A8\E0)\9Dg.e\B8M\C8㽒\9F7\
C\EB8\E4\A5\E28\B7\F0iZf>\D7lO\E6t;o\EDp\EC\A56\DB~\95p\D7\EE[\A89\9F$?\D8Pʹ«\F9І\F88ɴP\95Uu\B3t\A4\94^\CF}`ٗ\FAX6\F5\EFϾ\F9\E6\9B\FF\C8\F9\B92\00\00\00\00\00\00\F2
\00\00\00\D2\00\00x\9C\A5YKn%7\\8F\EF"\8FH\91\94\94\B3d\A3\EF$\921\E69\90ӧ\BA\DF\C4\EDu\ECg/\8A]\CD_\AD+漖\85\EB\B2DC\B1<B˻q\8E\BAr]_~{{\FC\F2\F5\EB\B7\F5\FE?~{\8F\F7\EF?\D6\EB#\BD\FE\FD\AB=\DE\BF\B6?ۿ\DF\FFj\FF<^\C7\F7?\BF\92Y\AC\A4\AA\96_\DF\E6v\81\A5\F2\FA\C7\DB\FA\E6B\C9\D1\F4\89\F2e\BF\D42\AA\8A\A5\B0\CDj\90\D1v(E5H^Iv\A6\F7\BC\8DRN\92E]\C4M9\FA\88\9F(\95僸&\95\CD&Ay32N:\8D\C7\DE)\C5Yv\BF-S\AA\85\B3\B0\87\F8	\92\84\AB\8B\F8\89",\E9\83\F8\B6Q)I+\A7\88\8C\8B\842FҢ\A6\D1\DB\C4\B9M9[,xf\F1\84\C4|\A5~\A2p\E6r\97\89wA+\CC,9H1\9D3\A4\B9\E7\D61iw\BA-\B1E\CD\E6#\8A%9\89(\B9^='2\BE\99B\8Dk\9F\A1\A1\C2COq\B7ZS\8BĎh\99\D8\D4Ku\8AZ\F7?\AA\FD\FFI\E23\8Ff\A9e\8C\F1&ȸ\B4\D0v,H\FB\9EDi\A7^\C6\FDh\82\AF\C2\D1G &\E2\CD8P2\CBU\EAx\AC6f\99aZ[A\84R\A8\F8ƚ4El\DF^gY\F5(usf D\85\9C\C4\F5,u\BB\D6\D9h\A0\DEg(]0\D5\EBޡ\ADR\82\8A\D41֞R\EE\B7\98b\B5Z\\C4B\C01\F1\85b\BD\D6Yߴ,\CFV]0\94#\8A~b\D6C\91\EBҪ#Z\CEfɵ\C7O\90\9C\B2s\9D\9D(ŮRgݥr\97\90\AD\88\A3ѻb\8F[\C1\BC\97mki\B9\8D82\B9\8F\F8R\A38\89%\99\D6\E2C\B8\91NB\8F\93\89c\86Q\F4M\A8\E3\86\BD#\9A\98F"'q9~8\F7\F8\81\92c\BC\88\AF8J\C94\83pG\A9ǖBYU\C2ܽۄ\AAIz[\B2B2\90A4\F8\94\DB	R\DCāRj\CC\C4S'\92\8E\81\AE]K\E3\9A\E5\92A\B5\ED\BE\AA&sDӈ\B7\ECSn'\88\9AO\AB\9F(\C4Dĩ\D7:ck\D8d\C6&\87\92\E3\CC+\B5\B6
\C6\D1㘎\88\E6rgO\EFT
\D6\F8U\EAx\97eaK\86\99\B0\BD\A5(iD\E5\EF\B5\E2\E4\C1s\93ޏ\96\A8\C0:3#\F5N\F5\C5j\FEdK\FB\AE#\C1\93Y\845\990\E5p\AA	\F2m\EBuG\8F'h\A1\A3\B1|\C4E\8Ety\89C\FCi\FE\E4\C7u\A4Ys
\9C\E4\F0\E31\87Ҏ\8C\A3\DA\8B`\A7\EFF\AB\C7X"\EA0'\91\FA\D6\D9%\C7O\92\D5\E0\C3\E8R\CFpg\CC
\B6*\A64\93\E3\96 nnG\C3T\82$\CA\C9E\FC\00av\9A\94'J\E5ˏk\DFk\B7\AC\81\F3\C4	\92r!\F4\82M6\ACŵnKVD\93*J.s\82(t\90\978P`S.冿\C1\8E\A1\B3\93a\B4w\CD\F8\94\A0\D5\F3`\8A\BCr_\8Eg\A6HR\92ˤ\9C xd\DF:;Q\B0\AER\A7\96"\DB\EAa\82>l\E9Z\A1\B6]\F1+\E3ud!m\F1f4\8EU\958\8Fr{\82\A0\E5\\A2\88\D5Oʭ\C1t\CFQBgX4\81V\C3\AF\8A܏\C4:\96\ACr\F7\83h%B6\88Ǐ\FF\C9\EC\F2\E3OR\BD\D6\9A\BEuI-\A4\D9\93\8E\A2\8F+\E4Y4\AD\A9Ɯ\EEG\ABZ)O\8F?Au\EA$~\A0T\BDl\A9\F0\E4\AC\D2C\EB\C3
\E69\94\B9
\F5\9Ero\98mc\DC==aF\C4\\B0\83]\C4O\A5\EAZgOȠ\F4I\C0\A8\C8\EA\8EKI\90j\98\EA\B6Z=A\B3\95\AB\EB\99k\DF\E9\E9	\A2곥O\FB\AC\D5\C70\EB\F0݁\FBq\88\98\82MƆ=>S_pEX\E7w\95\9F\E3X\A9x\94\DBO\90B.w\F6D1\8Bqt\B1u\85P%>\AE\E9Fs\A9\AC\80\D2em\9A2\EEKV\AD\99\8D\CDs\81\E1T#Ubv\DDܞ(\90AוuYy\AD\8Ai\82\80\E1Z+pC\A5\9Bv\C2\qg\C6t\F3i\F5\A4F\EFy\AA-Z\B9\9C\99\CE\CEHq\C1\\93L1\A0b\80)\95\CEx\E69D WǗ\F3t\B9\F7\83Հ\85v\AF\C5L\98\EA\8CM&\DAa\CC:\86<\84z\84\89\95ѳ\DCo\ACR)\C2\F9z\BCT\81\A4\F0\F689\BF\D6ٚ\AD\F7\D4F(ZQ\EAeÏ\A7N!\A1\ABV,\AB\EA\BA{\888\A2\C1y$+\A7R\F5\F4x^\E2\F9Poq\AA#/\81Fm\F38\BCE\D5P\B9\CD1P\99\FA\BA\ADܐme\AB\E4n'H\DF\FFΞ(%\D1\D5㿾\BE\BC\BC\FC\FF;h\00\00\00\00\00\00\F4
\00\00\00\CE\00\00x\9C\DDXI\B6\E36\S\A7\C0Џ\C4\C0aߋ>Do0$D\FA\93\84\CC\E1\CB\F2\E9;\00\8A\FA\AA*\BF~\BDr۵\918`HDfFFRS\D94D5\F7e\B8"\A5y[7\8E\9B&є\9A\9A\8E\8A{\F\CF\EEf)\\9Cn\FBFK\B1E\B6n\F1ƶ\9E\F2\8Bk\FC\A4e\9Ehފ\AD_\86qĘc\E8ם\C6"\86]i\F6\95\9D+0\9A\AF\C3L\B8ؖ\81Vv.\88\C5.]\EB:\ADj\C9C]w\9x\DBj\CDUCR\85\A6j\CB\E0O\B7\85֕<\BB\EEv\B6\9E\F5\C3ʂ\99\86\F1\C1&\9A,-k\B1-\E6\93\C6a\BE\B2d򕶴\91\C9V\8C\B4
qff\C6ц\99ϙ\B7%ڑ\A6\B58/\F2\DA\90\CF\FAKܗ\99ŃV\9C\EA\DB\CD.ZjD\AD\B8A\00̪\E2\B6r\97\A2\B4\B6\92\A5o\83Ŝ1ۃG\80\F6f!Ο\A1H-q2\B3\A3b2t\8C\EB\E3D_ƽ\CDr4Øà\EDq\C0}\D6-A\F1\CDN\97P\BB\AE\92\AA\E4\D4\C8\B0*\C5[\E7,W\A6\D4\D2Y\E3av\E1\FAa\F4\CD	\AB\ED9{[\E2\8Ema²ą\E5\FF!<\D89\B6\F8%~\C0\DF\C7\EB"\DE0{\FB\C6\F7\B7\F5\E1\FA\C8>r\\\82\F2\B2k+\E2\BEQ
Wҕ\BC\D5\DEs\E9\83\DA\F9*ت\C0A\81\E9ۯ\83'\B8\CC \80p\A8>\EE+\C6e\DFi\C5\EC\97c\F8Z\F4ô\D26\C6\CE1\D9@\B9ˇM+\BDv:\D0̗\D2\9D *ޕ\E4:\9E\F8\8C[Y\D3uҔ\95(\EC2\CC,\D6\EF\98\C3\E87@\F44e\BD\F7+ܓ
\CB\87
O`9\B2,d|h\9F=L\DE\E0\EE\EF&\BF\87\DDF3\CF\E4s\A8a\B5%ǆ7\FB\B5G
]|\E3L-M\83l5
@*\C3M([\A0|U\C9 m\EB\8A\EE31$\C6-\AE3\B7\E8\CC\F8\B8m\83+~x\F0\B29\E7\FB\91\F5\00m~\BCa\88\90b\D7\93E\F9\8D\EB\CD\A0S\F4\B7\A24η\9E\FB\DAW\AA\92\BC\C3/w\E4+\AFT*ǅ\94\FBi\93s̈́\E60\87!\81\94\A9$m\81x5\888\F6\F4!N\9F\89\C1\D6\FDF\CB\F1 \BB\E3ʬq\AC7cHK}\83\F9֛9\F3\B6az\85M\BA\A7)\A6k3\BEP7\E3\DD<ִ\C0\92\F6\FA
\93\82\AFm/\9D38\AB\F5\BC\B5
yޅ\C0
\B5-\D7Ju\CEQ\F0\AA\C5^\CCG\B7'F4\87ׯ\FBh\D8\9C\9A~\C3zC\00\96\93;1Բ\C3<v3x\99I
[\99\E7\F6\85\9E\88c\A8M\F7\FB=|\9F\8Bڸ\A7MLH\A0\B8\F8 \D8kCEu\E3\A7\8E@\F2US"b<\F2\AF\ADu+\DA\DA*\D3a@P\B1\93w\968?w\FB\00\C0k2\AC?\83\E3\FDm\B4_7\C2\BF\98k\9C\00"\E2\FE D\84m'\AC\E2M\DDV0Qk5\B2n\C1	*\D4D\BA-\B8\EF\F0)\B6M;\86}\C3\E9\DF\D6)V7\84\81]\F5f^\CE\F7l\85\98\88<\9Bb\9A\E3\98#Τ0bfL\D9\F7H\E6ŜPG\E6\99\AEX\8B\8C\ED#\83\90O\C7\C9o\EC\D8\E5mۃC.N	Si_!\FC\AB\9A\AB\D2ynK\84\87Q\95\AD\AE@+\C5\C9\F8\F3z\8BK\A6״\C2\C1i0z\C2\EB\FC\D70\82\D6\ED{\9Cq\8E\ED\ED6\F8\B2F\CE,\82c5%\EB\DC\E7/T\BA\B6m*ϕ\B0\F0~i$o\A9S\DCkk\8FZ \B5O
`\91E\C3\E4r\F4\C8\\EF	\BA	\C53\D96e\E0N\AC޼\92@\CFA\E9\A0i\EE8\84b\E5\99p\E9u\A2p\AC{V2\EC?e\B21x\8D\91a\C0\82!e\8C_/\D2V\95\B2`mu\CBU-Znꆸ\ACQł\A5N˺xF\E2\ED32\FD\BC/r$\9B\CCb+\CCqc\D3\EEzf\F7\ED\BD,c\9B,\C7{\D8#_\9BW\B6\EB|i(.\A0P\D4^\F0\B6)=\82\A41\A4Q)\DA\E2n\E6,5\92\E2\00\B6}\DC"\E7ֿ>.~\98Ai\97x\A7#\BE-\DF\F6\C8\D11\E5\E9ze\B2\AB\B3\F6\F1\B4\98K\A9\EB\96*d\97\97\E0^\D5jh\B9\CED\A5N\F8P\E9 8\968\B9X@qM|k\CD\FC\B1\EC\B7\ED\95\FF\BF\EEH\D0t\9E\DA\DA\CC=\89v;\AE\8E\B0x91/\F6\AC\B2y\D0ݬ\F9!D\9E
\9D\93\90Hu	
\E2!?\A1\FB$*\98\87\EC\D4S}\F1{\9C쐶\FA4k\F2\E1q\BF\9EZn|\F2|\FA\FCg
$\B9D2\EF)\E0^\93۞\AC\BE|\9F\D4\D4i'}\D7t\H\954g\D9\F0\D6$܀\A3!GU\A34\C4M\90VH\E3y$\\D2iK\F1/T40\FD\96b&\91&\F3\CB~=\92s\8A\A9\BC$'1\97\EF\F2\F3/\F2(ҥ]FJr\CD\DC\FB\CE:8\C5)\AB\9F\ɲ\BE\C6E\CA\FA\AF\80\CD!\8C]PYƘ\E9\E0{s_\8C\97)Q߶{\ACzik\C8U\F4\BC\B2
\F4\98\BA5\A25\B5*!\D5$J\C7Oztm\D3h.\D2v\95\t}-h\D1զ$\A2\9F\F4\E8\A2\EA4\D4"\B2N\D6\E02\AB\I\88\98Ɖ\AA\D4X\FAq\AD\9F\E3蕑\A5\A8\C9r\00\A0\9B\89xgB\87[@UiS\FE)z\88\D0a\EFZnԤB1F)\E9\D0\E8Z'\85v\A4\A8\AD\FEJBR\97\90\BDJ\B4j6\95>\99\A2\A7$\DE\F8VK\F2\BABY)g\C9\FEjW\E1ut̢\BBF#\89V\D5q8\86\A4\FA\FE\FA\9A\90\9F\C4φ\D5$y^<\85~6\F8P\EFϘ\B8\C3\CFO&?g\9A盕/Jx\D1he\B9\B1%\BC\EE\D0\F9P\C3߲\B1\F9\ED\9C\F8kYܵh#\C8j\8EJ\8B\BB\94Tm#Q\BA[Yv\FEg\CDK\E7j\F4"\F0\8E\B0\A9O\F1
D,j"/-\98T\8F|\914[]]\8F\F0\86\88~|\B7\8F\A9M(V\R\FBy`\F7\CAW4\D6\CF\CFF\D9S\EF+\9DV\FE`\F9\C2\E5V\FF<\CCK\89\9DÐ\D0\C8\FA\FE\C8\E8\CE*\E7+ě@r(m!h,\C2\85\B4lj\A1\9CmT\91h\BD%\CDI\BC\D0|\D3'\00kҷ,(p4(#\A3\CFs\91\E5#\DAR\96\9B\A2%>\F0\EA\94i\DFܼ͙\E3-\99\F9\FE\FEB\DEX+\8D\E3\AD\EE$T!\84\AB\81\88\E6R\88\8AJ\B4\9A\DA\FF\83YU\E7R`^\E3SRj\CD;a</eWĦ\B2T\FD`^i\90\890\E5\8D=\9E\B4\96\E5 \B9\FE\8D\D0\CE\DFR\8C=\F3\F7\9C\BB\A5/Q\F1\EC\F5\BE\E4\A0:\BF\E2\D9s\B6@\B8\DCo\D7*j\88:\8E\86\F09\D1p\D39\E2\C2 %km+QV\FF%'s|{\FAn4\8D\8D\FB\F6\9Eu\E3\9CE\AF\A1\BD\C4]nUMU\F2\AEC΢R\F1.jt\97\FF\C19<l\C3\EF\A9\FF\D3\D85\AB\B6\BDG%җкB-\96-N\E3\C0D*\8Fl\FE\8BSο\FFq\B9\\FE\D U\00\00\00\00\00\00\FD
\00\00\00\87\00\00x\9C\8D\92\CD\D1-!D\D73\B9\F0\95\F2\A3\90\CBۀ`\FE!<n\B3\93*lN7\E5\DAU\BA\84\80np;\E8wʒ\988\E6cr(m \B1u\D3ؠ>n{\9D\9A\9B\E5=_\94t\E1\C5\EA\FF3\F6FtгG\CB-IF;\CF7%\89[׷\00\EE\\DDDm@\E8&:\CBGU}S\C2i\E2w\0Z\B2\FBE
\B2΁\B5\A3\EEw\D6j8(\AB<\9B\D9wd++\EA
v{\A6\D3\C0U\D9z\C0T\E6׺\C4\D6\DF<\C5\C7k\C7qx$h0\DBm\F0\D2\C7l\E7\D4M\D6z\CA'\DD<
\81\DD\C9Y\9D\F86i\BAC(\A7\B8t\BE5U2\B0\E0\A8)\F0\9E\CCր"\E7\C0v\BB$=\8CɁ2\F0\A2\9F\CFQ\B0S\85*e!\D27%\C6\C4-\E01:\F1՝\9Aw\B5E\DA\E1\F89\F8-q\D36[!0d\B5\92\AD\8E`]j\BA)J\C3򾍶B\EC\C2\C4=nv\A4\8Dx:\EC\BA3\F9\E4\D3EW
\81\F1[Kr\006\B8&E\EF\EBwV\F9Vz\F9k&\BD\9Cb!\CEZ&\A5OY\B4\E0lw\D8\B1\B5\CF6\DBg9\F6\EAb\F3\FB\EF\EF}\DF\FF"\DD\D2\CE\00\00\00\00\00\00\F5
\00\00\00\00\00x\9C}\8F]o\820F\AF\CB\A9i\B1\DCM1\9B\880\F33KHy[l\E3\82\80\CE_\BF-˦K\B6\DD?O\CE9\9D\B4G\A2\FF\ACbo\B2\81E\B7P\8A\92\B8\AC\A2Y\84 \BD/\D4\C7$5\81\AF\ABp=
\F6:\D6\00R
)8L\DAR\BA\D8\E9Xm\CC\C0\B41wAb\93g\D4\EAX)5	E\C0K\91\D0\CE\EA\86\F3\A0^\87<\AA\D1.W\82\F3\AC\D4\FB\BB\F5\8E\EBm\F2:\FC-\96%\94\B2J \AD\A2p\B9	⸂\B1\9Fڽaׯ\ED\FC\D1\F8<O\E7\E4z&\DB\C0\B7;\CB\F9Ϫ\D0k\9A\D7E\CC\BD\B8\A9r\81\9B\84\A7;)31s\B3s\E98\D8b\CC}\DFd\829\F2\BBj:k\AE\F3<\E9\D7ʲ\FF\AB\FAU\EC\AB\EAr\D1~\C3\EE\FD\F2Ls\97\AA\D5|\E6\D5\C5z61^Z\86a\BC'\8CF\00\00\00\00\00\00\F6
\00\00\00V\00\00x\9C\AD\CFKo\AA@\80\E1\B5\FC\97Q\81\86\B3C-\D6K\A9\88\C641\C3\F8
\A3F\AE\D3\F8\EB\CFiӤi\BA\ED\F6}W'\00\DB2憃\98\CBL\E8\96m\A5\BA1\D6\\CD\F5i\B6\93\D14\BC\F2ī\A4\D4ed\91l\BF\A8\81\EA\F2\9F\EBr\93\C2y \95*\9B?\A3Q\C9\FAa\A3\EAs	C^\DCF5p8\97\AAy\EF7\C8\D5h\EAq\E6\B7\C5\8D\83\CB\C9'\DD\CE߆\A1Y\EEBݯ\A9.'<\96\C5j\91m\99͟2\FA\A6j%\AE\D4^O\FDv\91ܟ\EFG\D6ϳ\C7n\D7D\FE\F6\B9GK\FD\D4\F1,\9BE\FE\A5\9A\83\C0U\EA]"\B3b\E3M\9ANs93\C6,=!\92baWĀda\ECr\E2\84	|\E2\F7\F1\F8K7.\B95_\E6\C6\FE\FB\A6\81\FE\AF\F3\BB\F8 ϻ<\BB\ADm\9AL\DB\E2?\9E\8A\B6\ADD\A2B=\AEV\F1E\D2\DD\EC\D5ѩ6k\B8_\A9gТ j\83\83SL̋\D5>\C1"1\B5ס\A6i\FF\00}\E8\A8\FC\00\00\00\00\00\00\F0
\00\00\00,\00\00x\9Cm\91KW\E20\86\D7\E5W\CC\C2mJ\9B\A4\B9\ECT\94\8B\8E"r\DC|\B9A\B9\B4\98R\A4\FE\FA\E9\C69\A0\B3ʛ\9C\9C\E7}\92OR\873aIbDpH\C5ؠD\81U\94+\A1\008\9Ff\C1&_\98c\FC\99\97\BBu\9E\AFB\9Do\82\B7w\EBwU\8C\C9\E7=P\A9	`\BB\F5\F9ޚ`\D4\00\B3I\B3\860\8E:\AB\C2\D4ZDq\DD*\A8\D0HE\D2:)l\82\B9<-\99o ]\FF\A9\F8\EF\E1\EB0\8CnZ\83\C1\F5ՏV\AB\F3\D07\ADv\EF꼺\D0>\DD\EE\DE}\BA\B3\BEA\80\B2\C8\8D8\E3Q$\94%\F5k9p\C3\E3\EB$p\B2U\AE-d'\F1\A4\F7\AB\8B8\BA(:\83Y\D5\D3\D6b~\9D\92'M\97\93\89\CDF.\B3\FD\BB\ECm^l\DB\E9\F8*\97\9D\AA\E9;\AA7[W\A3#18\D2\FFy\BA\AF\9E463\C2c	CD\8C\00 H&\863E<X\81?\F3\FA\BA\FF\EB9Lt+\BAg\FE婿\9C\99\B4\C5.\E3֏\86\CD\FB*\92\92\F3\FDe\92\96U\FB\E3y2\DC=\A1\9B@\B3:e\BE\00\EEYGS\EA\DAтK\CE\92\96\D6\D34\92 I\93)!\A4\871\E0\DEk\CEqQ\A5^R|W\B4I\D8-\9E\F74z,\F25M\BBpiͨ<dK9\CF\F7\FA&\E2\E1ך\F4\DDS\B4>\C8Yo\A6[\C2O\B6\BD:\95\FC6tG\80\D3V\8F\9A*`H\F1ؠ8\E1\82E3*\D0\9F\C3|}\DF\EF\EE\C8\C78\F4Qwo\96z\FFb\E7\E3\DB\DBrZ\B6\D1\E1c\F8Ҟ\87\87)y\CBfr;\EA\F6+\DFk^n\8E\B0 \AB\B1[\9B\994\9B\9F\E1k\D8h4~Q\DF\00\00\00\00\00