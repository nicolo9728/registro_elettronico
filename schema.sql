create table Sedi(
    nomeSede char(3) not null primary key,
    descrizione varchar(50) not null
);

create sequence seq_utenti;

create table Utenti(
    matricola int not null primary key default nextval('seq_utenti'),
    nome varchar(30) not null,
    cognome varchar(30) not null,
    dataNascita Date not null,
    username varchar(30) not null,
    password char(60) not null,
    tipo varchar(10) not null,
    nomeSede char(3) not null,

    foreign key (nomeSede) references Sedi,
    check(tipo in ('Docente', 'Studente', 'Admin'))
);

create table Admins(
    idAdmin int not null primary key,
    foreign key (idAdmin) references Utenti
);

create sequence seq_circolari;

create table Circolari(
    numero int not null primary key default nextval('seq_circolari'),
    contenuto varchar(100) not null,
    titolo varchar(20) not null,
    idAdmin int not null,
    nomeSede char(3) not null,

    foreign key (idAdmin) references Admins,
    foreign key (nomeSede) references Sedi
);

create sequence seq_classi;

create table Classi(
    idClasse int not null primary key default nextval('seq_classi'),
    anno int not null,
    sezione char(2) not null,
    nomeSede char(3) not null,

    foreign key (nomeSede) references Sedi
);

create table Studenti(
    idStudente int not null primary key,
    idClasse int not null,

    foreign key (idStudente) references Utenti,
    foreign key (idClasse) references Classi
);

create table Docenti(
    idDocente int not null primary key,

    foreign key (idDocente) references Utenti
);

create table Insegnamenti(
    idClasse int not null,
    idDocente int not null,

    primary key(idClasse, idDocente),
    foreign key (idClasse) references Classi,
    foreign key (idDocente) references Docenti
);

create table Presenze(
    data Date not null,
    idStudente int not null,
    entrata int not null default 1,
    uscita int not null default 6,
    idDocente int not null,

    check(entrata > 0),
    check(uscita >= entrata),

    primary key(idStudente, data),
    foreign key (idStudente) references Studenti,
    foreign key (idDocente) references Docenti
);

create table Materie(
    nomeMateria varchar(30) not null primary key,
    descrizione varchar(50) not null
);

create table Competenze(
    idDocente int not null,
    nomeMateria varchar(50) not null,

    primary key(idDocente, nomeMateria),
    foreign key (idDocente) references Docenti,
    foreign key (nomeMateria) references Materie
);

create sequence seq_voti;

create table Voti(
    idVoto int not null primary key default nextval('seq_voti'),
    data Date not null default CURRENT_DATE,
    valutazione int not null,
    descrizione varchar(50) not null,
    idStudente int not null,
    nomeMateria varchar(30) not null,
    idDocente int not null,

    check(valutazione >= 1 and valutazione <= 10),
    
    foreign key (idStudente) references Studenti,
    foreign key (nomeMateria) references Materie,
    foreign key (idDocente) references Docenti
);