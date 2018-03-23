--Alec Martin
--Database Design Project 2
--3/8/2018
--Question 1: Find all the coaches who have coached exactly TWO teams. List their first names followed by their last names
select c.firstname, c.lastname from coaches_season c group by c.cid, c.firstname, c.lastname having count(distinct c.tid) = 2; 

--Question 2: Find all the players who played in a Boston team or a Denver team. List their first names only. 
select distinct p.firstname from player_rs p, teams t where p.tid = t.tid and (upper(t.location) = 'DENVER' or upper(t.location) = 'BOSTON');

--Question 3: Find those who happened to be a coach and a player in the same team in the same season. List their first names, last names, the team where this happened, and the year(s) when this happened. 
select distinct c.firstname, c.lastname, c.year, t.name from coaches_season c, teams t, player_rs p where upper(c.tid) = upper(t.tid) and upper(p.tid) = upper(t.tid) and upper(c.cid) = upper(p.ilkid) and c.year = p.year order by c.year;

--Question 4: Find the average height (in centimeters) of each team coached by Phil Jackson in each season. Print the team name, season and the average height value (in centimeters), and sort the results by the average height. 
select t.name, c.year, avg((p.h_feet * 12 + p.h_inches) * 2.54) from coaches_season c, teams t, players p, player_rs pr where upper(c.firstname) = 'PHIL' and upper(c.lastname) = 'JACKSON' and upper(c.tid) = upper(t.tid) and upper(c.tid) = upper(pr.tid) and upper(p.ilkid) = upper(pr.ilkid) and c.year = pr.year group by c.tid, t.location, t.name, c.year order by avg desc;

--Question 5: Find the coach(es) (first name and last name) who have coached the largest number of players in year 2003.
select c.firstname, c.lastname from player_rs p, coaches_season c where p.year = 2003 and c.year = 2003 and upper(p.tid) = upper(c.tid) group by c.firstname, c.lastname, p.tid having count(p.ilkid) in (select max(players.count) from (select count(distinct p.ilkid) from player_rs p, teams t, coaches_season c where p.year = 2003 and c.year = 2003 and (upper(p.tid) = upper(t.tid) and upper(c.tid) = upper(t.tid)) group by p.tid) players);

--Question 6: Find the coaches who coached in ALL leagues. List their first names followed by their last names.
select c.firstname, c.lastname from coaches_season c, teams t where upper(c.tid) = upper(t.tid) group by c.cid, c.firstname, c.lastname having count(distinct t.league) in (select max(t.count) from (select count(distinct t.league) from teams t) t) order by c.firstname;

--Question 7: Find those who happened to be a coach and a player in the same season, but in different teams. List their first names, last names, the season and the teams this happened. 
select c.firstname, c.lastname, c.year, t2.name, t1.name from coaches_season c, teams t1, teams t2, player_rs p where upper(c.tid) = upper(t1.tid) and upper(p.tid) = upper(t2.tid) and upper(t1.tid) != upper(t2.tid) and upper(c.firstname) = upper(p.firstname) and upper(c.lastname) = upper(p.lastname) and c.year = p.year and upper(c.cid) = upper(p.ilkid);

--Question 8: Find the players who have scored more points than Michael Jordan did. Print out the first name, last name, and total number of points they scored.
select p2.firstname, p2.lastname, p2.pts from player_rs_career p1, player_rs_career p2 where (upper(p1.firstname) = 'MICHAEL' and upper(p1.lastname) = 'JORDAN') and (upper(p2.firstname) != 'MICHAEL' and upper(p2.lastname) != 'JORDAN') and p2.pts > p1.pts;

--Question 9: Find the most successful coach in regular seasons in history. The level of success of a coach is measured as season_win /(season_win + season_loss). Note that you have to count in all seasons a coach attended to calculate this value. 
select c.firstname, c.lastname, sum(c.season_win) / (sum(c.season_win) + sum(season_loss)) as success from coaches_season c group by c.cid, c.firstname, c.lastname order by success desc limit 1;

--Question 10: List the name(s) of school(s) that sent the second largest number of drafts to NBA. List the name of each school and the number of drafts sent.
select d.draft_from, count(distinct d.ilkid) from draft d group by d.draft_from order by count(distinct d.ilkid) desc limit 1 offset 1;