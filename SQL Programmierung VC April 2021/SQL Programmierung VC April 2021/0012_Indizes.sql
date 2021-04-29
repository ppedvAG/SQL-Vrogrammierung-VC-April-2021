/*
Indizes...

Welche IX gibts denn

gruppierter IX
nur 1 mal pro Tabelle .. Daten werden physikalisch sortiert neu abgelegt.. kein HEAP mehr
bei Bereichsabfragen
auch wenn mal mehr rauskommt..
zuerst den gr IX festlegen (Spalte festlegen)

nicht gr IX
Kopie best Spalten in sortierter
Super bei: = , bzw bei rel wenigen Ergebniszeilen
.. ca 1023 mal pro Tabelle machbar

--------------------------
eindeutigen IX
zusammengesetzten IX ..max 16 Spalten, Reihenfolge wichtig
gefilterten IX: nicht mehr alle DS der Tabelle im IX, sondern gefiltert
		--Ziel: weniger Ebenen
		--bei 2 gleichwertigen IX ist der besser der weniger Benene besitzt
		-- also mach den Filter so, dass es weniger Ebenen sind, ansonsten kein Nutzen

abdeckende IX   der kann alles mit IX Seek beantworten und muss keinen Lookup machen

IX mit eingeschl Spalten Schlüsselspalten=where Spalten = Baum
		erst am Ende des Baumes die Sleect Spalten= eingeschloss. Spalten
     bis zu 1023 Spalten dürfen eingschlossen werden

partitionieren IX...
ind Sicht .. nicht ausgereift und wird es auch nie sein..
hypoth. realen IX-- Tool...
---------------------------
Columnstore

*/

set statistics io , time on
use northwind;

--KU1 ist ein HEAP -- TABLE SCAN 
select ID from ku1 where ID =100
--, CPU-Zeit = 499 ms, verstrichene Zeit = 78 ms. --62748 Seiten

--besser mit IX: der CL IX wird auf SP : Orderdate festgelegt
-- NCL ist gut geeigent

--NCL_ID   NCL IX SEEK
select ID from ku1 where ID =100
--, CPU-Zeit = 0 ms, verstrichene Zeit = 4 ms.---3 Seiten


--NCL IX SEEK.. aber mit Lookup
select ID, freight from ku1 where ID =100
--0ms aber 4 Seiten.. Lookup kostet 50%
select ID, freight from ku1 where ID <12000--103 Seiten

--besser machen
--kein Lookup mehr durch: NCL_IDFR zusammnegestzter
select ID, freight, city, country from ku1 where ID <12000

--der IX mit eingeschlossenen Spalten
select ID, freight, city, country from ku1 where ID =100
--NCL_IC_incl_FRCICY


select country, city, customerid, sum(unitprice*quantity)
from ku1
where orderid < 10270
group by country, city, customerid

--NCL_OID_incl_CICYUPQU.. der selbe IX den auch der SQL vorschlägt


--bein AND wird noch ein IX vorgeschal. bei OR nicht mehr
-- da sind mehr IX eigtl notwendig
select country, city, customerid, sum(unitprice*quantity)
from ku1
where orderid < 10270 OR employeeid = 3
group by country, city, customerid

--wenn man zig IX hat, welche nimmt er denn

--angenommen wir finden 3 Stück, die in Frage kommen
--kommen zuviele DS raus werden die IX unter den Tisch fallen : SCAN
-- auch überall die SELECT als eingeschl oder zusammengesetzt
-- ? muss ich einen Lookup machen
-- von 3 IX sind nur 2 ohne Lookup 
-- Welchen nehm ich von den zwei: ANzahl der Ebenen
-- IX A hat 3 Eb vs IX B hat 4 Ebenen.... der mit 3 Eb
-- IX A hat 3 und IX B hat auch 3 Eb.. die interne ID
-- IX A 127617612   IX B 8324728388882.. schlichtweg den von der Sortierung her den ersten



USE [Northwind]

GO

SET ANSI_PADDING ON


CREATE NONCLUSTERED INDEX [NCL_OID_alle] ON [dbo].[ku1]
(
	[OrderID] ASC,
	[City] ASC,
	[Country] ASC
)
INCLUDE([CompanyName],[OrderDate],[Freight]) 

CREATE NONCLUSTERED INDEX [NCL_OID_filter_BERLIN] ON [dbo].[ku1]
(
	[OrderID] ASC,
	[City] ASC,
	[Country] ASC
)
INCLUDE([CompanyName],[OrderDate],[Freight]) 
WHERE city='Berlin'



--Häufigkeit der Länder in KU

select country, count(*) from ku
group by country

--Sicht

create view vDemo
as
select country, count(*) as Anzahl from ku
group by country


select * from vDemo --gleich schnell wie die adhoc Abfrage

alter view vDemo with schemabinding
as
select country, count_big(*) as Anzahl from dbo.ku
group by country

--Sicht hat keinen Daten.. Wieos kann ich dann eine Sicht indizieren??

select * from vdemo --ufff??!!  Wunder:. 0 ms  2 Seiten

select country, count(*) from ku
group by country --auch nur ca 0 ms.. 2 Seiten

--im plan : er erwenbdet die Sicht nicht die Tabelle
--bei Sicht indizieren: er nimmt das Ergbenis der Sicht und tut diese Ergebnis indizieren
-- bei uns 21 Zeilen  und  rauf ein IX
--SQL Server ist in der Lage (nur bei Ent Ed) der Abfrage die ind Sicht unterzuschieben


--nur noch Sichten super..!..NEIN!! 
--IX muss immmer aktuell sein.. auch der der Sicht
--ind Sicht ist extrem penibel...es muss der count_big
--in den meisten Fälle ist die in der Sicht nicht möglich...

--PFLICHT: jeder Admin muss sih cdarum kümmern, dass IX gewartet werden
/*
überflüssige IX müssen weg. Weil diese immer bei UP INS DEL aktualsiiert werden
fehlende Indzies finden für den gesamten Workload des Tages
Wartung.. Indizes fragmentieren... unter 10% nix
								... über 30% Rebuild ganzer IX
								..  dzw Reorg der unterste Teil des Baumes

DEV Sache.. schau dir deine Abfragen an, ob die überhaupt gut performanen
--SEEK
--vermeide Lookup
--vermeide SCANs


Wieso sind Proc mal gut mal sehr schlecht 

Warum sind F() nicht besonders gut
*/

--TX SPERREN
--PARTIONIERUNG
--Trigger