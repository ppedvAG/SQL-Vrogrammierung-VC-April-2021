/*
JOIN

LEFT RIGHT 
INNER 
CROSS


Select Spalten
FROM
	TAB1 A 
		inner|right|left|cross join TAB2 B
			ON A.Spx = B.Spx
		inner|right|left|cross join TAB3 C
			ON c.spy = b.spy
WHERE
	....
*/

--CROSS
--jede Zeile mit jeder der anderen Tabelle verknüpft
select * from customers c cross join orders o


--INNER--nur noch überinstimmende DS

select * from customers c
			   inner join orders o on c.CustomerID=o.CustomerID	

--alle Bestellunge und deren Postitionen

select * from orders o inner join [Order Details] od
				on o.OrderID=od.orderid


select * from customers c 
			inner join orders o 
						   ON c.CustomerID	= o.CustomerID
			inner join [Order Details] od
						   ON o.OrderID		= od.OrderID

--Alle Firmen Companyname, Land, Stadt
--BestellNr, Freight und welches Produkt (Namen) zu welchem Preis und Menge

select  c.CompanyName
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
order by 1


--LEFT RIGHT

--der left join verwendet alle DS der links vom join stehende Anweisung
--und verknüpft dann alle mit der rechts stehende  Tabelle
--alle DS die keine entsprechendes Pendant finden werden mit NULL aufgefüllt
select * from orders o left join [Order Details] od 
				on o.orderid = od.orderid

select * from orders o inner join [Order Details] od 
		on o.orderid = od.orderid

--Wann brauch ich einen Left join
--wir brauchen eine Liste aller Kunden und deren evtl vorliegenden Bestellungen	
--letztendlich: alle Kundenm die nichts bestellt haben

select * from customers c left join orders o on c.CustomerID=o.CustomerID
where o.OrderID is null


--RIGHT JOIN ist dasselbe ..einfach nur andersrum
select * from  orders o  right join customers c on c.CustomerID=o.CustomerID
where o.OrderID is null







	




select  c.CompanyName
        , c.Country	,c.city
		,o.OrderID	,o.freight 
		,od.UnitPrice, od.Quantity
		,p.ProductName
from 
		orders o				
					inner join
		[Order Details] od		ON o.orderid		=	od.orderid
					inner join
		Products p				ON od.ProductID		=	p.ProductID
					inner join 
		customers c				ON c.CustomerID		= o.CustomerID
order by 1
									


	
