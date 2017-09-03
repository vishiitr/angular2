--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

-- Started on 2017-09-03 16:12:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2410 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 238 (class 1255 OID 24605)
-- Name: trgrfn_create_bookmark_permissions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION trgrfn_create_bookmark_permissions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO feature_permission (feature_id, permission_id)
select NEW.id, id
from permission_type;
RETURN NULL;
END
$$;


ALTER FUNCTION public.trgrfn_create_bookmark_permissions() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 24606)
-- Name: update_role_features_permissions(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_role_features_permissions(features_permissions text, crnt_role_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
   DECLARE
   	status integer = 1;          
   BEGIN
      delete from role_feature_permission where role_id = crnt_role_id;
      insert into role_feature_permission (role_id, feature_permission_id)
      select crnt_role_id, CAST(coalesce(feature_permission_id, '0') AS integer) 
      from regexp_split_to_table(features_permissions, ',') feature_permission_id 
      where char_length(feature_permission_id) > 0;
      status = 0;
      RETURN status;
   END; $$;


ALTER FUNCTION public.update_role_features_permissions(features_permissions text, crnt_role_id integer) OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 24746)
-- Name: channel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE channel_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE channel_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 222 (class 1259 OID 24791)
-- Name: channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE channel (
    "Id" integer DEFAULT nextval('channel_id_seq'::regclass) NOT NULL,
    "Name" character varying(100) NOT NULL,
    "Description" character varying(200),
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE channel OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 24705)
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE department_id_seq
    START WITH 10
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE department_id_seq OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 24707)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE department (
    id integer DEFAULT nextval('department_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(250),
    enabled bit(1) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE department OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 24607)
-- Name: seq_bookmark_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_bookmark_id
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_bookmark_id OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 24609)
-- Name: feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE feature (
    id integer DEFAULT nextval('seq_bookmark_id'::regclass) NOT NULL,
    title character varying(100) NOT NULL,
    description character varying(250),
    last_update time without time zone DEFAULT now()
);


ALTER TABLE feature OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 24614)
-- Name: seq_bookmark_permission_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_bookmark_permission_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_bookmark_permission_id OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 24616)
-- Name: feature_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE feature_permission (
    feature_id integer NOT NULL,
    permission_id integer NOT NULL,
    last_update time without time zone DEFAULT now() NOT NULL,
    id integer DEFAULT nextval('seq_bookmark_permission_id'::regclass) NOT NULL
);


ALTER TABLE feature_permission OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 24748)
-- Name: guest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE guest_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE guest_id_seq OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24797)
-- Name: guest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE guest (
    "Id" bigint DEFAULT nextval('guest_id_seq'::regclass) NOT NULL,
    "Name" character varying(100) NOT NULL,
    "Email" character varying(50),
    "Address" character varying(200),
    "MiscDetails" character varying(250),
    "Phone" character varying(15),
    "Last_Updated" time without time zone NOT NULL,
    "Date_Created" time without time zone NOT NULL
);


ALTER TABLE guest OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24772)
-- Name: investigation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE investigation_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE investigation_id_seq OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 24927)
-- Name: investigation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE investigation (
    "Id" bigint DEFAULT nextval('investigation_id_seq'::regclass) NOT NULL,
    "AssignedPersonId" bigint,
    "ProblemId" bigint,
    "Status" integer,
    "Reason" character varying(2000),
    "Resolution" character varying(2000),
    "SupervisorFeedback" character varying(2000),
    "SupervisorId" bigint,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE investigation OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24776)
-- Name: investigation_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE investigation_status_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE investigation_status_id_seq OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 24906)
-- Name: investigation_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE investigation_status (
    "Id" integer DEFAULT nextval('investigation_status_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "IsEnabled" integer,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE investigation_status OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 24744)
-- Name: language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE language_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE language_id_seq OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24785)
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE language (
    "Id" integer DEFAULT nextval('language_id_seq'::regclass) NOT NULL,
    "Name" character varying(50) NOT NULL,
    "Code" character(5) NOT NULL,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE language OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 24621)
-- Name: seq_permission_type_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_permission_type_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_permission_type_id OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 24623)
-- Name: permission_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE permission_type (
    id integer DEFAULT nextval('seq_permission_type_id'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(250),
    enabled bit(1) DEFAULT B'1'::"bit" NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE permission_type OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24768)
-- Name: problem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problem_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problem_id_seq OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24915)
-- Name: problem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE problem (
    "Id" bigint DEFAULT nextval('problem_id_seq'::regclass) NOT NULL,
    "ReviewId" bigint,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "Category" integer,
    "Status" integer,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE problem OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24766)
