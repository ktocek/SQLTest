-- 1
select nazov, count from(
select o.nazov, count(o.nazov) as count from obec o
group by o.nazov
having count(o.nazov) > 1
order by count desc) as nc
where count = (select max(count) from(
               select o.nazov, count(o.nazov) as count from obec o
               group by o.nazov
               having count(o.nazov) > 1
               order by count desc) as nc);
-- 2
select count(*) from okres
inner join kraj k on k.id = okres.id_kraj
where k.nazov = 'Kosicky kraj';
-- 3
select count(*) from obec
inner join okres o on o.id = obec.id_okres
inner join kraj k on k.id = o.id_kraj
where k.nazov = 'Kosicky kraj';
-- 4
select nazov, p.zeny + p.muzi as populacia from obec
inner join populacia p on obec.id = p.id_obec
where p.rok = 2012 and p.zeny + p.muzi = (select max(popu) from(
select p.zeny + p.muzi as popu from populacia p
inner join obec o on o.id = p.id_obec
where p.rok = '2012') as np);
-- 5
select sum(p.muzi + p.zeny) as populacia from okres o
inner join obec o2 on o.id = o2.id_okres
inner join populacia p on o2.id = p.id_obec
where o.nazov = 'Sabinov' and p.rok = 2012;
-- 6
select rok, sum(muzi + zeny) as populacia from populacia
group by rok
order by rok desc;
-- 7
select o.nazov, p.zeny + p.muzi as populacia from populacia p
inner join obec o on o.id = p.id_obec
inner join okres o2 on o2.id = o.id_okres
where p.rok = '2011' and o2.nazov = 'Tvrdosin' and p.zeny + p.muzi =
            (select min(p.zeny + p.muzi) as populacia from populacia p
             inner join obec o on o.id = p.id_obec
             inner join okres o2 on o2.id = o.id_okres
             where p.rok = '2011' and o2.nazov = 'Tvrdosin'
            )
order by populacia;
-- 8
select o.nazov from obec o
inner join populacia p on o.id = p.id_obec
where p.zeny + p.muzi < 5000 and p.rok = 2010;
-- 9
select o.nazov, round(p.zeny/p.muzi::numeric,4) as pomer from obec o
inner join populacia p on o.id = p.id_obec
where p.zeny + p.muzi > 20000 and p.rok = 2011 and p.zeny > p.muzi
order by pomer desc
limit 10;
-- 10
select k.nazov as kraj, count(o2.nazov) as obec, sum(p.zeny + p.muzi) as populacia from kraj k
inner join okres o on k.id = o.id_kraj
inner join obec o2 on o.id = o2.id_okres
inner join populacia p on o2.id = p.id_obec and p.rok = '2012'
group by k.nazov;
-- 11
select nazov, rok12 as r2012, rok11 as r2011, rok12 - rok11 as rozdiel from(
select o.nazov, sum(case when p.rok = 2011 then p.zeny + p.muzi end) as rok11,
       sum(case when p.rok = 2012 then p.zeny + p.muzi end) as rok12 from obec o
inner join populacia p on o.id = p.id_obec
group by o.nazov) as n
where rok12 - rok11 < 0
order by rozdiel;
-- 12
select o.nazov from obec o
inner join populacia p on o.id = p.id_obec
where p.rok = 2012 and p.muzi + p.zeny < ( select avg(muzi + zeny) from populacia
where rok = '2012');
