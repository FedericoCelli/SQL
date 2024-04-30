create database Consegna_30_4_2024;
use Consegna_30_4_2024;

-- tabella product, region e sales
create table Product (
    ProductID int auto_increment primary key,
    ProductName varchar(100),
    Price decimal(10,2),
    Quantity int,
    CategoryName varchar(50)
);

CREATE TABLE Region (
    RegionID int auto_increment primary key,
    RegionName varchar(50),
    SalesID int
);

CREATE TABLE Sales (
    SalesID int auto_increment primary key,
    SalesDate date,
    ProductID int,
    SalesTotal decimal(10,2),
    Quantity int,
    RegionID int
);

-- aggiungo chiavi esterne, creavano un problema se inserite sopra
ALTER TABLE Region
ADD FOREIGN KEY (SalesID) REFERENCES Sales(SalesID);

ALTER TABLE Sales
ADD FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
ADD FOREIGN KEY (RegionID) REFERENCES Region(RegionID);

-- Regioni Italiane; senza ID perché sopra c'è auto_increment
insert into Region (RegionName)
values
	('Abruzzo'),
	('Basilicata'),
	('Calabria'),
	('Campania'),
	('Emilia-Romagna'),
	('Friuli-Venezia Giulia'),
	('Lazio'),
	('Liguria'),
	('Lombardia'),
	('Marche'),
	('Molise'),
	('Piemonte'),
	('Puglia'),
	('Sardegna'),
	('Sicilia'),
	('Toscana'),
	('Trentino-Alto Adige'),
	('Umbria'),
	('Valle d''Aosta'),
	('Veneto')
;

-- Tabella Product
insert into Product (ProductName, Price, Quantity, CategoryName)
values
	('Pasta', 2.5, 100, 'Cibo'),
	('Caffè', 4.0, 50, 'Cibo'),
	('Maglietta', 15.99, 30, 'Abbigliamento'),
	('Scarpe', 49.99, 20, 'Abbigliamento'),
	('Libro', 12.99, 80, 'Libri'),
	('Televisore', 499.99, 10, 'Elettronica'),
	('Smartphone', 699.99, 15, 'Elettronica'),
	('Fornello', 199.99, 5, 'Elettrodomestici'),
	('Asciugatrice', 349.99, 8, 'Elettrodomestici'),
	('Vaso', 29.99, 40, 'Arredamento');

-- Tabella Sales
insert into  Sales (SalesDate, ProductID, SalesTotal, Quantity, RegionID)
values
	('2024-01-01', 1, 10.00, 4, 1),
	('2024-02-15', 3, 34.00, 2, 5),
	('2024-03-20', 5, 45.00, 3, 9),
	('2024-04-10', 7, 8.00, 8, 15),
	('2024-05-05', 2, 6.00, 5, 20),
	('2024-06-18', 9, 15.40, 2, 12),
	('2024-07-30', 4, 20.00, 1, 7),
	('2024-08-22', 6, 29.99, 4, 17),
	('2024-09-14', 8, 21.00, 3, 3),
	('2024-10-03', 10, 13.50, 2, 11),
	('2023-01-10', 1, 15.00, 6, 2),
	('2023-02-22', 3, 25.50, 3, 6),
	('2023-03-15', 5, 40.00, 4, 10),
	('2023-04-05', 7, 7.50, 5, 14),
	('2023-05-12', 2, 4.80, 2, 19),
	('2023-06-25', 9, 18.00, 3, 13),
	('2023-07-18', 4, 30.00, 1, 8),
	('2023-08-09', 6, 22.99, 2, 18),
	('2023-09-30', 8, 18.50, 4, 4),
	('2023-10-20', 10, 12.00, 3, 16)
;

-- Esercizio 1 verifico che le pk siano univoche:
-- se non ci sono risultati significa che c'è sono una chiave, quindi è una chiave primaria
select count(SalesID)
from Sales
group by SalesID
having count(SalesID) >1;

-- ripeto per le altre due
select count(RegionID)
from Region
group by RegionID
having count(RegionID) >1;

select count(ProductID)
from Product
group by ProductID
having count(ProductID) >1;

-- Esercizio 2
-- Esporre l'elenco dei soli prodotti venduti 
-- e per ognuno di questi il fatturato totale per anno
SELECT	year(s.salesdate) Anno,
		p.productname "Nome Prodotto",
        s.salestotal "Fatturato Totale"
FROM Sales s
JOIN Product p
ON p.ProductID = s.ProductID
group by 1, 2, 3
order by 3 desc
;

-- Esercizio 3
-- Esporre il fatturato per stato (immagino regione) per anno.
-- Ordina il risultato per date e per fatturato decrescente

select	year(s.salesdate) Anno,
		regionname Regione,
        sum(salestotal) "Fatturato Totale"
from region r
join sales s
on r.regionid = s.regionid
group by year(salesdate), RegionName
order by 1, 3 desc
;

-- Esercizio 4
-- Rispondi alla domanda:
-- Qual è la categoria di articoli maggiormente richiesta dal mercato?

select	CategoryName,
		sum(SalesTotal) "Numero Vendite"
from sales s
join product p
on s.productid = p.productid
group by p.CategoryName
order by 2 desc
limit 1
;

-- Esercizio 5
-- Rispondi alla domanda:
-- quali sono, se ci sono, i prodotti invenduti?
-- Proponi due approcci

-- Prima Opzione
select	p.ProductID,
		p.productname
from product p
left join sales s
on p.productid = s.productid
where s.salesid is null
;

-- Seconda Opzione
select	p.ProductID,
		p.productname
from product p
where productid not in (
			select productid
            from sales
            )
;

-- Esercizio 6
-- Esporre l'elenco dei prodotti con la rispettiva ultima data di vendita
-- (la data di vendita più recente)

select	s.salesdate,
		productname
from product p
join sales s
on p.productid = s.productid
order by 1 desc
;