-- Name: problem_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problem_category_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problem_category_id_seq OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24881)
-- Name: problem_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE problem_category (
    "Id" integer DEFAULT nextval('problem_category_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "Enabled" integer,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE problem_category OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24770)
-- Name: problem_investigation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problem_investigation_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problem_investigation_id_seq OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 24890)
-- Name: problem_investigation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE problem_investigation (
    "Id" bigint DEFAULT nextval('problem_investigation_id_seq'::regclass) NOT NULL,
    "ProblemId" bigint,
    "InvestigationId" bigint,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE problem_investigation OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24774)
-- Name: problem_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problem_status_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problem_status_id_seq OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24897)
-- Name: problem_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE problem_status (
    "Id" integer DEFAULT nextval('problem_status_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "IsEnabled" integer,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE problem_status OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 24742)
-- Name: property_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE property_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE property_id_seq OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24778)
-- Name: property; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE property (
    "Id" integer DEFAULT nextval('property_id_seq'::regclass) NOT NULL,
    "Name" character varying(100) NOT NULL,
    "Address" character varying(200),
    "Date_Created" timestamp without time zone NOT NULL,
    "Last_Updated" timestamp without time zone NOT NULL
);


ALTER TABLE property OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 24750)
-- Name: reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE reservation_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE reservation_id_seq OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24806)
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE reservation (
    "Id" bigint DEFAULT nextval('reservation_id_seq'::regclass) NOT NULL,
    "ConfirmationNumber" character varying(50),
    "MiscDetails" character varying(100),
    "GuestId" bigint,
    "Last_Updated" time without time zone NOT NULL,
    "Date_Created" time without time zone NOT NULL
);


ALTER TABLE reservation OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 24754)
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE review_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_id_seq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24830)
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE review (
    "Id" bigint DEFAULT nextval('review_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000) NOT NULL,
    "Description" character varying(2000) NOT NULL,
    "TranslatedTitle" character varying(1000),
    "TranslatedDesc" character varying(2000),
    "Status" integer NOT NULL,
    "Rating" numeric,
    "Type" integer,
    "PostedDate" time without time zone,
    "ChannelId" integer,
    "Score" numeric,
    "LanguageId" integer,
    "PropertyId" integer,
    "ReferenceNumber" character varying(100),
    "CreatedBy" bigint,
    "AssignedTo" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL,
    "ReservationId" bigint
);


ALTER TABLE review OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 24758)
-- Name: review_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE review_comment_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_comment_id_seq OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24845)
-- Name: review_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE review_comment (
    "Id" bigint DEFAULT nextval('review_comment_id_seq'::regclass) NOT NULL,
    "ReviewId" bigint,
    "Details" character varying(2000),
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE review_comment OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 24760)
-- Name: review_response_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE review_response_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_response_id_seq OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24854)
-- Name: review_response; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE review_response (
    "Id" bigint DEFAULT nextval('review_response_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "ReviewId" bigint,
    "IsPosted" integer,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE review_response OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 24764)
-- Name: review_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE review_status_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_status_id_seq OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 24872)
-- Name: review_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE review_status (
    "Id" integer DEFAULT nextval('review_status_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE review_status OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 24756)
-- Name: review_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE review_translation_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_translation_id_seq OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24839)
-- Name: review_translation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE review_translation (
    "Id" bigint DEFAULT nextval('review_translation_id_seq'::regclass) NOT NULL,
    "ReviewId" bigint,
    "TranslationId" bigint,
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE review_translation OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24762)
-- Name: review_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE review_type_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_type_id_seq OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24863)
-- Name: review_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE review_type (
    "Id" integer DEFAULT nextval('review_type_id_seq'::regclass) NOT NULL,
    "Title" character varying(1000),
    "Description" character varying(2000),
    "CreatedBy" bigint,
    "Last_Updated" timestamp without time zone NOT NULL,
    "Date_Created" timestamp without time zone NOT NULL
);


