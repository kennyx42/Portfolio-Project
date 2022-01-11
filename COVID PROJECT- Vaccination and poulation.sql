Select*
From PortfolioProject..Covid_death_dataset
where continent is not null
order by 3,4

Select*
From PortfolioProject..Covid_vaccinations_dataset
where continent is not null
order by 3,4


--Select*
--From PortfolioProject..Covid_vaccinations_dataset
--order by 3,4

Select location, date,total_cases, new_cases,total_deaths, population
From PortfolioProject..Covid_death_dataset
where continent is not null
order by 1,2


--Total cases Vs Total Deaths

Select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as per_of_death
From PortfolioProject..Covid_death_dataset
where continent is not null
and location ='spain' 
order by 1,2

--Total cases Vs Population

Select location, date,total_cases,population, (total_cases/population)*100 as per_of_pop
From PortfolioProject..Covid_death_dataset
where location ='spain' 
and continent is not null
order by 1,2

-- Countries with the highest percentage of infection to population ratio
Select location, population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as per_of_popinfected
From PortfolioProject..Covid_death_dataset
--where location ='spain'
where continent is not null
group by location, population
order by per_of_popinfected desc


-- Countries with the highest percentage of death to population ratio
Select location, population, MAX(cast(total_deaths as int)) as highestdeathcount, MAX((total_deaths/population))*100 as per_of_popdeath
From PortfolioProject..Covid_death_dataset
where continent is not null
group by location, population
order by per_of_popdeath desc


-- Joining covid death and covid vaccination table by date and location
Select*
From PortfolioProject..Covid_death_dataset dea
Join PortfolioProject..Covid_vaccinations_dataset vac
   on dea.date = vac.date
   and dea.location = vac.location


-- Total population vs vaccinaton
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
From PortfolioProject..Covid_death_dataset dea
Join PortfolioProject..Covid_vaccinations_dataset vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
order by 1,2,3


--- Summing the number of vaccination by location
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location,dea.date) as cumm_vac_count
From PortfolioProject..Covid_death_dataset dea
Join PortfolioProject..Covid_vaccinations_dataset vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
order by 2,3


--Creating a CTE
with pop_vs_vac (continent, location, date, population,new_vaccinations, cumm_vac_count)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location,dea.date) as cumm_vac_count
From PortfolioProject..Covid_death_dataset dea
Join PortfolioProject..Covid_vaccinations_dataset vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)
select *, (cumm_vac_count/population)*100
From pop_vs_vac


--Create View

Create View pop_vs_vac as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location,dea.date) as cumm_vac_count
From PortfolioProject..Covid_death_dataset dea
Join PortfolioProject..Covid_vaccinations_dataset vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
--order by 2,3
