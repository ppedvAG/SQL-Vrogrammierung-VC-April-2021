/*

Funktionen

extrem flexibel im Einsatz

select f(spalte) from f(wert) where f(saplte) < f(wert)

Aber: Performance ist etwas anderes


*/

--Skalarwertfunktion

create function fName (@par as int) returns int
as
begin
	return(@par*100)
end

select fName(19) --Error

--Angabe des Schemas notwendig

select dbo.fname(19)

--erstelle eine dbo.fbrutto(Wert) .. auf 1.19

create function dbo.fbrutto(@netto money) returns money
as
begin
		return (@netto *1.19)
end

select dbo.fbrutto(100)


select 
		freight as netto, dbo.fbrutto(freight) as Brutto,
		dbo.fbrutto(freight) - freight
from orders
where 
	dbo.fbrutto(freight) < 100


--Erstelle eine Funktion, die für ein best Orderid die
--RngSumme errechnet

select dbo.fRngSumme(10250) -- 14039

create function frngSumme(@oid int) returns money
as
begin
	return(select sum(unitprice*quantity) from [Order Details]
			where orderid = @oid)
end



--Alle Bestellungen (aus orders) , die unter 1000 Euro RngSumme liegen...?
select dbo.fRngSumme(orderid),* 
		from orders
		where dbo.fRngSumme(orderid) < 1000

--total easy..!! ;-)

--legen wir ne Schippe drauf

alter table orders add RngSumme as dbo.fRngSumme(orderid) 

select * from orders where RngSumme < 1000

--definitiv nicht schneller...
--

--Problem 1) jedes select * 
select * from orders
--problem 2: der Plan lügt dir ins Gesicht
--beim tats. Plan wird die F() nicht mal angzeigt
--im gesch. Plan häätte sie nur 15% ANteil, obwohl es sich um die größte Tabelle handelt
--und die Stat lügen ebfalls.. wir haben pro Zeile der Orders 
--einen Rechnenvorgang auf order details

set statistics io, time on

--F() die eine Tabelle zurückgibt

create function fTabelle (@wert varchar(50)) returns table
as
return (select * from tabelle where sp = @wert)


--TEST
select * from dbo.fTabelle(wert) -- inner join ... where ..group by

--erstelle eine F() dbo.KundeStadt ('Paris')
--alle Kunden aus Paris

create function dbo.fKundeStadt(@ort nvarchar(50)) returns table
as
return (select * from customers where city = @ort)


select * from dbo.fKundeStadt('Paris')
where contacttitle = 'Owner'

create dbo




