ALTER TABLE review_type OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 24629)
-- Name: seq_role_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_role_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_role_id OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 24631)
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE role (
    id integer DEFAULT nextval('seq_role_id'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(250),
    enabled bit(1) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE role OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 24636)
-- Name: seq_role_bookmark_permission_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_role_bookmark_permission_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_role_bookmark_permission_id OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 24638)
-- Name: role_feature_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE role_feature_permission (
    role_id integer DEFAULT nextval('seq_role_bookmark_permission_id'::regclass) NOT NULL,
    feature_permission_id integer NOT NULL,
    last_update time without time zone DEFAULT now(),
    id integer NOT NULL
);


ALTER TABLE role_feature_permission OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 24643)
-- Name: role_feature_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role_feature_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_feature_permission_id_seq OWNER TO postgres;

--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 195
-- Name: role_feature_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role_feature_permission_id_seq OWNED BY role_feature_permission.id;


--
-- TOC entry 196 (class 1259 OID 24645)
-- Name: seq_user_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_user_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_user_id OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 24752)
-- Name: translation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE translation_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE translation_id_seq OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24812)
-- Name: translation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE translation (
    "Id" bigint DEFAULT nextval('translation_id_seq'::regclass) NOT NULL,
    "FromLanguageId" integer NOT NULL,
    "ToLanguageId" integer NOT NULL,
    "OriginalText" character varying(2000) NOT NULL,
    "TranslatedText" character varying(2000) NOT NULL,
    "IsDone" integer,
    "Last_Updated" time without time zone NOT NULL,
    "Date_Created" time without time zone NOT NULL
);


ALTER TABLE translation OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 24647)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    id bigint DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
    "Name" character varying(100) NOT NULL,
    login_id character varying(100) NOT NULL,
    password character varying(50) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL,
    email_id character varying(100) NOT NULL,
    departmentid integer
);


ALTER TABLE users OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 24652)
-- Name: users_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_role (
    user_id bigint NOT NULL,
    role_id integer NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL
);


ALTER TABLE users_role OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 24656)
-- Name: users_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_role_id_seq OWNER TO postgres;

--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 199
-- Name: users_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_role_id_seq OWNED BY users_role.id;


--
-- TOC entry 2178 (class 2604 OID 24658)
-- Name: role_feature_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role_feature_permission ALTER COLUMN id SET DEFAULT nextval('role_feature_permission_id_seq'::regclass);


--
-- TOC entry 2182 (class 2604 OID 24659)
-- Name: users_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_role ALTER COLUMN id SET DEFAULT nextval('users_role_id_seq'::regclass);


--
-- TOC entry 2204 (class 2606 OID 24661)
-- Name: feature PK_feature; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature
    ADD CONSTRAINT "PK_feature" PRIMARY KEY (id);


--
-- TOC entry 2206 (class 2606 OID 24663)
-- Name: feature_permission PK_feature_permission; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_permission
    ADD CONSTRAINT "PK_feature_permission" PRIMARY KEY (id);


--
-- TOC entry 2208 (class 2606 OID 24665)
-- Name: feature_permission UNQ_feature_permisslon; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_permission
    ADD CONSTRAINT "UNQ_feature_permisslon" UNIQUE (feature_id, permission_id);


--
-- TOC entry 2226 (class 2606 OID 24796)
-- Name: channel channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY channel
    ADD CONSTRAINT channel_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2220 (class 2606 OID 24713)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- TOC entry 2228 (class 2606 OID 25125)
-- Name: guest guest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY guest
    ADD CONSTRAINT guest_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2256 (class 2606 OID 24935)
-- Name: investigation investigation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY investigation
    ADD CONSTRAINT investigation_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2252 (class 2606 OID 25110)
-- Name: investigation_status investigation_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY investigation_status
    ADD CONSTRAINT investigation_status_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2224 (class 2606 OID 24790)
-- Name: language language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2210 (class 2606 OID 24667)
-- Name: permission_type permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permission_type
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);


--
-- TOC entry 2246 (class 2606 OID 25068)
-- Name: problem_category problem_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_category
    ADD CONSTRAINT problem_category_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2248 (class 2606 OID 24895)
-- Name: problem_investigation problem_investigation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_investigation
    ADD CONSTRAINT problem_investigation_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2254 (class 2606 OID 24923)
-- Name: problem problem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem
    ADD CONSTRAINT problem_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2250 (class 2606 OID 25053)
-- Name: problem_status problem_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_status
    ADD CONSTRAINT problem_status_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2222 (class 2606 OID 24783)
-- Name: property property_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY property
    ADD CONSTRAINT property_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2230 (class 2606 OID 24811)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2238 (class 2606 OID 24853)
