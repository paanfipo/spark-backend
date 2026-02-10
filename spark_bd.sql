--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2026-02-10 10:10:46

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
-- TOC entry 225 (class 1259 OID 17056)
-- Name: game_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_levels (
    id integer NOT NULL,
    game_id integer,
    level_number integer NOT NULL,
    phase character varying NOT NULL,
    level_data jsonb
);


ALTER TABLE public.game_levels OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17055)
-- Name: game_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_levels_id_seq OWNER TO postgres;

--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 224
-- Name: game_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_levels_id_seq OWNED BY public.game_levels.id;


--
-- TOC entry 229 (class 1259 OID 17084)
-- Name: game_plays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_plays (
    id integer NOT NULL,
    round_id integer NOT NULL,
    game_id integer NOT NULL,
    current_level integer NOT NULL,
    score integer,
    results_data jsonb,
    start_time timestamp with time zone DEFAULT now(),
    end_time timestamp with time zone
);


ALTER TABLE public.game_plays OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17083)
-- Name: game_plays_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_plays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_plays_id_seq OWNER TO postgres;

--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 228
-- Name: game_plays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_plays_id_seq OWNED BY public.game_plays.id;


--
-- TOC entry 217 (class 1259 OID 17004)
-- Name: games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games (
    id integer NOT NULL,
    game_code character varying NOT NULL,
    name character varying NOT NULL,
    description text,
    cognitive_domain character varying
);


ALTER TABLE public.games OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17003)
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_id_seq OWNER TO postgres;

--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 216
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;


--
-- TOC entry 221 (class 1259 OID 17028)
-- Name: metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metrics (
    id integer NOT NULL,
    name character varying NOT NULL,
    display_name character varying NOT NULL,
    is_primary boolean NOT NULL,
    unit character varying,
    formula text,
    description text,
    game_id integer
);


ALTER TABLE public.metrics OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17027)
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metrics_id_seq OWNER TO postgres;

--
-- TOC entry 3426 (class 0 OID 0)
-- Dependencies: 220
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- TOC entry 227 (class 1259 OID 17070)
-- Name: rounds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rounds (
    id integer NOT NULL,
    session_id integer,
    round_number integer,
    focus_domain character varying
);


ALTER TABLE public.rounds OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17069)
-- Name: rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rounds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rounds_id_seq OWNER TO postgres;

--
-- TOC entry 3427 (class 0 OID 0)
-- Dependencies: 226
-- Name: rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rounds_id_seq OWNED BY public.rounds.id;


--
-- TOC entry 223 (class 1259 OID 17043)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    user_id integer,
    start_time timestamp with time zone DEFAULT now(),
    end_time timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17042)
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO postgres;

--
-- TOC entry 3428 (class 0 OID 0)
-- Dependencies: 222
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- TOC entry 231 (class 1259 OID 17104)
-- Name: trials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trials (
    id integer NOT NULL,
    game_play_id integer,
    trial_number integer,
    was_correct boolean,
    reaction_time_ms integer
);


ALTER TABLE public.trials OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17103)
-- Name: trials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trials_id_seq OWNER TO postgres;

--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 230
-- Name: trials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trials_id_seq OWNED BY public.trials.id;


--
-- TOC entry 215 (class 1259 OID 16993)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    birth_date date,
    country character varying,
    gender character varying,
    education_level character varying,
    is_active boolean,
    is_premium boolean,
    created_at timestamp with time zone DEFAULT now(),
    last_login timestamp with time zone,
    training_goals character varying,
    preferred_training_days character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16992)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 219 (class 1259 OID 17017)
-- Name: words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.words (
    id integer NOT NULL,
    text character varying NOT NULL,
    category character varying NOT NULL,
    gender character varying,
    number character varying NOT NULL,
    lang character varying
);


ALTER TABLE public.words OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17016)
-- Name: words_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.words_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.words_id_seq OWNER TO postgres;

--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 218
-- Name: words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.words_id_seq OWNED BY public.words.id;


--
-- TOC entry 3220 (class 2604 OID 17059)
-- Name: game_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_levels ALTER COLUMN id SET DEFAULT nextval('public.game_levels_id_seq'::regclass);


--
-- TOC entry 3222 (class 2604 OID 17087)
-- Name: game_plays id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_plays ALTER COLUMN id SET DEFAULT nextval('public.game_plays_id_seq'::regclass);


--
-- TOC entry 3215 (class 2604 OID 17007)
-- Name: games id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);


