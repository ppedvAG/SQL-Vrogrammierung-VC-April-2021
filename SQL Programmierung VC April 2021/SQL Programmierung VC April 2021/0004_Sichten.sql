/*
Views Sichten

Hinter eine Sicht steckt eine Abfrage (SELECT) und enthält selbst keine Daten

Idee: komplexe Statemtents vereinfachen


Sichten verhalten sich wie Tabellen..

Join ja
where ja
AGG mit Group by ja

INS UP DEL.. ja geht, aber nicht immer, miest nur dann, wenn die Sicht keine Joins
 und alle Pflichtspalten enthält

Rechte auf Sichten ja

Trigger ja

Indizes ja
*/

select * from (select * from orders) o
where o.Freight = 0.02

create view vKundeVerkauf
as
select top 100 percent  c.CompanyName
        , c.Country	,c.city
		,o.OrderID	,o.freight 
		,od.UnitPrice, od.Quantity
		,p.ProductName
from 
		customers c 
					inner join 
		orders o				ON c.CustomerID		=	o.CustomerID
					inner join
		[Order Details] od		ON o.orderid		=	od.orderid
					inner join
		Products p				ON od.ProductID		=	p.ProductID
order by c.CustomerID


select * from vKundeVerkauf

alter view vKundeEinkauf
as
select ...


create table slf (id int identity, stadt int, land int)


insert into slf values (10,100)

select * from slf

insert into slf
select 20,200


insert into slf
select 30,300


--Lege eine Sicht an, in der alle Daten zu sehen sind..

create view vslf
as
select * from slf

select * from vslf

--Spalte dazu.. und Fluss mit 1000fachen ID Wert
alter table slf add fluss int
update slf set fluss = id * 1000

--aktuelles Aussehen
select * from slf

select * from vslf --Fluss fehlt, obwohl ein * in der Sicht steht
--jede neue Spalte wird also in der Sicht nicht mehr zu sehen sein
--der Stern wurde aufgelöst in Spaltenamen

alter table slf drop column land --geht...

select * from vslf --nun sind die Werte von Fluss in einer nicht existierende Spalte Land

--Regel: verwende keinen *
--Hilfe: schemabinding

create view vslf2 with schemabinding
as
select * from slf --darf man nicht mehr schreiben wg *



create view vslf2 with schemabinding
as
select id, stadt, fluss from slf --darf man nicht mehr schreiben wg fehlendem Schema


create view vslf2 with schemabinding
as
select id, stadt, fluss from dbo.slf

alter table slf drop column fluss --geht nicht mehr..
--man kann nur die Spalten löschen, die nicht in der Sicht vorkommen
--neue Spalten anlegen sind kein Problem


--Wie schnel ist eine Sicht gegenüber der adhoc Abfrage?
set statistics io, time on -- Dauer und CPU Zeit in ms sowie Anzhal der Seiten
set statistics io, time off -- bis man off setzt oder die verb. beendet
--Vorsicht bei Schleifen zb..

--im Plan sieht man, dass die Sicht gleich schnell ist.. weil der selbe Code ausgeführt wird...

select id, stadt, fluss from dbo.slf

select * from vslf2

--oder man schaut den Plan an...
--von rechts nach links..von Quelle zur Ausgabe
--jedes Symbol enthält Kosten: SQL Dollar
--die Kosten werden nach links aufsummiert
--ein Batch verbraucht immer 100%.. diese können nat. auf mehrere Anweisungen aufgeteilt 
--worden sein
--Ausnahme: bei F() lügt der Plan, dann besser noch messen

select customerid, sum(freight) from nwindbig..orders group by customerid

--lege Sicht vKundeEinkauf an

CREATE  view vKundeVerkauf with schemabinding
as
select top 100 percent   c.CompanyName
        , c.Country	,c.city
		,o.OrderID	,o.freight 
		,od.UnitPrice, od.Quantity
		,p.ProductName
from 
		dbo.customers c 
					inner join 
		dbo.orders o				ON c.CustomerID		=	o.CustomerID
					inner join
		dbo.[Order Details] od		ON o.orderid		=	od.orderid
					inner join
		dbo.Products p				ON od.ProductID		=	p.ProductID
order by 1



--aha

select * from vKundeVerkauf

--alle Firmen die aus Lyon..
--mit Sicht
select distinct companyname from vKundeVerkauf where city = 'Lyon'

select companyname from customers where city = 'Lyon'

--tu nie eine Sicht zweckentfremden...weil sie immer das tut was drin steht.. alles abfragen















