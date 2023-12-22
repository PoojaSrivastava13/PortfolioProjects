select * from PortfolicProject.coviddeaths
order by date asc;

select * from PortfolicProject.covidvaccinations
order by date asc;

select continent, location, count(location) from PortfolicProject.coviddeaths
group by continent,location
order by continent;

select @@session.sql_mode='';   

set session sql_mode='only_full_group_by';        -- Setting sql mode from 'only_full_group_by' to ''

-- Select data that we will be using by creating Temp Table
drop table if exists covid_deaths_temp;
create temporary table covid_deaths_temp( select continent,location,date,total_cases,new_cases,total_deaths,population
from PortfolicProject.coviddeaths
order by 1,2);

-- Total Covid Cases vs Total Deaths(Likelyhood of dying if contacted covid in your location)
select *,(total_deaths/total_cases)*100 as deathpercent
from covid_deaths_temp
where location like '%india%'
order by 1,2;

-- Total cases vs population(Percentage of population contacted covid)
select *,(total_cases/population)*100 as infectedPercentage
from covid_deaths_temp
-- where location like '%india%'
order by 1,2;

-- List of contries with highest infection rate compared to population
select location,population,max(total_cases) as highestcases,max((total_cases/population)*100) 
as infectedPercentage
from covid_deaths_temp
group by location,population
order by infectedPercentage desc;

-- List of contries with highest death count compared per population
select location,max(cast(total_deaths as unsigned int)) as highestdeaths
from covid_deaths_temp
group by location
order by highestdeaths desc;

-- Global number of deaths 
select sum(new_cases) as total_cases,sum(new_deaths)as total_deaths,
sum(new_deaths)/sum(new_cases)*100 as deathpercent
from PortfolicProject.coviddeaths
order by 1,2;


-- Total population vs vaccinated population(By creating CTE)
with CTE_percent_people_vaccinated (continent,location, date, Population, new_vaccinations, rolling_people_vaccinated)
as(select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(v.new_vaccinations, unsigned int)) over (partition by d.location
order by d.location, d.date) as rolling_people_vaccinated
from PortfolicProject.coviddeaths d, PortfolicProject.covidvaccinations v
where d.location=v.location and d.date=v.date 
and v.continent is not null and v.continent !=''
order by 2,3)

select *, (rolling_people_vaccinated/population) * 100 
from CTE_percent_people_vaccinated;

-- Previous Query using Temp table
drop temporary table if exists Temp_percent_people_vaccinated;
create temporary table Temp_percent_people_vaccinated(
Continent varchar(255),
Locatiopn varchar(255),
Date text,
Population varchar(255),
new_vaccinations int, 
rolling_people_vac int
);

Insert into Temp_percent_people_vaccinated(
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(v.new_vaccinations, unsigned int)) over (partition by d.location
order by d.location, d.date) as rolling_people_vaccinated
from PortfolicProject.coviddeaths d, PortfolicProject.covidvaccinations v
where d.location=v.location and d.date=v.date 
and v.continent is not null and v.continent !=''
order by 2,3
);

select *,(rolling_people_vac/Population) * 100 
from Temp_percent_people_vaccinated;

desc PortfolicProject.coviddeaths;

-- creating view for visualization
drop view if exists PortfolicProject.view_percent_people_vaccinated;

create view PortfolicProject.view_percent_people_vaccinated as
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(v.new_vaccinations, unsigned int)) over (partition by d.location
order by d.location, d.date) as rolling_people_vaccinated
from PortfolicProject.coviddeaths d, PortfolicProject.covidvaccinations v
where d.location=v.location and d.date=v.date 
and v.continent is not null and v.continent !='';

select * from PortfolicProject.view_percent_people_vaccinated;