--
-- TOC entry 3217 (class 2604 OID 17031)
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- TOC entry 3221 (class 2604 OID 17073)
-- Name: rounds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rounds ALTER COLUMN id SET DEFAULT nextval('public.rounds_id_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 17046)
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- TOC entry 3224 (class 2604 OID 17107)
-- Name: trials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trials ALTER COLUMN id SET DEFAULT nextval('public.trials_id_seq'::regclass);


--
-- TOC entry 3213 (class 2604 OID 16996)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3216 (class 2604 OID 17020)
-- Name: words id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words ALTER COLUMN id SET DEFAULT nextval('public.words_id_seq'::regclass);


--
-- TOC entry 3411 (class 0 OID 17056)
-- Dependencies: 225
-- Data for Name: game_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_levels (id, game_id, level_number, phase, level_data) FROM stdin;
1	3	1	Letras Comunes - Fácil	{"letter": "P", "valid_words": ["pera", "pato", "pelo", "piso", "pan", "papa", "paso", "pino", "polo", "pala", "pila", "pomo", "pozo", "puerta", "pueblo"], "time_limit_seconds": 60}
2	3	2	Letras Comunes - Fácil	{"letter": "M", "valid_words": ["mano", "mesa", "mapa", "meta", "mimo", "mora", "muro", "musa", "mono", "mota", "miel", "mito", "mina", "malla", "mundo"], "time_limit_seconds": 60}
3	3	3	Letras Comunes - Intermedio	{"letter": "C", "valid_words": ["casa", "carro", "cama", "copa", "cono", "cielo", "cine", "cuna", "codo", "cola", "caja", "calle", "campo", "carta", "coro"], "time_limit_seconds": 50}
4	3	4	Letras Comunes - Intermedio	{"letter": "A", "valid_words": ["amor", "alma", "arte", "agua", "aire", "anillo", "arco", "alto", "azul", "ala", "ave", "arbol", "arena", "avena", "autor"], "time_limit_seconds": 50}
5	3	5	Letras Infrecuentes - Difícil	{"letter": "F", "valid_words": ["foco", "fama", "fila", "fino", "frio", "fuego", "flor", "fruta", "faro", "foca", "falda", "fiesta", "fauna", "feliz", "fondo"], "time_limit_seconds": 45}
6	4	1	Básica	{"word_set": ["el", "gato", "duerme", "corre", "rojo", "la", "gatos"], "valid_sentences": ["el gato duerme", "el gato corre", "el gato rojo corre", "el gato rojo duerme"]}
7	4	2	Básica	{"word_set": ["la", "niña", "es", "corre", "feliz", "alta"], "valid_sentences": ["la niña corre", "la niña es feliz", "la niña es alta"]}
8	4	3	Básica	{"word_set": ["los", "perros", "grandes", "comen", "pan", "lento"], "valid_sentences": ["los perros comen pan", "los perros grandes comen", "los perros comen lento", "los perros grandes comen pan", "los perros grandes comen lento pan"]}
9	4	4	Básica	{"word_set": ["mi", "mamá", "cocina", "sopa", "rica", "casa", "en"], "valid_sentences": ["mi mamá cocina sopa", "mi mamá cocina en casa", "mi mamá cocina sopa rica"]}
10	4	5	Básica	{"word_set": ["el", "el", "sol", "brilla", "fuerte", "cielo", "en", "luna"], "valid_sentences": ["el sol brilla", "el sol brilla fuerte", "el sol brilla en el cielo"]}
11	4	6	Intermedia	{"word_set": ["la", "maestra", "lee", "un", "libro", "interesante", "rápido", "banco"], "valid_sentences": ["la maestra lee un libro", "la maestra lee un libro interesante", "la maestra lee rápido"]}
12	4	7	Intermedia	{"word_set": ["el", "niño", "corre", "en", "el", "parque", "grande", "feliz", "nube"], "valid_sentences": ["el niño corre en el parque", "el niño corre feliz", "el niño corre en el parque grande", "el niño corre feliz en el parque"]}
13	4	8	Intermedia	{"word_set": ["los", "árboles", "altos", "se", "mueven", "con", "el", "viento", "piedra"], "valid_sentences": ["los árboles altos se mueven", "los árboles se mueven con el viento", "los árboles altos se mueven con el viento"]}
14	4	9	Intermedia	{"word_set": ["ella", "canta", "una", "canción", "alegre", "bonito", "tarde"], "valid_sentences": ["ella canta bonito", "ella canta una canción", "ella canta una canción alegre"]}
15	4	10	Intermedia	{"word_set": ["mi", "amigo", "estudia", "matemáticas", "en", "la", "universidad", "temprano"], "valid_sentences": ["mi amigo estudia matemáticas", "mi amigo estudia en la universidad"]}
16	4	11	Avanzada	{"word_set": ["el", "científico", "descubre", "una", "estrella", "brillante", "y", "nueva", "roca"], "valid_sentences": ["el científico descubre una estrella", "el científico descubre una estrella brillante", "el científico descubre una estrella nueva"]}
17	4	12	Avanzada	{"word_set": ["los", "niños", "juegan", "mientras", "llueve", "en", "el", "parque", "ruido"], "valid_sentences": ["los niños juegan en el parque", "los niños juegan mientras llueve"]}
18	4	13	Avanzada	{"word_set": ["la", "mujer", "cocina", "un", "pastel", "delicioso", "de", "chocolate", "y"], "valid_sentences": ["la mujer cocina un pastel", "la mujer cocina un pastel delicioso", "la mujer cocina un pastel de chocolate"]}
19	4	14	Avanzada	{"word_set": ["ellos", "viajan", "a", "la", "ciudad", "grande", "en", "tren", "pero"], "valid_sentences": ["ellos viajan en tren", "ellos viajan a la ciudad grande", "ellos viajan a la ciudad"]}
20	4	15	Avanzada	{"word_set": ["la", "profesora", "explica", "un", "tema", "difícil", "matemático", "pero", "claro"], "valid_sentences": ["la profesora explica un tema", "la profesora explica un tema difícil", "la profesora explica un tema matemático"]}
21	4	16	Experta	{"word_set": ["el", "niño", "no", "quiere", "comer", "sus", "verduras", "aunque", "ahora"], "valid_sentences": ["el niño no quiere comer verduras", "el niño no quiere sus verduras", "aunque el niño no quiere verduras"]}
22	4	17	Experta	{"word_set": ["ellos", "corren", "rápido", "y", "saltan", "alto", "porque", "noche"], "valid_sentences": ["ellos corren rápido", "ellos corren y saltan alto"]}
23	4	18	Experta	{"word_set": ["ella", "escribe", "una", "carta", "larga", "bonita", "cuando", "puede"], "valid_sentences": ["ella escribe una carta", "ella escribe una carta larga", "ella escribe una carta bonita"]}
24	4	19	Experta	{"word_set": ["el", "perro", "ladra", "pero", "el", "gato", "duerme", "si"], "valid_sentences": ["el perro ladra", "el perro ladra pero el gato duerme"]}
25	4	20	Experta	{"word_set": ["aunque", "llueve", "ellos", "juegan", "felices", "en", "el", "campo", "siempre"], "valid_sentences": ["ellos juegan en el campo", "aunque llueve ellos juegan felices en el campo"]}
\.


--
-- TOC entry 3415 (class 0 OID 17084)
-- Dependencies: 229
-- Data for Name: game_plays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_plays (id, round_id, game_id, current_level, score, results_data, start_time, end_time) FROM stdin;
1	1	3	1	0	{}	2025-09-22 14:50:26.68762-05	\N
2	2	4	1	0	{}	2025-09-22 14:50:30.546426-05	\N
3	3	4	1	0	{}	2025-09-22 14:52:01.732396-05	\N
4	4	3	1	0	{}	2025-09-24 10:14:35.21152-05	\N
5	5	1	1	0	{}	2025-09-24 10:14:38.249111-05	\N
6	6	1	1	0	{}	2025-09-24 10:14:58.993292-05	\N
7	7	1	1	0	{}	2025-09-24 10:22:53.484182-05	\N
8	8	3	1	0	{}	2025-09-24 10:23:35.563149-05	\N
9	9	1	1	0	{}	2025-09-24 10:34:06.148735-05	\N
10	10	3	1	0	{}	2025-09-24 10:35:31.471073-05	\N
11	11	1	1	0	{}	2025-09-24 10:42:55.541161-05	\N
12	12	1	1	0	{}	2025-09-24 10:43:18.887547-05	\N
13	13	1	1	0	{}	2025-09-24 10:47:01.529392-05	\N
14	14	1	1	0	{}	2025-09-24 10:49:13.567686-05	\N
15	15	4	1	0	{}	2025-09-24 10:49:29.274651-05	\N
16	16	3	1	0	{}	2025-09-24 10:49:32.510925-05	\N
17	17	1	1	0	{}	2025-09-24 10:54:14.538419-05	\N
18	18	1	1	0	{}	2025-09-24 11:03:14.845722-05	\N
19	19	1	1	0	{}	2025-09-24 11:30:28.688569-05	\N
20	20	1	1	0	{}	2025-09-25 08:43:55.90105-05	\N
21	21	1	1	0	{}	2025-09-25 08:44:08.753702-05	\N
22	22	3	1	0	{}	2025-09-25 08:58:29.139482-05	\N
23	23	1	1	0	{}	2025-09-25 09:01:41.479537-05	\N
24	24	1	1	210	{"score": 210, "total_aciertos": 41, "errores_omision": 10, "errores_comision": 4, "estrellas_obtenidas": 6, "indice_precision_neta": 72.55, "tiempo_respuesta_promedio_ms": 4111}	2025-09-25 09:32:53.353266-05	\N
25	25	1	1	80	{"score": 80, "total_aciertos": 16, "errores_omision": 28, "errores_comision": 4, "estrellas_obtenidas": 4, "indice_precision_neta": 27.27, "tiempo_respuesta_promedio_ms": 1730.63}	2025-09-25 10:16:32.990668-05	\N
26	26	1	1	0	{}	2025-09-25 10:24:30.549706-05	\N
44	44	1	1	100	{"score": 30, "total_aciertos": 7, "errores_omision": 9, "errores_comision": 2, "estrellas_obtenidas": 0, "indice_precision_neta": 31.25, "tiempo_respuesta_promedio_ms": 1161}	2025-09-25 19:25:15.104104-05	\N
27	27	1	1	180	{"score": 180, "total_aciertos": 42, "errores_omision": 20, "errores_comision": 4, "estrellas_obtenidas": 2, "indice_precision_neta": 61.29, "tiempo_respuesta_promedio_ms": 2808.2}	2025-09-25 10:25:45.130805-05	\N
28	28	1	1	0	{}	2025-09-25 14:24:47.265615-05	\N
29	29	1	1	130	{"score": 100, "total_aciertos": 22, "errores_omision": 9, "errores_comision": 2, "estrellas_obtenidas": 2, "indice_precision_neta": 64.52, "tiempo_respuesta_promedio_ms": 2668.83}	2025-09-25 14:25:20.716091-05	\N
30	30	3	1	0	{}	2025-09-25 14:34:05.728091-05	\N
31	31	3	1	5	{"level_1": {"total_score": 5, "level_letter": "P", "correct_words": ["papa", "piso", "pomo", "pino", "pala"], "intrusion_errors": 12, "perseveration_errors": 0, "total_words_submitted": 17, "unique_words_submitted": 17, "lexical_production_rate": 5.0}}	2025-09-25 14:58:09.378598-05	\N
32	32	3	1	0	{}	2025-09-25 15:01:06.892548-05	\N
33	33	4	1	0	{}	2025-09-25 15:01:10.313622-05	\N
34	34	4	1	0	{}	2025-09-25 15:03:40.182636-05	\N
35	35	4	1	0	{}	2025-09-25 15:15:50.430923-05	\N
36	36	4	1	0	{}	2025-09-25 15:16:22.523333-05	\N
37	37	4	1	0	{}	2025-09-25 15:25:10.59953-05	\N
38	38	4	1	0	{}	2025-09-25 15:28:14.658739-05	\N
39	39	4	1	0	{}	2025-09-25 15:28:22.335639-05	\N
40	40	4	1	0	{}	2025-09-25 15:29:09.056805-05	\N
49	49	1	1	150	{"score": 150, "total_aciertos": 25, "errores_omision": 15, "errores_comision": 2, "estrellas_obtenidas": 3, "indice_precision_neta": 57.5, "tiempo_respuesta_promedio_ms": 1930.57}	2025-09-26 14:57:55.636661-05	\N
45	45	1	1	30	{"score": 30, "total_aciertos": 7, "errores_omision": 9, "errores_comision": 2, "estrellas_obtenidas": 0, "indice_precision_neta": 31.25, "tiempo_respuesta_promedio_ms": 1209.75}	2025-09-25 19:30:42.074999-05	\N
50	50	1	1	0	{}	2025-09-26 15:27:43.139103-05	\N
46	46	1	1	40	{"score": 40, "total_aciertos": 10, "errores_omision": 9, "errores_comision": 2, "estrellas_obtenidas": 1, "indice_precision_neta": 42.11, "tiempo_respuesta_promedio_ms": 1369.8}	2025-09-25 19:46:06.750192-05	\N
41	41	4	4	300	{"time_taken_ms": 7521, "completed_level": 3, "efficiency_score": 13.3, "first_interaction_ms": 2111, "first_attempt_success": true}	2025-09-25 15:46:15.928992-05	\N
42	42	1	1	0	{}	2025-09-25 15:55:14.27827-05	\N
43	43	1	1	60	{"score": 60, "total_aciertos": 12, "errores_omision": 11, "errores_comision": 2, "estrellas_obtenidas": 1, "indice_precision_neta": 43.48, "tiempo_respuesta_promedio_ms": 1537}	2025-09-25 19:15:17.851655-05	\N
51	51	1	1	0	{}	2025-09-26 18:41:49.823935-05	\N
47	47	1	1	120	{"score": 10, "total_aciertos": 3, "errores_omision": 7, "errores_comision": 2, "estrellas_obtenidas": 0, "indice_precision_neta": 10, "tiempo_respuesta_promedio_ms": 718.67}	2025-09-25 19:53:12.548544-05	\N
48	48	1	1	0	{}	2025-09-26 14:40:15.71075-05	\N
52	52	1	1	0	{}	2025-09-27 08:40:52.158899-05	\N
53	53	1	1	0	{}	2025-09-27 09:16:12.121398-05	\N
54	54	1	1	0	{}	2025-09-27 09:16:22.755764-05	\N
55	55	1	1	0	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "-33 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "0,67 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-09-27 14:22:41.671507-05	\N
56	56	1	1	0	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "-33 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "6,70 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-09-27 14:47:08.138369-05	\N
139	139	2	1	0	{}	2025-11-07 20:42:33.618017-05	\N
157	157	5	1	0	{}	2025-11-08 00:04:41.732133-05	\N
219	219	2	1	0	{}	2025-12-23 15:04:00.041213-05	\N
220	220	6	1	0	{}	2025-12-23 15:10:08.588907-05	\N
221	221	5	1	0	{}	2025-12-23 15:10:18.960976-05	\N
57	57	1	1	50	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "47 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "1,51 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "8", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-09-27 19:33:10.838639-05	\N
58	58	2	1	0	{}	2025-10-04 10:48:37.660098-05	\N
59	59	2	1	0	{}	2025-10-04 11:00:05.253042-05	\N
60	60	1	1	0	{}	2025-10-04 11:01:29.581783-05	\N
61	61	2	1	0	{}	2025-10-04 11:01:37.581235-05	\N
62	62	2	1	0	{}	2025-10-04 11:09:38.589259-05	\N
63	63	1	1	0	{}	2025-10-17 08:42:25.339736-05	\N
64	64	1	1	0	{}	2025-10-17 20:43:18.11706-05	\N
65	65	1	1	0	{}	2025-10-18 20:30:55.15709-05	\N
66	66	1	1	0	{}	2025-10-18 21:01:11.992201-05	\N
67	67	1	1	0	{}	2025-10-18 21:33:08.470611-05	\N
68	68	1	1	0	{}	2025-10-18 21:45:53.954616-05	\N
69	69	1	1	0	{}	2025-10-19 18:31:10.618066-05	\N
70	70	1	1	0	{}	2025-10-19 18:31:36.279313-05	\N
71	71	2	1	0	{}	2025-10-19 18:32:17.837026-05	\N
72	72	1	1	0	{}	2025-10-19 18:39:34.324043-05	\N
73	73	1	1	0	{}	2025-10-19 20:37:01.117775-05	\N
74	74	1	1	0	{}	2025-10-20 15:29:02.354551-05	\N
75	75	1	1	0	{}	2025-10-20 20:19:43.455064-05	\N
76	76	1	1	0	{}	2025-10-20 20:54:37.818518-05	\N
77	77	1	1	0	{}	2025-10-22 17:18:03.646369-05	\N
78	78	1	1	0	{}	2025-10-27 10:43:08.015325-05	\N
79	79	1	1	20	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "38 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "13,57 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-10-27 10:49:58.843135-05	\N
80	80	1	1	30	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "38 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "1,37 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "8", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-10-27 10:56:20.027107-05	\N
81	81	1	1	30	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "40 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "2,25 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "7", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-10-27 11:05:52.741619-05	\N
82	82	1	1	0	{}	2025-10-27 11:07:05.267718-05	\N
83	83	1	1	30	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "47 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "1,82 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-10-27 11:13:16.804095-05	\N
84	84	1	1	0	{}	2025-10-27 15:14:20.505441-05	\N
85	85	1	1	0	{}	2025-10-27 15:33:17.306608-05	\N
86	86	2	1	0	{}	2025-10-27 19:54:31.604204-05	\N
87	87	2	1	0	{}	2025-10-27 19:58:16.972909-05	\N
88	88	2	1	0	{}	2025-10-27 20:02:24.157635-05	\N
89	89	2	1	0	{}	2025-10-27 20:23:18.101217-05	\N
90	90	2	1	0	{}	2025-10-27 20:56:06.809107-05	\N
91	91	1	1	0	{}	2025-10-27 21:10:17.763807-05	\N
92	92	2	1	20	[{"icon": "📊", "label": "Tasa de Éxito", "value": "66,7 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "1,75 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-27 21:10:46.68366-05	\N
93	93	2	1	0	{}	2025-10-27 21:21:09.717342-05	\N
94	94	2	1	0	[{"icon": "📊", "label": "Tasa de Éxito", "value": "0,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-28 09:20:37.58281-05	\N
95	95	2	1	10	[{"icon": "📊", "label": "Tasa de Éxito", "value": "33,3 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "6,75 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "2", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-28 09:41:28.968688-05	\N
222	222	1	1	0	{}	2025-12-23 15:10:33.346207-05	\N
223	223	2	1	0	{}	2025-12-23 15:11:47.146568-05	\N
224	224	1	1	0	{}	2025-12-23 15:14:29.288181-05	\N
291	291	7	1	0	[{"icon": "❌", "label": "Errores de Comisión", "value": "2", "helper": "Responder “Sí” ante una figura no presentada."}, {"icon": "🚫", "label": "Errores de Omisión", "value": "0", "helper": "Responder “No” ante una figura previamente vista."}]	2025-12-29 18:37:51.340095-05	\N
292	292	7	1	0	{}	2025-12-29 18:40:27.491098-05	\N
96	96	2	1	0	[{"icon": "📊", "label": "Tasa de Éxito", "value": "0,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-28 09:49:02.491994-05	\N
97	97	2	1	30	[{"icon": "📊", "label": "Tasa de Éxito", "value": "75,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "3,02 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-28 10:00:44.674355-05	\N
98	98	2	1	0	{}	2025-10-28 10:13:31.607499-05	\N
99	99	2	1	0	{}	2025-10-28 10:20:41.538922-05	\N
100	100	2	1	0	{}	2025-10-28 10:51:05.579366-05	\N
101	101	2	1	0	{}	2025-10-28 14:49:18.45056-05	\N
102	102	1	1	0	{}	2025-10-28 15:05:39.094383-05	\N
103	103	2	1	0	{}	2025-10-28 15:05:50.922117-05	\N
104	104	1	1	0	{}	2025-10-28 15:13:46.309599-05	\N
105	105	1	1	0	{}	2025-10-28 15:16:59.148538-05	\N
106	106	2	1	0	{}	2025-10-28 15:17:02.72364-05	\N
107	107	2	1	0	{}	2025-10-28 15:18:13.130523-05	\N
108	108	2	1	0	{}	2025-10-28 15:19:46.140441-05	\N
109	109	1	1	0	{}	2025-10-28 15:35:48.288566-05	\N
110	110	2	1	0	{}	2025-10-28 15:35:51.978649-05	\N
111	111	2	1	0	{}	2025-10-28 15:50:27.724358-05	\N
112	112	2	1	0	{}	2025-10-28 19:53:35.519014-05	\N
113	113	2	1	0	{}	2025-10-28 20:30:03.556244-05	\N
114	114	2	1	0	{}	2025-10-29 20:24:01.811746-05	\N
115	115	5	1	0	{}	2025-10-29 20:42:49.871024-05	\N
116	116	5	1	0	{}	2025-10-29 20:55:04.057837-05	\N
117	117	5	1	0	[{"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un objeto incorrecto o fuera de orden."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas por tiempo o fallo."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-29 21:00:03.863455-05	\N
118	118	5	1	0	{}	2025-10-29 21:03:28.816179-05	\N
119	119	5	1	0	[{"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clic a objeto incorrecto/fuera de orden."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que repetiste un nivel."}]	2025-10-29 21:16:13.798796-05	\N
120	120	5	1	0	[{"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clic a objeto incorrecto/fuera de orden."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que repetiste un nivel."}]	2025-10-29 21:27:48.413945-05	\N
121	121	5	1	0	{}	2025-10-29 21:44:44.111719-05	\N
122	122	1	1	0	{}	2025-10-30 08:17:57.444251-05	\N
123	123	1	1	10	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "10 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "2,07 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "7", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-10-30 08:19:06.930151-05	\N
124	124	1	1	0	{}	2025-10-30 08:19:53.885155-05	\N
125	125	2	1	20	[{"icon": "📊", "label": "Tasa de Éxito", "value": "66,7 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "3,99 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-10-30 08:20:26.033074-05	\N
126	126	5	1	0	{}	2025-10-30 08:22:11.882977-05	\N
127	127	1	1	0	{}	2025-10-30 08:22:25.318074-05	\N
128	128	2	1	0	{}	2025-10-30 08:22:38.857508-05	\N
129	129	5	1	20	[{"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "2,93 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clic a objeto incorrecto/fuera de orden."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que repetiste un nivel."}]	2025-10-30 08:22:45.992848-05	\N
130	130	5	1	0	{}	2025-10-30 08:25:51.064069-05	\N
131	131	1	1	0	{}	2025-11-07 18:04:04.485884-05	\N
132	132	2	1	0	{}	2025-11-07 18:04:09.881523-05	\N
133	133	5	1	0	{}	2025-11-07 18:04:13.753284-05	\N
134	134	1	1	0	{}	2025-11-07 20:34:50.026604-05	\N
135	135	5	1	0	{}	2025-11-07 20:35:00.424649-05	\N
136	136	1	1	390	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "89 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "3,27 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-11-07 20:35:24.906166-05	\N
137	137	2	1	0	{}	2025-11-07 20:37:08.01237-05	\N
138	138	1	1	0	{}	2025-11-07 20:40:06.830306-05	\N
140	140	2	1	30	[{"icon": "📊", "label": "Tasa de Éxito", "value": "75,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "2,18 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-11-07 20:42:33.762499-05	\N
141	141	5	1	0	{}	2025-11-07 20:44:16.591111-05	\N
142	142	5	1	0	{}	2025-11-07 22:46:08.817582-05	\N
143	143	5	1	0	{}	2025-11-07 22:49:23.658291-05	\N
144	144	5	1	0	{}	2025-11-07 23:16:13.097711-05	\N
145	145	5	1	0	{}	2025-11-07 23:18:37.505008-05	\N
146	146	5	1	0	{}	2025-11-07 23:20:10.545334-05	\N
147	147	5	1	0	{}	2025-11-07 23:21:47.389789-05	\N
148	148	5	1	0	{}	2025-11-07 23:22:04.726913-05	\N
149	149	5	1	0	{}	2025-11-07 23:22:41.134367-05	\N
150	150	5	1	0	{}	2025-11-07 23:24:45.862454-05	\N
151	151	5	1	0	{}	2025-11-07 23:25:18.123574-05	\N
152	152	5	1	0	{}	2025-11-07 23:47:10.085105-05	\N
153	153	5	1	0	{}	2025-11-07 23:51:38.997413-05	\N
154	154	2	1	0	{}	2025-11-07 23:51:47.954113-05	\N
155	155	5	1	0	{}	2025-11-07 23:53:33.446513-05	\N
156	156	2	1	0	{}	2025-11-08 00:04:31.691108-05	\N
158	158	6	1	0	{}	2025-11-08 17:06:09.266792-05	\N
159	159	1	1	30	[{"icon": "📈", "label": "Índice de Precisión Neta", "value": "56 %", "helper": "Relación entre tus aciertos y errores."}, {"icon": "⏱️", "label": "Tiempo Promedio / Nivel", "value": "3,38 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Elegiste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "5", "helper": "Olvidaste seleccionar casillas que sí estaban en el patrón."}]	2025-11-08 17:07:59.882619-05	\N
160	160	2	1	30	[{"icon": "📊", "label": "Tasa de Éxito", "value": "75,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "3,19 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-11-08 17:08:53.103395-05	\N
161	161	5	1	0	{}	2025-11-08 17:09:51.949118-05	\N
162	162	6	1	0	{}	2025-11-09 14:54:29.854478-05	\N
163	163	5	1	0	{}	2025-11-09 14:55:34.018179-05	\N
164	164	5	1	0	{}	2025-11-09 21:11:44.642387-05	\N
165	165	5	1	0	{}	2025-11-10 06:57:44.785948-05	\N
166	166	6	1	0	{}	2025-11-10 06:58:15.364222-05	\N
167	167	5	1	0	{}	2025-11-10 07:05:22.667962-05	\N
168	168	5	1	0	{}	2025-11-10 07:12:41.254828-05	\N
169	169	5	1	0	{}	2025-11-10 10:00:24.451076-05	\N
170	170	5	1	0	{}	2025-11-10 10:15:33.02748-05	\N
171	171	5	1	0	{}	2025-11-10 10:30:19.805034-05	\N
172	172	5	1	0	{}	2025-11-10 11:13:33.95938-05	\N
173	173	5	1	0	{}	2025-11-10 11:29:16.547421-05	\N
174	174	5	1	0	{}	2025-11-10 11:55:28.276484-05	\N
175	175	1	1	0	{}	2025-11-10 11:56:15.049721-05	\N
176	176	2	1	0	{}	2025-11-10 11:57:11.43535-05	\N
177	177	5	1	0	{}	2025-11-10 11:57:19.87029-05	\N
178	178	5	1	0	{}	2025-11-10 14:59:37.364986-05	\N
179	179	5	1	0	{}	2025-11-10 15:20:05.715378-05	\N
180	180	5	1	0	{}	2025-11-10 19:32:26.647772-05	\N
181	181	1	1	0	{}	2025-11-10 19:54:14.547793-05	\N
182	182	2	1	0	{}	2025-11-10 19:54:24.797612-05	\N
183	183	5	1	0	{}	2025-11-10 19:54:33.78213-05	\N
184	184	6	1	0	{}	2025-11-10 19:54:54.134108-05	\N
185	185	6	1	0	{}	2025-11-11 09:51:57.339623-05	\N
186	186	1	1	0	{}	2025-11-11 09:56:59.258402-05	\N
187	187	2	1	0	{}	2025-11-11 09:57:03.074262-05	\N
188	188	5	1	0	{}	2025-11-11 09:57:06.715512-05	\N
189	189	6	1	0	{}	2025-11-11 09:57:10.072031-05	\N
190	190	6	1	0	{}	2025-11-11 10:09:39.996408-05	\N
191	191	7	1	0	{}	2025-11-11 10:14:49.168208-05	\N
192	192	1	1	0	{}	2025-11-11 10:18:00.942012-05	\N
193	193	2	1	0	{}	2025-11-11 10:18:12.597042-05	\N
194	194	6	1	0	{}	2025-11-11 10:18:40.538368-05	\N
195	195	6	1	0	{}	2025-11-11 17:49:04.342705-05	\N
196	196	1	1	0	{}	2025-11-11 17:50:32.921438-05	\N
197	197	1	1	0	{}	2025-11-11 17:52:59.475721-05	\N
198	198	6	1	0	{}	2025-11-11 17:53:59.089207-05	\N
199	199	1	1	0	{}	2025-11-11 17:56:26.985276-05	\N
200	200	6	1	0	{}	2025-11-11 18:17:47.231083-05	\N
201	201	6	1	0	{}	2025-11-13 08:05:47.888201-05	\N
202	202	5	1	0	{}	2025-11-13 08:06:42.537832-05	\N
203	203	2	1	0	{}	2025-11-13 08:08:53.305121-05	\N
204	204	1	1	0	{}	2025-11-13 08:09:12.830942-05	\N
205	205	1	1	0	{}	2025-11-26 19:19:36.511491-05	\N
206	206	1	1	280	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima (Span VS)", "value": "9", "helper": "Mayor número de celdas reproducidas correctamente en un tablero sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "68,85 %", "helper": "Proporción de aciertos respecto al total de objetivos presentados."}, {"icon": "⏱️", "label": "Tiempo Promedio / Tablero", "value": "2,41 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Seleccionaste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "19", "helper": "No seleccionaste casillas que sí estaban en el patrón."}, {"icon": "📉", "label": "Índice de Precisión Neta", "value": "65,57 %", "helper": "Relación global entre aciertos y errores (no es el indicador principal del juego)."}]	2025-12-21 20:43:34.9709-05	\N
207	207	1	1	0	{}	2025-12-22 10:02:52.277998-05	\N
208	208	2	1	0	{}	2025-12-22 10:12:29.212686-05	\N
209	209	1	1	0	{}	2025-12-22 10:34:07.633343-05	\N
210	210	2	1	0	{}	2025-12-22 19:21:37.791698-05	\N
211	211	2	1	0	{}	2025-12-22 20:02:30.364641-05	\N
212	212	1	1	0	{}	2025-12-22 20:30:00.828271-05	\N
213	213	5	1	0	{}	2025-12-22 20:32:55.079755-05	\N
214	214	2	1	0	{}	2025-12-22 20:38:16.522721-05	\N
215	215	2	1	0	{}	2025-12-23 07:53:46.898267-05	\N
216	216	1	1	0	{}	2025-12-23 07:54:52.999968-05	\N
217	217	2	1	0	{}	2025-12-23 15:01:44.8843-05	\N
218	218	2	1	0	{}	2025-12-23 15:02:38.616783-05	\N
225	225	2	1	20	[{"icon": "📊", "label": "Tasa de Éxito", "value": "66,7 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "2,61 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-12-23 15:15:36.150267-05	\N
226	226	2	1	0	[{"icon": "📊", "label": "Tasa de Éxito", "value": "0,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-12-23 15:24:35.437344-05	\N
227	227	2	1	0	{}	2025-12-23 15:26:06.418972-05	\N
228	228	2	1	0	[{"icon": "📊", "label": "Tasa de Éxito", "value": "0,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-12-23 15:27:50.994305-05	\N
229	229	2	1	0	[{"icon": "📊", "label": "Tasa de Éxito", "value": "0,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-12-23 15:32:31.256392-05	\N
230	230	2	1	0	{}	2025-12-23 18:02:27.786942-05	\N
231	231	2	1	0	{}	2025-12-23 18:24:31.252116-05	\N
232	232	1	1	0	{}	2025-12-23 18:25:51.321244-05	\N
233	233	2	1	0	{}	2025-12-23 18:31:26.295677-05	\N
234	234	1	1	0	{}	2025-12-23 18:31:39.216837-05	\N
235	235	1	1	60	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima (Span VS)", "value": "5", "helper": "Mayor número de celdas reproducidas correctamente en un tablero sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "57,14 %", "helper": "Proporción de aciertos respecto al total de objetivos presentados."}, {"icon": "⏱️", "label": "Tiempo Promedio / Tablero", "value": "3,79 s", "helper": "Velocidad media para resolver cada tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Seleccionaste casillas que no estaban en el patrón."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "9", "helper": "No seleccionaste casillas que sí estaban en el patrón."}, {"icon": "📉", "label": "Índice de Precisión Neta", "value": "47,62 %", "helper": "Relación global entre aciertos y errores (no es el indicador principal del juego)."}]	2025-12-23 20:15:05.145143-05	\N
236	236	2	1	0	{}	2025-12-23 20:16:07.117908-05	\N
237	237	1	1	0	{}	2025-12-23 20:17:02.532602-05	\N
238	238	2	1	0	{}	2025-12-23 20:18:10.317892-05	\N
239	239	2	1	0	{}	2025-12-23 20:19:13.403727-05	\N
240	240	1	1	0	{}	2025-12-23 20:19:43.159978-05	\N
241	241	2	1	0	[{"icon": "📊", "label": "Tasa de Éxito", "value": "0,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "0,00 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "1", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "1", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-12-23 20:21:41.443763-05	\N
242	242	1	1	0	{}	2025-12-26 15:00:32.78882-05	\N
243	243	2	1	0	{}	2025-12-26 15:00:44.094941-05	\N
244	244	1	1	0	{}	2025-12-26 15:00:58.260389-05	\N
245	245	2	1	0	{}	2025-12-26 15:01:06.681327-05	\N
246	246	2	1	0	{}	2025-12-26 15:06:00.491994-05	\N
247	247	2	1	0	{}	2025-12-26 15:08:26.174289-05	\N
248	248	5	1	0	{}	2025-12-26 15:13:22.103982-05	\N
249	249	5	1	0	{}	2025-12-26 15:41:02.943322-05	\N
250	250	5	1	0	{}	2025-12-26 18:24:54.78008-05	\N
251	251	2	1	0	{}	2025-12-26 18:35:36.848841-05	\N
252	252	5	1	0	{}	2025-12-26 18:35:47.27528-05	\N
253	253	5	1	0	{}	2025-12-26 20:06:10.609217-05	\N
254	254	1	1	0	{}	2025-12-26 20:07:04.908572-05	\N
255	255	2	1	0	{}	2025-12-26 20:08:01.02008-05	\N
256	256	1	1	0	{}	2025-12-26 20:23:55.782347-05	\N
257	257	2	1	0	{}	2025-12-26 20:25:16.321697-05	\N
258	258	5	1	0	{}	2025-12-26 20:25:29.349579-05	\N
259	259	1	1	0	{}	2025-12-26 20:27:21.678117-05	\N
260	260	5	1	0	{}	2025-12-26 20:27:34.463775-05	\N
261	261	1	1	0	{}	2025-12-26 20:28:07.596453-05	\N
262	262	2	1	0	{}	2025-12-26 20:28:32.105988-05	\N
263	263	5	1	0	{}	2025-12-26 20:30:58.479575-05	\N
264	264	5	1	0	{}	2025-12-26 20:31:28.734542-05	\N
265	265	5	1	0	{}	2025-12-26 20:36:44.964465-05	\N
266	266	5	1	60	[{"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "3,77 s", "helper": "Velocidad media."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Clic incorrecto."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "2", "helper": "Veces que repetiste."}]	2025-12-26 21:08:49.066784-05	\N
290	290	7	1	6342	[{"icon": "❌", "label": "Errores de Comisión", "value": "10", "helper": "Responder “Sí” ante una figura no presentada."}, {"icon": "🚫", "label": "Errores de Omisión", "value": "3", "helper": "Responder “No” ante una figura previamente vista."}]	2025-12-29 18:24:41.613008-05	\N
293	293	7	1	0	{}	2025-12-29 19:05:51.344261-05	\N
294	294	7	1	0	{}	2025-12-29 20:49:30.473236-05	\N
267	267	5	1	20	[{"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "2,46 s", "helper": "Velocidad media."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Clic incorrecto."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "2", "helper": "Veces que repetiste."}]	2025-12-27 09:21:37.107869-05	\N
268	268	5	1	0	[{"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "4,60 s", "helper": "Tiempo medio por selección."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "0", "helper": "Selección de distractores."}, {"icon": "❌", "label": "Errores de Orden", "value": "1", "helper": "Objetos correctos en orden incorrecto."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}]	2025-12-27 10:31:48.685862-05	\N
269	269	1	1	100	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "6", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "71,43 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,93 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "8", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,00", "helper": "Consistencia del rendimiento entre tableros."}]	2025-12-27 18:02:16.609213-05	\N
270	270	1	1	60	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "5", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "52,17 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,36 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "11", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,14", "helper": "Consistencia del rendimiento entre tableros."}]	2025-12-27 18:32:46.772337-05	\N
271	271	1	1	0	{}	2025-12-27 18:33:38.999161-05	\N
272	272	1	1	30	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "4", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "73,33 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "3,68 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "4", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,40", "helper": "Consistencia del rendimiento entre tableros."}]	2025-12-27 19:49:41.467224-05	\N
273	273	1	1	150	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "7", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "77,50 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "3,19 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "9", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,50", "helper": "Consistencia del rendimiento entre tableros."}]	2025-12-27 19:51:52.689876-05	\N
274	274	2	1	30	[{"icon": "📊", "label": "Tasa de Éxito", "value": "60,0 %", "helper": "Porcentaje de secuencias correctas del total intentado."}, {"icon": "⏱️", "label": "Tiempo Promedio / Acierto", "value": "2,19 s", "helper": "Velocidad media para completar secuencias correctas."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Clicaste un número incorrecto en la secuencia."}, {"icon": "…", "label": "Errores de Omisión", "value": "0", "helper": "No completaste la secuencia (si aplica)."}, {"icon": "🔄", "label": "Reintentos Usados", "value": "2", "helper": "Veces que fallaste el primer intento en un nivel."}]	2025-12-27 20:10:51.032-05	\N
275	275	2	1	20	[{"icon": "📏", "label": "Amplitud de Dígitos Máxima"}, {"icon": "📊", "label": "Porcentaje de Secuencias Correctas", "value": "undefined %"}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "NaN s"}, {"icon": "↕️", "label": "Errores de Orden"}, {"icon": "⭕", "label": "Errores de Omisión"}]	2025-12-27 20:19:56.619814-05	\N
276	276	2	1	0	[{"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,79 s", "helper": "Tiempo promedio por secuencia."}, {"icon": "↕️", "label": "Errores de Orden", "value": "1", "helper": "Selecciones fuera del orden correcto."}, {"icon": "⭕", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}]	2025-12-27 20:33:16.192618-05	\N
277	277	6	1	0	{}	2025-12-28 16:49:03.495911-05	\N
278	278	6	1	0	{}	2025-12-28 17:02:23.498279-05	\N
279	279	6	1	0	{}	2025-12-28 17:11:07.439024-05	\N
280	280	6	1	0	[{"icon": "❌", "label": "Errores de Omisión", "value": "12", "helper": "Palabras de la lista que no fueron recordadas en la tercera ronda."}, {"icon": "🚫", "label": "Errores de Comisión (Intrusiones)", "value": "0", "helper": "Palabras seleccionadas que no pertenecían a la lista objetivo."}]	2025-12-28 17:42:03.938422-05	\N
282	282	6	1	0	{}	2025-12-28 18:10:53.208301-05	\N
281	281	6	1	0	[{"icon": "❌", "label": "Errores de Omisión", "value": "12", "helper": "Palabras de la lista que no fueron recordadas en la tercera ronda."}, {"icon": "🚫", "label": "Errores de Comisión (Intrusiones)", "value": "0", "helper": "Palabras seleccionadas que no pertenecían a la lista objetivo."}]	2025-12-28 17:49:59.329108-05	\N
284	284	7	1	0	{}	2025-12-28 21:00:36.843034-05	\N
283	283	6	1	190	[{"icon": "❌", "label": "Errores de Omisión", "value": "2", "helper": "Palabras de la lista que no fueron recordadas en la tercera ronda."}, {"icon": "🚫", "label": "Errores de Comisión (Intrusiones)", "value": "0", "helper": "Palabras seleccionadas que no pertenecían a la lista objetivo."}]	2025-12-28 18:16:40.24816-05	\N
285	285	7	1	0	{}	2025-12-28 21:17:24.995008-05	\N
286	286	7	1	0	{}	2025-12-29 10:01:07.805943-05	\N
287	287	7	1	0	{}	2025-12-29 10:19:37.686531-05	\N
288	288	7	1	0	{}	2025-12-29 10:47:05.273982-05	\N
289	289	7	1	0	{}	2025-12-29 17:43:36.12483-05	\N
295	295	1	1	0	{}	2025-12-29 21:02:19.149236-05	\N
296	296	2	1	0	{}	2025-12-29 21:02:22.517916-05	\N
297	297	5	1	0	{}	2025-12-29 21:02:26.220743-05	\N
298	298	6	1	0	{}	2025-12-29 21:04:02.868207-05	\N
299	299	6	1	0	{}	2025-12-30 06:21:38.245895-05	\N
300	300	7	1	0	{}	2026-01-04 16:58:59.158139-05	\N
301	301	27	1	0	{}	2026-01-04 17:10:31.952437-05	\N
302	302	27	1	0	{}	2026-01-04 17:15:35.910814-05	\N
303	303	1	1	0	{}	2026-01-04 17:27:54.707284-05	\N
304	304	27	1	0	{}	2026-01-04 17:28:26.280597-05	\N
305	305	27	1	0	{}	2026-01-04 17:28:39.914179-05	\N
306	306	1	1	0	{}	2026-01-04 17:33:01.232326-05	\N
307	307	27	1	0	{}	2026-01-04 17:34:45.590546-05	\N
308	308	27	1	0	{}	2026-01-04 17:41:15.489179-05	\N
309	309	27	1	0	{}	2026-01-04 17:41:58.505086-05	\N
310	310	27	1	0	{}	2026-01-04 17:44:58.477956-05	\N
311	311	27	1	0	{}	2026-01-04 17:46:39.875418-05	\N
312	312	27	1	0	{}	2026-01-04 17:49:59.873304-05	\N
313	313	27	1	0	{}	2026-01-04 17:55:39.463541-05	\N
314	314	27	1	0	{}	2026-01-04 20:31:54.300231-05	\N
315	315	27	1	0	{}	2026-01-04 21:08:44.470911-05	\N
316	316	27	1	0	{}	2026-01-04 21:13:37.322562-05	\N
317	317	27	1	3679	[{"icon": "📈", "label": "Nivel máximo alcanzado", "value": 10, "helper": "Máxima complejidad lógica resuelta."}, {"icon": "❌", "label": "Errores lógicos", "value": "33,33 %", "helper": "Respuestas incorrectas por inferencia lógica errónea."}]	2026-01-04 21:27:49.04771-05	\N
318	318	27	1	0	{}	2026-01-05 06:24:45.692396-05	\N
319	319	27	1	0	{}	2026-01-05 06:37:40.799661-05	\N
320	320	27	1	0	{}	2026-01-05 15:40:22.2591-05	\N
321	321	27	1	373	[{"icon": "📈", "label": "Nivel máximo alcanzado", "value": 10, "helper": "Máxima complejidad lógica resuelta."}, {"icon": "❌", "label": "Errores lógicos", "value": "44,44 %", "helper": "Respuestas incorrectas por inferencia lógica errónea."}]	2026-01-05 15:42:27.218437-05	\N
322	322	27	1	0	{}	2026-01-05 16:21:55.056905-05	\N
323	323	5	1	0	{}	2026-01-05 16:31:15.989622-05	\N
324	324	6	1	0	{}	2026-01-05 16:31:22.737425-05	\N
325	325	6	1	0	{}	2026-01-05 17:20:01.774739-05	\N
326	326	5	1	0	{}	2026-01-05 17:48:18.386001-05	\N
327	327	6	1	0	{}	2026-01-05 17:48:21.846458-05	\N
328	328	6	1	0	{}	2026-01-05 17:51:40.48988-05	\N
329	329	6	1	0	{}	2026-01-05 17:56:53.856891-05	\N
330	330	7	1	0	{}	2026-01-05 18:01:06.936592-05	\N
331	331	7	1	0	{}	2026-01-05 18:23:55.206669-05	\N
332	332	7	1	4273	[{"icon": "❌", "label": "Errores de Comisión", "value": "2", "helper": "Responder “Sí” ante una figura no presentada."}, {"icon": "🚫", "label": "Errores de Omisión", "value": "0", "helper": "Responder “No” ante una figura previamente vista."}]	2026-01-05 20:14:47.179871-05	\N
333	333	7	1	6978	[{"icon": "❌", "label": "Errores de Comisión", "value": "2", "helper": "Responder “Sí” ante una figura no presentada."}, {"icon": "🚫", "label": "Errores de Omisión", "value": "0", "helper": "Responder “No” ante una figura previamente vista."}]	2026-01-05 20:23:58.379678-05	\N
334	334	7	1	6488	[{"icon": "❌", "label": "Errores de Comisión", "value": "0", "helper": "Responder “Sí” ante una figura no presentada."}, {"icon": "🚫", "label": "Errores de Omisión", "value": "2", "helper": "Responder “No” ante una figura previamente vista."}]	2026-01-05 20:26:45.566086-05	\N
335	335	1	1	0	{}	2026-01-05 20:27:47.696387-05	\N
336	336	7	1	0	{}	2026-01-05 20:28:34.812981-05	\N
337	337	7	1	7611	[{"icon": "❌", "label": "Errores de Comisión", "value": "1", "helper": "Responder “Sí” ante una figura no presentada."}, {"icon": "🚫", "label": "Errores de Omisión", "value": "1", "helper": "Responder “No” ante una figura previamente vista."}]	2026-01-05 20:52:46.053375-05	\N
338	338	7	1	0	{}	2026-01-05 21:17:01.716165-05	\N
339	339	1	1	10	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "3", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "70,00 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,96 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "3", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,60", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-13 10:35:09.376545-05	\N
340	340	1	1	10	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "3", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "70,00 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "2,08 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "3", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,60", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-13 10:45:19.567918-05	\N
341	341	1	1	10	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "3", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "50,00 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,88 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "5", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,25", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-13 10:48:11.951674-05	\N
342	342	1	1	40	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "4", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "58,82 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,75 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "7", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,16", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-13 10:54:48.370192-05	\N
370	370	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:24:56.408205-05	\N
343	343	1	1	40	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "4", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "52,63 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,67 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "9", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,16", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-13 17:02:16.373872-05	\N
344	344	1	1	40	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "4", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "68,42 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "2,49 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,48", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-13 17:05:37.018805-05	\N
345	345	1	1	450	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "10", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "89,02 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "4,34 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "9", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,66", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-19 16:51:22.919975-05	\N
346	346	2	1	0	[{"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "2,75 s", "helper": "Tiempo promedio por secuencia."}, {"icon": "↕️", "label": "Errores de Orden", "value": "2", "helper": "Selecciones fuera del orden correcto."}, {"icon": "⭕", "label": "Errores de Omisión", "value": "0", "helper": "Secuencias no completadas."}]	2026-01-19 16:53:39.743839-05	\N
347	347	5	1	0	{}	2026-01-19 16:54:36.987221-05	\N
348	348	6	1	0	{}	2026-01-19 16:55:52.556789-05	\N
349	349	7	1	0	{}	2026-01-19 16:58:40.45652-05	\N
350	350	8	1	0	{}	2026-01-19 17:00:27.310256-05	\N
351	351	1	1	0	{}	2026-01-19 17:03:47.00157-05	\N
352	352	2	1	0	{}	2026-01-19 17:04:29.308514-05	\N
353	353	5	1	0	{}	2026-01-19 17:04:42.840978-05	\N
354	354	6	1	0	{}	2026-01-19 17:05:06.347103-05	\N
355	355	1	1	0	{}	2026-01-19 17:05:41.06985-05	\N
356	356	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 20}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 10:25:14.779577-05	\N
357	357	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 20}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 10:54:08.849137-05	\N
358	358	10	1	112	[{"icon": "🚫", "label": "Errores de comisión", "value": 2}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "1881 ms"}]	2026-01-28 10:55:44.184022-05	\N
359	359	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:01:29.865966-05	\N
360	360	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:02:42.115835-05	\N
361	361	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:06:00.037542-05	\N
362	362	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:07:25.752737-05	\N
363	363	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:08:40.269329-05	\N
364	364	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:12:46.125813-05	\N
365	365	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:16:43.798155-05	\N
366	366	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:18:36.315911-05	\N
367	367	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:20:45.41944-05	\N
368	368	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:22:09.780696-05	\N
369	369	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:23:35.378268-05	\N
508	508	19	1	0	{}	2026-02-07 15:17:20.774318-05	\N
509	509	19	1	0	{}	2026-02-07 18:08:48.147769-05	\N
371	371	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:27:11.006012-05	\N
372	372	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:30:58.997179-05	\N
373	373	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:31:25.348131-05	\N
374	374	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 11:39:10.008656-05	\N
375	375	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 15:16:29.549424-05	\N
376	376	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 15:25:24.84975-05	\N
377	377	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 3}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 15:28:46.080352-05	\N
378	378	10	1	18	[{"icon": "🚫", "label": "Errores de comisión", "value": 3}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "307 ms"}]	2026-01-28 15:30:40.891641-05	\N
379	379	10	1	0	{}	2026-01-28 15:40:44.562259-05	\N
380	380	1	1	0	{}	2026-01-28 15:41:28.60996-05	\N
381	381	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-28 15:42:17.066162-05	\N
382	382	1	1	0	{}	2026-01-29 08:30:17.214883-05	\N
383	383	2	1	0	{}	2026-01-29 08:31:08.334185-05	\N
384	384	10	1	0	{}	2026-01-29 08:34:26.659348-05	\N
385	385	1	1	0	{}	2026-01-29 08:34:50.307633-05	\N
386	386	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-29 10:51:22.764539-05	\N
387	387	10	1	36	[{"icon": "🚫", "label": "Errores de comisión", "value": 1}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "18778 ms"}]	2026-01-29 10:55:18.894197-05	\N
388	388	10	1	30	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "1523 ms"}]	2026-01-29 11:01:23.972431-05	\N
389	389	10	1	0	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "0 ms"}]	2026-01-29 11:05:06.10437-05	\N
390	390	10	1	70	[{"icon": "🚫", "label": "Errores de comisión", "value": 0}, {"icon": "❌", "label": "Errores de omisión", "value": 0}, {"icon": "📉", "label": "Variabilidad del tiempo de respuesta", "value": "1075 ms"}]	2026-01-29 11:11:37.11515-05	\N
391	391	6	1	0	{}	2026-01-29 11:17:07.227167-05	\N
392	392	5	1	0	{}	2026-01-29 11:27:11.296543-05	\N
393	393	1	1	730	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "7", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "89,74 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "2,49 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "8", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,71", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-29 16:47:58.134322-05	\N
394	394	1	1	0	{}	2026-01-29 18:33:29.803416-05	\N
395	395	1	1	0	{}	2026-01-29 18:42:21.56194-05	\N
396	396	1	1	0	{}	2026-01-29 18:49:07.106182-05	\N
397	397	1	1	0	{}	2026-01-29 18:49:23.409908-05	\N
398	398	1	1	490	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "6", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "88,14 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "2,10 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "7", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,70", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-29 21:16:23.212327-05	\N
399	399	1	1	550	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "7", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "90,16 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "2,65 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,63", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-29 21:36:31.591619-05	\N
510	510	20	1	0	{}	2026-02-07 18:09:34.872286-05	\N
511	511	20	1	0	{}	2026-02-07 18:13:39.467756-05	\N
512	512	20	1	0	{}	2026-02-07 18:39:06.930978-05	\N
400	400	1	1	280	[{"icon": "📏", "label": "Amplitud Visoespacial Máxima", "value": "5", "helper": "Mayor número de celdas recordadas sin error."}, {"icon": "🎯", "label": "Tasa de Aciertos", "value": "65,52 %", "helper": "Proporción de aciertos sobre el total."}, {"icon": "⏱️", "label": "Tiempo de Respuesta", "value": "1,27 s", "helper": "Tiempo promedio por tablero."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Selecciones incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "10", "helper": "Objetivos no seleccionados."}, {"icon": "📊", "label": "Estabilidad del Desempeño", "value": "0,33", "helper": "Consistencia del rendimiento entre tableros."}]	2026-01-29 22:15:17.809978-05	\N
401	401	2	1	0	{}	2026-01-30 15:32:04.105038-05	\N
402	402	5	1	0	{}	2026-01-30 20:20:18.514336-05	\N
403	403	2	1	0	{}	2026-01-30 20:29:05.450147-05	\N
404	404	2	1	0	{}	2026-01-30 20:37:12.531051-05	\N
405	405	6	1	0	{}	2026-01-30 20:48:32.523603-05	\N
406	406	2	1	0	{}	2026-01-31 08:01:01.630939-05	\N
407	407	7	1	0	{}	2026-01-31 08:17:55.782128-05	\N
408	408	7	1	0	{}	2026-01-31 08:24:30.731241-05	\N
409	409	7	1	0	{}	2026-01-31 08:30:29.001657-05	\N
410	410	7	1	0	{}	2026-01-31 08:33:11.437415-05	\N
411	411	7	1	0	{}	2026-01-31 08:35:14.413112-05	\N
412	412	7	1	0	{}	2026-01-31 10:05:33.435562-05	\N
413	413	1	1	0	{}	2026-01-31 15:02:34.88426-05	\N
414	414	2	1	0	{}	2026-01-31 15:02:47.520456-05	\N
415	415	7	1	0	{}	2026-01-31 15:07:16.423283-05	\N
416	416	8	1	0	{}	2026-01-31 15:15:34.509777-05	\N
417	417	10	1	0	{}	2026-01-31 15:20:05.391599-05	\N
418	418	8	1	0	{}	2026-01-31 15:20:15.807454-05	\N
419	419	8	1	0	{}	2026-01-31 15:21:18.269406-05	\N
420	420	8	1	0	{}	2026-01-31 15:24:32.490756-05	\N
421	421	1	1	0	{}	2026-01-31 15:24:49.062561-05	\N
422	422	8	1	0	{}	2026-01-31 15:25:42.209635-05	\N
423	423	1	1	0	{}	2026-01-31 15:26:01.397849-05	\N
424	424	8	1	0	[{"icon": "📏", "label": "Span Inverso", "value": "0", "helper": "Máximo de elementos invertidos correctamente."}, {"icon": "⏱️", "label": "Tiempo Total", "value": "22,16 s", "helper": "Tiempo invertido en las respuestas."}, {"icon": "🚫", "label": "Errores de Orden", "value": "2", "helper": "Secuencias fallidas por orden incorrecto."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "0", "helper": "Niveles perdidos por inactividad."}]	2026-01-31 15:26:42.059577-05	\N
425	425	8	1	0	{}	2026-01-31 15:30:37.036113-05	\N
426	426	8	1	0	{}	2026-01-31 17:56:55.832237-05	\N
427	427	9	1	0	{}	2026-01-31 18:13:28.117088-05	\N
428	428	8	1	0	{}	2026-01-31 18:21:14.248889-05	\N
434	434	11	1	0	[{"icon": "🚫", "label": "Errores Comisión", "value": 0, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 19:26:51.114171-05	\N
429	429	11	1	1150	[{"icon": "🚫", "label": "Errores Comisión", "value": 5, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 4, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "10.151,5ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 18:51:08.87066-05	\N
432	432	11	1	1025	[{"icon": "🚫", "label": "Errores Comisión", "value": 2, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 19:22:08.381662-05	\N
430	430	11	1	25	[{"icon": "🚫", "label": "Errores Comisión", "value": 2, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 19:08:59.811756-05	\N
435	435	11	1	0	{}	2026-01-31 19:27:11.515053-05	\N
431	431	11	1	1075	[{"icon": "🚫", "label": "Errores Comisión", "value": 0, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 19:14:36.031935-05	\N
433	433	11	1	0	[{"icon": "🚫", "label": "Errores Comisión", "value": 0, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 19:26:25.837479-05	\N
436	436	11	1	0	[{"icon": "🚫", "label": "Errores Comisión", "value": 0, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 21:13:38.206145-05	\N
437	437	11	1	1250	[{"icon": "🚫", "label": "Errores Comisión", "value": 0, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 21:16:54.851711-05	\N
438	438	11	1	1075	[{"icon": "🚫", "label": "Errores Comisión", "value": 2, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "5536ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-01-31 21:24:26.11534-05	\N
439	439	11	1	0	{}	2026-01-31 21:28:56.484474-05	\N
440	440	1	1	0	{}	2026-01-31 21:39:29.547645-05	\N
441	441	11	1	0	{}	2026-01-31 21:43:46.142684-05	\N
442	442	12	1	0	{}	2026-02-01 16:32:13.886775-05	\N
443	443	11	1	0	{}	2026-02-02 08:01:31.38382-05	\N
444	444	1	1	0	{}	2026-02-02 08:36:50.071554-05	\N
445	445	11	1	1025	[{"icon": "🚫", "label": "Errores Comisión", "value": 2, "helper": "Objetivos incorrectos seleccionados (impulsividad)."}, {"icon": "❓", "label": "Errores Omisión", "value": 0, "helper": "Objetivos que no lograste identificar."}, {"icon": "📊", "label": "Variabilidad T.R.", "value": "0ms", "helper": "Estabilidad de tu foco atencional durante la tarea."}]	2026-02-02 08:39:55.375645-05	\N
446	446	11	1	0	{}	2026-02-02 08:41:07.343352-05	\N
447	447	7	1	0	{}	2026-02-02 08:42:28.315371-05	\N
448	448	6	1	0	{}	2026-02-02 08:42:45.010399-05	\N
449	449	1	1	0	{}	2026-02-03 15:03:11.677463-05	\N
450	450	1	1	0	{}	2026-02-03 15:25:55.612454-05	\N
451	451	2	1	0	{}	2026-02-03 15:28:03.292619-05	\N
452	452	1	1	0	{}	2026-02-03 15:28:10.476471-05	\N
453	453	5	1	0	{}	2026-02-03 15:28:15.627264-05	\N
454	454	12	1	0	{}	2026-02-03 21:12:58.565529-05	\N
455	455	12	1	0	{}	2026-02-03 21:19:08.48383-05	\N
456	456	12	1	0	[{"icon": "🚫", "label": "Errores de Comisión", "value": 2, "helper": "Respuestas incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": 0, "helper": "Flechas no respondidas."}, {"icon": "📊", "label": "Estabilidad Atencional", "value": "0,00", "helper": "Consistencia en tu velocidad de respuesta."}]	2026-02-05 17:24:28.613267-05	\N
457	457	12	1	190	[{"icon": "🚫", "label": "Errores de Comisión", "value": 2, "helper": "Respuestas incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": 0, "helper": "Flechas no respondidas."}, {"icon": "📊", "label": "Estabilidad Atencional", "value": "0,62", "helper": "Consistencia en tu velocidad de respuesta."}]	2026-02-05 17:30:18.178085-05	\N
458	458	13	1	10	[{"icon": "⏱️", "label": "TR en Ensayos Válidos", "value": "876 ms", "helper": "Tiempo de reacción cuando la flecha acertó."}, {"icon": "🔄", "label": "Costo de Reorientación", "value": "-876 ms", "helper": "Tiempo extra que tardas cuando la flecha te engaña."}, {"icon": "📊", "label": "Variabilidad del TR", "value": "0,00 ms", "helper": "Qué tan consistente fue tu velocidad de respuesta."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Presionaste el lado equivocado."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "0", "helper": "No respondiste a tiempo."}]	2026-02-05 20:41:13.916685-05	\N
459	459	13	1	160	[{"icon": "⏱️", "label": "TR en Ensayos Válidos", "value": "477 ms", "helper": "Tiempo de reacción cuando la flecha acertó."}, {"icon": "🔄", "label": "Costo de Reorientación", "value": "56 ms", "helper": "Tiempo extra que tardas cuando la flecha te engaña."}, {"icon": "📊", "label": "Variabilidad del TR", "value": "125,43 ms", "helper": "Qué tan consistente fue tu velocidad de respuesta."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Presionaste el lado equivocado."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "0", "helper": "No respondiste a tiempo."}]	2026-02-05 20:55:11.533309-05	\N
460	460	13	1	0	{}	2026-02-05 20:56:13.329358-05	\N
461	461	13	1	0	{}	2026-02-05 20:59:06.0665-05	\N
462	462	14	1	0	{}	2026-02-05 21:07:20.11421-05	\N
463	463	14	1	0	[{"icon": "⏱️", "label": "Velocidad de Reacción", "value": "0 ms", "helper": "Rapidez en capturar patos."}, {"icon": "📊", "label": "Consistencia (Variabilidad)", "value": "0,00 ms", "helper": "Qué tan estable fue tu velocidad."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "0", "helper": "Animales fotografiados por error (Impulsividad)."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "0", "helper": "Patos que se escaparon."}]	2026-02-05 21:07:31.284469-05	\N
464	464	14	1	135	[{"icon": "⏱️", "label": "Velocidad de Reacción", "value": "830 ms", "helper": "Rapidez en capturar patos."}, {"icon": "📊", "label": "Consistencia (Variabilidad)", "value": "93,13 ms", "helper": "Qué tan estable fue tu velocidad."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Animales fotografiados por error (Impulsividad)."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "13", "helper": "Patos que se escaparon."}]	2026-02-05 21:13:22.288358-05	\N
465	465	14	1	150	[{"icon": "⏱️", "label": "Velocidad de Reacción", "value": "842 ms", "helper": "Rapidez en capturar patos."}, {"icon": "📊", "label": "Consistencia (Variabilidad)", "value": "149,42 ms", "helper": "Qué tan estable fue tu velocidad."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Animales fotografiados por error (Impulsividad)."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "6", "helper": "Patos que se escaparon."}]	2026-02-05 21:19:16.026037-05	\N
466	466	15	1	600	[{"icon": "⏱️", "label": "Tiempo Medio de Localización", "value": "0 s", "helper": "Promedio de tiempo por cada palabra encontrada."}, {"icon": "💡", "label": "Uso de Ayudas", "value": "0", "helper": "Cantidad de veces que solicitaste una pista."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "2", "helper": "Intentos fallidos al seleccionar letras incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "2", "helper": "Palabras que no lograste encontrar."}]	2026-02-05 21:30:07.433926-05	\N
477	477	16	1	321	[{"icon": "🧠", "label": "Errores de Confusión", "value": "2", "helper": "Veces que seleccionaste un distractor semánticamente cercano."}, {"icon": "🐢", "label": "Latencia Máxima", "value": "4,67 s", "helper": "Tu tiempo de respuesta más largo."}]	2026-02-06 15:10:06.399688-05	\N
467	467	15	1	400	[{"icon": "⏱️", "label": "Tiempo Medio de Localización", "value": "0 s", "helper": "Promedio de tiempo por cada palabra encontrada."}, {"icon": "💡", "label": "Uso de Ayudas", "value": "0", "helper": "Cantidad de veces que solicitaste una pista."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "0", "helper": "Intentos fallidos al seleccionar letras incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "3", "helper": "Palabras que no lograste encontrar."}]	2026-02-05 21:34:28.23563-05	\N
468	468	15	1	800	[{"icon": "⏱️", "label": "Tiempo Medio de Localización", "value": "0 s", "helper": "Promedio de tiempo por cada palabra encontrada."}, {"icon": "💡", "label": "Uso de Ayudas", "value": "0", "helper": "Cantidad de veces que solicitaste una pista."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "0", "helper": "Intentos fallidos al seleccionar letras incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "1", "helper": "Palabras que no lograste encontrar."}]	2026-02-05 21:40:16.999938-05	\N
469	469	15	1	300	[{"icon": "⏱️", "label": "Tiempo Medio de Localización", "value": "0 s", "helper": "Promedio de tiempo por cada palabra encontrada."}, {"icon": "💡", "label": "Uso de Ayudas", "value": "0", "helper": "Cantidad de veces que solicitaste una pista."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "0", "helper": "Intentos fallidos al seleccionar letras incorrectas."}, {"icon": "🟨", "label": "Errores de Omisión", "value": "5", "helper": "Palabras que no lograste encontrar."}]	2026-02-05 21:57:16.474909-05	\N
470	470	15	1	0	{}	2026-02-05 22:00:52.908214-05	\N
471	471	16	1	164	[{"icon": "🧠", "label": "Errores de Confusión", "value": "6", "helper": "Veces que seleccionaste un distractor semánticamente cercano."}, {"icon": "🐢", "label": "Latencia Máxima", "value": "4,30 s", "helper": "Tu tiempo de respuesta más largo."}]	2026-02-05 22:12:34.147156-05	\N
478	478	17	1	668	[{"icon": "❌", "label": "Errores de Clasificación", "value": "2", "helper": "Total de palabras clasificadas incorrectamente."}, {"icon": "📊", "label": "Variabilidad (Desv. Est.)", "value": "398 ms", "helper": "Mide qué tan constante fuiste en tus respuestas."}]	2026-02-06 15:16:27.415877-05	\N
472	472	16	1	0	[{"icon": "🧠", "label": "Errores de Confusión", "value": "4", "helper": "Veces que seleccionaste un distractor semánticamente cercano."}, {"icon": "🐢", "label": "Latencia Máxima", "value": "11,09 s", "helper": "Tu tiempo de respuesta más largo."}]	2026-02-05 22:24:01.635257-05	\N
479	479	17	1	0	{}	2026-02-06 15:18:26.964659-05	\N
473	473	16	1	0	[{"icon": "🧠", "label": "Errores de Confusión", "value": "4", "helper": "Veces que seleccionaste un distractor semánticamente cercano."}, {"icon": "🐢", "label": "Latencia Máxima", "value": "11,10 s", "helper": "Tu tiempo de respuesta más largo."}]	2026-02-05 22:27:43.802116-05	\N
480	480	3	1	0	{}	2026-02-06 15:30:06.723807-05	\N
474	474	16	1	0	[{"icon": "🧠", "label": "Errores de Confusión", "value": "4", "helper": "Veces que seleccionaste un distractor semánticamente cercano."}, {"icon": "🐢", "label": "Latencia Máxima", "value": "11,06 s", "helper": "Tu tiempo de respuesta más largo."}]	2026-02-05 22:29:06.342039-05	\N
481	481	3	1	0	{}	2026-02-06 15:31:41.248046-05	\N
475	475	16	1	0	[{"icon": "🧠", "label": "Errores de Confusión", "value": "4", "helper": "Veces que seleccionaste un distractor semánticamente cercano."}, {"icon": "🐢", "label": "Latencia Máxima", "value": "10,98 s", "helper": "Tu tiempo de respuesta más largo."}]	2026-02-05 22:30:56.547873-05	\N
476	476	16	1	0	{}	2026-02-05 22:31:57.686522-05	\N
482	482	3	1	1800	[{"icon": "⏱️", "label": "Latencia Inicial", "value": "4670 ms", "helper": "Tiempo que tardaste en escribir la primera palabra."}, {"icon": "🔄", "label": "Perseveraciones", "value": "1", "helper": "Veces que repetiste la misma palabra."}, {"icon": "🚫", "label": "Errores de Comisión", "value": "0", "helper": "Palabras que no cumplían la regla de la letra."}]	2026-02-06 20:41:08.114151-05	\N
483	483	4	1	500	[{"icon": "❌", "label": "Errores de Selección", "value": "2", "helper": "Palabras incorrectas o distractoras seleccionadas."}]	2026-02-06 20:56:17.708795-05	\N
484	484	4	1	1000	[{"icon": "❌", "label": "Errores de Selección", "value": "0", "helper": "Palabras incorrectas o distractoras seleccionadas."}]	2026-02-06 20:58:20.922252-05	\N
485	485	18	1	0	{}	2026-02-06 21:20:31.887768-05	\N
486	486	4	1	0	{}	2026-02-06 21:22:23.632295-05	\N
487	487	3	1	0	{}	2026-02-06 21:22:43.245907-05	\N
488	488	18	1	1200	[{"icon": "⏩", "label": "Anticipaciones", "value": "1", "helper": "Clics antes de tiempo."}, {"icon": "⏪", "label": "Retrasos", "value": "2", "helper": "Clics después del punto exacto."}, {"icon": "📊", "label": "Consistencia (SD)", "value": "77,46 ms", "helper": "Variabilidad en tus reflejos."}]	2026-02-06 21:22:51.961225-05	\N
489	489	18	1	0	{}	2026-02-06 21:23:33.44585-05	\N
490	490	18	1	0	{}	2026-02-06 21:25:03.735541-05	\N
491	491	15	1	0	{}	2026-02-06 21:26:13.988488-05	\N
492	492	3	1	0	{}	2026-02-06 21:26:21.030636-05	\N
493	493	4	1	0	{}	2026-02-06 21:26:42.228114-05	\N
494	494	3	1	0	{}	2026-02-06 21:27:12.677221-05	\N
495	495	16	1	0	{}	2026-02-06 21:27:23.753984-05	\N
496	496	19	1	0	[{"icon": "🔄", "label": "Rotaciones", "value": "5", "helper": "Total de giros realizados."}, {"icon": "⚠️", "label": "Errores Estructurales", "value": "0", "helper": "Intentos de conexión fallidos."}]	2026-02-06 21:31:08.773457-05	\N
497	497	19	1	0	{}	2026-02-06 21:47:37.072039-05	\N
498	498	19	1	0	{}	2026-02-06 21:48:16.591975-05	\N
499	499	19	1	0	{}	2026-02-06 21:52:10.256331-05	\N
500	500	19	1	0	{}	2026-02-06 21:55:56.715124-05	\N
501	501	19	1	0	{}	2026-02-07 10:17:25.082888-05	\N
502	502	19	1	0	{}	2026-02-07 10:48:10.112125-05	\N
503	503	19	1	0	{}	2026-02-07 11:16:00.46449-05	\N
504	504	19	1	0	{}	2026-02-07 14:35:51.89504-05	\N
505	505	19	1	0	{}	2026-02-07 14:46:17.748645-05	\N
506	506	1	1	0	{}	2026-02-07 14:46:24.720265-05	\N
507	507	19	1	0	{}	2026-02-07 14:46:36.532274-05	\N
513	513	20	1	0	[{"icon": "📏", "label": "IPV", "value": "0,00 %", "helper": "Relación entre área cubierta y precisión de movimientos."}, {"icon": "🚫", "label": "Errores de Superposición", "value": "0", "helper": "Veces que se intentó encajar piezas sobre otras."}, {"icon": "🔲", "label": "Espacios no Cubiertos", "value": "0", "helper": "Celdas del contorno que quedaron vacías al finalizar."}, {"icon": "🔄", "label": "Reubicaciones de Piezas", "value": "0", "helper": "Número de veces que se movieron piezas ya colocadas."}]	2026-02-07 20:31:02.108146-05	\N
514	514	20	1	0	[{"icon": "📏", "label": "IPV", "value": "0,00 %", "helper": "Relación entre área cubierta y precisión de movimientos."}, {"icon": "🚫", "label": "Errores de Superposición", "value": "0", "helper": "Veces que se intentó encajar piezas sobre otras."}, {"icon": "🔲", "label": "Espacios no Cubiertos", "value": "0", "helper": "Celdas del contorno que quedaron vacías al finalizar."}, {"icon": "🔄", "label": "Reubicaciones de Piezas", "value": "0", "helper": "Número de veces que se movieron piezas ya colocadas."}]	2026-02-07 20:45:02.909752-05	\N
515	515	20	1	0	[{"icon": "📏", "label": "IPV", "value": "0,00 %", "helper": "Relación entre área cubierta y precisión de movimientos."}, {"icon": "🚫", "label": "Errores de Superposición", "value": "0", "helper": "Veces que se intentó encajar piezas sobre otras."}, {"icon": "🔲", "label": "Espacios no Cubiertos", "value": "0", "helper": "Celdas del contorno que quedaron vacías al finalizar."}, {"icon": "🔄", "label": "Reubicaciones de Piezas", "value": "0", "helper": "Número de veces que se movieron piezas ya colocadas."}]	2026-02-07 20:49:50.94025-05	\N
516	516	20	1	0	[{"icon": "📏", "label": "IPV", "value": "0,00 %", "helper": "Relación entre área cubierta y precisión de movimientos."}, {"icon": "🚫", "label": "Errores de Superposición", "value": "0", "helper": "Veces que se intentó encajar piezas sobre otras."}, {"icon": "🔲", "label": "Espacios no Cubiertos", "value": "0", "helper": "Celdas del contorno que quedaron vacías al finalizar."}, {"icon": "🔄", "label": "Reubicaciones de Piezas", "value": "0", "helper": "Número de veces que se movieron piezas ya colocadas."}]	2026-02-07 21:14:21.380565-05	\N
517	517	20	1	0	{}	2026-02-07 21:24:27.132073-05	\N
518	518	20	1	0	{}	2026-02-07 21:47:04.240648-05	\N
519	519	20	1	0	[{"icon": "📏", "label": "IPV", "value": "0,00 %", "helper": "Relación entre área cubierta y precisión de movimientos."}, {"icon": "🚫", "label": "Errores de Superposición", "value": "0", "helper": "Veces que se intentó encajar piezas sobre otras."}, {"icon": "🔲", "label": "Espacios no Cubiertos", "value": "0", "helper": "Celdas del contorno que quedaron vacías al finalizar."}, {"icon": "🔄", "label": "Reubicaciones de Piezas", "value": "0", "helper": "Número de veces que se movieron piezas ya colocadas."}]	2026-02-08 10:52:59.922328-05	\N
520	520	20	1	0	[{"icon": "📏", "label": "IPV", "value": "0,00 %", "helper": "Relación entre área cubierta y precisión de movimientos."}, {"icon": "🚫", "label": "Errores de Superposición", "value": "0", "helper": "Veces que se intentó encajar piezas sobre otras."}, {"icon": "🔲", "label": "Espacios no Cubiertos", "value": "0", "helper": "Celdas del contorno que quedaron vacías al finalizar."}, {"icon": "🔄", "label": "Reubicaciones de Piezas", "value": "0", "helper": "Número de veces que se movieron piezas ya colocadas."}]	2026-02-08 11:16:24.251697-05	\N
521	521	20	1	100	[{"icon": "📏", "label": "IPV", "value": "100,00 %", "helper": "Mide qué tan exacto fuiste al rellenar el contorno."}, {"icon": "🚫", "label": "Superposiciones", "value": "0", "helper": "Veces que intentaste encajar piezas donde no cabían."}, {"icon": "🔲", "label": "Espacios Vacíos", "value": "0", "helper": "Celdas que quedaron sin rellenar."}, {"icon": "🔄", "label": "Reubicaciones", "value": "6", "helper": "Cantidad de movimientos realizados con las piezas."}]	2026-02-08 11:24:26.955963-05	\N
522	522	20	1	783	[{"icon": "📏", "label": "IPV", "value": "78,33 %", "helper": "Exactitud al rellenar el contorno."}, {"icon": "🚫", "label": "Superposiciones", "value": "0", "helper": "Intentos de encaje sobre otras piezas."}, {"icon": "🔲", "label": "Espacios Vacíos", "value": "13", "helper": "Celdas que quedaron sin rellenar."}, {"icon": "🔄", "label": "Reubicaciones", "value": "4", "helper": "Movimientos realizados con las piezas."}]	2026-02-08 11:33:10.959248-05	\N
523	523	21	1	900	[{"icon": "📍", "label": "Errores de Posición", "value": "0", "helper": "Clics en celdas que deberían estar vacías."}, {"icon": "🎨", "label": "Errores de Color", "value": "10", "helper": "Veces que se usó un color equivocado."}, {"icon": "⚡", "label": "Índice de Eficiencia", "value": "8,57", "helper": "Relación entre precisión y velocidad."}]	2026-02-08 11:41:50.673845-05	\N
524	524	21	1	0	{}	2026-02-08 12:00:24.466125-05	\N
525	525	22	1	867	[{"icon": "❌", "label": "Errores de Conexión", "value": "2", "helper": "Veces que se unieron puntos fuera de orden."}, {"icon": "📐", "label": "Desviación Espacial", "value": "1,70", "helper": "Estimación de la precisión en el recorrido del trazo."}, {"icon": "📏", "label": "Precisión (IPV)", "value": "86,67 %", "helper": "Eficacia constructiva basada en aciertos."}]	2026-02-08 14:55:35.06898-05	\N
526	526	22	1	0	{}	2026-02-08 15:02:40.703037-05	\N
527	527	1	1	0	{}	2026-02-08 15:02:59.011146-05	\N
528	528	22	1	0	{}	2026-02-08 15:04:21.81198-05	\N
529	529	22	1	0	{}	2026-02-08 15:28:38.279647-05	\N
530	530	22	1	1000	[{"icon": "❌", "label": "Errores de Conexión", "value": "0", "helper": "Veces que se unieron puntos fuera de orden."}, {"icon": "📐", "label": "Desviación Espacial", "value": "0,00", "helper": "Estimación de la precisión en el recorrido del trazo."}, {"icon": "📏", "label": "Precisión (IPV)", "value": "100,00 %", "helper": "Eficacia constructiva basada en aciertos."}]	2026-02-08 17:31:11.189694-05	\N
531	531	23	1	120	{}	2026-02-08 20:18:27.43157-05	\N
532	532	23	1	100	{}	2026-02-08 20:28:48.062984-05	\N
533	533	23	1	90	[{"label": "Costo de Cambio", "value": "0 ms", "description": "Tiempo extra que tarda el cerebro en procesar un cambio de regla."}, {"label": "Precisión en Cambios", "value": "50%", "description": "Efectividad al responder justo cuando la regla acaba de cambiar."}, {"label": "Errores Perseverativos", "value": "0%", "description": "Veces que seguiste usando la regla anterior por error."}, {"label": "Tiempo Base (Sin cambio)", "value": "1318 ms", "description": "Tu velocidad de reacción cuando la regla se mantiene igual."}]	2026-02-08 20:44:34.370533-05	\N
534	534	23	1	80	[{"label": "Costo de Cambio", "value": "130 ms", "description": "Tiempo extra que tarda el cerebro en procesar un cambio de regla."}, {"label": "Precisión en Cambios", "value": "100%", "description": "Efectividad al responder justo cuando la regla acaba de cambiar."}, {"label": "Errores Perseverativos", "value": "0%", "description": "Veces que seguiste usando la regla anterior por error."}, {"label": "Tiempo Base (Sin cambio)", "value": "933 ms", "description": "Tu velocidad de reacción cuando la regla se mantiene igual."}]	2026-02-08 20:47:12.395428-05	\N
535	535	23	1	60	[{"label": "Costo de Cambio", "value": "0 ms", "description": "Tiempo extra que tarda el cerebro en procesar un cambio de regla."}, {"label": "Precisión en Cambios", "value": "0%", "description": "Efectividad al responder justo cuando la regla acaba de cambiar."}, {"label": "Errores Perseverativos", "value": "100%", "description": "Veces que seguiste usando la regla anterior por error."}, {"label": "Tiempo Base (Sin cambio)", "value": "1030 ms", "description": "Tu velocidad de reacción cuando la regla se mantiene igual."}]	2026-02-08 20:57:50.136152-05	\N
536	536	23	1	60	[{"label": "Costo de Cambio", "value": "953 ms", "description": "Tiempo extra que tarda el cerebro en procesar un cambio de regla."}, {"label": "Precisión en Cambios", "value": "100%", "description": "Efectividad al responder justo cuando la regla acaba de cambiar."}, {"label": "Errores Perseverativos", "value": "0%", "description": "Veces que seguiste usando la regla anterior por error."}, {"label": "Tiempo Base (Sin cambio)", "value": "957 ms", "description": "Tu velocidad de reacción cuando la regla se mantiene igual."}]	2026-02-08 21:08:59.646725-05	\N
537	537	24	1	100	[{"label": "Aciertos Incongruentes", "value": "100%", "description": "Precisión cuando la tinta y el significado de la palabra no coinciden."}, {"label": "Tiempo de Reacción", "value": "1525 ms", "description": "Tiempo medio de respuesta en ensayos correctos."}, {"label": "Errores de Comisión", "value": 2, "description": "Veces que respondiste incorrectamente."}, {"label": "Errores de Omisión", "value": 0, "description": "Ensayos en los que se agotó el tiempo sin responder."}]	2026-02-08 21:16:59.037111-05	\N
538	538	25	1	0	{}	2026-02-08 21:23:45.456252-05	\N
539	539	25	1	140	[{"label": "Costo de Cambio", "value": "0 ms", "description": "Tiempo extra invertido al procesar un cambio de color/regla."}, {"label": "Precisión en Cambios", "value": "100%", "description": "Efectividad justo después de que la regla cambia."}, {"label": "Errores Perseverativos", "value": "0%", "description": "Veces que usaste la regla del color anterior."}, {"label": "Tiempo Base", "value": "5361 ms", "description": "Velocidad media cuando el color de la hoja se repite."}]	2026-02-08 21:32:30.178325-05	\N
540	540	25	1	0	{}	2026-02-08 21:34:05.206518-05	\N
541	541	26	1	0	[{"label": "Precisión inferencial", "value": "0%", "description": "Porcentaje de problemas resueltos correctamente."}, {"label": "Tiempo medio de resolución", "value": "0 ms", "description": "Promedio del tiempo hasta resolver (solo problemas correctos)."}, {"label": "Intentos incorrectos", "value": "2", "description": "Número total de selecciones erróneas."}]	2026-02-08 21:47:41.378681-05	\N
542	542	26	1	0	{}	2026-02-08 21:48:20.92519-05	\N
543	543	26	1	60	[{"label": "Precisión inferencial", "value": "100%", "description": "Porcentaje de problemas resueltos correctamente."}, {"label": "Tiempo medio de resolución", "value": "9840 ms", "description": "Promedio del tiempo hasta resolver (solo problemas correctos)."}, {"label": "Intentos incorrectos", "value": "2", "description": "Número total de selecciones erróneas."}]	2026-02-09 09:27:41.897615-05	\N
544	544	26	1	80	[{"label": "Precisión inferencial", "value": "100%", "description": "Porcentaje de problemas resueltos correctamente."}, {"label": "Tiempo medio de resolución", "value": "4227 ms", "description": "Promedio del tiempo hasta resolver (solo problemas correctos)."}, {"label": "Intentos incorrectos", "value": "2", "description": "Número total de selecciones erróneas."}]	2026-02-09 09:36:34.614214-05	\N
545	545	26	1	0	{}	2026-02-09 09:39:19.956632-05	\N
546	546	26	1	0	{}	2026-02-09 10:12:40.889748-05	\N
547	547	26	1	0	{}	2026-02-09 15:44:55.030241-05	\N
548	548	27	1	0	{}	2026-02-09 16:14:44.411642-05	\N
549	549	27	1	0	{}	2026-02-09 16:28:00.20744-05	\N
550	550	27	1	0	{}	2026-02-09 16:51:18.474567-05	\N
551	551	27	1	0	{}	2026-02-09 16:57:20.832127-05	\N
552	552	27	1	173	[{"icon": "⏱️", "label": "Tiempo medio de resolución", "value": "1,14 s", "helper": "Promedio del tiempo por ítem respondido."}, {"icon": "🧠", "label": "Tasa de errores lógicos", "value": "66,67 %", "helper": "Errores / intentos totales (porcentaje)."}]	2026-02-09 17:21:50.435424-05	\N
553	553	27	1	0	{}	2026-02-09 17:24:36.038812-05	\N
\.


--
-- TOC entry 3403 (class 0 OID 17004)
-- Dependencies: 217
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games (id, game_code, name, description, cognitive_domain) FROM stdin;
1	MEM-01	Matriz de memoria	Memoriza la posición de los objetos en la matriz.	Memoria
2	MEM-02	Sigue la secuencia	Sigue la secuencia de luces ignorando los distractores.	Memoria
3	LEN-04	Tormenta de Palabras	Se le da al participante una letra del abecedario y un límite de tiempo para generar todas las palabras válidas que comiencen con esa letra.	Lenguaje y Funciones Ejecutivas
4	LEN-05	El Lector del Cosmos	El jugador selecciona palabras flotantes y las ordena para construir una oración gramaticalmente válida, evitando palabras distractoras.	Lenguaje
5	MEM-03	Recuerda los objetos	Identifica objetos y reproduce su secuencia, ignorando los distractores.	Memoria y Memoria de Trabajo
6	MEM-04	Caja de recuerdos	Memoriza una lista de 12 palabras, repetida 3 veces, y selecciona las que recuerdes.	Memoria
7	MEM-05	Deja vú	Responde 'sí' o 'no' para discriminar entre figuras vistas y nuevos distractores.	Memoria
8	MEM-06	Ruta de luces	Haz clic en los círculos en el mismo orden en que fueron iluminados.	Memoria y Memoria de Trabajo
9	MEM-07	Ruta de colores al revés	Reproduce la secuencia de círculos en el orden inverso al mostrado.	Memoria y Funciones ejecutivas
10	AT-01	Concéntrate en el objetivo	Identifica la dirección de una flecha objetivo, filtrando distractores incongruentes.	Atención y Funciones ejecutivas
11	AT-02	Cazador de burbujas	Identifica la posición final de varios objetivos en movimiento que se mezclan con distractores.	Atención
12	AT-03	Enfoca la Flecha	Usa el teclado para seleccionar la dirección a la que apuntan los objetos, ignorando distractores.	Atención
13	AT-04	No te despistes	Indica la ubicación de un estímulo reaccionando a señales válidas (que ayudan) e inválidas (que engañan).	Atención
14	AT-05	Safari Fotográfico	Haz clic para 'fotografiar' a los patos (Go) e inhibe el clic ante otros animales (No-Go).	Atención y Funciones Ejecutivas
15	LEN-01	Sopa de letras	Encuentra y marca palabras ocultas en una cuadrícula de letras.	Lenguaje, Habilidades Visoespaciales y Atención
16	LEN-02	A fin	Selecciona la palabra que sea sinónima de la palabra objetivo en el menor tiempo posible.	Lenguaje
17	LEN-03	¿Qué sentido tiene?	Clasifica palabras como 'positivas' o 'negativas' usando las flechas del teclado.	Lenguaje y Funciones ejecutivas
18	VISO-01	Apunta y acierta!	Haz clic en el momento exacto en que un objeto en movimiento pasa por un punto determinado.	Habilidades Visoespaciales y Funciones Ejecutivas
19	VISO-02	Construye la cañería	Rota o mueve piezas de tubería para crear un canal continuo de agua.	Habilidades Visoespaciales y Funciones Ejecutivas
20	VISO-03	Colorea el camino	Arrastra y coloca bloques de colores para llenar un contorno sin dejar espacios ni superponer.	Habilidades visoconstructivas y Funciones Ejecutivas
21	VISO-04	Mosaico espejo	Replica un patrón de colores haciendo clic en las celdas de una cuadrícula vacía.	Habilidades visoconstructivas
22	VISO-05	Trazos Conectados	Haz clic y arrastra entre puntos para trazar las líneas y replicar una figura objetivo.	Habilidades visoconstructivas
23	FE-01	Enfoque cambiante	Alterna entre juzgar si un número es par o si una letra es vocal, aplicando la regla correcta.	Funciones ejecutivas
24	FE-02	Comparación de colores	Indica si el significado de una palabra coincide con el color de un parche, ignorando el color de la tinta.	Atención y Funciones Ejecutivas
25	FE-03	Hojas navegantes	Indica dirección de movimiento (hoja naranja) u orientación (hoja verde) según el color.	Funciones ejecutivas
26	FE-04	Balance de balanza	Deduce qué conjunto de formas equilibrará la última balanza usando las anteriores como reglas.	Funciones ejecutivas
27	FE-05	Matrices progresivas	Deduce la regla lógica de una matriz 3x3 incompleta y selecciona la figura que la completa.	Funciones ejecutivas
\.


--
-- TOC entry 3407 (class 0 OID 17028)
-- Dependencies: 221
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metrics (id, name, display_name, is_primary, unit, formula, description, game_id) FROM stdin;
205	precision_sintactica_pct	Precisión Sintáctica	t	%	(oraciones_correctas / total_intentos) * 100	Porcentaje de oraciones construidas correctamente desde el punto de vista gramatical.	4
206	tiempo_construccion_promedio_ms	Tiempo Medio de Construcción	f	ms	\N	Tiempo promedio empleado para construir correctamente una oración.	4
207	errores_comision_lexica	Errores de Comisión Léxica	f	recuento	\N	Número de veces que se seleccionaron palabras distractoras durante la construcción de la oración.	4
33	amplitud_visoespacial_span	Amplitud Visoespacial (Span)	t	recuento	\N	La longitud de la secuencia más larga replicada correctamente.	8
36	errores_orden	Errores de Orden	f	recuento	\N	Seleccionar los círculos correctos pero en la secuencia equivocada.	8
26	precision_reconocimiento_pct	Precisión de Reconocimiento	t	%	\N	Porcentaje total de juicios correctos considerando aciertos y rechazos correctos.	7
32	tiempo_reaccion_promedio_ms	Tiempo de Reacción Promedio	t	ms	\N	Tiempo promedio empleado para emitir una respuesta durante la fase de reconocimiento.	7
50	indice_precision_rastreo	Índice de Precisión de Rastreo	t	índice	\N	Capacidad para mantener el seguimiento correcto de los objetivos frente a distractores.	11
30	errores_omision_misses	Errores de Omisión	f	recuento	\N	Número de veces que se respondió no ante un estímulo previamente presentado.	7
31	errores_comision_falsas_alarmas	Errores de Comisión	f	recuento	\N	Número de veces que se respondió sí ante un estímulo distractor.	7
48	errores_comision	Errores de comisión	f	recuento	\N	Número de respuestas realizadas sobre estímulos distractores.	10
208	precision_semantica_pct	Precisión Semántica	t	%	\N	Porcentaje de palabras clasificadas correctamente según su significado semántico.	17
53	errores_comision	Errores de Comisión	f	recuento	\N	Número de distractores seleccionados por error.	11
54	errores_omision	Errores de Omisión	f	recuento	\N	Número de objetivos correctos que no fueron señalados.	11
209	tiempo_decision_semantica_ms	Tiempo Medio de Decisión Semántica	t	ms	\N	Tiempo promedio empleado para clasificar correctamente el significado semántico de las palabras.	17
210	errores_clasificacion_semantica	Errores de Clasificación Semántica	f	recuento	\N	Número total de clasificaciones incorrectas de la valencia semántica.	17
211	variabilidad_tr_ms	Variabilidad del Tiempo de Respuesta	f	ms	\N	Desviación estándar del tiempo de respuesta en clasificaciones correctas, como indicador de estabilidad del procesamiento semántico.	17
212	precision_temporal_visoespacial_pct	Precisión Temporal Visoespacial	t	%	(respuestas_dentro_ventana / total_intentos) * 100	Porcentaje de respuestas ejecutadas dentro de la ventana temporal considerada correcta.	18
214	errores_anticipacion	Errores de Anticipación	f	recuento	COUNT(t_respuesta < t_objetivo - umbral)	Número de respuestas ejecutadas antes de que el objeto alcance el punto objetivo.	18
215	errores_retraso	Errores de Retraso	f	recuento	COUNT(t_respuesta > t_objetivo + umbral)	Número de respuestas ejecutadas después de que el objeto ha superado el punto objetivo.	18
216	variabilidad_error_temporal_ms	Variabilidad del Error Temporal	f	ms	STDDEV(ABS(t_respuesta - t_objetivo))	Desviación estándar del error temporal absoluto, indicador de estabilidad del control temporal.	18
213	error_temporal_absoluto_promedio_ms	Error Temporal Absoluto Promedio	t	ms	AVG(ABS(t_respuesta - t_objetivo))	Diferencia temporal absoluta media entre la respuesta del participante y el instante objetivo.	18
217	indice_completitud_espacial	Índice de Completitud Espacial	t	%	(conexiones_correctas / conexiones_totales) * 100	Proporción de conexiones correctamente completadas entre fuentes y destinos respecto al total requerido.	19
218	tiempo_total_resolucion_s	Tiempo Total de Resolución	t	s	t_fin - t_inicio	Tiempo total empleado por el jugador para completar correctamente el tablero.	19
219	numero_rotaciones_piezas	Número de Rotaciones de Piezas	f	recuento	COUNT(rotaciones)	Cantidad total de rotaciones realizadas sobre las piezas de tubería.	19
220	numero_movimientos_piezas	Número de Movimientos de Piezas	f	recuento	COUNT(movimientos)	Cantidad total de desplazamientos de piezas dentro de la cuadrícula.	19
221	errores_estructurales	Errores Estructurales	f	recuento	COUNT(errores)	Número de conexiones inválidas, tramos abiertos o configuraciones que impiden el flujo continuo.	19
222	indice_precision_visoconstructiva_pct	Índice de Precisión Viso-constructiva	t	%	area_correcta / area_total * 100	Proporción del área del contorno correctamente cubierta sin superposición ni espacios vacíos.	20
223	tiempo_total_construccion_ms	Tiempo Total de Construcción	t	ms	t_fin - t_inicio	Tiempo total empleado desde la primera colocación válida hasta completar el contorno.	20
224	errores_superposicion	Errores de Superposición	f	recuento	count(superposiciones)	Número de veces que una pieza se superpone a otra.	20
225	espacios_no_cubiertos	Espacios No Cubiertos	f	recuento	count(areas_vacias)	Cantidad de áreas del contorno que quedan sin cubrir al finalizar.	20
226	reubicaciones_piezas	Reubicaciones de Piezas	f	recuento	count(movimientos_repetidos)	Número total de ajustes realizados después de una colocación inicial.	20
227	precision_reconstruccion_pct	Precisión de Reconstrucción Visoespacial	t	%	celdas_correctas / total_celdas * 100	Porcentaje de celdas correctamente replicadas respecto al patrón modelo.	21
228	tiempo_resolucion_s	Tiempo Total de Resolución	t	s	t_fin - t_inicio	Tiempo total empleado para completar correctamente la reconstrucción del patrón.	21
229	indice_eficiencia_visoconstructiva	Índice de Eficiencia Visoconstructiva	t	ratio	precision_reconstruccion_pct / tiempo_resolucion_s	Relación entre la precisión alcanzada y el tiempo total de resolución.	21
230	errores_posicion	Errores de Posición	f	recuento	count(celdas_posicion_incorrecta)	Número de celdas seleccionadas en una posición espacial incorrecta.	21
231	errores_color	Errores de Color	f	recuento	count(celdas_color_incorrecto)	Número de celdas seleccionadas con un color incorrecto respecto al modelo.	21
232	indice_eficiencia_trazado	Índice de Eficiencia de Trazado	t	ms	tiempo_resolucion_ms / precision_trazado	Índice compuesto que integra velocidad y precisión del trazado, penalizando ejecuciones lentas o imprecisas.	22
233	tiempo_resolucion_s	Tiempo de Resolución	f	s	\N	Tiempo total requerido para completar correctamente la figura.	22
234	precision_trazado_pct	Precisión de Trazado	f	%	\N	Porcentaje de trazos correctos respecto al total de conexiones requeridas por la figura.	22
55	tiempo_respuesta_promedio_ms	Tiempo de Respuesta Promedio	t	ms	\N	Tiempo medio de respuesta en selecciones correctas de los objetivos.	11
64	tr_promedio_validos_ms	Tiempo de Reacción en Ensayos Válidos	t	ms	mean(TR_valido)	Tiempo medio de reacción cuando el estímulo aparece en la ubicación señalada.	13
62	costo_reorientacion_ms	Costo de Reorientación Atencional	t	ms	TR_invalido - TR_valido	Diferencia entre el tiempo medio de reacción en ensayos inválidos y válidos.	13
70	porcentaje_aciertos_go_pct	Porcentaje de Aciertos (Go)	t	%	\N	Porcentaje de estímulos Go correctamente respondidos; refleja atención sostenida y detección eficiente de objetivos.	14
68	errores_comision_nogo	Errores de Comisión	t	recuento	\N	Número de respuestas emitidas incorrectamente ante estímulos No-Go; indicador directo del control inhibitorio.	14
71	errores_omision_go	Errores de Omisión	f	recuento	\N	Número de estímulos Go ante los cuales no se emitió respuesta; refleja lapsos atencionales.	14
72	tiempo_reaccion_medio_ms	Tiempo Medio de Reacción	f	ms	\N	Tiempo promedio de respuesta en ensayos Go correctos; refleja velocidad de procesamiento bajo demanda atencional.	14
235	numero_trazos_incorrectos	Número de Trazos Incorrectos	f	recuento	\N	Cantidad de intentos de conexión que no corresponden a la estructura del modelo.	22
236	costo_cambio_regla_ms	Costo de cambio de regla	t	ms	AVG(tr_cambio) - AVG(tr_sin_cambio)	Diferencia entre el tiempo medio de reacción en ensayos de cambio de regla y ensayos sin cambio.	23
237	precision_ensayos_cambio_pct	Precisión en ensayos de cambio	f	%	(aciertos_cambio::float / total_ensayos_cambio) * 100	Porcentaje de respuestas correctas en ensayos donde la regla cambia.	23
238	tasa_errores_perseverativos_pct	Tasa de errores perseverativos	f	%	(errores_perseverativos::float / total_ensayos_cambio) * 100	Porcentaje de ensayos de cambio en los que se aplica la regla anterior.	23
239	tr_medio_sin_cambio_ms	Tiempo medio de respuesta en ensayos sin cambio	f	ms	AVG(tr_sin_cambio)	Tiempo de reacción promedio en ensayos donde la regla se mantiene.	23
16	errores_omision	Errores de Omisión	f	recuento	\N	Número de objetos objetivo no seleccionados.	5
141	tasa_aciertos	Tasa de Aciertos	t	%	(total_aciertos / total_objetivos) * 100	Proporción de aciertos respecto al total de objetivos presentados.	1
17	errores_comision	Errores de Comisión	f	recuento	\N	Número de distractores seleccionados.	5
18	tiempo_respuesta_promedio_ms	Tiempo de respuesta	f	ms	\N	Tiempo promedio en la identificación de cada objeto.	5
144	max_object_span	Amplitud Máxima de Objetos (Span)	t	recuento	\N	Número máximo de objetos recordados correctamente en una secuencia.	5
140	span_visoespacial_max	Amplitud Visoespacial Máxima (Span VS)	t	recuento	max(n)	Mayor número de celdas correctamente reproducidas en un tablero sin error.	1
145	secuencias_correctas_pct	Porcentaje de Secuencias Correctas	t	%	\N	Proporción de secuencias completadas correctamente.	5
146	errores_orden	Errores de Orden	f	recuento	\N	Objetos correctos seleccionados en orden incorrecto.	5
3	errores_comision	Errores de Comisión	f	recuento	\N	Número de celdas seleccionadas que no estaban resaltadas.	1
142	tiempo_respuesta_promedio_ms	Tiempo de Respuesta Promedio	f	ms	promedio(responseTimeMs)	Tiempo promedio de respuesta por tablero.	1
143	errores_omision	Errores de Omisión	f	recuento	\N	Número de celdas objetivo que no fueron seleccionadas.	1
147	estabilidad_desempeno	Estabilidad del Desempeño	f	índice	\N	Variabilidad del desempeño entre tableros.	1
153	max_digit_span	Amplitud máxima de dígitos	t	recuento	\N	Longitud máxima de la secuencia reproducida correctamente.	2
154	percentage_correct_sequences	Porcentaje de secuencias correctas	t	porcentaje	\N	Porcentaje de secuencias reproducidas correctamente respecto al total.	2
155	response_time	Tiempo de respuesta	f	ms	\N	Tiempo promedio de respuesta durante la reproducción de la secuencia.	2
156	order_errors	Errores de orden	f	recuento	\N	Número de errores por reproducción en orden incorrecto.	2
157	omission_errors	Errores de omisión	f	recuento	\N	Número de elementos omitidos durante la reproducción de la secuencia.	2
158	total_palabras_recordadas_ronda_final	Total de Palabras Recordadas (Ronda 3)	t	recuento	\N	Número de palabras objetivo correctamente recordadas en la tercera ronda, indicador principal del aprendizaje verbal consolidado.	6
159	porcentaje_recuerdo_ronda_final	Porcentaje de Recuerdo Correcto (Ronda 3)	t	%	\N	Proporción de palabras correctamente recordadas en la tercera ronda respecto al total de palabras presentadas.	6
160	errores_omision	Errores de Omisión	f	recuento	\N	Número de palabras objetivo no recuperadas en la tercera ronda; refleja fallos de consolidación o evocación.	6
161	errores_comision	Errores de Comisión (Intrusiones)	f	recuento	\N	Número de palabras distractoras seleccionadas que no pertenecían a la lista objetivo.	6
162	tasa_aprendizaje_e3_e1	Tasa de Aprendizaje entre Rondas (E3 − E1)	f	recuento	\N	Incremento en el número de palabras correctamente recordadas entre la primera y la tercera ronda.	6
163	porcentaje_secuencias_correctas	Porcentaje de Secuencias Correctas	f	porcentaje	(secuencias_correctas / secuencias_totales) * 100	Proporción de secuencias reproducidas correctamente respecto al total presentado.	8
164	tiempo_total_respuesta_ms	Tiempo Total de Respuesta	f	ms	\N	Tiempo total empleado para reproducir todas las secuencias de la sesión.	8
165	amplitud_inversa_maxima	Amplitud Inversa Máxima	t	count	\N	Longitud máxima de la secuencia reproducida correctamente en orden inverso.	9
166	porcentaje_secuencias_inversas_correctas	Porcentaje de Secuencias Inversas Correctas	t	percentage	(secuencias_correctas / secuencias_totales) * 100	Proporción de secuencias inversas reproducidas correctamente respecto al total de intentos.	9
167	errores_orden	Errores de Orden	f	count	\N	Errores en los que los estímulos correctos fueron seleccionados en un orden inverso incorrecto.	9
168	errores_omision	Errores de Omisión	f	count	\N	Fallo al seleccionar uno o más estímulos que sí pertenecían a la secuencia.	9
169	tiempo_total_respuesta_ms	Tiempo Total de Respuesta	f	ms	\N	Tiempo total empleado para completar todas las secuencias del juego.	9
170	porcentaje_respuestas_correctas	Porcentaje de respuestas correctas al estímulo objetivo	t	%	\N	Porcentaje de respuestas correctas sobre el total de estímulos objetivo presentados.	10
171	tiempo_medio_respuesta_correcta_ms	Tiempo medio de respuesta correcta	t	ms	\N	Tiempo promedio de respuesta considerando únicamente los ensayos correctos.	10
172	errores_omision	Errores de omisión	f	recuento	\N	Número de estímulos objetivo a los que no se respondió.	10
173	variabilidad_tiempo_respuesta_ms	Variabilidad del tiempo de respuesta	f	ms	\N	Desviación estándar del tiempo de respuesta a lo largo de los ensayos.	10
174	variabilidad_tr_ms	Variabilidad del Tiempo de Respuesta	f	ms	STDDEV(tiempo_respuesta_correctos)	Variabilidad intra-sujeto del tiempo de respuesta durante el rastreo de objetivos.	11
175	porcentaje_respuestas_correctas_direccion	Porcentaje de Respuestas Correctas Direccionales	t	%	(respuestas_correctas / total_estimulos) * 100	Porcentaje de estímulos cuya dirección fue identificada correctamente respecto al total de estímulos presentados.	12
176	tiempo_medio_respuesta_correcta_ms	Tiempo Medio de Respuesta Correcta	t	ms	SUM(tiempos_respuesta_correctos) / total_respuestas_correctas	Tiempo promedio empleado para responder correctamente a la dirección del estímulo.	12
177	errores_comision	Errores de Comisión	f	recuento	COUNT(respuestas_direccion_incorrecta)	Número de veces que el participante responde a una dirección incorrecta.	12
178	errores_omision	Errores de Omisión	f	recuento	COUNT(estimulos_sin_respuesta)	Número de estímulos ante los cuales no se emitió respuesta.	12
179	variabilidad_tiempo_respuesta_ms	Variabilidad del Tiempo de Respuesta	f	ms	STDDEV(tiempos_respuesta_correctos)	Desviación estándar del tiempo de respuesta en respuestas correctas.	12
180	errores_comision	Errores de Comisión	f	recuento	count(respuesta_incorrecta)	Respuestas emitidas ante una localización incorrecta del estímulo.	13
181	errores_omision	Errores de Omisión	f	recuento	count(no_respuesta)	Falta de respuesta ante la aparición del estímulo objetivo.	13
182	variabilidad_tr_ms	Variabilidad del Tiempo de Reacción	f	ms	stddev(TR)	Desviación estándar del tiempo de reacción, indicador de estabilidad atencional.	13
183	variabilidad_tiempo_reaccion_ms	Variabilidad del Tiempo de Reacción	f	ms	STDDEV(tiempo_reaccion_go_ms)	Desviación estándar del tiempo de reacción en ensayos Go; indica estabilidad y consistencia del procesamiento cognitivo.	14
184	indice_precision_lexica_pct	Índice de Precisión Léxica	t	%	(palabras_correctas / palabras_objetivo) * 100	Proporción de palabras objetivo correctamente identificadas respecto al total presentado.	15
186	errores_comision	Errores de Comisión	f	recuento	\N	Número de selecciones incorrectas sobre letras o secuencias no objetivo.	15
187	errores_omision	Errores de Omisión	f	recuento	\N	Número de palabras objetivo no localizadas al finalizar la tarea.	15
188	uso_pistas	Uso de Pistas	f	recuento	\N	Cantidad de ayudas solicitadas durante la ejecución del juego.	15
185	tiempo_medio_localizacion_s	Tiempo Medio de Localización	t	s	tiempo_total / palabras_correctas	Tiempo promedio requerido para localizar correctamente cada palabra objetivo.	15
189	precision_incongruentes_pct	Precisión en Ensayos Incongruentes	t	%	(aciertos_incongruentes / total_incongruentes) * 100	Porcentaje de respuestas correctas en ensayos incongruentes. Indicador principal del control inhibitorio y la atención selectiva.	24
190	tr_promedio_congruentes_ms	Tiempo de Reacción – Congruentes	f	ms	promedio(TR_congruentes)	Tiempo medio de reacción cuando el significado de la palabra coincide con el color del parche.	24
191	tr_promedio_incongruentes_ms	Tiempo de Reacción – Incongruentes	f	ms	promedio(TR_incongruentes)	Tiempo medio de reacción cuando existe conflicto entre el significado de la palabra y el color del parche.	24
192	efecto_interferencia_stroop_ms	Efecto de Interferencia (Stroop)	f	ms	TR_incongruentes - TR_congruentes	Magnitud del efecto Stroop calculada como la diferencia entre los tiempos de reacción en ensayos incongruentes y congruentes.	24
193	errores_comision	Errores de Comisión	f	recuento	respuestas_incorrectas_incongruentes	Respuestas incorrectas debidas a fallas de inhibición ante estímulos incongruentes.	24
194	errores_omision	Errores de Omisión	f	recuento	no_respuestas_a_estimulos_objetivo	Fallas de respuesta ante estímulos objetivo, asociadas a lapsos atencionales.	24
195	precision_semantica_pct	Precisión Semántica	t	%	(respuestas_correctas / total_ensayos) * 100	Porcentaje de respuestas correctas en la selección de sinónimos semánticamente equivalentes.	16
196	tiempo_medio_respuesta_correcta_ms	Tiempo Medio de Respuesta Correcta	t	ms	promedio(TR_respuestas_correctas)	Tiempo promedio empleado para responder correctamente en los ensayos válidos.	16
197	errores_confusion_semantica	Errores de Confusión Semántica	f	recuento	conteo(seleccion_distractor_semantico)	Número de errores producidos por selección de distractores semánticamente cercanos al estímulo objetivo.	16
198	latencia_maxima_respuesta_ms	Latencia Máxima de Respuesta	f	ms	max(TR_respuesta)	Mayor tiempo de respuesta registrado durante la tarea, indicador de sobrecarga semántica o duda léxica.	16
199	tasa_produccion_lexica_wpm	Tasa de Producción Léxica	t	palabras/minuto	total_palabras_validas / tiempo_total_min	Velocidad de acceso y recuperación léxica bajo restricción temporal.	3
200	total_palabras_validas	Total de Palabras Válidas	t	recuento	\N	Número total de palabras correctas, únicas y conformes a la regla producidas durante el intervalo.	3
201	errores_comision	Errores de Comisión	f	recuento	\N	Producción de palabras inválidas: nombres propios, derivaciones o palabras que no cumplen la regla.	3
202	errores_perseveracion	Errores de Perseveración	f	recuento	\N	Repetición de la misma palabra o de la misma raíz léxica.	3
203	latencia_inicial_ms	Latencia Inicial	f	ms	\N	Tiempo transcurrido desde el inicio del ensayo hasta la primera palabra válida.	3
204	variabilidad_interrespuesta_ms	Variabilidad Inter-respuesta	f	ms	\N	Variabilidad temporal entre respuestas consecutivas, indicador de estabilidad en la recuperación léxica.	3
240	costo_cambio_ms	Costo de Cambio (Switch Cost)	t	ms	AVG(tr_cambio) - AVG(tr_repeticion)	Diferencia del tiempo de reacción promedio entre ensayos de cambio de regla y ensayos de repetición.	25
241	precision_general_pct	Precisión General	f	%	100 * (respuestas_correctas / total_ensayos)	Porcentaje total de respuestas correctas considerando todos los ensayos.	25
242	tr_promedio_repeticion_ms	Tiempo de Reacción – Ensayos de Repetición	f	ms	AVG(tr_repeticion)	Tiempo de reacción promedio en ensayos donde la regla cognitiva se mantiene.	25
243	tr_promedio_cambio_ms	Tiempo de Reacción – Ensayos de Cambio	f	ms	AVG(tr_cambio)	Tiempo de reacción promedio en ensayos donde la regla cognitiva cambia.	25
244	errores_perseveracion	Errores de Perseveración	f	recuento	COUNT(respuesta_incorrecta_cambio)	Número de respuestas incorrectas en ensayos de cambio por aplicación de la regla previa.	25
245	precision_inferencial_pct	Precisión Inferencial	t	%	(respuestas_correctas / total_problemas) * 100	Porcentaje de problemas correctamente resueltos mediante inferencia lógica relacional.	26
246	tiempo_medio_resolucion_ms	Tiempo Medio de Resolución	f	ms	AVG(tiempo_resolucion)	Tiempo promedio requerido para resolver correctamente un problema de balance.	26
247	errores_inferenciales	Errores Inferenciales	f	recuento	COUNT(intentos_incorrectos)	Número de intentos incorrectos derivados de inferencias lógicas erróneas.	26
252	precision_matrices_pct	Precisión en matrices	t	%	(aciertos / total_matrices) * 100	Porcentaje de matrices correctamente resueltas respecto al total presentado.	27
253	tiempo_medio_resolucion_ms	Tiempo medio de resolución	f	ms	AVG(tiempo_respuesta_ms)	Tiempo promedio empleado para resolver una matriz correctamente.	27
254	nivel_maximo_complejidad	Nivel máximo de complejidad alcanzado	f	nivel	MAX(nivel_dificultad)	Nivel más alto de complejidad lógica resuelto correctamente por el jugador.	27
255	tasa_errores_logicos_pct	Tasa de errores lógicos	f	%	(errores_logicos / total_matrices) * 100	Proporción de respuestas incorrectas derivadas de una inferencia lógica errónea.	27
\.


--
-- TOC entry 3413 (class 0 OID 17070)
-- Dependencies: 227
-- Data for Name: rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rounds (id, session_id, round_number, focus_domain) FROM stdin;
1	1	1	General
2	1	2	General
3	1	3	General
4	2	1	General
5	2	2	General
6	2	3	General
7	2	4	General
8	2	5	General
9	2	6	General
10	2	7	General
11	2	8	General
12	2	9	General
13	2	10	General
14	2	11	General
15	2	12	General
16	2	13	General
17	2	14	General
18	2	15	General
19	2	16	General
20	3	1	General
21	3	2	General
22	3	3	General
23	3	4	General
24	3	5	General
25	3	6	General
26	3	7	General
27	3	8	General
28	3	9	General
29	3	10	General
30	3	11	General
31	3	12	General
32	3	13	General
33	3	14	General
34	3	15	General
35	3	16	General
36	3	17	General
37	3	18	General
38	3	19	General
39	3	20	General
40	3	21	General
41	3	22	General
42	3	23	General
43	4	1	General
44	5	1	General
45	6	1	General
46	7	1	General
47	8	1	General
48	9	1	General
49	9	2	General
50	9	3	General
51	9	4	General
52	10	1	General
53	10	2	General
54	10	3	General
55	10	4	General
56	10	5	General
57	11	1	General
58	12	1	General
59	12	2	General
60	12	3	General
61	12	4	General
62	12	5	General
63	13	1	General
64	14	1	General
65	15	1	General
66	16	1	General
67	17	1	General
68	18	1	General
69	19	1	General
70	19	2	General
71	19	3	General
72	19	4	General
73	20	1	General
74	21	1	General
75	22	1	General
76	23	1	General
77	24	1	General
78	25	1	General
79	25	2	General
80	25	3	General
81	25	4	General
82	25	5	General
83	25	6	General
84	25	7	General
85	25	8	General
86	26	1	General
87	27	1	General
88	28	1	General
89	29	1	General
90	30	1	General
91	31	1	General
92	32	1	General
93	33	1	General
94	34	1	General
95	34	2	General
96	34	3	General
97	34	4	General
98	34	5	General
99	34	6	General
100	34	7	General
101	34	8	General
102	34	9	General
103	34	10	General
104	34	11	General
105	34	12	General
106	34	13	General
107	34	14	General
108	34	15	General
109	34	16	General
110	34	17	General
111	34	18	General
112	35	1	General
113	36	1	General
114	37	1	General
115	38	1	General
116	39	1	General
117	40	1	General
118	41	1	General
119	42	1	General
120	43	1	General
121	44	1	General
122	45	1	General
123	45	2	General
124	45	3	General
125	45	4	General
126	45	5	General
127	45	6	General
128	45	7	General
129	45	8	General
130	45	9	General
131	46	1	General
132	46	2	General
133	46	3	General
134	47	1	General
135	48	1	General
136	49	1	General
137	50	1	General
138	51	1	General
139	52	1	General
140	53	1	General
141	54	1	General
142	55	1	General
143	56	1	General
144	57	1	General
145	58	1	General
146	59	1	General
147	60	1	General
148	61	1	General
149	62	1	General
150	63	1	General
151	64	1	General
152	65	1	General
153	66	1	General
154	67	1	General
155	68	1	General
156	69	1	General
157	69	2	General
158	69	3	General
159	69	4	General
160	69	5	General
161	69	6	General
162	70	1	General
163	70	2	General
164	71	1	General
165	72	1	General
166	72	2	General
167	72	3	General
168	72	4	General
169	72	5	General
170	72	6	General
171	72	7	General
172	72	8	General
173	72	9	General
174	72	10	General
175	72	11	General
176	72	12	General
177	72	13	General
178	72	14	General
179	72	15	General
180	73	1	General
181	74	1	General
182	75	1	General
183	76	1	General
184	77	1	General
185	78	1	General
186	78	2	General
187	78	3	General
188	78	4	General
189	78	5	General
190	78	6	General
191	78	7	General
192	78	8	General
193	78	9	General
194	78	10	General
195	78	11	General
196	78	12	General
197	78	13	General
198	78	14	General
199	78	15	General
200	78	16	General
201	79	1	General
202	79	2	General
203	79	3	General
204	79	4	General
205	80	1	General
206	81	1	General
207	82	1	General
208	82	2	General
209	82	3	General
210	83	1	General
211	84	1	General
212	85	1	General
213	86	1	General
214	87	1	General
215	88	1	General
216	88	2	General
217	88	3	General
218	88	4	General
219	88	5	General
220	88	6	General
221	88	7	General
222	88	8	General
223	88	9	General
224	88	10	General
225	88	11	General
226	88	12	General
227	88	13	General
228	88	14	General
229	88	15	General
230	88	16	General
231	88	17	General
232	88	18	General
233	88	19	General
234	88	20	General
235	89	1	General
236	90	1	General
237	91	1	General
238	92	1	General
239	93	1	General
240	94	1	General
241	95	1	General
242	96	1	General
243	96	2	General
244	96	3	General
245	96	4	General
246	96	5	General
247	96	6	General
248	96	7	General
249	96	8	General
250	96	9	General
251	96	10	General
252	96	11	General
253	97	1	General
254	98	1	General
255	99	1	General
256	100	1	General
257	101	1	General
258	102	1	General
259	103	1	General
260	104	1	General
261	105	1	General
262	106	1	General
263	107	1	General
264	108	1	General
265	109	1	General
266	110	1	General
267	111	1	General
268	111	2	General
269	111	3	General
270	111	4	General
271	111	5	General
272	112	1	General
273	113	1	General
274	114	1	General
275	115	1	General
276	116	1	General
277	117	1	General
278	117	2	General
279	117	3	General
280	117	4	General
281	117	5	General
282	117	6	General
283	117	7	General
284	118	1	General
285	119	1	General
286	120	1	General
287	120	2	General
288	120	3	General
289	120	4	General
290	120	5	General
291	120	6	General
292	120	7	General
293	121	1	General
294	122	1	General
295	123	1	General
296	124	1	General
297	125	1	General
298	126	1	General
299	127	1	General
300	128	1	General
301	128	2	General
302	128	3	General
303	128	4	General
304	128	5	General
305	128	6	General
306	128	7	General
307	128	8	General
308	128	9	General
309	128	10	General
310	128	11	General
311	128	12	General
312	128	13	General
313	128	14	General
314	129	1	General
315	130	1	General
316	131	1	General
317	132	1	General
318	133	1	General
319	133	2	General
320	133	3	General
321	133	4	General
322	133	5	General
323	133	6	General
324	133	7	General
325	133	8	General
326	133	9	General
327	133	10	General
328	133	11	General
329	133	12	General
330	133	13	General
331	133	14	General
332	134	1	General
333	135	1	General
334	136	1	General
335	137	1	General
336	138	1	General
337	139	1	General
338	140	1	General
339	141	1	General
340	141	2	General
341	141	3	General
342	141	4	General
343	141	5	General
344	141	6	General
345	142	1	General
346	142	2	General
347	142	3	General
348	142	4	General
349	142	5	General
350	142	6	General
351	142	7	General
352	142	8	General
353	142	9	General
354	142	10	General
355	142	11	General
356	143	1	General
357	143	2	General
358	143	3	General
359	143	4	General
360	143	5	General
361	143	6	General
362	143	7	General
363	143	8	General
364	143	9	General
365	143	10	General
366	143	11	General
367	143	12	General
368	143	13	General
369	143	14	General
370	143	15	General
371	143	16	General
372	143	17	General
373	143	18	General
374	143	19	General
375	143	20	General
376	143	21	General
377	143	22	General
378	143	23	General
379	143	24	General
380	143	25	General
381	143	26	General
382	144	1	General
383	144	2	General
384	144	3	General
385	144	4	General
386	144	5	General
387	144	6	General
388	144	7	General
389	144	8	General
390	144	9	General
391	144	10	General
392	144	11	General
393	144	12	General
394	144	13	General
395	144	14	General
396	144	15	General
397	144	16	General
398	145	1	General
399	146	1	General
400	147	1	General
401	148	1	General
402	149	1	General
403	150	1	General
404	151	1	General
405	152	1	General
406	153	1	General
407	153	2	General
408	153	3	General
409	153	4	General
410	153	5	General
411	153	6	General
412	153	7	General
413	153	8	General
414	153	9	General
415	153	10	General
416	153	11	General
417	153	12	General
418	153	13	General
419	153	14	General
420	153	15	General
421	153	16	General
422	153	17	General
423	153	18	General
424	153	19	General
425	153	20	General
426	153	21	General
427	153	22	General
428	153	23	General
429	153	24	General
430	154	1	General
431	155	1	General
432	156	1	General
433	157	1	General
434	158	1	General
435	159	1	General
436	160	1	General
437	161	1	General
438	162	1	General
439	163	1	General
440	164	1	General
441	165	1	General
442	166	1	General
443	167	1	General
444	167	2	General
445	167	3	General
446	167	4	General
447	167	5	General
448	167	6	General
449	168	1	General
450	168	2	General
451	168	3	General
452	168	4	General
453	168	5	General
454	169	1	General
455	170	1	General
456	171	1	General
457	171	2	General
458	172	1	General
459	173	1	General
460	174	1	General
461	175	1	General
462	176	1	General
463	177	1	General
464	178	1	General
465	179	1	General
466	180	1	General
467	181	1	General
468	182	1	General
469	183	1	General
470	184	1	General
471	185	1	General
472	186	1	General
473	187	1	General
474	188	1	General
475	189	1	General
476	190	1	General
477	191	1	General
478	191	2	General
479	191	3	General
480	191	4	General
481	191	5	General
482	192	1	General
483	193	1	General
484	194	1	General
485	195	1	General
486	196	1	General
487	197	1	General
488	198	1	General
489	199	1	General
490	200	1	General
491	201	1	General
492	202	1	General
493	203	1	General
494	204	1	General
495	205	1	General
496	206	1	General
497	207	1	General
498	208	1	General
499	209	1	General
500	210	1	General
501	211	1	General
502	211	2	General
503	211	3	General
504	211	4	General
505	211	5	General
506	211	6	General
507	211	7	General
508	211	8	General
509	211	9	General
510	211	10	General
511	211	11	General
512	211	12	General
513	212	1	General
514	213	1	General
515	214	1	General
516	215	1	General
517	216	1	General
518	217	1	General
519	218	1	General
520	218	2	General
521	218	3	General
522	218	4	General
523	218	5	General
524	218	6	General
525	218	7	General
526	218	8	General
527	218	9	General
528	218	10	General
529	218	11	General
530	218	12	General
531	219	1	General
532	220	1	General
533	221	1	General
534	222	1	General
535	223	1	General
536	224	1	General
537	225	1	General
538	226	1	General
539	227	1	General
540	228	1	General
541	229	1	General
542	230	1	General
543	231	1	General
544	231	2	General
545	231	3	General
546	231	4	General
547	231	5	General
548	231	6	General
549	231	7	General
550	231	8	General
551	231	9	General
552	231	10	General
553	231	11	General
\.


--
-- TOC entry 3409 (class 0 OID 17043)
-- Dependencies: 223
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, start_time, end_time) FROM stdin;
1	1	2025-09-22 14:50:26.627412-05	\N
2	1	2025-09-24 10:14:35.105965-05	\N
3	1	2025-09-25 08:43:55.859637-05	\N
4	1	2025-09-25 19:15:17.823947-05	\N
5	1	2025-09-25 19:25:15.079153-05	\N
6	1	2025-09-25 19:30:42.064646-05	\N
7	1	2025-09-25 19:46:06.702059-05	\N
8	1	2025-09-25 19:53:12.5169-05	\N
9	1	2025-09-26 14:40:15.674041-05	\N
10	1	2025-09-27 08:40:52.129279-05	\N
11	1	2025-09-27 19:33:10.78594-05	\N
12	1	2025-10-04 10:48:37.395421-05	\N
13	1	2025-10-17 08:42:25.197001-05	\N
14	1	2025-10-17 20:43:18.089093-05	\N
15	1	2025-10-18 20:30:55.129296-05	\N
16	1	2025-10-18 21:01:11.94994-05	\N
17	1	2025-10-18 21:33:08.401155-05	\N
18	1	2025-10-18 21:45:53.913359-05	\N
19	1	2025-10-19 18:31:10.570974-05	\N
20	1	2025-10-19 20:37:01.076443-05	\N
21	1	2025-10-20 15:29:02.266928-05	\N
22	1	2025-10-20 20:19:43.417289-05	\N
23	1	2025-10-20 20:54:37.756677-05	\N
24	1	2025-10-22 17:18:03.538785-05	\N
25	1	2025-10-27 10:43:07.949828-05	\N
26	1	2025-10-27 19:54:31.573417-05	\N
27	1	2025-10-27 19:58:16.951296-05	\N
28	1	2025-10-27 20:02:24.136972-05	\N
29	1	2025-10-27 20:23:18.055451-05	\N
30	1	2025-10-27 20:56:06.783394-05	\N
31	1	2025-10-27 21:10:17.731152-05	\N
32	1	2025-10-27 21:10:46.674175-05	\N
33	1	2025-10-27 21:21:09.704868-05	\N
34	1	2025-10-28 09:20:37.378227-05	\N
35	1	2025-10-28 19:53:35.483728-05	\N
36	1	2025-10-28 20:30:03.51295-05	\N
37	1	2025-10-29 20:24:01.749441-05	\N
38	1	2025-10-29 20:42:49.828356-05	\N
39	1	2025-10-29 20:55:04.037988-05	\N
40	1	2025-10-29 21:00:03.847941-05	\N
41	1	2025-10-29 21:03:28.796398-05	\N
42	1	2025-10-29 21:16:13.757347-05	\N
43	1	2025-10-29 21:27:48.403953-05	\N
44	1	2025-10-29 21:44:44.094236-05	\N
45	1	2025-10-30 08:17:57.372192-05	\N
46	1	2025-11-07 18:04:04.432823-05	\N
47	1	2025-11-07 20:34:50.004717-05	\N
48	1	2025-11-07 20:35:00.418145-05	\N
49	1	2025-11-07 20:35:24.897786-05	\N
50	1	2025-11-07 20:37:08.003827-05	\N
51	1	2025-11-07 20:40:06.817386-05	\N
52	1	2025-11-07 20:42:32.198498-05	\N
53	1	2025-11-07 20:42:33.742074-05	\N
54	1	2025-11-07 20:44:16.579174-05	\N
55	1	2025-11-07 22:46:08.761069-05	\N
56	1	2025-11-07 22:49:23.627734-05	\N
57	1	2025-11-07 23:16:12.997543-05	\N
58	1	2025-11-07 23:18:37.478823-05	\N
59	1	2025-11-07 23:20:10.51559-05	\N
60	1	2025-11-07 23:21:47.370301-05	\N
61	1	2025-11-07 23:22:04.709971-05	\N
62	1	2025-11-07 23:22:41.107825-05	\N
63	1	2025-11-07 23:24:45.841816-05	\N
64	1	2025-11-07 23:25:18.105157-05	\N
65	1	2025-11-07 23:47:10.048429-05	\N
66	1	2025-11-07 23:51:38.975133-05	\N
67	1	2025-11-07 23:51:47.928712-05	\N
68	1	2025-11-07 23:53:33.420054-05	\N
69	1	2025-11-08 00:04:31.640261-05	\N
70	1	2025-11-09 14:54:29.779415-05	\N
71	1	2025-11-09 21:11:44.607966-05	\N
72	1	2025-11-10 06:57:44.725092-05	\N
73	1	2025-11-10 19:32:26.608306-05	\N
74	1	2025-11-10 19:54:14.50542-05	\N
75	1	2025-11-10 19:54:24.790552-05	\N
76	1	2025-11-10 19:54:33.775251-05	\N
77	1	2025-11-10 19:54:54.125951-05	\N
78	1	2025-11-11 09:51:57.221782-05	\N
79	1	2025-11-13 08:05:46.231119-05	\N
80	1	2025-11-26 19:19:36.405235-05	\N
81	1	2025-12-21 20:43:34.908692-05	\N
82	1	2025-12-22 10:02:52.22977-05	\N
83	1	2025-12-22 19:21:37.757088-05	\N
84	1	2025-12-22 20:02:30.316749-05	\N
85	1	2025-12-22 20:30:00.743837-05	\N
86	1	2025-12-22 20:32:55.053978-05	\N
87	1	2025-12-22 20:38:16.449991-05	\N
88	1	2025-12-23 07:53:46.8573-05	\N
89	1	2025-12-23 20:15:05.038261-05	\N
90	1	2025-12-23 20:16:07.066193-05	\N
91	1	2025-12-23 20:17:02.510704-05	\N
92	1	2025-12-23 20:18:10.294852-05	\N
93	1	2025-12-23 20:19:13.386042-05	\N
94	1	2025-12-23 20:19:43.131807-05	\N
95	1	2025-12-23 20:21:41.424892-05	\N
96	1	2025-12-26 15:00:32.722224-05	\N
97	1	2025-12-26 20:06:10.557879-05	\N
98	1	2025-12-26 20:07:04.899488-05	\N
99	1	2025-12-26 20:08:01.012047-05	\N
100	1	2025-12-26 20:23:55.750961-05	\N
101	1	2025-12-26 20:25:16.303051-05	\N
102	1	2025-12-26 20:25:29.340413-05	\N
103	1	2025-12-26 20:27:21.666791-05	\N
104	1	2025-12-26 20:27:34.454743-05	\N
105	1	2025-12-26 20:28:07.588546-05	\N
106	1	2025-12-26 20:28:32.09875-05	\N
107	1	2025-12-26 20:30:58.459971-05	\N
108	1	2025-12-26 20:31:28.725619-05	\N
109	1	2025-12-26 20:36:44.909304-05	\N
110	1	2025-12-26 21:08:48.91919-05	\N
111	1	2025-12-27 09:21:37.057526-05	\N
112	1	2025-12-27 19:49:41.401255-05	\N
113	1	2025-12-27 19:51:52.681104-05	\N
114	1	2025-12-27 20:10:50.961196-05	\N
115	1	2025-12-27 20:19:56.585331-05	\N
116	1	2025-12-27 20:33:15.837743-05	\N
117	1	2025-12-28 16:49:03.468279-05	\N
118	1	2025-12-28 21:00:36.777918-05	\N
119	1	2025-12-28 21:17:24.935864-05	\N
120	1	2025-12-29 10:01:07.771797-05	\N
121	1	2025-12-29 19:05:51.311397-05	\N
122	1	2025-12-29 20:49:30.445485-05	\N
123	1	2025-12-29 21:02:19.110739-05	\N
124	1	2025-12-29 21:02:22.510481-05	\N
125	1	2025-12-29 21:02:26.213292-05	\N
126	1	2025-12-29 21:04:02.833453-05	\N
127	1	2025-12-30 06:21:38.169157-05	\N
128	1	2026-01-04 16:58:59.120373-05	\N
129	1	2026-01-04 20:31:54.242315-05	\N
130	1	2026-01-04 21:08:44.426518-05	\N
131	1	2026-01-04 21:13:37.295757-05	\N
132	1	2026-01-04 21:27:49.001087-05	\N
133	1	2026-01-05 06:24:45.559623-05	\N
134	1	2026-01-05 20:14:46.884647-05	\N
135	1	2026-01-05 20:23:58.308343-05	\N
136	1	2026-01-05 20:26:45.537163-05	\N
137	1	2026-01-05 20:27:47.674418-05	\N
138	1	2026-01-05 20:28:34.795495-05	\N
139	1	2026-01-05 20:52:45.988938-05	\N
140	1	2026-01-05 21:17:01.659258-05	\N
141	1	2026-01-13 10:35:09.298853-05	\N
142	1	2026-01-19 16:51:22.804148-05	\N
143	1	2026-01-28 10:25:14.647185-05	\N
144	1	2026-01-29 08:30:17.083737-05	\N
145	1	2026-01-29 21:16:23.145679-05	\N
146	1	2026-01-29 21:36:31.561549-05	\N
147	1	2026-01-29 22:15:17.782087-05	\N
148	1	2026-01-30 15:32:03.971894-05	\N
149	1	2026-01-30 20:20:18.424552-05	\N
150	1	2026-01-30 20:29:05.392791-05	\N
151	1	2026-01-30 20:37:12.460542-05	\N
152	1	2026-01-30 20:48:32.467758-05	\N
153	1	2026-01-31 08:01:01.570373-05	\N
154	1	2026-01-31 19:08:59.764919-05	\N
155	1	2026-01-31 19:14:36.002028-05	\N
156	1	2026-01-31 19:22:08.347417-05	\N
157	1	2026-01-31 19:26:25.818458-05	\N
158	1	2026-01-31 19:26:51.105796-05	\N
159	1	2026-01-31 19:27:11.505355-05	\N
160	1	2026-01-31 21:13:38.149191-05	\N
161	1	2026-01-31 21:16:54.815896-05	\N
162	1	2026-01-31 21:24:26.071537-05	\N
163	1	2026-01-31 21:28:56.412233-05	\N
164	1	2026-01-31 21:39:29.46337-05	\N
165	1	2026-01-31 21:43:46.105409-05	\N
166	1	2026-02-01 16:32:13.800476-05	\N
167	1	2026-02-02 08:01:31.315045-05	\N
168	1	2026-02-03 15:03:11.597686-05	\N
169	1	2026-02-03 21:12:58.508551-05	\N
170	1	2026-02-03 21:19:08.428466-05	\N
171	1	2026-02-05 17:24:28.563814-05	\N
172	1	2026-02-05 20:41:13.877921-05	\N
173	1	2026-02-05 20:55:11.496744-05	\N
174	1	2026-02-05 20:56:13.312557-05	\N
175	1	2026-02-05 20:59:06.051626-05	\N
176	1	2026-02-05 21:07:20.046925-05	\N
177	1	2026-02-05 21:07:31.273576-05	\N
178	1	2026-02-05 21:13:22.252034-05	\N
179	1	2026-02-05 21:19:15.988201-05	\N
180	1	2026-02-05 21:30:07.384149-05	\N
181	1	2026-02-05 21:34:28.220845-05	\N
182	1	2026-02-05 21:40:16.976207-05	\N
183	1	2026-02-05 21:57:16.447433-05	\N
184	1	2026-02-05 22:00:52.857988-05	\N
185	1	2026-02-05 22:12:34.096177-05	\N
186	1	2026-02-05 22:24:01.603196-05	\N
187	1	2026-02-05 22:27:43.767059-05	\N
188	1	2026-02-05 22:29:06.319048-05	\N
189	1	2026-02-05 22:30:56.412743-05	\N
190	1	2026-02-05 22:31:57.672228-05	\N
191	1	2026-02-06 15:10:06.299765-05	\N
192	1	2026-02-06 20:41:08.090737-05	\N
193	1	2026-02-06 20:56:17.666033-05	\N
194	1	2026-02-06 20:58:20.912519-05	\N
195	1	2026-02-06 21:20:31.845958-05	\N
196	1	2026-02-06 21:22:23.614535-05	\N
197	1	2026-02-06 21:22:43.237139-05	\N
198	1	2026-02-06 21:22:51.952077-05	\N
199	1	2026-02-06 21:23:33.43188-05	\N
200	1	2026-02-06 21:25:03.712963-05	\N
201	1	2026-02-06 21:26:13.970236-05	\N
202	1	2026-02-06 21:26:21.023789-05	\N
203	1	2026-02-06 21:26:42.214364-05	\N
204	1	2026-02-06 21:27:12.665023-05	\N
205	1	2026-02-06 21:27:23.730014-05	\N
206	1	2026-02-06 21:31:08.739035-05	\N
207	1	2026-02-06 21:47:37.023906-05	\N
208	1	2026-02-06 21:48:16.577767-05	\N
209	1	2026-02-06 21:52:10.234742-05	\N
210	1	2026-02-06 21:55:56.687376-05	\N
211	1	2026-02-07 10:17:25.003591-05	\N
212	1	2026-02-07 20:31:02.042017-05	\N
213	1	2026-02-07 20:45:02.869016-05	\N
214	1	2026-02-07 20:49:50.926202-05	\N
215	1	2026-02-07 21:14:21.338341-05	\N
216	1	2026-02-07 21:24:27.097478-05	\N
217	1	2026-02-07 21:47:04.197934-05	\N
218	1	2026-02-08 10:52:59.83732-05	\N
219	1	2026-02-08 20:18:27.367676-05	\N
220	1	2026-02-08 20:28:47.999116-05	\N
221	1	2026-02-08 20:44:34.336563-05	\N
222	1	2026-02-08 20:47:12.37952-05	\N
223	1	2026-02-08 20:57:50.100189-05	\N
224	1	2026-02-08 21:08:59.607097-05	\N
225	1	2026-02-08 21:16:59.001289-05	\N
226	1	2026-02-08 21:23:45.402225-05	\N
227	1	2026-02-08 21:32:30.138964-05	\N
228	1	2026-02-08 21:34:05.187128-05	\N
229	1	2026-02-08 21:47:40.947819-05	\N
230	1	2026-02-08 21:48:20.916659-05	\N
231	1	2026-02-09 09:27:41.830223-05	\N
\.


--
-- TOC entry 3417 (class 0 OID 17104)
-- Dependencies: 231
-- Data for Name: trials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trials (id, game_play_id, trial_number, was_correct, reaction_time_ms) FROM stdin;
\.


--
-- TOC entry 3401 (class 0 OID 16993)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hashed_password, first_name, last_name, birth_date, country, gender, education_level, is_active, is_premium, created_at, last_login, training_goals, preferred_training_days) FROM stdin;
1	prueba3@demo.com	$2b$12$qkCE/H07HvVF5OF.iuDZcO3dPJFB4Ixi5y61WTd4s7oLjBeCOwgFy	PAULA	FIGUEROA	\N	\N	\N	\N	t	f	2025-09-21 19:31:39.931121-05	\N	\N	\N
\.


--
-- TOC entry 3405 (class 0 OID 17017)
-- Dependencies: 219
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.words (id, text, category, gender, number, lang) FROM stdin;
\.


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 224
-- Name: game_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_levels_id_seq', 25, true);


--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 228
-- Name: game_plays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_plays_id_seq', 553, true);


--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 216
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_id_seq', 27, true);


--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 220
-- Name: metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metrics_id_seq', 255, true);


--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 226
-- Name: rounds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rounds_id_seq', 553, true);


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 222
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sessions_id_seq', 231, true);


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 230
-- Name: trials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trials_id_seq', 1, false);


--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 218
-- Name: words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.words_id_seq', 1, false);


--
-- TOC entry 3244 (class 2606 OID 17063)
-- Name: game_levels game_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_levels
    ADD CONSTRAINT game_levels_pkey PRIMARY KEY (id);


--
-- TOC entry 3248 (class 2606 OID 17092)
-- Name: game_plays game_plays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_plays
    ADD CONSTRAINT game_plays_pkey PRIMARY KEY (id);


--
-- TOC entry 3229 (class 2606 OID 17013)
-- Name: games games_game_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_game_code_key UNIQUE (game_code);


--
-- TOC entry 3231 (class 2606 OID 17015)
-- Name: games games_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_name_key UNIQUE (name);


--
-- TOC entry 3233 (class 2606 OID 17011)
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- TOC entry 3240 (class 2606 OID 17035)
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 3246 (class 2606 OID 17077)
-- Name: rounds rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rounds
    ADD CONSTRAINT rounds_pkey PRIMARY KEY (id);


--
-- TOC entry 3242 (class 2606 OID 17049)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3250 (class 2606 OID 17109)
-- Name: trials trials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trials
    ADD CONSTRAINT trials_pkey PRIMARY KEY (id);


--
-- TOC entry 3227 (class 2606 OID 17001)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3235 (class 2606 OID 17024)
-- Name: words words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_pkey PRIMARY KEY (id);


--
-- TOC entry 3237 (class 2606 OID 17026)
-- Name: words words_text_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_text_key UNIQUE (text);


--
-- TOC entry 3238 (class 1259 OID 17041)
-- Name: ix_metrics_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_metrics_name ON public.metrics USING btree (name);


--
-- TOC entry 3225 (class 1259 OID 17002)
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- TOC entry 3253 (class 2606 OID 17064)
-- Name: game_levels game_levels_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_levels
    ADD CONSTRAINT game_levels_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- TOC entry 3255 (class 2606 OID 17098)
-- Name: game_plays game_plays_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_plays
    ADD CONSTRAINT game_plays_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- TOC entry 3256 (class 2606 OID 17093)
-- Name: game_plays game_plays_round_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_plays
    ADD CONSTRAINT game_plays_round_id_fkey FOREIGN KEY (round_id) REFERENCES public.rounds(id);


--
-- TOC entry 3251 (class 2606 OID 17036)
-- Name: metrics metrics_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- TOC entry 3254 (class 2606 OID 17078)
-- Name: rounds rounds_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rounds
    ADD CONSTRAINT rounds_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id);


--
-- TOC entry 3252 (class 2606 OID 17050)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3257 (class 2606 OID 17110)
-- Name: trials trials_game_play_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trials
    ADD CONSTRAINT trials_game_play_id_fkey FOREIGN KEY (game_play_id) REFERENCES public.game_plays(id);


-- Completed on 2026-02-10 10:10:47

--
-- PostgreSQL database dump complete
--

