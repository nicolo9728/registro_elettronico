PGDMP          9                y            registro    13.1    13.1 !    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    33366    registro    DATABASE     d   CREATE DATABASE registro WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';
    DROP DATABASE registro;
                postgres    false            ?            1259    33392 
   seq_classe    SEQUENCE     s   CREATE SEQUENCE public.seq_classe
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.seq_classe;
       public          postgres    false            ?            1259    33394    classi    TABLE     ?   CREATE TABLE public.classi (
    idclasse integer DEFAULT nextval('public.seq_classe'::regclass) NOT NULL,
    anno integer NOT NULL,
    sezione character(2) NOT NULL
);
    DROP TABLE public.classi;
       public         heap    postgres    false    202            ?            1259    33470 
   competenze    TABLE     s   CREATE TABLE public.competenze (
    nomemateria character varying(30) NOT NULL,
    iddocente integer NOT NULL
);
    DROP TABLE public.competenze;
       public         heap    postgres    false            ?            1259    33409    docenti    TABLE       CREATE TABLE public.docenti (
    iddocente integer NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    datanascita date NOT NULL,
    CONSTRAINT docenti_datanascita_check CHECK ((datanascita < CURRENT_DATE))
);
    DROP TABLE public.docenti;
       public         heap    postgres    false            ?            1259    33420    insegnamenti    TABLE     d   CREATE TABLE public.insegnamenti (
    iddocente integer NOT NULL,
    idclasse integer NOT NULL
);
     DROP TABLE public.insegnamenti;
       public         heap    postgres    false            ?            1259    33450    materie    TABLE     w   CREATE TABLE public.materie (
    nomemateria character varying(30) NOT NULL,
    descrizione character varying(50)
);
    DROP TABLE public.materie;
       public         heap    postgres    false            ?            1259    33384 
   seq_utenti    SEQUENCE     s   CREATE SEQUENCE public.seq_utenti
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.seq_utenti;
       public          postgres    false            ?            1259    33504    seq_voti    SEQUENCE     q   CREATE SEQUENCE public.seq_voti
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.seq_voti;
       public          postgres    false            ?            1259    33435    studenti    TABLE     ?   CREATE TABLE public.studenti (
    idstudente integer NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    datanascita date NOT NULL,
    idclasse integer NOT NULL
);
    DROP TABLE public.studenti;
       public         heap    postgres    false            ?            1259    33386    utenti    TABLE     ?   CREATE TABLE public.utenti (
    matricola integer DEFAULT nextval('public.seq_utenti'::regclass) NOT NULL,
    username character varying(30) NOT NULL,
    password character varying(128) NOT NULL,
    tipo character varying(30) NOT NULL
);
    DROP TABLE public.utenti;
       public         heap    postgres    false    200            ?            1259    33506    voti    TABLE     ?  CREATE TABLE public.voti (
    idvoto integer DEFAULT nextval('public.seq_voti'::regclass) NOT NULL,
    valutazione integer NOT NULL,
    descrizione character varying(50) NOT NULL,
    data date NOT NULL,
    idstudente integer NOT NULL,
    iddocente integer NOT NULL,
    nomemateria character varying(30) NOT NULL,
    CONSTRAINT voti_valutazione_check CHECK (((valutazione >= 1) AND (valutazione <= 10)))
);
    DROP TABLE public.voti;
       public         heap    postgres    false    209            J           2606    33399    classi classi_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.classi
    ADD CONSTRAINT classi_pkey PRIMARY KEY (idclasse);
 <   ALTER TABLE ONLY public.classi DROP CONSTRAINT classi_pkey;
       public            postgres    false    203            T           2606    33474    competenze competenze_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.competenze
    ADD CONSTRAINT competenze_pkey PRIMARY KEY (nomemateria, iddocente);
 D   ALTER TABLE ONLY public.competenze DROP CONSTRAINT competenze_pkey;
       public            postgres    false    208    208            L           2606    33414    docenti docenti_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.docenti
    ADD CONSTRAINT docenti_pkey PRIMARY KEY (iddocente);
 >   ALTER TABLE ONLY public.docenti DROP CONSTRAINT docenti_pkey;
       public            postgres    false    204            N           2606    33424    insegnamenti insegnamenti_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.insegnamenti
    ADD CONSTRAINT insegnamenti_pkey PRIMARY KEY (iddocente, idclasse);
 H   ALTER TABLE ONLY public.insegnamenti DROP CONSTRAINT insegnamenti_pkey;
       public            postgres    false    205    205            R           2606    33454    materie materie_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.materie
    ADD CONSTRAINT materie_pkey PRIMARY KEY (nomemateria);
 >   ALTER TABLE ONLY public.materie DROP CONSTRAINT materie_pkey;
       public            postgres    false    207            P           2606    33439    studenti studenti_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.studenti
    ADD CONSTRAINT studenti_pkey PRIMARY KEY (idstudente);
 @   ALTER TABLE ONLY public.studenti DROP CONSTRAINT studenti_pkey;
       public            postgres    false    206            H           2606    33391    utenti utenti_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (matricola);
 <   ALTER TABLE ONLY public.utenti DROP CONSTRAINT utenti_pkey;
       public            postgres    false    201            V           2606    33512    voti voti_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_pkey PRIMARY KEY (idvoto);
 8   ALTER TABLE ONLY public.voti DROP CONSTRAINT voti_pkey;
       public            postgres    false    210            ]           2606    33480 $   competenze competenze_iddocente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.competenze
    ADD CONSTRAINT competenze_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);
 N   ALTER TABLE ONLY public.competenze DROP CONSTRAINT competenze_iddocente_fkey;
       public          postgres    false    2892    208    204            \           2606    33475 &   competenze competenze_nomemateria_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.competenze
    ADD CONSTRAINT competenze_nomemateria_fkey FOREIGN KEY (nomemateria) REFERENCES public.materie(nomemateria);
 P   ALTER TABLE ONLY public.competenze DROP CONSTRAINT competenze_nomemateria_fkey;
       public          postgres    false    207    208    2898            W           2606    33415    docenti docenti_iddocente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.docenti
    ADD CONSTRAINT docenti_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.utenti(matricola);
 H   ALTER TABLE ONLY public.docenti DROP CONSTRAINT docenti_iddocente_fkey;
       public          postgres    false    2888    201    204            Y           2606    33430 '   insegnamenti insegnamenti_idclasse_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.insegnamenti
    ADD CONSTRAINT insegnamenti_idclasse_fkey FOREIGN KEY (idclasse) REFERENCES public.classi(idclasse);
 Q   ALTER TABLE ONLY public.insegnamenti DROP CONSTRAINT insegnamenti_idclasse_fkey;
       public          postgres    false    203    205    2890            X           2606    33425 (   insegnamenti insegnamenti_iddocente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.insegnamenti
    ADD CONSTRAINT insegnamenti_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);
 R   ALTER TABLE ONLY public.insegnamenti DROP CONSTRAINT insegnamenti_iddocente_fkey;
       public          postgres    false    2892    205    204            [           2606    33445    studenti studenti_idclasse_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.studenti
    ADD CONSTRAINT studenti_idclasse_fkey FOREIGN KEY (idclasse) REFERENCES public.classi(idclasse);
 I   ALTER TABLE ONLY public.studenti DROP CONSTRAINT studenti_idclasse_fkey;
       public          postgres    false    203    206    2890            Z           2606    33440 !   studenti studenti_idstudente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.studenti
    ADD CONSTRAINT studenti_idstudente_fkey FOREIGN KEY (idstudente) REFERENCES public.utenti(matricola);
 K   ALTER TABLE ONLY public.studenti DROP CONSTRAINT studenti_idstudente_fkey;
       public          postgres    false    206    201    2888            _           2606    33518    voti voti_iddocente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_iddocente_fkey FOREIGN KEY (iddocente) REFERENCES public.docenti(iddocente);
 B   ALTER TABLE ONLY public.voti DROP CONSTRAINT voti_iddocente_fkey;
       public          postgres    false    204    210    2892            ^           2606    33513    voti voti_idstudente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_idstudente_fkey FOREIGN KEY (idstudente) REFERENCES public.studenti(idstudente);
 C   ALTER TABLE ONLY public.voti DROP CONSTRAINT voti_idstudente_fkey;
       public          postgres    false    2896    210    206            `           2606    33523    voti voti_nomemateria_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.voti
    ADD CONSTRAINT voti_nomemateria_fkey FOREIGN KEY (nomemateria) REFERENCES public.materie(nomemateria);
 D   ALTER TABLE ONLY public.voti DROP CONSTRAINT voti_nomemateria_fkey;
       public          postgres    false    207    210    2898           