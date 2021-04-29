/*
Common Table Expression

with ctename (Sp1, Sp2)
as
	(
	select SpX, SPY from Tabelle where sp = Wert
	)
select * from ctename
so eine Art Tabelle...
Idee Unterabfragen umgehen, ko,plexerer Abfragen vereinfachen

*/

with cte (AngID, FamName)
as
	(
		select employeeid, Lastname from employees
	)
Select * from cte



with cte2 (Land, MinW, MaxW, Anz,Schnitt, Summe)
as
(
	select shipcountry ,
		min(freight), max(freight), count(*), avg(freight) , sum(freight)
	from orders
	group by shipcountry
)
select sum(Summe) from cte2 where Land in ('UK', 'USA')

--geht auch um Rekursionen zu vereinfachen

select Lastname, employeeid, reportsto from employees
select Lastname, employeeid, reportsto from employees


--CTE, die wieiviele Ang managed jeder:

With CTEAng(famName, Knecht, Chef)
as
(select lastname, 
	    (select count(1) from employees e2 where e2.reportsto=e1.employeeid),
		reportsto
		from employees e1)
select FamName, knecht, chef from cteAng

with cteReport(empid, VorgID)
as
	(select employeeid, reportsto from employees where reportsto is null --alle obersten Chefs
	 UNION ALL			
	 select e.employeeid, e.reportsto from employees e 
		inner join cteReport on cteReport.empId=e.reportsto
	)
Select * from ctereport


with cteReport(empid, VorgID, Ebene)
as
	(
	select employeeid, reportsto,1 as Ebene from employees where reportsto is null --alle obersten Chefs
	 UNION ALL			
	select e.employeeid, e.reportsto, ebene+1 from employees e 
		inner join cteReport on cteReport.empId=e.reportsto
	)
Select * from ctereport where ebene = 3

select employeeid, reportsto from employees

with cteReport(empid, VorgID, Ebene)
as
	(
	select employeeid, reportsto,1 as Ebene from employees where reportsto =5 --alle obersten Chefs
	 UNION ALL			
	select e.employeeid, e.reportsto, ebene+1 from employees e 
		inner join cteReport on cteReport.empId=e.reportsto
	)
Select * from ctereport where ebene = 3








select * from employees e1 inner join employees e2 on e1.employeeid = e2.reportsto



