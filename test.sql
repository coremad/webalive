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
-- Name: headers_list; Type: VIEW; Schema: public; Owner: madcore
--

CREATE VIEW public.headers_list AS
 SELECT hn.name,
    hv.val,
    h.log_id
   FROM ((public.headers h
     JOIN public.header_names hn ON ((hn.id = h.hn_id)))
     JOIN public.header_values hv ON ((hv.id = h.hv_id)));


ALTER TABLE public.headers_list OWNER TO madcore;

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
-- Name: logs_list; Type: VIEW; Schema: public; Owner: madcore
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


ALTER TABLE public.logs_list OWNER TO madcore;

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
-- Data for Name: header_names; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.header_names (id, name) FROM stdin;
29294	cf-ray
29295	expires
29312	last-modified
29314	etag
29329	vary
29338	cf-cache-status
29343	strict-transport-security
29347	pragma
29368	accept-ranges
29255	content-language
29256	set-cookie
29257	location
29258	x-frame-options
29260	x-xss-protection
29261	x-content-type-options
29262	content-type
29263	report-to
29264	keep-alive
29266	date
29267	cache-control
29268	server
29269	nel
29272	alt-svc
29277	content-length
29278	connection
29282	content-security-policy-report-only
29284	link
29287	upgrade
\.


