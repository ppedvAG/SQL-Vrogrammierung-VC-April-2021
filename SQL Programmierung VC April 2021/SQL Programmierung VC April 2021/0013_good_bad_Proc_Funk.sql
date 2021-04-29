--Tabelle1

--Kopie der Tab ku1 in Tabelle KU2

select * into ku2 from ku1

--kein IX: HEAP

--Proz
--alle DS (*) die eine ID haben, die kleiner ist als ???
exec gpgoodBad 10

create proc gpname @par int, @par1...
as


create proc gpGoodBad @par1 int
as
select * from ku2 where id < @par1



set statistics io, time on

exec gpGoodBad  2 --- nur einer.. 

select * from ku2 where id < 2 --das selbe als adhoc
--mit IX besser


--NCL_ID

CREATE UNIQUE NONCLUSTERED INDEX [NCL_ID] ON [dbo].[ku2]
(
	[ID] ASC
)

select * from ku2 where id < 2  --IX
 --mit IX 4 Seiten, CPU-Zeit = 0 ms, verstrichene Zeit = 0 ms.  




 exec gpGoodBad  2 --auch hier IX seek .. 4 Seiten und 0 ms


 select * from ku2 where id < 1000000 --46302--bei Table Scan
 --, CPU-Zeit = 2797 ms, verstrichene Zeit = 23793 ms.

 exec gpGoodBad 1000000
 --ca 1 Mio Seiten obwohl die Tabelle nur 46000 Seiten besitzt
 --, CPU-Zeit = 4609 ms, verstrichene Zeit = 24108 ms.

 /*
 jeder Abfrage muss sich einen Plan überlegen
 Pläne sind wiederverwendbar, dann wendiger Aufwand und schneller

 Pläne der adhoc Abfragen können aus dem Cache verschwinden
 Proz erstellen einen Plan bei der ersten Ausführung, der dann immer bestehen bleibt
 der Plan wird dann immer verwendet , egal ob gut oder schlecht

 
 */
--alle Pläne sind nun futsch aus dem RAM
 dbcc freeproccache

  exec gpGoodBad 1000000 --  46302
  --CPU-Zeit = 2563 ms, verstrichene Zeit = 27897 ms.

  exec gpGoodBad 2 --Table Scan  46302

   select * from ku2 where id < 2

  --weil Proc den Plan beim ersten Aufruf erstellen und beibehalten, 
  --sollten man was...
  /*
  nicht benutzerfreundlich sein
  dh nicht: mal deutlich mehr mal deutlicher weniger ...

  der Plan sollte eigtl immer sehr gut sein 

  in der Proz nicht wirr programmmieren

  create proc gpXY 1
  as
  IF @par=1
  select ...orders where
  IF @Par != 1
  select * from customers where...

  exec gpxy 5 --- PLAN für orders Abfrage, der für Customers wird
  grob geschätzt

  in der Proz sollte immer der gleiche Code ausgeführt werden


  */

 USE [master]
GO
ALTER DATABASE [Northwind] SET COMPATIBILITY_LEVEL = 120
--150 SQL 2019
--120 SQL 2014



  --FUNKTION
  set statistics io, time on
  select * from ku2 where customerid like 'A%' --Table SCAN

CREATE NONCLUSTERED INDEX NCL_CID_inkl_ALL
ON [dbo].[ku2] ([CustomerID])
INCLUDE ([CompanyName],[ContactName],[ContactTitle],[City],[Country],[EmployeeID],[OrderDate],[Freight],[ShipName],[ShipCity],[ShipCountry],[LastName],[FirstName],[OrderID],[ProductID],[UnitPrice],[Quantity],[ProductName],[UnitsInStock],[ID])
GO

 select * from ku2 where customerid like 'A%' --IX 1530

 --Funktionen im Where um einen Spalte sind grottenschlecht
 --weil immer Table Scan
 --F() können meist nur 1 CPU verwenden
 --F() können nicht vorab gut geschätzt werden
 --oft wird nur 1 oder 100 geschätzt
 --erst ab SQL 2019 wird das ein wenig besser
 select * from ku2 where left(customerid,1) ='A' --46000 T SCAN


select * from employees
 --alle die im Rentenalter sind : 65 Jahre..Birthdate

select  getdate()
--dateadd (yy, Datum, 3)
--datediff (dd, Datum1 , Datum2)

select datediff(dd, Getdate(), '20.4.2021') --   -8
select datediff(dd,  '20.4.2021',Getdate()) --   +8
select dateadd(dd, 3,getdate())  --2021-05-01 11:24:01.190
select dateadd(dd, -3,getdate()) --2021-04-25 11:24:26.790

--dd Tag, ww WOche, mm Monat, yy Jahr, qq Quartal
--

--Var1: Table Scan und immer ohne IX

select * from 
(
select Lastname
		, datediff(yy,Birthdate, getdate()) as [ALTER]
		, Birthdate 
from employees
) t where t.[alter] > 65


--nett.. aber Table Scan.. weil jede Zeile untersucht werden muss
--weil f() um Spalte im Where
select Lastname
		, datediff(yy,Birthdate, getdate()) as [ALTER]
		, Birthdate 
from employees where dateadd(yy,65, Birthdate) < Getdate()


--Rentenalter:
select dateadd(yy, -65, getdate())


--wesentlich schneller, weil IX genutzt werden kann
select Lastname
		, datediff(yy,Birthdate, getdate()) as [ALTER]
		, Birthdate 
from employees where  Birthdate < dateadd(yy, -65, getdate())



--optisch schöner, aber nicht unbedingt schneller
declare @GebDatum as datetime
select @GebDatum =dateadd(yy, -67, getdate())

select Lastname
		, datediff(yy,Birthdate, getdate()) as [ALTER]
		, Birthdate 
from employees where  Birthdate < @GebDatum


