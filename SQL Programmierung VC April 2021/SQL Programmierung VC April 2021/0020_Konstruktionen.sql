/*

IF
Vorsicht bei IF...
ohne Begin und End wird immer nur eine Anweisung interpretiert
daher ist es günstiger und auch übersichtlicher, wenn man Anweisungen 
in BEGIN ..END Blöcken unterbringt.


WHILE
	Begin 
		break.. unterbricht die Schleife sofort
		continue.. springt zum Schleifeeinstieg
	end

Schlimmster Fehler: Endlosschleifen






*/

IF 1=1
	select 100
ELSE
	select 200
	select 300 --kommt mit raus..

--immer mit Begin und End 
IF 1=1
	BEGIN 
		select 100
	END
ELSE
	BEGIN
		select 100
		select 300
	END

--auch Bedingung per Slect oder Variablen möglich
IF (select count(*) from customers) > 100
select 100
else

--Schleife
declare @i as int =1

--Bedingungen auch hier per Variable oder 
--Select möglich...
--Vorsicht bei Variablen: Die ändern sich nur, wenn 
--man einen neuen Wert zuweist <-- Endlosschleife
While @i<5
	begin
		select 100, @i		
		---If @i=3 break --unterbricht die Schleife sofort
		IF @i=3 continue --springt sofort zum Schleifeneinstieg
		set @i=@i+1 --blöd gelaufen-
		--in Schleife kein set statistics, oder Pläne
		set @i+=1
	end

