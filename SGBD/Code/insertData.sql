insert into locatie values(1, 'Splaiul Independentei 204', 'Bucuresti', 'Romania');
insert into locatie values(2, 'Bulevardul Iuliu Maniua 104', 'Bucuresti', 'Romania');
insert into locatie values(3, 'Strada Zavoiului 39', 'Chisinau', 'Republica Moldova');
insert into locatie values(4, 'Bergen Strasse 3', 'Berlin', 'Germania');
insert into locatie values(5, 'Bulevardul Alba Iulia 69', 'Cluj-Napoca', 'Romania');

insert into depozit values(1, 1, '0747111111', 'depozit1@email.com');
insert into depozit values(2, 2, '0737222222', 'depozit2@email.com');
insert into depozit values(3, 4, '0737222322', 'depozit3@email.com');
insert into depozit values(4, 5, '0737222422', 'depozit4@email.com');
insert into depozit values(5, 3, '0737252222', 'depozit5@email.com');

insert into utilizator values(1, 'Ion', 'Popescu', 'Administrator', 'ion.popescu@email.com', '0737111111', sysdate, 4);
insert into utilizator values(2, 'Gicu', 'Gigel', 'Utilizator', 'gicu.gigel@email.com', '0737222222', sysdate, 3);
insert into utilizator values(3, 'Dorel', 'Dori', 'Partener', 'dorel.dori@email.com', '0737333333', sysdate, 1);
insert into utilizator values(4, 'Teo', 'Costel', 'Utilizator', 'teo.costel@email.com', '0737204222', sysdate, 4);
insert into utilizator values(5, 'Ana', 'Maria', 'Utilizator', 'ana.maria@email.com', '0737202202', sysdate, 2);

insert into categorie values(1, 'Tech', null, null);
insert into categorie values(2, 'Religie', null, null);
insert into categorie values(3, 'Pantaloni', null, null);
insert into categorie values(4, 'Incaltaminte', null, null);
insert into categorie values(5, 'Utilitare', null, null);

insert into produs values(1, 3, 1, 'Iphone 115 Pro X Max', 'Max', 1099.99, 5);
insert into produs values(2, 1, 2, 'Biblia', 'Efectiv cartea cartilor', 333, 3);
insert into produs values(3, 3, 4, 'Crose alergat', 'Adidas cel mai bun pentru alergat, tripaloski', 699, 4);
insert into produs values(4, 3, 5, 'Banda adeziva', 'Repara orice', 15, 5);
insert into produs values(5, 3, 3, 'Pantaloni negri', 'O pereche de pantaloni', 49.99, 2.5);

insert into StocDepozit values(1, 4, 40);
insert into StocDepozit values(1, 5, 50);
insert into StocDepozit values(1, 2, 100);
insert into StocDepozit values(1, 1, 220);
insert into StocDepozit values(2, 3, 100);
insert into StocDepozit values(2, 2, 10);
insert into StocDepozit values(2, 4, 25);
insert into StocDepozit values(3, 5, 69);
insert into StocDepozit values(3, 2, 420);
insert into StocDepozit values(3, 1, 12);
insert into StocDepozit values(4, 1, 55);
insert into StocDepozit values(4, 2, 69420);
insert into StocDepozit values(4, 3, 34);
insert into StocDepozit values(4, 4, 21);
insert into StocDepozit values(4, 5, 9);

insert into comanda values(1, 1, sysdate);
insert into comanda values(2, 5, sysdate);
insert into comanda values(3, 2, sysdate);
insert into comanda values(4, 3, sysdate);
insert into comanda values(5, 4, sysdate);

insert into PlasareComanda values(1, 1, 2);
insert into PlasareComanda values(1, 2, 4);
insert into PlasareComanda values(2, 4, 5);
insert into PlasareComanda values(2, 3, 8);
insert into PlasareComanda values(2, 5, 2);
insert into PlasareComanda values(3, 1, 1);
insert into PlasareComanda values(3, 2, 3);
insert into PlasareComanda values(3, 5, 1);
insert into PlasareComanda values(4, 4, 2);
insert into PlasareComanda values(4, 3, 7);
insert into PlasareComanda values(5, 3, 3);
insert into PlasareComanda values(5, 1, 2);

commit;
