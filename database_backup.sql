--
-- PostgreSQL database dump
--

\restrict fdjN5y9ZhVSWa9LNwJskmKvWsfJCvSpodhR8b2SmYXfWeJhI5abJFkuOBbsOvPt

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_messages (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.contact_messages OWNER TO postgres;

--
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contact_messages_id_seq OWNER TO postgres;

--
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_messages_id_seq OWNED BY public.contact_messages.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    shipping_address text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    payment_method character varying(50) DEFAULT 'CASH_ON_DELIVERY'::character varying,
    payment_mode character varying(20) DEFAULT 'COD'::character varying NOT NULL,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'CONFIRMED'::character varying, 'SHIPPED'::character varying, 'DELIVERED'::character varying, 'CANCELLED'::character varying])::text[])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    brand character varying(100) NOT NULL,
    model_compatibility character varying(500),
    category character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    description text,
    image_url character varying(500),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT products_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT products_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(15),
    role character varying(20) DEFAULT 'CUSTOMER'::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['CUSTOMER'::character varying, 'ADMIN'::character varying])::text[])))
);

ALTER TABLE public.users 
ADD COLUMN address TEXT,
ADD COLUMN city VARCHAR(255),
ADD COLUMN state VARCHAR(255),
ADD COLUMN pincode VARCHAR(10),
ADD COLUMN change_password_token VARCHAR(255);

