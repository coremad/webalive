--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: header_names; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.header_names (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.header_names OWNER TO admin;

--
-- Name: header_names_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.header_names_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.header_names_id_seq OWNER TO admin;

--
-- Name: header_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.header_names_id_seq OWNED BY public.header_names.id;


--
-- Name: header_values; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.header_values (
    id integer NOT NULL,
    val character varying NOT NULL
);


ALTER TABLE public.header_values OWNER TO admin;

--
-- Name: header_values_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.header_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.header_values_id_seq OWNER TO admin;

--
-- Name: header_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.header_values_id_seq OWNED BY public.header_values.id;


--
-- Name: headers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.headers (
    id integer NOT NULL,
    log_id integer NOT NULL,
    hn_id integer NOT NULL,
    hv_id integer NOT NULL
);


ALTER TABLE public.headers OWNER TO admin;

--
-- Name: headers_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.headers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.headers_id_seq OWNER TO admin;

--
-- Name: headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.headers_id_seq OWNED BY public.headers.id;


--
-- Name: headers_list; Type: VIEW; Schema: public; Owner: admin
--

CREATE VIEW public.headers_list AS
 SELECT hn.name,
    hv.val,
    h.log_id
   FROM ((public.headers h
     JOIN public.header_names hn ON ((hn.id = h.hn_id)))
     JOIN public.header_values hv ON ((hv.id = h.hv_id)));


ALTER TABLE public.headers_list OWNER TO admin;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    url_id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    status integer
);


ALTER TABLE public.logs OWNER TO admin;

--
-- Name: TABLE logs; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON TABLE public.logs IS '
';


--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_id_seq OWNER TO admin;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: observables; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.observables (
    id integer NOT NULL,
    url character varying(2048) NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.observables OWNER TO admin;

--
-- Name: TABLE observables; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON TABLE public.observables IS 'URL''s for check';


--
-- Name: logs_list; Type: VIEW; Schema: public; Owner: admin
--

CREATE VIEW public.logs_list AS
 SELECT DISTINCT ON (logs.url_id) logs.id,
    observables.url,
    logs.date,
    observables.enabled,
    logs.status,
    logs.url_id
   FROM (public.logs
     JOIN public.observables ON ((observables.id = logs.url_id)))
  ORDER BY logs.url_id DESC, logs.id DESC;


ALTER TABLE public.logs_list OWNER TO admin;

--
-- Name: observables_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.observables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.observables_id_seq OWNER TO admin;

--
-- Name: observables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.observables_id_seq OWNED BY public.observables.id;


--
-- Name: header_names id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.header_names ALTER COLUMN id SET DEFAULT nextval('public.header_names_id_seq'::regclass);


--
-- Name: header_values id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.header_values ALTER COLUMN id SET DEFAULT nextval('public.header_values_id_seq'::regclass);


--
-- Name: headers id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.headers ALTER COLUMN id SET DEFAULT nextval('public.headers_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: observables id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.observables ALTER COLUMN id SET DEFAULT nextval('public.observables_id_seq'::regclass);


--
-- Name: header_names header_names_name_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.header_names
    ADD CONSTRAINT header_names_name_key UNIQUE (name);


--
-- Name: header_names header_names_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.header_names
    ADD CONSTRAINT header_names_pkey PRIMARY KEY (id);


--
-- Name: header_values header_values_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.header_values
    ADD CONSTRAINT header_values_pkey PRIMARY KEY (id);


--
-- Name: header_values header_values_val_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.header_values
    ADD CONSTRAINT header_values_val_key UNIQUE (val);


--
-- Name: headers headers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.headers
    ADD CONSTRAINT headers_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: observables observables_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.observables
    ADD CONSTRAINT observables_pkey PRIMARY KEY (id);


--
-- Name: observables observables_url_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.observables
    ADD CONSTRAINT observables_url_key UNIQUE (url);


--
-- Name: headers fk_hn_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.headers
    ADD CONSTRAINT fk_hn_id FOREIGN KEY (hn_id) REFERENCES public.header_names(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: headers fk_hv_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.headers
    ADD CONSTRAINT fk_hv_id FOREIGN KEY (hv_id) REFERENCES public.header_values(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: logs fk_url_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT fk_url_id FOREIGN KEY (url_id) REFERENCES public.observables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--
