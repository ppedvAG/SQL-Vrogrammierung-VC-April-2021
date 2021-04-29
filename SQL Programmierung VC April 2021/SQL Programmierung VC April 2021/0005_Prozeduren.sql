/*
stored procedures

..wie eine Windows Batchdatei. DH also eine Reihe von Anweisungen ausführen

Ausgeführt mit 

exec ProcName Par1, Par2,....

Proz lassen sich nicht so einfach mit einer Sicht oder Tabelle in einem Statement mischen

Anweisungen in der Proz können alles mögliche sein: I Up DEL SEL Exec...

Warum: Komplexe Vorgänge zu vereinfachen

create proc gpProcname [@par1 int, @par2 int,....]
as
select ... @par1
update set .. = @par2

exec gpPro 2,5

exec gpPro @par1=2 , @par2 = 5




*/
delete from [Order Details] where orderid .. die Best des ALFKI
delete from orders where customerid = 'ALFKI'
delete from customers where customerid = 'ALFKI'

--IDEE: exec gpDelKunde 'ALFKI' evtl sogar schneller

--Proz die alle Kunden sucht, die aus einem best Land sind

create proc gpKundeLand @Land nvarchar(15)
as
select * from customers where country = @Land

exec gpKundeLand 'UK'

exec gpKundeLand @Land='Germany'

--proc soll alle Kunden suchen , die mit einem best Buchstaben beginnen
-- aber ein wenig flexibel sein
exec gpKundenSuche 'A' --alle Kunden mit A beginnend finden
exec gpKundenSuche 'ALF' -- alle finden, die mit ALF beginnen
exec gpKundenSuche       --alle..


exec gpKundenSuche 'A%' --alle Kunden mit A beginnend finden
exec gpKundenSuche 'ALF%' -- alle finden, die mit ALF beginnen
exec gpKundenSuche  '%'     --alle..

/*
create proc gpProcname @par1 int, @par2 int,....
as
select ... @par1


*/

select * from customers where customerid


alter proc gpKundenSuche @Kunde nchar(5)
as
select * from customers where customerid like @Kunde


exec gpKundensuche 'ALFKI'
exec gpKundensuche 'A%' --geht nur bei Like..geht aber immer noch nicht

--keiner sagt, auch wenn es logisch erscheint, dass der Par identischen Datentyp wie der Wert 
--in der Tabelle haben muss

--bei char(5).. A% ... 'A%___'.. könnte mit rtrim(customerid).. eleganter mit varchar..

alter proc gpKundenSuche @Kunde nvarchar(5)
as
select * from customers where customerid like @Kunde

--jetzt klappt...
exec gpKundensuche 'A%'
exec gpKundensuche 'AL%'
exec gpKundensuche '%'


--gehts auch ohne %

alter proc gpKundenSuche @Kunde nvarchar(5)
as
select * from customers where customerid like @Kunde+ '%'

exec gpKundensuche 'A'
exec gpKundensuche 'AL'
exec gpKundensuche ''
--gehts auch ohen Par Angabe

exec gpKundensuche 

alter proc gpKundenSuche @Kunde nvarchar(5)='%' --default Wert
as
select * from customers where customerid like @Kunde+ '%'


exec gpKundensuche --nun klappt auch das..!


--jetzt mit 2 Parameter
--Proc die alle Bestellungen sucht, die von einem best Ang sind 
--und evtl best Frachtkosten unterschreiten
select top 3 * from orders --..employeeid int und Freight money

exec gpBestAngFracht 4, 50

alter proc gpAngFracht @AngId int=1, @fracht money 
as
select * from orders where employeeid = @AngId and freight < @Fracht

exec gpAngFracht 4,50 

exec gpAngFracht @Fracht = 30, @AngId = 3

exec gpAngFracht 2,100

exec gpAngFracht @fracht=50
--Proz geht der Reihe nach die Par durch... daher mal die Par angeben, damit es deutlich wird..

--Kann auch Ausgabeparameter haben

select avg(freight) from orders where employeeid = 1

--Proz die bei Übergabe der AngID die durschn Frachtkosten ausgibt


create proc gpAngSchnittFracht @Angid int
as
select avg(freight) from orders where employeeid = @Angid


exec gpAngSchnittFracht 1

--mit Ausgabveparameter

alter  proc gpAngSchnittFracht @Angid int , @ergebnis money output --output ist dennoch beides INPUT und OUTPUT
as
select avg(freight) from orders where employeeid = @Angid


exec gpAngSchnittFracht 2
----Nachricht 201, Stufe 16, Status 4, Prozedur gpAngSchnittFracht, Zeile 0 [Batchstartzeile 151]
----Die Prozedur oder Funktion "gpAngSchnittFracht" erwartet den @ergebnis-Parameter, der nicht bereitgestellt wurde.

alter  proc gpAngSchnittFracht @Angid int , @ergebnis money output --output ist dennoch beides INPUT und OUTPUT
as
select @ergebnis=avg(freight) from orders where employeeid = @Angid

exec gpAngSchnittFracht 2--immer noch Fehler


--Variabel ist die Lösung
--Variablen gelten nur während der Batch läuft
declare @Frachtschnitt money
set @frachtschnitt = 999
select @frachtschnitt


--									<---
exec gpAngSchnittFracht 2, @ergebnis=@frachtschnitt 

--                                 --->
exec gpAngSchnittFracht 2, @ergebnis=@frachtschnitt output
select @frachtschnitt

select @Frachtschnitt*1.19 

--wichtig der GO
--dem SQL ist egewal wieviel zwischen den Anweisung liegen

alter proc gpDemo1
as
select getdate()
GO

exec gpDemo1


exec gpDemo1

--ein GO trennt Batches voneinander
--wichtig bei Variabvlen, da Variablen nur in einem Batch gültig sind
--und weil man sehr gut Proz oder Sichten genrieren ohne Fehler oder Fehlverhalten

declare @Var1 int
set @var1 = 100
GO
select @var1



























