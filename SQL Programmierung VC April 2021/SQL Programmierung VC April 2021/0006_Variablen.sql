/*
Variablen

Variablen werden mit @ oder @@ deklariert

Wenn @ , dann lokale Variable
diese gilt nur während der Batch läuft
..und nur der Ersteller bzw die Ceine Ersteller Coennection hat darauf Zugriff
----meist  zu 99,99 % werden diese im Code verwendet


Wenn @@ , dann globale Variable
gilt nur während des Batches
..aber alle haben darauf Zugriff
meist Sytemvariablen

Var machen den Code übersichtlicher, aber nicht unbedingt schneller
--der Plan kann nicht richtig schätzen ...



*/

--Variablen müssen deklariert werden

declare @var1 as int --Datentyp zuweisen

--Wert zuweise
set @var1=100

--oder per Select
select @var1 = max(freight) from orders

--ab jetzt kann für die Dauer des Bacthes die var verwendet werden

select @var1

--aber in GO vernichtet die Var1

GO

select @var1--ab hier ein Error

--Besonderheiten:
--Man kann mehr Var gleichzeitg definieren und Wert zuweisen

declare @var2 int, @var3 int = 10