-- Name: review_comment review_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_comment
    ADD CONSTRAINT review_comment_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2234 (class 2606 OID 24838)
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2240 (class 2606 OID 24862)
-- Name: review_response review_response_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_response
    ADD CONSTRAINT review_response_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2244 (class 2606 OID 25165)
-- Name: review_status review_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_status
    ADD CONSTRAINT review_status_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2236 (class 2606 OID 24844)
-- Name: review_translation review_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_translation
    ADD CONSTRAINT review_translation_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2242 (class 2606 OID 25150)
-- Name: review_type review_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_type
    ADD CONSTRAINT review_type_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2214 (class 2606 OID 24669)
-- Name: role_feature_permission role_feature_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role_feature_permission
    ADD CONSTRAINT role_feature_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 2212 (class 2606 OID 24671)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 2232 (class 2606 OID 24820)
-- Name: translation translation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY translation
    ADD CONSTRAINT translation_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2216 (class 2606 OID 25083)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2218 (class 2606 OID 24675)
-- Name: users_role users_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_role
    ADD CONSTRAINT users_role_pkey PRIMARY KEY (id);


--
-- TOC entry 2286 (class 2620 OID 24676)
-- Name: feature trgr_create_bookmark_permissions; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trgr_create_bookmark_permissions AFTER INSERT ON feature FOR EACH ROW EXECUTE PROCEDURE trgrfn_create_bookmark_permissions();


--
-- TOC entry 2257 (class 2606 OID 24677)
-- Name: feature_permission FK1_feature_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_permission
    ADD CONSTRAINT "FK1_feature_permission" FOREIGN KEY (feature_id) REFERENCES feature(id);


--
-- TOC entry 2259 (class 2606 OID 24682)
-- Name: role_feature_permission FK1_role_feature_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role_feature_permission
    ADD CONSTRAINT "FK1_role_feature_permission" FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE;


--
-- TOC entry 2258 (class 2606 OID 24687)
-- Name: feature_permission FK2_feature_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feature_permission
    ADD CONSTRAINT "FK2_feature_permission" FOREIGN KEY (permission_id) REFERENCES permission_type(id);


--
-- TOC entry 2260 (class 2606 OID 24692)
-- Name: role_feature_permission FK2_role_feature_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role_feature_permission
    ADD CONSTRAINT "FK2_role_feature_permission" FOREIGN KEY (feature_permission_id) REFERENCES feature_permission(id);


--
-- TOC entry 2262 (class 2606 OID 25138)
-- Name: users_role FK_users_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_role
    ADD CONSTRAINT "FK_users_role" FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2261 (class 2606 OID 24714)
-- Name: users fk_user_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_user_department FOREIGN KEY (departmentid) REFERENCES department(id);


--
-- TOC entry 2285 (class 2606 OID 25111)
-- Name: investigation investigation_investigationStatusId_FKey3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY investigation
    ADD CONSTRAINT "investigation_investigationStatusId_FKey3" FOREIGN KEY ("Status") REFERENCES investigation_status("Id");


--
-- TOC entry 2282 (class 2606 OID 25001)
-- Name: investigation investigation_problemId_FKey2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY investigation
    ADD CONSTRAINT "investigation_problemId_FKey2" FOREIGN KEY ("ProblemId") REFERENCES problem("Id");


--
-- TOC entry 2283 (class 2606 OID 25089)
-- Name: investigation investigation_userId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY investigation
    ADD CONSTRAINT "investigation_userId_FKey1" FOREIGN KEY ("AssignedPersonId") REFERENCES users(id);


--
-- TOC entry 2284 (class 2606 OID 25094)
-- Name: investigation investigation_userId_FKey4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY investigation
    ADD CONSTRAINT "investigation_userId_FKey4" FOREIGN KEY ("SupervisorId") REFERENCES users(id);


--
-- TOC entry 2278 (class 2606 OID 24991)
-- Name: problem_investigation problemInvestigation_investigationId_FKey2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_investigation
    ADD CONSTRAINT "problemInvestigation_investigationId_FKey2" FOREIGN KEY ("InvestigationId") REFERENCES investigation("Id");


--
-- TOC entry 2277 (class 2606 OID 24986)
-- Name: problem_investigation problemInvestigation_problemId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_investigation
    ADD CONSTRAINT "problemInvestigation_problemId_FKey1" FOREIGN KEY ("ProblemId") REFERENCES problem("Id");


