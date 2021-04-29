/*
wenn was passiert , dann Code

reagiert automatisch auf
Ereignis: I U D  od CREATE  DROP  ALTER
           DML         DDL


DML:
während oder danach oder anstatt

Bei I wird einen Tabelle generiert , die sich INSERTED nennt
- in der sind die DS , die man gerade eingefügt hat
dann Code

Bei D wird eine Tabelle generiert,  die sich DELETED nennt
- in der sich alle DS befinden, die man gerade gelöscht hat
dann Code

INSERED und DELETED Tabellen sehen aus wie die OrigTabellen

Bei U wird eine INSERTED und DELETED Tabelle generiert
-- dann Code

nach dem Trigger sind die Tabellen INSERTED und DELETED weg

ein Trigger passiert erst nach Eintritt der Ereignisses
die Daten die man löscht, ändert oder einfügt, sind schon mal grundsätzlich in der 
ttagbelle gelandet


*/


create trigger trgDemo ON Tabelle
for insert--.. , delete, update
as
Code
--select * from inserted

select * into kundenEu2 from Kundeneu

ALTER trigger trgDemo on KundenEU2
for insert, update, delete
as
select * from inserted
select * from deleted
select * from kundenEU2

select * from kundeneu2

delete from kundeneu2 where customerid = 'djfhl'

--Ausgabe: eine Zeile für deleted und keine für Inserted

insert into Kundeneu2 
select 'djfhl', 'fsjfhsdhfhsdk', 'jhfjsdhf', 'kjkjdsa'
--Ausgabe: eine Zeile in INSERTED und keine für DELETED


update kundenEu2 set city = 'Paris' where customerid like 'D%'

--Kope der Tabelle Orders
select * into orders2 from orders

alter table orders2 add RechSumme money




select * from orders2
select * from [Order Details]

--Trigger auf Order details (UPDATE)
--... der die Rechnungsumme aktualisiert

create  trigger trgRSumme on [order details]
for update
as
--code: Aktualisiere die RechSumme Spalte (orders2)
--Tipp: alle Werte des update sind bereits 
--in der orders während der Trigger läuft

--zuerst : Abfragen zur Berechnug einer best Bestellung

select 
		sum(unitprice*quantity) from [Order Details]
where 
		orderid = 10248




--woher weiss ich welche Bestellung geändert wurde: aus dem Trigger
create  trigger trgRSumme on [order details]
for update
as
select orderid from inserted

select * from [Order Details] where orderid = 10248

update [Order Details] set quantity = 100
where 
	orderid = 10248 and Productid = 11



ALTER  trigger trgRSumme on [order details]
for update
as
select 
		sum(unitprice*quantity) from [Order Details]
where 
		orderid = (select orderid from inserted)



		--letzte Schritt RSUmme in Orders aktualsieren


ALTER  trigger trgRSumme on [order details]
for update
as
declare @BestId as int
select @BestID = orderid from inserted

declare @Rsumme as money
select @RSumme = sum(unitprice*quantity) from [Order Details]
where orderid = @BestID

update orders2 set RechSumme = @Rsumme
	where 
			orderid = @BestID	

















create trigger trgName on Tabelle bzw Sicht
for INSERT, UPDATE, DELETE
as
--CODE... Tab INSERTED , DELETED
--UP = INS und DEL
--alle Daten die eingefügt oder geändert oder gelöscht werden
--, sind zur Laufzeit des trigger bereits in der Tabelle drin.

--Sicht und trigger?
--wenn eine Sicht keine Joins enthält, sindern nur eine Tabelle
--und alle Pflichtspalten enthält, dann ist auch ein INS , UP, DEL möglich
--Daten werden über die Sicht in die Tabelle umgeleitet

create view vKundenEU
as
select customerid, companyname, city, country from kundenEU
where country = 'Germany'

insert into vKundenEu
select 'eruee','kjfhskjfdhkjdh','jkfhjd', 'UK'

select * from vKundenEu

update vkundeneu set city = 'Berlin'--nur die eutschen betroffen

delete from vKundenEu --keine dt mehr in Tab



---DDL .. CREATE DROP ALTER
--Reaktion: Nachricht wird generiert
---  Wer hat wann was wie getan mit Uhrzeit

create trigger trgDDLdemo on Database
for ddl_database_level_events --alle Ereignisse 
as
select eventdata()

create table demoTab2 (id int)

drop table demotab2

create trigger trgDDLdemo on Database
for ALTER_TABLE -- ddl_database_level_events
as
select eventdata()


--Idee um die Ereignisse wieder zu finden: 
--Tabelle Logging

--Tabelle logging (id int identity, Ereignis xml, Datum smalldatetime)

create table logging(id int identity, Ereignis xml, Datum smalldatetime)

--Trigger: trgDDLMonitor

create trigger trgDDLMonitor on DATABASE
for DDL_DATABASE_LEVEL_EVENTS
as
insert into logging 
select eventdata(), getdate()

create table demoxyz (id int)

drop table demoxyz

select * from logging



