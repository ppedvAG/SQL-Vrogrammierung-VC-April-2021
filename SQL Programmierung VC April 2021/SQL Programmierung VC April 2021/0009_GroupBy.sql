/*

Group by , dann wenn AGG pro Spalte benötigt

AGG

*/

select min(freight), max(freight), count(*), avg(freight)
from orders


select shipcountry, min(freight), max(freight), count(*), avg(freight)
from orders
--where
group by shipcountry --alle Aliase und AGG entfernen aus dem Slect

--Firmen und deren umsatz
--Customers (Companyname)--(customerid)  orders  (orderid) --order detailsSUMME(up*qu)





select c.CompanyName, sum(od.UnitPrice * od.Quantity) from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
group by c.CompanyName


--Umsatz pro Land und Stadt eines Kunden

select c.country,c.city, sum(od.UnitPrice * od.Quantity) from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
where c.country in ('UK','France')
group by c.country,c.city
order by country, city

--eigtl wollte ich gar nicht alle haben..

--nur noch die aus UK  und Frankreich 
--aber auch nur die, die mehr als 50000 Umsatz haben


select c.country,c.city, sum(od.UnitPrice * od.Quantity) as Umsatz from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
where c.country in ('UK','France') --kann nur Daten filtern die in Spalten enthalten sind
group by c.country,c.city having  sum(od.UnitPrice * od.Quantity) > 50000
order by umsatz

--Das Having ist das where für das Group by
--im Having kann man keine Aliase nehmen


--Tu das nie..!
select c.country,c.city, sum(od.UnitPrice * od.Quantity) as Umsatz from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
where c.country in ('UK','France') --kann nur Daten filtern die in Spalten enthalten sind
group by c.country,c.city having c.city = 'Paris'
order by umsatz


--nur das where gibt vor, welche DS tats. verwendet werden
--gibt es kein where, dann def alle
--tu nie im Having etwas filtern , was ein where kann
--ein having sollte immer nur AGG filtern

select c.country, c.city, sum(od.UnitPrice * od.Quantity) from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
group by  c.country, c.city
order by c.country, c.city

--weltweit, nur pro Land

select c.country, c.city, sum(od.UnitPrice * od.Quantity) from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
group by  c.country, c.city with cube
order by c.country, c.city

select c.country, c.city, sum(od.UnitPrice * od.Quantity) from 
	customers c inner join orders o on c.CustomerID=o.CustomerID
				inner join [Order Details] od on od.OrderID= o.OrderID
group by  c.country, c.city with rollup
order by c.country, c.city