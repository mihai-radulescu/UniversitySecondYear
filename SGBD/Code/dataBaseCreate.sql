drop table Utilizator cascade constraints;
drop table Depozit cascade constraints;
drop table StocDepozit cascade constraints;
drop table Produs cascade constraints;
drop table Locatie cascade constraints;
drop table Categorie cascade constraints;
drop table Comanda cascade constraints;
drop table PlasareComanda cascade constraints;

create table Locatie(
	locatie_id number primary key,
	adresa     varchar2(100),
	oras       varchar2(100),
	tara	   varchar2(100)
);

create table Utilizator(
	utilizator_id		number primary key,
	nume				varchar2(20) not null,
	prenume				varchar2(20),
	tip 				varchar2(20) not null,
	email				varchar2(60),
	telefon				varchar2(10),
	DataInregistrare	date,
	locatie_id			number not null,
	foreign key (locatie_id) references Locatie(locatie_id) on delete set null
);

create table Categorie(
	categorie_id	number primary key,
	numeCategorie	varchar2(50),
	PretMinim		number,
	pretMaxim		number
);

create table Produs(
	produs_id		number primary key,
	vanzator_id		number not null,
	categorie_id	number not null,
	titlu			varchar2(200),
	descriere		varchar2(3000),
	pret			number(10, 2),
	rating			number(2, 1),
	foreign key (vanzator_id) references Utilizator(utilizator_id) on delete cascade,
	foreign key (categorie_id) references Categorie(categorie_id) on delete cascade
);

create table Comanda(
	comanda_id		number primary key,
	utilizator_id	number not null,
	data			date,
	foreign key (utilizator_id) references Utilizator(utilizator_id) on delete cascade
);

create table PlasareComanda(
	produs_id		number,
	comanda_id		number,
	cantitate		number,
	primary key (produs_id, comanda_id),
	foreign key (produs_id) references Produs(produs_id) on delete cascade,
	foreign key (comanda_id) references Comanda(comanda_id) on delete cascade
);

create table Depozit(
	depozit_id		number primary key,
	locatie_id		number not null,
	telefon			varchar2(10),
	email			varchar2(60),
	foreign key (locatie_id) references Locatie(locatie_id) on delete set null
);

create table StocDepozit(
	produs_id		number,
	depozit_id		number,
	cantitate		number,
	primary key (produs_id, depozit_id),
	foreign key (produs_id) references Produs(produs_id) on delete cascade,
	foreign key (depozit_id) references Depozit(depozit_id) on delete cascade
);

create or replace trigger IntervalPret
after insert or update on produs for each row
declare
    pretMin      number;
    pretMax      number;
    cat       categorie%rowtype;
begin    
    pretMin := :new.pret;
    pretMax := :new.pret;
    
    select * into cat
    from categorie
    where categorie_id = :new.categorie_id;
    
    if nvl(cat.PretMinim, pretMin) < pretMin then
        pretMin := cat.PretMinim;
    end if;
    
    if nvl(cat.PretMaxim, pretMax) > pretMax then
        pretMax := cat.PretMaxim;
    end if;
    
    update categorie
    set PretMinim = pretMin,
        PretMaxim = pretMax
    where categorie_id = :new.categorie_id;
end;
/

describe locatie;
describe categorie;
describe utilizator;
describe produs;
describe depozit;
describe StocDepozit;
describe comanda;
describe PlasareComanda;

commit;