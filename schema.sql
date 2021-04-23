--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2021-04-23 17:42:42

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

--
-- TOC entry 212 (class 1259 OID 33725)
-- Name: seq_circolari; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_circolari
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_circolari OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 33727)
-- Name: circolari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.circolari (
    numero integer DEFAULT nextval('public.seq_circolari'::regclass) NOT NULL,
    titolo character varying(20),
    contenuto character varying(100),
    idadmin integer NOT NULL,
    nomesede character varying(30) NOT NULL
);


ALTER TABLE public.circolari OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 33392)
-- Name: seq_classe; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_classe
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_classe OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 33394)
-- Name: classi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classi (
    idclasse integer DEFAULT nextval('public.seq_classe'::regclass) NOT NULL,
    anno integer NOT NULL,
    sezione character(2) NOT NULL,
    nomesede character varying(30) DEFAULT 'ITI'::character varying NOT NULL
);


ALTER TABLE public.classi OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 33470)
-- Name: competenze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competenze (
    nomemateria character varying(30) NOT NULL,
    iddocente integer NOT NULL
);


ALTER TABLE public.competenze OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 33409)
-- Name: docenti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.docenti (
    iddocente integer NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    datanascita date NOT NULL,
    CONSTRAINT docenti_datanascita_check CHECK ((datanascita < CURRENT_DATE))
);


ALTER TABLE public.docenti OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 33420)
-- Name: insegnamenti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insegnamenti (
    iddocente integer NOT NULL,
    idclasse integer NOT NULL
);


ALTER TABLE public.insegnamenti OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 33450)
-- Name: materie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materie (
    nomemateria character varying(30) NOT NULL,
    descrizione character varying(50)
);


ALTER TABLE public.materie OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 33801)
-- Name: presenze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.presenze (
    idstudente integer NOT NULL,
    iddocente integer NOT NULL,
    data date NOT NULL,
    tipo character(4) NOT NULL,
    CONSTRAINT presenze_tipo_check CHECK ((tipo = ANY (ARRAY['pres'::bpchar, 'entr'::bpchar, 'usci'::bpchar])))
);


ALTER TABLE public.presenze OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 33621)
-- Name: sedi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sedi (
    nomesede character varying(30) NOT NULL,
    descrizione character varying(50)
);


ALTER TABLE public.sedi OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 33384)
-- Name: seq_utenti; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_utenti
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_utenti OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33504)
-- Name: seq_voti; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_voti
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_voti OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 33435)
-- Name: studenti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studenti (
    idstudente integer NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    datanascita date NOT NULL,
    idclasse integer NOT NULL
);


ALTER TABLE public.studenti OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 33386)
-- Name: utenti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utenti (
    matricola integer DEFAULT nextval('public.seq_utenti'::regclass) NOT NULL,
    username character varying(30) NOT NULL,
    password character varying(128) NOT NULL,
    tipo character varying(30) NOT NULL,
    nomesede character varying(30) DEFAULT 'ITI'::character varying NOT NULL,
    CONSTRAINT utenti_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['Docente'::character varying, 'Studente'::character varying, 'Admin'::character varying])::text[])))
);


ALTER TABLE public.utenti OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 33506)
-- Name: voti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voti (
    idvoto integer DEFAULT nextval('public.seq_voti'::regclass) NOT NULL,
    valutazione integer NOT NULL,
    descrizione character varying(50) NOT NULL,
    data date NOT NULL,
    idstudente integer NOT NULL,
    iddocente integer NOT NULL,
    nomemateria character varying(30) NOT NULL,
    CONSTRAINT voti_valutazione_check CHECK (((valutazione >= 1) AND (valutazione <= 10)))
);


ALTER TABLE public.voti OWNER TO postgres;

--
-- TOC entry 2927 (class 2606 OID 33732)
-- Name: circolari circolari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circolari
    ADD CONSTRAINT circolari_pkey PRIMARY KEY (numero);


--
-- TOC entry 2911 (class 2606 OID 33399)
-- Name: classi classi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classi
    ADD CONSTRAINT classi_pkey PRIMARY KEY (idclasse);


--
-- TOC entry 2921 (class 2606 OID 33474)
-- Name: competenze competenze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competenze
    ADD CONSTRAINT competenze_pkey PRIMARY KEY (nomemateria, iddocente);


--
-- TOC entry 2913 (class 2606 OID 33414)
-- Name: docenti docenti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.docenti
    ADD CONSTRAINT docenti_pkey PRIMARY KEY (iddocente);


--
-- TOC entry 2915 (class 2606 OID 33424)
-- Name: insegnamenti insegnamenti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insegnamenti
    ADD CONSTRAINT insegnamenti_pkey PRIMARY KEY (iddocente, idclasse);


--
-- TOC entry 2919 (class 2606 OID 33454)
-- Name: materie materie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materie
    ADD CONSTRAINT materie_pkey PRIMARY KEY (nomemateria);