--
-- TOC entry 2279 (class 2606 OID 24971)
-- Name: problem problem_ReviewId_Fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem
    ADD CONSTRAINT "problem_ReviewId_Fkey1" FOREIGN KEY ("ReviewId") REFERENCES review("Id");


--
-- TOC entry 2281 (class 2606 OID 25069)
-- Name: problem problem_problemCategoryId_Fkey2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem
    ADD CONSTRAINT "problem_problemCategoryId_Fkey2" FOREIGN KEY ("Category") REFERENCES problem_category("Id");


--
-- TOC entry 2280 (class 2606 OID 25054)
-- Name: problem problem_problemStatusId_Fkey3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem
    ADD CONSTRAINT "problem_problemStatusId_Fkey3" FOREIGN KEY ("Status") REFERENCES problem_status("Id");


--
-- TOC entry 2263 (class 2606 OID 25126)
-- Name: reservation reservation_guestId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reservation
    ADD CONSTRAINT "reservation_guestId_FKey1" FOREIGN KEY ("GuestId") REFERENCES guest("Id");


--
-- TOC entry 2275 (class 2606 OID 24956)
-- Name: review_comment reviewComment_ReviewId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_comment
    ADD CONSTRAINT "reviewComment_ReviewId_FKey1" FOREIGN KEY ("ReviewId") REFERENCES review("Id");


--
-- TOC entry 2276 (class 2606 OID 24951)
-- Name: review_response reviewResponse_ReviewId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_response
    ADD CONSTRAINT "reviewResponse_ReviewId_FKey1" FOREIGN KEY ("ReviewId") REFERENCES review("Id");


--
-- TOC entry 2273 (class 2606 OID 24961)
-- Name: review_translation reviewTranslation_reviewId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_translation
    ADD CONSTRAINT "reviewTranslation_reviewId_FKey1" FOREIGN KEY ("ReviewId") REFERENCES review("Id");


--
-- TOC entry 2274 (class 2606 OID 24966)
-- Name: review_translation reviewTranslation_translationId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review_translation
    ADD CONSTRAINT "reviewTranslation_translationId_FKey1" FOREIGN KEY ("TranslationId") REFERENCES translation("Id");


--
-- TOC entry 2266 (class 2606 OID 25026)
-- Name: review review_channelId_FKey3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_channelId_FKey3" FOREIGN KEY ("ChannelId") REFERENCES channel("Id");


--
-- TOC entry 2267 (class 2606 OID 25031)
-- Name: review review_languageId_FKey4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_languageId_FKey4" FOREIGN KEY ("LanguageId") REFERENCES language("Id");


--
-- TOC entry 2268 (class 2606 OID 25036)
-- Name: review review_propertyId_FKey5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_propertyId_FKey5" FOREIGN KEY ("PropertyId") REFERENCES property("Id");


--
-- TOC entry 2269 (class 2606 OID 25046)
-- Name: review review_reservationId_FKey7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_reservationId_FKey7" FOREIGN KEY ("ReservationId") REFERENCES reservation("Id");


--
-- TOC entry 2272 (class 2606 OID 25166)
-- Name: review review_reviewStatusId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_reviewStatusId_FKey1" FOREIGN KEY ("Status") REFERENCES review_status("Id");


--
-- TOC entry 2271 (class 2606 OID 25151)
-- Name: review review_reviewType_FKey2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_reviewType_FKey2" FOREIGN KEY ("Type") REFERENCES review_type("Id");


--
-- TOC entry 2270 (class 2606 OID 25099)
-- Name: review review_userId_FKey6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "review_userId_FKey6" FOREIGN KEY ("AssignedTo") REFERENCES users(id);


--
-- TOC entry 2264 (class 2606 OID 24941)
-- Name: translation translation_FromlanguageId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY translation
    ADD CONSTRAINT "translation_FromlanguageId_FKey1" FOREIGN KEY ("FromLanguageId") REFERENCES language("Id");


--
-- TOC entry 2265 (class 2606 OID 24946)
-- Name: translation translation_ToLanguageId_FKey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY translation
    ADD CONSTRAINT "translation_ToLanguageId_FKey1" FOREIGN KEY ("ToLanguageId") REFERENCES language("Id");


-- Completed on 2017-09-03 16:12:05

--
-- PostgreSQL database dump complete
--

