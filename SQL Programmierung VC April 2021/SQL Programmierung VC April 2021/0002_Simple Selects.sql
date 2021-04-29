/*
where

=
><
<=
!=  NON SARG
<>  NON SARG
like
in
between
not ..in, between, like    NON SARG

NULL Wert Suche

is null
is not null

Eine Suche nach NULL im Where mit = oder > < führt immer zu keinem Ergebnis

Wildcards:funktioierne nur beim Like

% steht für bel. viele Zeichen
_ steht für ein Zeichen genau

*/

--alle mit "Futter" im Namen.. Companyname
select * from customers
	where companyname like '%futter%'

--alle die, wo der vorletzte Buchstabe ein L sein soll

select * from customers
	where companyname like '%L_'

--suche alle Companyname mit % in Customers

select * from customers where companyname like '%%%' ----wie %

select * from customers where companyname like '%'%%' ----falsch'

--alle Datensätze von Order Details
--man braucht eckige Klammern,: du SQL Servfer, interpretier dsa nicht als SQL Code
select * from [order details]--
--tu nie bei Objektnamen ein Leerzeichen oder math Zeichen verwenden

select * from customers where companyname like '%[%]%' 

--Suche alle die ein ' im Companyname haben

select * from customers where companyname like '%['
select * from customers where companyname like '%''%' -- zwei Hochkommas


--Alle Kunden die eine CustomeriD besitzen die mit A, B, C, oder D beginnt

--umständlich
select * from customers where customerid like 'A%' or Customerid like 'B%'--....

--nur dann wenn alles mit A beginnt 
select * from customers where customerid < 'E'

select * from customers where customerid >= 'A' and customerid < 'E'

--nur dann , wenn es keinen E gibt, da die Grenzen bei Between inklusive
--  <= E
select * from customers where customerid between 'A' and 'E'

--gehts auch mit IN?

select * from customers where city in ('Berlin','Paris','London')
--ist dasslebe wie: where city = 'Berlin' or city = 'Paris'
--nein  geht nicht , da kein Like sondern = 
select * from customers where customerid in ('A%','B%','C%')

--alle Kunden aus Customers die mit ABC beginnen oder mit GHI
select * from customers where customerid like '[ABCGHI]%'

--die eckigen Klammern stehen für genau ein! Zeichen..
--und alle zeichen werden mit oder interpretiert

select * from customers where customerid like '[A-C|G-I|R-T]%'
--Wertebereiche möglich mit - und mehrere Bereiche durch |


--Spalte PIN 4 char(4)-- durch WebSoftware war es möglich auch Buchstaben einzutippen
--alle DS, die nicht dem Zahlenschema entsprechen

--where PIN like '%[A-Z]%'

--alle , die korrekt sind

--where PIN like '[0-9][0-9][0-9][0-9]'

--alle aus Orders raussuchen, die nicht in Shipregion SP sind

--hier fehlen alle die ShiopRegion NULL besitzen
select * from orders where shipregion <>'SP' --274

select * from orders where shipregion <>'SP' or Shipregion is NULL --781