-- CREATE TABLE public.addresses (
--     address_id BIGSERIAL PRIMARY KEY,
--     street_address TEXT NOT NULL,
--     city VARCHAR(255) NOT NULL,
--     state VARCHAR(255) NOT NULL,
--     pincode VARCHAR(6),
--     user_id BIGINT NOT NULL UNIQUE,
--     CONSTRAINT fk_user FOREIGN KEY (user_id)
--         REFERENCES public.users(id)
--         ON DELETE CASCADE
-- );



ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: contact_messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_messages ALTER COLUMN id SET DEFAULT nextval('public.contact_messages_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_messages (id, name, email, subject, message, is_read, created_at) FROM stdin;
2	Samkit Chopda	samkit@gmail.com	About an enquiry for a Part	I want to make an enquiry for Petrol Tank my Scooty Pep+ i have checked on website but its not available	t	2026-03-12 15:16:00.441292
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, unit_price) FROM stdin;
15	15	3	1	2499.00
16	15	12	1	499.00
17	16	2	1	899.00
18	17	11	1	200.00
45	32	9	1	750.00
46	33	21	1	1399.00
47	34	11	1	200.00
48	34	19	1	1899.00
49	35	13	1	199.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, total_amount, status, shipping_address, created_at, updated_at, payment_method, payment_mode) FROM stdin;
16	6	1060.82	PENDING	Darshan\nSolapur\nSolapur, Maharashtra - 745821\nPhone: 8459951285	2026-03-10 23:33:45.923747	2026-03-10 23:33:45.923747	CASH_ON_DELIVERY	COD
15	6	3537.64	SHIPPED	Chota Don\n1548, Andhruni galli, Baap ka ghar\nSolapur, Maharashtra - 745821\nPhone: 8459951264	2026-03-10 23:27:56.398089	2026-03-10 23:34:39.007136	CASH_ON_DELIVERY	COD
17	6	236.00	PENDING	Darshan\n1256,jhvyh ,oiho\nSolapur, Maharashtra - 245365\nPhone: 1526457895	2026-03-10 23:46:35.060082	2026-03-10 23:46:35.060082	CASH_ON_DELIVERY	COD
32	5	885.00	PENDING	Vinayak Diwase\nSolapur\nSolapur, Maharashtra - 745821\nPhone: 8459951285	2026-03-11 00:37:27.916107	2026-03-11 00:37:27.916107	CASH_ON_DELIVERY	COD
34	18	2476.82	DELIVERED	Samkit Chopda\nSolapur\nSolapur, Maharashtra - 745821\nPhone: 5421536952	2026-03-12 12:27:33.174558	2026-03-12 12:29:20.04398	CASH_ON_DELIVERY	COD
33	5	1650.82	DELIVERED	Vinayak Diwase\nSolapur\nSolapur, Maharashtra - 745821\nPhone: 8459951285	2026-03-12 09:38:13.407342	2026-03-12 12:30:37.725553	CASH_ON_DELIVERY	COD
35	18	234.82	PENDING	Samkit Chopda\nnarendra modi stadium\nahemdabad, Gujarat - 124598\nPhone: 9864565987	2026-03-12 13:14:47.845603	2026-03-12 13:14:47.846603	CASH_ON_DELIVERY	COD
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, brand, model_compatibility, category, price, stock, description, image_url, created_at) FROM stdin;
4	Spark Plug (Iridium)	NGK	Universal â€“ All Bikes	electrical	349.00	29	Iridium tipped spark plug for improved ignitability and longer service life.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773056111/81O7PCgNFnL._AC_UL495_SR435_495__emftuz.jpg	2026-02-28 16:35:05.182569
14	Front Brake Pad Set	Hero Genuine	Hero Xtreme 160R, Xpulse 200	brakes	799.00	20	OEM Hero brake pad set providing reliable stopping power and improved braking performance.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773280106/POW-2-optimized_orwxrk.png	2026-03-12 07:12:15.795044
17	Brake Lever	Brembo	Hero Glamour, Passion Pro	brakes	299.00	30	Strong aluminum brake lever designed for comfortable grip and responsive braking.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773280410/king-quality-clutch-lever-30-09-2021-012-240970062-du0gk_bxlapr.jpg	2026-03-12 07:12:15.795044
15	Rear Brake Shoe	Hero Genuine	Hero Splendor Plus, HF Deluxe	brakes	499.00	25	Durable rear brake shoes designed for smooth braking and longer service life.	https://i.ytimg.com/vi/qAW0PHLDUSY/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLCTBN12H44Q-rpAUqFDU1kyUP4BEg	2026-03-12 07:12:15.795044
9	Clutch Plate Set	Alto	Hero Splendor, HF Deluxe, Passion Pro	engine	750.00	13	Complete clutch plate set with fiber and steel plates for smooth engagement.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773280877/hero-splendor-plus-clutch-plate_j7eh6p.jpg	2026-02-28 16:35:05.182569
20	Ignition Coil	NGK	Hero Passion Pro, Bajaj Discover 125	electrical	699.00	18	Premium ignition coil designed to deliver strong spark and improved engine performance.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773281099/Ignition-Coil-Passion-Pro_clymye.jpg	2026-03-12 07:37:58.225022
11	Bearings Rear Wheel	Aramco	cd100, Splendor	engine	200.00	7	Our premium deep-groove ball bearings are designed for high-speed operation, providing low-friction, smooth rotation.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773286111/IMG-20241005-WA0028-copy_zjg8lf.jpg	2026-03-02 22:25:40.209298
22	Front Fork Suspension Set	Hero Genuine	Hero Xtreme 160R, Xpulse 200	suspension	3299.00	8	OEM front fork suspension set ensuring better shock absorption and precise handling.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773281879/front-fork-assembly-for-hero-cbz-xtreme-new-model-single-seat-bike-hunk-black-colour-set-of-2-865_800x_kg2oso.jpg	2026-03-12 07:48:44.017302
23	Chain & Sprocket Kit	D.I.D	Hero Splendor Plus, HF Deluxe, Passion Pro	drivetrain	1799.00	16	Durable chain and sprocket kit designed for smooth power transmission and extended service life.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773282383/61-19dxRnDL_qnrucl.jpg	2026-03-12 07:58:49.702427
24	Gear Shift Lever	Uno Minda	Hero Xtreme 160R, Hero Glamour	drivetrain	499.00	18	Durable gear shift lever providing precise gear shifting and improved riding control.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773282486/xtreme-125r-gear-shift-lever_wyt82d.webp	2026-03-12 07:58:49.702427
25	Fuel Tank	Hero Genuine	Hero Splendor Plus, HF Deluxe	body	5499.00	6	Genuine fuel tank designed for perfect fit and durability with corrosion-resistant coating.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773282840/ensons-petrol-tank-for-hero-splendor-plus-bs4-2018-model-black-grey_zipfnp.jpg	2026-03-12 08:05:19.447339
26	Tail Light Assembly	Uno Minda	Hero Splendor Plus, HF Deluxe	body	799.00	20	Bright tail light assembly ensuring clear visibility for vehicles behind.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773282988/uno-minda-lamps_eyjwul.jpg	2026-03-12 08:05:19.447339
10	Rear Shock Absorber	Gabriel	TVS Apache RTR 160, Apache RTR 180	suspension	1450.00	7	OEM replacement shock absorber for comfortable ride and stable handling.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773281651/product-jpeg_cfwk1e.jpg	2026-02-28 16:35:05.182569
28	Front Mudguard	Honda Genuine	Honda Shine, Honda CB Shine SP	body	899.00	14	Durable front mudguard providing protection from mud, water and road debris.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773283623/AUT.MUD.921699315_1695621798179_h8vxgo.webp	2026-03-12 08:14:22.67274
27	Rear View Mirror Set	Uno Minda	Honda Shine, Honda Activa	body	399.00	28	Durable rear view mirror set offering clear rear visibility and strong mounting support.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773284139/honda-shine-twister-rear-view-mirror-500x500_yby9vp.jpg	2026-03-12 08:14:22.67274
5	Front Fork Oil Seals	Moto Master	Yamaha FZ16, FZ-S, MT-15	suspension	650.00	27	OEM-quality fork oil seals to prevent oil leaks and maintain suspension performance.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773284857/fss-007_a_1024x1024_r6xaz5.jpg	2026-02-28 16:35:05.182569
2	Air Filter Element	Leonardo	Honda CB300R, TVS Apache 160/200	engine	899.00	7	High-flow washable and reusable air filter for improved engine performance.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773284380/81bE-bgzJRL._AC_UF1000_1000_QL80__eywq25.jpg	2026-02-28 16:35:05.182569
12	Headlight	vd	TVS scooty pep, Honda activa	electrical	499.00	43	A top-tier choice for maximum output, delivering 32,000 lumens with a focused beam pattern and 5G high-speed fan cooling.	https://m.media-amazon.com/images/I/41invCLDk0S._AC_UF1000,1000_QL80_.jpg	2026-03-05 17:06:59.835829
13	Spark Plug	NGK	Hero Splendor, HF Delux, Honda Shine	engine	199.00	17	Spark plug that ensures the smooth performance and enhanced milege.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773056111/81O7PCgNFnL._AC_UL495_SR435_495__emftuz.jpg	2026-03-09 17:08:19.738561
7	Engine Oil Filter	Bosch	Universal Fit	engine	180.00	50	Premium oil filter for efficient filtration of engine oil contaminants.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773286395/bike-oil-filter_ghn8nc.jpg	2026-02-28 16:35:05.182569
3	Chain & Sprocket Kit	D.I.D	KTM 200 Duke, KTM 390 Duke	drivetrain	2499.00	49	Complete chain and front/rear sprocket kit with o-ring chain for extended life.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773286536/1a4f1490-b3ff-4432-a349-844c4248406f_lmzzxq.webp	2026-02-28 16:35:05.182569
6	LED Headlight Assembly	Comet	Bajaj Pulsar NS200, AS200	electrical	3200.00	4	Full LED headlight assembly with DRL ring. Plug and play installation.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773286931/062bc3ba-c853-49a4-a39c-e5c9c12d8971_c42rgt.webp	2026-02-28 16:35:05.182569
21	Rear Shock Absorber	Endurance	Hero Splendor Plus, HF Deluxe, Passion Pro	suspension	1399.00	13	High-quality rear shock absorber designed for smooth ride comfort and improved stability on rough roads.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773281651/product-jpeg_cfwk1e.jpg	2026-03-12 07:48:44.017302
1	Performance Brake Pads	Brembo	Royal Enfield Classic 350, Bullet 350, Bajaj Pulsar 150/180	brakes	1299.00	12	High-performance sintered brake pads for superior stopping power in all weather conditions.	https://res.cloudinary.com/dkvagokrh/image/upload/v1772642239/new-auto-brake-pads-isolated-on-white-background-photo_zi2xbs.jpg	2026-02-28 16:35:05.182569
8	Disc Brake Rotor 320mm	Wave	Royal Enfield Himalayan, Classic 350	brakes	1890.00	3	Floating disc rotor with anti-lock grooves for efficient heat dissipation.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773286694/tf29511-22-royal-enfield-motors-classic-350-front-rear-wheel-disc-brake-rotor__69026.1772725585_segj8e.jpg	2026-02-28 16:35:05.182569
19	Motorcycle Battery	Exide	Hero Splendor Plus, Honda Shine, TVS Star City	electrical	1899.00	19	Maintenance-free motorcycle battery providing reliable starting power and long operational life.	https://res.cloudinary.com/dkvagokrh/image/upload/v1773285216/product-jpeg_u2cn6e.jpg	2026-03-12 07:37:58.225022
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, phone, role, active, created_at) FROM stdin;
4	Admin	motoparts_admin@gmail.com	$2a$10$SfmEuswqyLWDhm5GILb.PufqtZg.NQnXjVbhInqsv8/yOkdqDlLA.	8459951285	ADMIN	t	2026-03-02 17:54:45.592011
5	Vinayak Diwase	vinayakdiwase353@gmail.com	$2a$10$0pOe.fH41n8w995hlBH6/.zgyif.3/lnhzsH9gxTx4fbBIPrWxM6e	8459951285	CUSTOMER	t	2026-03-09 23:27:20.771428
6	Darshan	darshan@gmail.com	$2a$10$MacKXx9xPx/wHR2liuYR0.0D0p5.THYhw.qgA5Aap1oWZN2vX//RK	9865432154	CUSTOMER	t	2026-03-10 13:46:44.140419
7	Admin User	admin@motoparts.in	$2a$10$slYQmyNdgTY18LGvgxPghe2UxLyxgesU6zKiUtkWelMGX3B1zTm7S	9999999999	ADMIN	t	2026-03-10 13:59:44.058615
8	Rahul Sharma	rahul@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9876543210	CUSTOMER	t	2026-01-10 00:15:43.824708
9	Priya Singh	priya@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9123456789	CUSTOMER	t	2026-01-20 00:15:43.824708
10	Arjun Mehta	arjun@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9988776655	CUSTOMER	t	2026-01-25 00:15:43.824708
11	Kavya Nair	kavya@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9812345678	CUSTOMER	t	2026-01-30 00:15:43.824708
12	Rohit Kumar	rohit@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9765432100	CUSTOMER	t	2026-02-04 00:15:43.824708
13	Sneha Patil	sneha@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9654321098	CUSTOMER	t	2026-02-09 00:15:43.824708
14	Vikram Rao	vikram@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9543210987	CUSTOMER	t	2026-02-14 00:15:43.824708
15	Anita Desai	anita@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9432109876	CUSTOMER	t	2026-02-19 00:15:43.824708
16	Suresh Iyer	suresh@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9321098765	CUSTOMER	t	2026-02-24 00:15:43.824708
17	Deepa Joshi	deepa@example.com	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh9y	9210987654	CUSTOMER	t	2026-03-01 00:15:43.824708
18	Samkit Chopda	samkit@gmail.com	$2a$10$Dotl/Tfmk66UVO0zjFBFieePq060terwhk6IMYQUiIeuDrriCsiYu	9568326547	CUSTOMER	t	2026-03-12 12:26:24.147621
\.


--
-- Name: contact_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_messages_id_seq', 2, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 49, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 35, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 29, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 18, true);


--
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_contact_messages_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_messages_created_at ON public.contact_messages USING btree (created_at DESC);


--
-- Name: idx_contact_messages_is_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_messages_is_read ON public.contact_messages USING btree (is_read);


--
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);


--
-- Name: idx_orders_payment_method; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_payment_method ON public.orders USING btree (payment_method);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_orders_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_user_id ON public.orders USING btree (user_id);


--
-- Name: idx_products_brand; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_brand ON public.products USING btree (brand);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (category);


--
-- Name: idx_products_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_stock ON public.products USING btree (stock);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict fdjN5y9ZhVSWa9LNwJskmKvWsfJCvSpodhR8b2SmYXfWeJhI5abJFkuOBbsOvPt

