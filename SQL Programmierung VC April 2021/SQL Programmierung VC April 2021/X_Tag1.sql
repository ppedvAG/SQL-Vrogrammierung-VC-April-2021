/*
SELECT 
		SPALTEN, SP1 Alias, Berechnungen Alias, 'TXT', [ein Wert]
FROM  [Tabellenartiges=Sicht, Abfrage, F()]
		TAB1 A INNER|RIGHT|LEFT|CROSS TAB2 B ON A.SP=B.SP
			   INNER|RIGHT|LEFT|CROSS TAB3 C ON C.SP=B.SP
			   ...
		VIEW V1 INNER|RIGHT|LEFT|CROSS  SICHT|TAB ON ...
WHERE  [Vergleich mit einem Wert=Unterabfragen]
		SP > < != between in not like =
		..nur der like hat Wildcards:
							%:  beliebig (0 bis n)
							_:  genau ein Zeichen
						   []:  steht nur für ein Zeichen und besietzt Wertemenge
									[0-9|A-Z].. [^A-M].. Verneinung

		AND |  OR
		das AND ist immer stärker bindend, daher Tipp: Immer Klammern setzen 
		SP = ......
ORDER BY Sp1 asc, Sp2 desc





*/

select freight*1.19, 'TEXT', 100 from orders
	where (freight < 10 or employeeid = 4) and Shipcity = 'Berlin'


select freight -(select max(freight) from orders) from
			(select 
					orderid, employeeid, freight , shipcity
			from orders 
			where 
					shipcity = 'Berlin') t
where t.Freight < 10 and Shipcity = (select top 1 city from customers)


--Welche Firmen haben etwas von Davolio gekauft und wieivel Frachtkosten sind pro Bestellung
--bezahlt worden

--CompanyName, Orderid, Freight, Lastname.. nur von Davolio verkauft...

Select c.CompanyName, o.OrderID, e.LastName, e.FirstName from customers c
				inner join orders o		on c.customerid = o.CustomerID
				inner join employees e	on e.EmployeeID = o.EmployeeID
where
		e.LastName='Davolio'


--ergänze die Abfrage um die Frachtkosten aus Orders...

Select c.CompanyName, o.OrderID, e.LastName, e.FirstName, c.customerid, o.freight from customers c
				inner join orders o		on c.customerid = o.CustomerID
				inner join employees e	on e.EmployeeID = o.EmployeeID
where
		e.LastName='Davolio'

--und vergleiche die Frachkosten mit dem Schnitt... zwar so, dass die mit den höchsten 
--abweichenden Frachtkosten sortiert oben zu finden sind...

Select c.CompanyName, o.OrderID, e.LastName, e.FirstName, c.customerid
		, o.freight - (select avg(freight) from orders) as Abw, freight
from customers c
				inner join orders o		on c.customerid = o.CustomerID
				inner join employees e	on e.EmployeeID = o.EmployeeID
where
		e.LastName='Davolio'
order by Abw desc



select avg(freight) from orders
		
Select c.CompanyName, o.OrderID, e.LastName, e.FirstName, c.customerid, o.freight from customers c
				inner join orders o		on c.customerid = o.CustomerID
				inner join employees e	on e.EmployeeID = o.EmployeeID
where
		e.LastName='Davolio'

select shipcity,max(freight) from orders --abfrage Max Frachtkosten pro Shipcity
								          --

--etwas scheinbar eleganter und einfacher und übersichtlicher

select avg(freight) from orders



declare @schnitt money
--set @schnitt = 10
select @schnitt = max(freight) from orders

Select c.CompanyName, o.OrderID, e.LastName, e.FirstName, c.customerid
		, (o.freight - @schnitt) as Abw
from customers c
				inner join orders o		on c.customerid = o.CustomerID
				inner join employees e	on e.EmployeeID = o.EmployeeID
where
		e.LastName='Davolio' 
order by Abw desc


--Ergebnis soll noch eingeschränkt werden..
--alle die mit M S oder T beginnen (Companyname)


declare @schnitt money
--set @schnitt = 10
select @schnitt = max(freight) from orders

Select c.CompanyName, o.OrderID, e.LastName, e.FirstName, c.customerid
		, (o.freight - @schnitt) as Abw
from customers c
				inner join orders o		on c.customerid = o.CustomerID
				inner join employees e	on e.EmployeeID = o.EmployeeID
where
		e.LastName='Davolio' 
		AND
		c.CompanyName like '[MST]%'
order by Abw desc