--
-- TOC entry 2929 (class 2606 OID 33806)
-- Name: presenze presenze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presenze
    ADD CONSTRAINT presenze_pkey PRIMARY KEY (idstudente, tipo, data);


--
-- TOC entry 2925 (class 2606 OID 33625)
-- Name: sedi sedi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sedi
    ADD CONSTRAINT sedi_pkey PRIMARY KEY (nomesede);


--
-- TOC entry 2917 (class 2606 OID 33439)
-- Name: studenti studenti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studenti
    ADD CONSTRAINT studenti_pkey PRIMARY KEY (idstudente);


--
-- TOC entry 2907 (class 2606 OID 33391)
-- Name: utenti utenti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (matricola);


--
-- TOC entry 2909 (class 2606 OID 33530)
-- Name: utenti utenti_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenti
    ADD CONSTRAINT utenti_username_key UNIQUE (username);


--
-- TOC entry 2923 (class 2606 OID 33512)
-- Name: voti voti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_pkey PRIMARY KEY (idvoto);


--
-- TOC entry 2942 (class 2606 OID 33733)
-- Name: circolari circolari_idadmin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circolari
    ADD CONSTRAINT circolari_idadmin_fkey FOREIGN KEY (idadmin) REFERENCES public.utenti(matricola);


--
-- TOC entry 2943 (class 2606 OID 33738)
-- Name: circolari circolari_nomesede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circolari
    ADD CONSTRAINT circolari_nomesede_fkey FOREIGN KEY (nomesede) REFERENCES public.sedi(nomesede);


--
-- TOC entry 2931 (class 2606 OID 33653)
-- Name: classi classi_nomesede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classi
    ADD CONSTRAINT classi_nomesede_fkey FOREIGN KEY (nomesede) REFERENCES public.sedi(nomesede);


--
-- TOC entry 2938 (class 2606 OID 33480)
-- Name: competenze competenze_iddocente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competenze
    ADD CONSTRAINT competenze_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);


--
-- TOC entry 2937 (class 2606 OID 33475)
-- Name: competenze competenze_nomemateria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competenze
    ADD CONSTRAINT competenze_nomemateria_fkey FOREIGN KEY (nomemateria) REFERENCES public.materie(nomemateria);


--
-- TOC entry 2932 (class 2606 OID 33415)
-- Name: docenti docenti_iddocente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.docenti
    ADD CONSTRAINT docenti_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.utenti(matricola);


--
-- TOC entry 2934 (class 2606 OID 33430)
-- Name: insegnamenti insegnamenti_idclasse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insegnamenti
    ADD CONSTRAINT insegnamenti_idclasse_fkey FOREIGN KEY (idclasse) REFERENCES public.classi(idclasse);


--
-- TOC entry 2933 (class 2606 OID 33425)
-- Name: insegnamenti insegnamenti_iddocente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insegnamenti
    ADD CONSTRAINT insegnamenti_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);


--
-- TOC entry 2945 (class 2606 OID 33812)
-- Name: presenze presenze_iddocente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presenze
    ADD CONSTRAINT presenze_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);


--
-- TOC entry 2944 (class 2606 OID 33807)
-- Name: presenze presenze_idstudente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presenze
    ADD CONSTRAINT presenze_idstudente_fkey FOREIGN KEY (idstudente) REFERENCES public.studenti(idstudente);


--
-- TOC entry 2936 (class 2606 OID 33445)
-- Name: studenti studenti_idclasse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studenti
    ADD CONSTRAINT studenti_idclasse_fkey FOREIGN KEY (idclasse) REFERENCES public.classi(idclasse);


--
-- TOC entry 2935 (class 2606 OID 33440)
-- Name: studenti studenti_idstudente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studenti
    ADD CONSTRAINT studenti_idstudente_fkey FOREIGN KEY (idstudente) REFERENCES public.utenti(matricola);


--
-- TOC entry 2930 (class 2606 OID 33642)
-- Name: utenti utenti_nomesede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenti
    ADD CONSTRAINT utenti_nomesede_fkey FOREIGN KEY (nomesede) REFERENCES public.sedi(nomesede);


--
-- TOC entry 2940 (class 2606 OID 33518)
-- Name: voti voti_iddocente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);


--
-- TOC entry 2939 (class 2606 OID 33513)
-- Name: voti voti_idstudente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_idstudente_fkey FOREIGN KEY (idstudente) REFERENCES public.studenti(idstudente);


--
-- TOC entry 2941 (class 2606 OID 33523)
-- Name: voti voti_nomemateria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_nomemateria_fkey FOREIGN KEY (nomemateria) REFERENCES public.materie(nomemateria);

-- Completed on 2021-04-23 17:42:43

--
-- PostgreSQL database dump complete
--

