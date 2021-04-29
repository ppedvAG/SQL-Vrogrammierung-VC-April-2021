/*
2 Sorten:

#tabelle: lokale 
sie existiert ab Erstellung bis zum drop der Tabelle oder Schlissen der Vebindung
aber der Zugriff kann nur in der selben Verbindung geschehen



##tabelle: globale
exisitiert bis sie gel�scht wird, oder die Verbindung geschlossen wird
aber andere Session k�nnen diese verwenden
sie kann zumindest solange verwendet werden bis das akt Statement vollendet wurde


--dienen dazu:
komplexe Statements zu vereinfachen
zu beschleunigen
	--tempdb ist evtl auf HDD optimiert worden
	--Zwischenergebnisse .. man muss nicht mehr auf die orig - sehr gro�en - tabvellen zugreifen


*/

create table #txyz (id int)

select * from #txyz

create table ##txyz (id int)

select * from ##txyz