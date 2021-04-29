/*
Variablen

@var... lebt nur während des Batches
@@var

temporären Tabellen
#tab
##tab

..leben solange die Session existiert

Idee: statt komplexer prozedural, schnell weil Rundanz.. schneller



*/


--Aufgabe: Übersicht 2 Zeilen  sum(unitprice * quantity)


companyname,  max(sum(unitprice * quantity))

Companyname    Umsatz     beste
Companyname    Umsatz     schlechteste






--select eine Zeile, from nächste
select c.customerid, productname
from customers c inner join orders o on o.customerid =c.customerid
				 inner join [Order Details] od on od.orderid = o.orderid
				 inner join products p on p.productid = od.productid
where ProductName  like 'Chai%'


begin tran
delete Customers
update customers set city = ...
--select distinct  c.customerid    --, productname, companyname
from customers c inner join orders o on o.customerid =c.customerid
				 inner join [Order Details] od on od.orderid = o.orderid
				 inner join products p on p.productid = od.productid
where ProductName  like 'Chai%'
select * from customers
rollbacknsselect c.customerid, productname
from customers c inner join orders o on o.customerid =c.customerid
				 inner join [Order Details] od on od.orderid = o.orderid
				 inner join products p on p.productid = od.productid
where ProductName  like 'Chai%'rt into 



insert into tabelle           --10 Spalten
select Spalten from tabelle   --10 Spalten in der selben Reihenfolge

insert into tabelle (Sp1, sp3, sp5) values (100, 'WertfürSp3', WertfürSp5)


rollback


drop table #t

select top 1 c.CompanyName, ( od.Quantity * od.UnitPrice) as Umsatz, 
		'beste' as Typ
into #t2
from customers c 
			inner join Orders o on c.CustomerID = o.CustomerID
			inner join [Order Details] od on o.OrderID = od.OrderID	
			order by Umsatz desc


insert into #t2
select top 1 c.CompanyName, ( od.Quantity * od.UnitPrice) as Umsatz, 
		'mies' as Typ
from customers c 
			inner join Orders o on c.CustomerID = o.CustomerID
			inner join [Order Details] od on o.OrderID = od.OrderID	
			order by Umsatz asc


select * from #t2
group by Companyname




select companyname, 
	SUM(od.UnitPrice*quantity) as Umsatz ,
		ROW_NUMBER() over (order by SUM(od.UnitPrice*quantity)) as RANG
into #t5
from Customers c
inner join orders o on c.CustomerID=o.customerid
inner join [Order Details] od on od.OrderID=o.OrderID
group by CompanyName


select * from #t5
where Rang = 1 
   OR
		RANG = (Select max(rang) from #t5)

select top 1 companyname, SUM(RngSumme) as Umsatz,'beste' as Typ
from Customers c
inner join orders o on c.CustomerID=o.customerid
group by CompanyName
order by Umsatz desc


select top 1 CompanyName, SUM(unitprice*quantity) as Umsatz,'beste' as Typ
from vKundeVerkauf
group by Companyname
order by Umsatz desc


select top 1 c.CompanyName,sum ( od.Quantity * od.UnitPrice) as Umsatz, 
		'beste' as Typ
from customers c 
			inner join Orders o on c.CustomerID = o.CustomerID
			inner join [Order Details] od on o.OrderID = od.OrderID	
			group by Companyname
			order by Umsatz desc




