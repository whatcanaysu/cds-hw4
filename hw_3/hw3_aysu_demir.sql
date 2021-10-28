
-- Problem set week 3 number 2.

-- Please load music-store database

-- Please add the proper SQL query to follow the instructions below


------------------------------------------------
use musicstore;
------------------------------------------------

-- 1.Show the Number of tracks whose composer is F. Baltes
-- (Note: there can be more than one composers for each track)

select count(TrackId) from track where composer regexp "F. Baltes";

-- 2.Show the Number of invoices, and the number of invoices with a total amount =0 in the same query
-- (Hint: you can use CASE WHEN)

select count(distinct InvoiceID) as TotalInvoices,
	   sum(T_099) as Total099Invoices
from (select InvoiceID, 
	  case when Total = 0.99 then 1 
		else 0 end as T_099
	  from invoice) as A;

-- 3.Show the album title and artist name of the first five albums sorted alphabetically

select a.title, ar.name from album a, artist ar where a.artistId = ar.ArtistId order by title limit 5;

-- second way
select a.Title, b.Name
from (select Title, ArtistId from album order by Title limit 5) as a
left join artist as b on a.ArtistId = b.ArtistId;

-- 4.Show the Id, first name, and last name of the 10 first customers 
-- alphabetically ordered. Include the id, first name and last name 
-- of their support representative (employee)
 
select c.customerid, c.firstname, c.lastname, e.firstname, e.lastname 
from employee e, customer c 
where c.SupportRepId = e.EmployeeId
order by c.firstname asc limit 10;

-- second way
select a.CustomerId, a.FirstName, a.LastName, b.EmployeeId, b.FirstName as RepFirstName, b.LastName as RepLastName
from (select CustomerId, FirstName, LastName, SupportRepId from customer order by FirstName limit 10) as a
left join employee as b on a.SupportRepId = b.EmployeeId;


-- 5.Show the Track name, duration, album title, artist name,
--  media name, and genre name for the five longest tracks

select t.name as track_name, t.milliseconds, al.title as album_title, ar.name as artist_name, m.name as media_name, g.name as genre
from track t, album al, artist ar, mediatype m, genre g
where t.MediaTypeId = m.MediaTypeId and t.AlbumId = al.AlbumId and ar.ArtistId = al.ArtistId and g.genreId = t.genreId
order by milliseconds desc limit 5;

-- second way
select distinct a.Name, a.Milliseconds, b.Title as 'Album Title', c.Name as 'Band Name', d.Name as 'Media Type', e.Name 'Genre'
from track as a
left join album as b on a.AlbumId = b.AlbumId
left join artist as c on b.ArtistId = c.ArtistId
left join mediatype as d on d.MediaTypeID = a.MediaTypeID
left join genre as e on e.GenreId = a.GenreID
order by a.Milliseconds desc
limit 5;

-- 6.Show Employees' first name and last name
-- together with their supervisor's first name and last name
-- Sort the result by employee last name

select distinct a.FirstName, a.LastName, a.ReportsTo, b.FirstName, b.LastName
from employee as a 
left join (select FirstName, LastName, EmployeeId from employee) as b on a.ReportsTo = b.EmployeeId
order by a.LastName;

-- 7.Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
--  together with the average price per track

select a.Title, (b.TotalCostAlbum / b.TotalTracksAlbum) as AveragePricePerTrack
from album as a
inner join
	(select AlbumId, sum(UnitPrice) as TotalCostAlbum, count(distinct TrackId) as TotalTracksAlbum 
	from track
	group by AlbumId) as b
on a.AlbumId = b.AlbumId
order by b.TotalCostAlbum desc
limit 5;

-- 8. Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
-- but only if the average price per track is above 1

select a.Title, (b.TotalCostAlbum / b.TotalTracksAlbum) as AveragePricePerTrack
from album as a
inner join
	(select AlbumId, sum(UnitPrice) as TotalCostAlbum, count(distinct TrackId) as TotalTracksAlbum 
	from track
	group by AlbumId) as b
on a.AlbumId = b.AlbumId
where (b.TotalCostAlbum / b.TotalTracksAlbum) > 1
order by b.TotalCostAlbum desc
limit 5;


-- 9.Show the album Id and number of different genres
-- for those albums with more than one genre
-- (tracks contained in an album must be from at least two different genres)
-- Show the result sorted by the number of different genres from the most to the least eclectic 

select distinct a.AlbumId, GenresAmount
from track as a
left join
	(select AlbumId, count(distinct GenreId) as GenresAmount
	from track
	group by AlbumId) as b
	on a.AlbumId = b.AlbumId
left join Genre as c on a.GenreId = c.GenreId
where GenresAmount > 1
order by GenresAmount desc;

-- 10.Show the total number of albums that you get from the previous result (hint: use a nested query)
select count(*)
from 
	(select distinct a.AlbumId, GenresAmount
	from track as a
	left join
		(select AlbumId, count(distinct GenreId) as GenresAmount
		from track
		group by AlbumId) as b
		on a.AlbumId = b.AlbumId
	left join Genre as c on a.GenreId = c.GenreId
	where GenresAmount > 1
	order by GenresAmount desc) as x; 


