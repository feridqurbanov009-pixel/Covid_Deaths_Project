/* 

FERID GURBANOV

COVID DEATHS PROJECT ANALYS

*/

------------------------------------------------------------ Select Data that we are going to be using

select location , date_, total_cases, new_cases, total_deaths, population
from covid_deaths order by 1,2


--------------------------------------------------------------- Looking at Total Cases vs Total Deaths
------------------------------------------------------- Shows likelihood of dying if you contract covid in your country

select location , date_, total_cases , total_deaths, round((total_deaths/total_cases)*100 ,2) as death_percentage
from covid_deaths  
where location like '%Azerbaijan%'
order by 1,2

----------------------------------------------------------- Loking at Total Cases vs Population 
--------------------------------------------------------- Shows what percentage of population got Covid

select location , date_, population total_cases , round((total_cases/population)*100 ,2) as population_percentage_infct
from covid_deaths  
--where location like '%Azerbaijan%'
order by 1,2

--------------------------------------------- Looking at Countries with Highest Infection Rate compared to Population

select location ,population, max(total_cases) as highest_infection , round(max((total_cases/population))*100 ,2) as population_percentage_infct
from covid_deaths 
group by location ,population 
order by population_percentage_infct desc

--------------------------------------------------- Showing Countries with Highest Death Count per Population

select location , max(total_deaths) as total_deaths_count
from covid_deaths 
--where location like '%Azerbaijan%'
where continent is not null and total_deaths is not null 
group by location 
order by total_deaths_count desc



-------------------------------------------------------------- Break Things Down by Continent

select continent , sum(total_deaths) as total_deaths_count
from covid_deaths 
--where location like '%Azerbaijan%'
where continent is not null 
group by continent 
order by total_deaths_count desc

select location , sum(total_deaths) as total_deaths_count
from covid_deaths 
--where location like '%Azerbaijan%'
where continent is null 
group by location 
order by total_deaths_count desc

------------------------------------------------ Showing Continents with the highest death count per population

select continent , max(total_deaths) as total_deaths_count
from covid_deaths 
--where location like '%Azerbaijan%'
where continent is not null 
group by continent 
order by total_deaths_count desc

--------------------------------------------------------------------------Global Numbers

select   sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, round(sum(new_deaths)/sum(new_cases)*100,2) as deathpercentage
from covid_deaths  
--where location like '%Azerbaijan%'
where continent is not null
--group by  date_
order by 1,2


--------------------------------------------------------------- Looking at Total Population vs Vaccinations


select dea.continent, dea.location, dea.date_, dea.population, vc.new_vaccinations, sum(vc.new_vaccinations) as rolling_ppl_vacc,
round((sum(vc.new_vaccinations)/dea.population)*100,2) as vac_vs_pop
from covid_deaths dea join covid_vacc vc on dea.location = vc.location
and dea.date_ = vc.date_
where dea.continent is not null
group by dea.continent,
    dea.location,
    dea.date_,
    dea.population,
    vc.new_vaccinations
order by 5,6 desc


---------------------------------------------------------- Creating view to store data for Visualizations


create view covid_vaccination_analysis as
select
    dea.continent,
    dea.location,
    dea.date_,
    dea.population,
    vc.new_vaccinations,

    sum(vc.new_vaccinations)
        over (partition by dea.location order by dea.date_)
        as rolling_ppl_vacc,

    round(
        (sum(vc.new_vaccinations)
            over (partition by dea.location order by dea.date_)
        / dea.population) * 100
    , 2) as percent_vaccinated

from covid_deaths dea
join covid_vacc vc
    on dea.location = vc.location
   and dea.date_ = vc.date_
where dea.continent is not null


select *
from covid_vaccination_analysis


 









