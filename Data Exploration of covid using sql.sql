select * from coviddeaths
where continent is not null
order by 3,4


select * from covidvaccinations
where continent is not null
order by 3,4

--Select data that we are going to be using.

select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
where continent is not null
order by 1,2

--looking at toal cases vs total deaths as death percentage
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as "death percentage"
from coviddeaths
where continent is not null
order by 1,2

--looking for death percentage in india
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as "death percentage"
from coviddeaths
where location='india' and continent is not null
order by 1,2;

--looking at total_cases vs population
select location,date,total_cases,population,(total_cases/population)*100 as "Case percentage"
from coviddeaths
where continent is not null
order by 1,2

--lokking for how much percentage of people got covid in india
select location,date,total_cases,population,(total_cases/population)*100 as "Case percentage"
from coviddeaths
where location='india' and continent is not null
order by 1,2

--looking at countries with highest infection rate compared to population
select location,max(total_cases)as 'highest infection count',max((total_cases/population))*100 as 'perentage of population infected'
from coviddeaths
where continent is not null
group by location,population
order by 3 desc
--from above data we can see that andorra has highest of population infected

--showing countries with highest deeath count per population
select location,max(cast(total_deaths as int)) as 'total deaths counts'
from coviddeaths
where continent is not null
group by location
order by 'total deaths counts' desc

--for divison in continent
select location,max(cast(total_deaths as int)) as 'total deaths counts'
from coviddeaths
where continent is null
group by location
order by 'total deaths counts' desc

select continent,max(cast(total_deaths as int)) as 'total deaths counts'
from coviddeaths
where continent is not null
group by continent
order by 'total deaths counts' desc


--global numbers
select sum(new_cases) as 'totalcases' ,sum(cast(new_deaths as int)) as 'total_deaths', sum(cast(new_deaths as int))/sum(new_cases)*100 as 'global death percentage'
from coviddeaths
where continent is not null
--group by date
order by 1,2

--covid vaccinations
--joining covid deaths,covid vaccinations

select * from coviddeaths as cd
join covidvaccinations as cv
on cd.location=cv.location and cd.date=cv.date

--looking for total populations vs vaccinations
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
from coviddeaths as cd
join covidvaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null 
order by 2,3

--adding up vaccination 
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as 'rollingpeoleVaccinated'
from coviddeaths as cd
join covidvaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null 
order by 2,3

--percenatge of people getting vaccinated


with PopuvsVac (Continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as 'rollingpeoleVaccinated'
from coviddeaths as cd
join covidvaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null 
--order by 2,3
)
select *,(rollingpeoplevaccinated/population)*100 from PopuvsVac

--Temp Table
drop table if exists #percentPopulationVaccinated
Create Table #percentPopulationVaccinated
(Continent varchar(255),
loaction varchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpeoplevaccinated numeric
)
insert into #percentPopulationVaccinated
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as 'rollingpeoleVaccinated'
from coviddeaths as cd
join covidvaccinations as cv
on cd.location=cv.location and cd.date=cv.date
--order by 2,3

--viewing from temp table
select *,(rollingpeoplevaccinated/population)*100 from #percentPopulationVaccinated

--creating view to stoe data for later visualzation
create view percentpopulatedvaccinated as 
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as 'rollingpeoleVaccinated'
from coviddeaths as cd
join covidvaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