-- 11.Show the	number of tracks that were ever in some invoice

select count(distinct InvoiceId, TrackId) as TotalTrackEverInvoice
from invoiceline;

-- 12.Show the Customer id and total amount of money billed to the five best customers 
-- (Those with the highest cumulated billed imports)

select CustomerId, sum(Total) as Total
from invoice
group by CustomerId
order by Total desc
limit 5;


-- 13.Add the customer's first name and last name to the previous result
-- (hint:use a nested query)

select a.FirstName, a.LastName, b. CustomerId, b.Total
from customer as a
right join
	(select CustomerId, sum(Total) as Total
	from invoice
	group by CustomerId
	order by Total desc
	limit 5) as b
on a.CustomerID = b.CustomerID;

-- 14.Check that the total amount of money in each invoice
-- is equal to the sum of unit price x quantity
-- of its invoice lines.

select count(*)
from
	(select a.InvoiceID, a.Total, b.TotalComputed
	from Invoice as a
	inner join
		(select InvoiceID, sum(UnitPrice * Quantity) as TotalComputed
		from invoiceline
		group by InvoiceID) as b
	on a.InvoiceID = b.InvoiceID) as x
where Total != TotalComputed;

-- 15.We are interested in those employees whose customers have generated 
-- the highest amount of invoices 
-- Show first_name, last_name, and total amount generated 
select c.FirstName, c.LastName, sum(b.AmountOfInvoice) as TotalAmount
from customer as a
inner join 
	(select CustomerId, count(distinct InvoiceId) as AmountOfInvoice
	from invoice
	group by CustomerId) as b
on a.CustomerId = b.CustomerId
inner join employee as c
on a.SupportRepId = c.EmployeeId
group by c.FirstName, c.LastName
order by TotalAmount desc;



-- 16.Show the following values: Average expense per customer, average expense per invoice, 
-- and average invoices per customer.
-- Consider just active customers (customers that generated at least one invoice)

select avg(TotalSpent) as AvgSpentCust, sum(TotalSpent)/sum(AmountInvoices) as AvgSpentInvoice,avg(AmountInvoices) as AvgInvoicesCust
from
	(select CustomerId, count(distinct InvoiceId) as AmountInvoices, sum(Total) as TotalSpent
	from invoice
	group by CustomerId) as a;

-- 17.We want to know the number of customers that are above the average expense level per customer. (how many?)
select count(*)
from 
	(select sum(Total) as TotalSpent
	from invoice
	group by CustomerId
	having TotalSpent > (select avg(TotalSpent) as AvgSpent
		from
			(select CustomerId, sum(Total) as TotalSpent
			from invoice
			group by CustomerId) as a)) as x ;

-- 18.We want to know who is the most purchased artist (considering the number of purchased tracks), 
-- who is the most profitable artist (considering the total amount of money generated).
-- and who is the most listened artist (considering purchased song minutes).
-- Show the results in 3 rows in the following format: 
-- ArtistName, Concept('Total Quantity','Total Amount','Total Time (in seconds)'), Value
-- (hint:use the UNION statement)

select *
from
	(select Artist, TotalTracks
	from
		(select Name as Artist, sum(Quantity) as TotalTracks, sum(UnitPrice) as TotalMoney, sum(Milliseconds) as TotalMilliseconds
		from
			(select distinct c.Name, Milliseconds ,d.UnitPrice, d.Quantity
			 from track as a
			 inner join album as b
			 on a.AlbumId = b.AlbumId
			 inner join artist as c
			 on b.ArtistId = c.ArtistId
			 inner join invoiceline as d
			 on a.TrackId = d.TrackId) as info
		group by Artist) as summary
	order by TotalTracks desc
	limit 1) as MostTracksSelled
union
	(select Artist, TotalMoney
	from
		(select Name as Artist, sum(Quantity) as TotalTracks, sum(UnitPrice) as TotalMoney, sum(Milliseconds) as TotalMilliseconds
		from
			(select distinct c.Name, Milliseconds ,d.UnitPrice, d.Quantity
			 from track as a
			 inner join album as b
			 on a.AlbumId = b.AlbumId
			 inner join artist as c
			 on b.ArtistId = c.ArtistId
			 inner join invoiceline as d
			 on a.TrackId = d.TrackId) as info
		group by Artist) as summary
	order by TotalMoney desc
	limit 1)
union
	(select Artist, TotalMilliseconds/1000 as TotalSeconds
	from
		(select Name as Artist, sum(Quantity) as TotalTracks, sum(UnitPrice) as TotalMoney, sum(Milliseconds) as TotalMilliseconds
		from
			(select distinct c.Name, Milliseconds ,d.UnitPrice, d.Quantity
			 from track as a
			 inner join album as b
			 on a.AlbumId = b.AlbumId
			 inner join artist as c
			 on b.ArtistId = c.ArtistId
			 inner join invoiceline as d
			 on a.TrackId = d.TrackId) as info
		group by Artist) as summary
	order by TotalSeconds desc
	limit 1);


