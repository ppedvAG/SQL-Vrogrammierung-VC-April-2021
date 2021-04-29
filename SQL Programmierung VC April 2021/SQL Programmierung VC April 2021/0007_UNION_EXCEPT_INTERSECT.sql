/*
UNION verknpüft zwei Abfrageergebnisse zu einem
--Ergenisse sind untereinander
--aber!!!
doppelte Zeilen werden eliminiert



*/

select city from customers
UNION
select shipcity from orders

select 100
UNION
select 200


select 100
union
select 100

select 100,200
union
select 100,2

--wenn man keine doppelte Zeilen eliminieren will dann 
--UNION ALL

select 100
union ALL
select 100 --2 Zeilen.

--opt: wenn man weiss, dass es keine dopp Zeilen gibt, dann nicht ihn zwingewn danach zu suchen
--UNION ALL !!!

--Die Spalten müssen kompatibel 

select orderid from orders --der int wird zu einem money
UNION 
select convert(int,freight) from orders


--merhfach

select 100
union
select 200
union
select 300


--A B C 

select * from orders --0.02 bis 1007

-- A Kunde 0.02 bis 100
-- C Kunde mehr als 500
-- B Kunden über 100 aber unter 500


--Ergebnis sollte so aussehen:
--Ein Liste
--OrderID, Customerid, freight, A B oder C


--CASE ...perfekt
--geht aber auch mit UNION.. 


select OrderID, Customerid, freight, 'A' from orders where freight < 100 --A Kunde
UNION
select OrderID, Customerid, freight, 'B' from orders where freight between 100 and 500
UNION
select OrderID, Customerid, freight ,'C' from orders where freight > 500
order by freight --dieser order by bezieht sich auf das komplette Ergebnis des UNION

--Den teuerste Frachtkosten und billigeste

--Customerid , Freight, 'billigster'
--customerid, freight, 'teuerste'

select top 1  customerid, freight, 'teuerste' from orders
order by freight desc
UNION ALL --darf man leider nicht
select top 1  customerid, freight, 'billigtser' from orders
order by freight asc


select * from sicht --die sortiert
union
select * from sicht -- die sortiert ist erlaubt

--jetzt wirds häßlich

select * from (
				select top 1  customerid, freight, 'teuerste' as Typ from orders
				order by freight desc
			  ) t
UNION ALL --darf man leider nicht
select * from  (			
				select top 1  customerid, freight, 'billigtser' as Typ2 from orders
				order by freight asc
			  ) t2

--temp Tabelle
select top 1  customerid, freight, 'teuerste' as Typ 
into #t1
from orders	order by freight desc


select top 1  customerid, freight, 'bllig' as Typ 
into #t2
from orders	order by freight asc

select * from #t1
UNION ALL
select * from #t2


--muss man jetzt drop table #t1

--Spieltabelle
select customerid, companyname, city, country 
into KundenEU
from customers 
where country in ('Germany', 'Italy', 'France')



select * from kundeneu

--ein DS in KundenEU ändern
update kundeneu set City = 'Bonn' where customerid = 'ALFKI'

insert into customers (customerid, companyname, city, country)
values
					  ('ppedv', 'ppedv KG', 'Kiel', 'Germany')


insert into KundenEU (customerid, companyname, city, country)
values
					  ('XYZAB', 'XYZ AG', 'Aachen', 'Germany')

delete from kundeneu where customerid = 'Blaus'

--Wie finde ich die unterschiedlichen Zeilen raus...
--und wie die gemeinsamen Zeilen

--gemeinsame Zeilen...

--join. aber dann alle Spalten im JOIN ...ufffff!!!


select customerid, companyname, city, country from Customers
intersect
select customerid, companyname, city, country from KundenEU --23 Zeilen

select customerid, companyname from Customers
intersect
select customerid, companyname from KundenEU --24 Zeilen
--wichtig: man vergleicht die Abfrageergbenisse nicht die Tabelle


--und wie die unterschiedlichen

select customerid, companyname from Customers
except
select customerid, companyname from KundenEU --68


select customerid, companyname from KundenEu
except
select customerid, companyname from Customers --nur 1

select customerid, companyname, city, country from KundenEu--Basis
except
select customerid, companyname,city, country from Customers --nur 2
--except
--select 



--Sonderfälle
--bei unterscheidl Spaltenmengen
--einfach mit Platzhalter  bzw NULL ergänzen

select customerid, companyname, city, country, Region from customers
UNION
select customerid, companyname, city, country, NULL from KundenEU



