--
-- Data for Name: header_values; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.header_values (id, val) FROM stdin;
27703	["Sun, 20 Nov 2022 05:04:23 GMT"]
27704	["nosniff","nosniff"]
27706	[5586]
27709	["76cea4fffeb1b98c-AMS"]
27710	["Thu, 01 Jan 1970 00:00:01 GMT"]
27711	["https://names.com/LOL.com"]
27716	["Sat, 19 Nov 2022 09:04:23 GMT"]
27718	["228"]
27719	["CSRF_TOKEN=NXAD2U6IS+tnVLCVwWfBdA==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:04:23 GMT; Path=/","JSESSIONID=33769A48E3B5E0706CB76FA2E87A2AB6; Path=/; Secure; HttpOnly"]
27723	["118"]
27724	["max-age=43200"]
27725	["Sun, 20 Nov 2022 05:04:48 GMT"]
27727	["Sun, 29 May 2022 08:46:26 GMT"]
27728	["Apache"]
27729	["\\"1ea09d0-32f5-5e02293346f3c-gzip\\""]
27733	["QRATOR"]
27734	["CSRF_TOKEN=dn+E+5q42obxEvWBJ2YyPg==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:06:30 GMT; Path=/","CSRF_TOKEN=PUdfzFJnLrzTO+AjbgxSvg==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:06:30 GMT; Path=/","CSRF_TOKEN=DOcnvCrA1Z0wnD1+xgJdRQ==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:06:30 GMT; Path=/","JSESSIONID=B20397D21A99D7FD30CF7065B5D5FEE3; Path=/; Secure; HttpOnly"]
27737	["ghs"]
27738	["0"]
27740	["spravka=dD0xNjM3Mzg0NzkwO2k9MzEuMTMwLjc4LjQ0O0Q9QjA4OTFDMUJGNEZGMEJFMTA0M0M5REJBN0Q0NEU3RUFERDVBMTZGOUZENTI0QUVDOTI5OTgzQkZEQTJGMzUxNkVFM0MzMUVEO3U9MTYzNzM4NDc5MDU2MTM2MzE1NztoPTU3MDFhN2MzMWM2OGIzYWUxOTZhMTE3Y2M1YWYxNmEx; domain=.ya.ru; path=/; expires=Tue, 20-Dec-2022 05:06:30 GMT","i=5kWLJKDBz3rPPX6kH6SD2QCr8SY7TpfkB5XqVDrWGOsMsfG0kN3/CPAL0gvDdnqMRgdTwKAf8U9VYEZTESKsSsrRkYw=; Expires=Tue, 19-Nov-2024 05:06:30 GMT; Domain=.ya.ru; Path=/; Secure; HttpOnly"]
27741	["https://ya.ru/showcaptcha?cc=1&mt=F2E5024123A69AE78B7C123062DAD1AF239258C1313E933DAC83E66452096FA63CE9&retpath=aHR0cHM6Ly95YS5ydS8__eb0758ddc477ac638ea8d2335a983286&t=2/1668920790/098390931a9bedee8e601208e86ee92b&u=abbd756-7e37ba13-2cd67979-50fb79dc&s=095f0f633ed3b9b83f46e94688e6ec21"]
27744	["Accept-Encoding"]
27748	["Sun, 20 Nov 2022 05:06:30 GMT"]
27753	["DYNAMIC"]
27754	["text/html; charset=UTF-8"]
27757	["DENY"]
27758	["max-age=7776000"]
27759	["private"]
27761	["no-store, no-cache, must-revalidate"]
27762	["no-cache"]
27768	["Sun, 20 Nov 2022 05:08:16 GMT"]
27772	["https://ya.ru/showcaptcha?cc=1&mt=994D71A8A2D7DC7F9DF8E5964771E9432F01B1434071A799C355EF14808CA4367AD9&retpath=aHR0cHM6Ly95YS5ydS8__eb0758ddc477ac638ea8d2335a983286&t=2/1668920896/4de57519db181767ce5a2e17730d9a4b&u=6daec91f-aceaeda1-2c96f51-33065a93&s=bb79faf287b56c4b7ee5e02352d178b9"]
27779	["Sun, 20 Nov 2022 05:08:17 GMT"]
27782	["text/html"]
27783	["bytes"]
27784	["https://www.wtf.com/"]
27787	["Sun, 20 Nov 2022 05:08:15 GMT"]
27789	[36373]
27790	["Sun, 20 Nov 2022 05:08:42 GMT"]
27793	["Thu, 19 Nov 1981 08:52:00 GMT"]
27794	["nginx"]
27670	["ru"]
27671	["CSRF_TOKEN=Ogzzy8UiMaBRIQhF6i0CMw==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:02:22 GMT; Path=/","CSRF_TOKEN=NUtpRr/WudpYcEcoMaHztA==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:02:22 GMT; Path=/","CSRF_TOKEN=wrnrm7zW1S/8jy5K0YNPUA==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:02:22 GMT; Path=/","JSESSIONID=7FFDB7705A08657F6F7ED9AF0B780E51; Path=/; Secure; HttpOnly"]
27672	["https://ya.ru/showcaptcha?cc=1&mt=7D90EFAA2163A7303D1E73E459E2DB2C2B5B613F16A425C9B6FC4A4AB8C33D4C3A96&retpath=aHR0cHM6Ly95YS5ydS8__eb0758ddc477ac638ea8d2335a983286&t=2/1668920542/69dff2131db78121bf7dc82402804ce9&u=4a61fe30-aa35bee8-17e9125c-fba81f6f&s=49f7b0cc37dc716c79ad6610d44668e3"]
27673	["DENY","SAMEORIGIN"]
27674	["SAMEORIGIN"]
27675	["1; mode=block"]
27676	["nosniff"]
27677	["text/html;charset=utf-8"]
27678	["{ \\"group\\": \\"network-errors\\", \\"max_age\\": 100, \\"endpoints\\": [{\\"url\\": \\"https://dr.yandex.net/nel\\", \\"priority\\": 1}, {\\"url\\": \\"https://dr2.yandex.net/nel\\", \\"priority\\": 2}]}"]
27679	["timeout=15"]
27680	["https://www.youtube.com/lolflix"]
27681	["Sun, 20 Nov 2022 05:02:22 GMT"]
27682	["max-age=604800"]
27683	["cloudflare"]
27684	["{\\"success_fraction\\":0,\\"report_to\\":\\"cf-nel\\",\\"max_age\\":604800}"]
27686	["private, max-age=0, no-store, no-cache, must-revalidate, post-check=0, pre-check=0"]
27687	["h3=\\":443\\"; ma=86400, h3-29=\\":443\\"; ma=86400"]
27689	["CSRF_TOKEN=bT/a2CGevtZpJZYveE33lw==; Max-Age=64281600; Expires=Tue, 03-Dec-2024 05:02:23 GMT; Path=/","JSESSIONID=42806352ADFAB1283D97408B96AE08B2; Path=/; Secure; HttpOnly"]
27691	["nginx/1.12.2"]
27692	["21349"]
27693	["keep-alive"]
27694	["Sun, 20 Nov 2022 05:02:23 GMT"]
27696	["awselb/2.0"]
27697	["frame-ancestors 'self' metrika.yandex.ru mc.yandex.ru http://webvisor.com; frame-src *.youtube.com vk.com https: blob: mc.yandex.ru jivosite.com; report-uri /csp-report;"]
27699	["<https://sevstar.net/wp-json/>; rel=\\"https://api.w.org/\\"","<https://sevstar.net/wp-json/wp/v2/pages/11313>; rel=\\"alternate\\"; type=\\"application/json\\"","<https://sevstar.net/>; rel=shortlink"]
27700	[13045]
27701	["Upgrade"]
27702	["h2,h2c"]
\.


--
-- Data for Name: headers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.headers (id, log_id, hn_id, hv_id) FROM stdin;
27060	10529	29255	27670
27061	10530	29256	27671
27062	10531	29257	27672
27063	10529	29258	27673
27064	10532	29258	27674
27065	10530	29260	27675
27066	10531	29261	27676
27067	10529	29262	27677
27068	10531	29263	27678
27069	10530	29264	27679
27070	10532	29257	27680
27071	10532	29266	27681
27072	10533	29267	27682
27073	10534	29268	27683
27074	10534	29269	27684
27075	10533	29268	27683
27076	10534	29267	27686
27077	10533	29272	27687
27078	10536	29260	27675
27079	10536	29256	27689
27080	10536	29264	27679
27081	10537	29268	27691
27082	10537	29277	27692
27083	10537	29278	27693
27084	10538	29266	27694
27085	10538	29278	27693
27086	10538	29268	27696
27087	10539	29282	27697
27088	10539	29258	27674
27089	10539	29284	27699
27090	10540	29277	27700
27091	10540	29278	27701
27092	10540	29287	27702
27093	10542	29266	27703
27094	10542	29261	27704
27095	10543	29266	27703
27096	10542	29277	27706
27097	10543	29258	27674
27098	10543	29257	27680
27099	10544	29294	27709
27100	10544	29295	27710
27101	10544	29257	27711
27102	10545	29263	27678
27103	10545	29261	27676
27104	10545	29266	27703
27105	10547	29264	27679
27106	10547	29295	27716
27107	10548	29278	27693
27108	10548	29277	27718
27109	10547	29256	27719
27110	10548	29266	27703
27111	10549	29268	27696
27112	10549	29278	27693
27113	10549	29277	27723
27114	10550	29267	27724
27115	10550	29266	27725
27116	10550	29278	27693
27117	10551	29312	27727
27118	10551	29268	27728
27119	10551	29314	27729
27120	10552	29284	27699
27121	10552	29258	27674
27122	10552	29282	27697
27123	10554	29268	27733
27124	10554	29256	27734
27125	10555	29257	27680
27126	10554	29278	27693
27127	10555	29268	27737
27128	10555	29260	27738
27129	10556	29263	27678
27130	10556	29256	27740
27131	10556	29257	27741
27132	10557	29295	27710
27133	10557	29278	27693
27134	10557	29329	27744
27135	10558	29268	27728
27136	10558	29329	27744
27137	10558	29278	27701
27138	10559	29266	27748
27139	10559	29277	27723
27140	10559	29268	27696
27141	10561	29267	27682
27142	10561	29266	27748
27143	10561	29338	27753
27144	10562	29262	27754
27145	10562	29267	27724
27146	10562	29277	27692
27147	10563	29258	27757
27148	10563	29343	27758
27149	10563	29267	27759
27150	10564	29266	27748
27151	10564	29267	27761
27152	10564	29347	27762
27153	10566	29261	27704
27154	10566	29262	27677
27155	10566	29264	27679
27156	10567	29268	27737
27157	10567	29258	27674
27158	10567	29266	27768
27159	10568	29255	27670
27160	10568	29258	27673
27161	10568	29262	27677
27162	10569	29257	27772
27163	10569	29261	27676
27164	10569	29263	27678
27165	10570	29267	27686
27166	10570	29277	27738
27167	10570	29269	27684
27168	10571	29277	27700
27169	10572	29266	27779
27170	10572	29278	27693
27171	10571	29312	27727
27172	10572	29262	27782
27173	10571	29368	27783
27174	10573	29257	27784
27175	10573	29338	27753
27176	10573	29268	27683
27177	10574	29312	27787
27178	10574	29267	27759
27179	10574	29277	27789
27180	10576	29266	27790
27181	10576	29278	27693
27182	10576	29262	27754
27183	10577	29295	27793
27184	10577	29268	27794
27185	10577	29347	27762
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.logs (id, url_id, date, status) FROM stdin;
10531	3	2022-11-20 08:02:22.818334	302
10532	184	2022-11-20 08:02:22.820568	302
10533	46	2022-11-20 08:02:23.005013	301
10534	39	2022-11-20 08:02:23.066498	302
10535	6	2022-11-20 08:02:23.068805	\N
10536	2	2022-11-20 08:02:23.176553	200
10537	45	2022-11-20 08:02:23.259925	200
10538	47	2022-11-20 08:02:23.405486	403
10539	1	2022-11-20 08:02:23.571834	200
10540	44	2022-11-20 08:02:23.610341	200
10541	61	2022-11-20 08:02:32.901891	\N
10543	184	2022-11-20 08:04:23.009684	302
10544	39	2022-11-20 08:04:23.079702	302
10545	3	2022-11-20 08:04:23.095274	302
10546	6	2022-11-20 08:04:23.125511	\N
10547	2	2022-11-20 08:04:23.250149	200
10548	46	2022-11-20 08:04:23.263034	301
10549	47	2022-11-20 08:04:23.387486	403
10550	45	2022-11-20 08:04:23.452564	200
10551	44	2022-11-20 08:04:23.710953	200
10552	1	2022-11-20 08:04:23.81869	200
10553	61	2022-11-20 08:04:33.081992	\N
10555	184	2022-11-20 08:06:30.561473	302
10556	3	2022-11-20 08:06:30.586281	302
10557	39	2022-11-20 08:06:30.612136	302
10558	44	2022-11-20 08:06:30.851293	200
10559	47	2022-11-20 08:06:30.879902	403
10560	6	2022-11-20 08:06:30.984891	\N
10561	46	2022-11-20 08:06:31.009931	301
10562	45	2022-11-20 08:06:31.026364	200
10563	2	2022-11-20 08:06:31.092964	200
10564	1	2022-11-20 08:06:31.391	200
10565	61	2022-11-20 08:06:40.625658	\N
10566	189	2022-11-20 08:06:57.589849	404
10567	184	2022-11-20 08:08:16.765269	302
10568	189	2022-11-20 08:08:16.775787	404
10569	3	2022-11-20 08:08:16.808722	302
10570	39	2022-11-20 08:08:16.859469	302
10571	44	2022-11-20 08:08:17.125054	200
10572	47	2022-11-20 08:08:17.128089	403
10573	46	2022-11-20 08:08:17.239105	301
10574	2	2022-11-20 08:08:17.356613	200
10575	6	2022-11-20 08:08:17.433672	\N
10576	45	2022-11-20 08:08:17.448619	200
10577	1	2022-11-20 08:08:17.473797	200
10578	61	2022-11-20 08:08:26.822566	\N
\.


--
-- Data for Name: observables; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.observables (id, url, enabled) FROM stdin;
1	https://sevstar.net	t
3	https://ya.ru	t
2	https://www.linux.org.ru	t
6	https://twitter.com/	t
39	lol.com	t
44	kek.com	t
45	lolkek.ru	t
46	wtf.com	t
47	new.com	t
61	sql.ru	t
184	lol1.com	t
189	https://www.linux.org.ru/3	t
\.


--
-- Name: header_names_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.header_names_id_seq', 29380, true);


--
-- Name: header_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.header_values_id_seq', 27795, true);


--
-- Name: headers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.headers_id_seq', 27185, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.logs_id_seq', 10578, true);


--
-- Name: observables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.observables_id_seq', 189, true);


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

