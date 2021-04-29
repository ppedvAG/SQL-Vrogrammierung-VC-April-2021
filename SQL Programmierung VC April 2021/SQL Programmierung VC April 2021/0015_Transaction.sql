/*
TX sind immer entweder 100% abgeschlossen Aktionen
oder es wird alles R�ckg�ngig gemacht

100% oder 0%

TX k�nnen aus mehreren Aktionen bestehen wie I U D S CR DR ALT

TX werden mit begin transaction eingleitet
und mit ROLLACK r�ckg�ngig gemacht
oder mit COMMIT best�tigt und somit fixiert

TX sperren betroffen DS solange die TX l�uft...
bei mehr Anweisungen, dann geschieht das der Reihe nach

Sperren k�nnen auf Tabellenniveau, Seiten, Zeilen oder Bl�cke

aber warum sperrt er mehr..weil zb ein IX fehlt
ist ein guter IX vorhanden, kann man auf Zeilenniveau sperren

�ndert man viele DS kann das Sperrniveau steigen.. von Zeile auf Seiten auf Block auf Tabelle
--je mehr desto h�her das Sperrniveau

Man kann allerdings die , die gesperrt werden etwas beeinflussen..
default: READ COMMITED  erst lesen nach Commit
         READ UNCOMMITED


TX sollte so kurz wie m�glich gestaltet sein

*/

begin tran

select * from customers

update customers set city = 'jajhsa' where customerid = 'ALFKI'
select * from customers

ROLLBACK
COMMIT




--Auswirkungen
select * into kunden from customers

begin tran
update Kunden set city = 'XYZ' where customerid = 'ALFKI'

select * from kunden
ROLLBACK
COMMIT

select @@TRANCOUNT

sp_lock --Sperren..

--
USE [Northwind]



CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20210428-143851] ON [dbo].[kunden]
(
	[CustomerID] ASC
)



--Zeilnversionierung
--DS werden vor �nderung in tempdb kopiert mit Versionsnummer
ALTER DATABASE [Northwind] SET ALLOW_SNAPSHOT_ISOLATION ON

--kein Sperre mehr, denn ein Lesen auf Die version ist nun erlaubt und std geworden
ALTER DATABASE [Northwind] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT








--in anderer Session
--default
set transaction isolation level READ COMMITTED
set transaction isolation level READ UNCOMMITTED--DS wird gelesen mit akt Wert
--bei �nderung auch lesen??

set transaction isolation level REPEATABLEREAD
--verhindern wir ein �ndern bei Daten die gelesen werden

set transaction isolation SERIALIZABLE
--bei Lesen �ndern kein schreiben
--wie Repeatablereasd aber auch INSERT


select * from kunden where customerid = 'ALFKI'