alter session set "_ORACLE_SCRIPT"=true;
--1 Part I Create a tablespace with name 'third_quiz' and three datafiles. Each datafile of 15Mb.
CREATE TABLESPACE third_quiz
DATAFILE 'third_quiz_01' SIZE 15M,'third_quiz_02' SIZE 15M,'third_quiz_03' SIZE 15M


--2  Create a profile with idle time of 3 minutes and 3 maximum failed attempts, the name of the profile should be 'consultant'
CREATE PROFILE consultant LIMIT
IDLE_TIME 3
FAILED_LOGIN_ATTEMPTS     3

-- 3 Create an user named "user1" with password "user1". 
--The user should be able to connect
--The user should has the profile "consultant"
--The user should be associated to the tablespace "third_quiz"
--The user should be able to create tables WITHOUT USING THE DBA ROLE. 



CREATE USER user1 
IDENTIFIED BY user1
DEFAULT TABLESPACE third_quiz
QUOTA UNLIMITED ON third_quiz
PROFILE consultant

GRANT CREATE SESSION TO user1
GRANT CREATE TABLE TO user1

-- 4 Create an user named "user2" with password "user2"
--The user should be able to connect
--The user should has the profile "consultant"
--The user should be associated to the tablespace "third_quiz"
--The user shouldn't be able to create tables.

CREATE USER user2 
IDENTIFIED BY user2
DEFAULT TABLESPACE third_quiz
QUOTA UNLIMITED ON third_quiz
PROFILE consultant

GRANT CREATE SESSION TO user2



---PART II  1. With the user1 create the next table (DON'T CHANGE THE NAME OF THE TABLE NOR 



CREATE TABLE attacks (id int, 
url varchar(2048),
ip_address varchar(20),
number_of_attacks int,
time_of_last_attack timestamp)



GRANT SELECT ON attacks TO user2


--- PART III Queries (Don't change the name of the columns): 
--1. Count the urls which have been attacked and have the protocol 'https'
SELECT count(url) conteo
FROM attacks
WHERE URL LIKE 'https%'
--2. List the records where the URL attacked matches with google (it does not matter if it is google.co.jp, google.es, google.pt, etc) order by number of attacks ascendent
select *
from attacks 
where url like '%google%'
order by number_of_attacks desc
--3. List the ip addresses and the time of the last attack if the attack has been produced on year 2017 (Hint: https://stackoverflow.com/a/30071091)
select ip_address
from attacks
where extract(year from time_of_last_attack)=2017
--4. Show the first IP Address which has been registered with the minimum number of attacks 
SELECT IP_ADDRESS
FROM (
select IP_ADDRESS,NUMBER_OF_ATTACKS,MIN(NUMBER_OF_ATTACKS) OVER() MINIMO
from attacks) 
WHERE NUMBER_OF_ATTACKS=MINIMO
--5. Show the ip address and the number of attacks if instagram has been attack using https protocol
SELECT ip_address,number_of_attacks
FROM attacks
WHERE url like '%instagram%' AND url like 'https%'
--6. Show the records which the time of last attack has been produced between the 6 am and noon
SELECT *
FROM attacks
WHERE EXTRACT(HOUR FROM time_of_last_attack) between 6 and 11