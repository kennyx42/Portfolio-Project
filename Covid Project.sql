
--- Prompting SQL to use the database"Project on Covid"
Use [Project on Covid];


--Getting an overview of what the columns in each table are
select * 
from [Project on Covid]..covid_vaccinations_dataset

get the net of population after death??

/* from exploring the dataset on Covid death, I observed that
 in the location field there are instances of continents and world as 
 variables. To restrict this, I will use a where clause that filters
 out where continent field is not null */

Select location, month(date) as month,date,total_cases,new_cases, total_deaths,
population, (population-total_deaths) as post_pop
from [Project on Covid]..Covid_death_dataset
order by 1,3

--% of death to total cases

--% of death to total cases
Select location, month(date) as month,total_cases, total_deaths,
(cast (total_deaths as int)/total_cases)*100 as death_rate__per_case
from [Project on Covid]..Covid_death_dataset
where continent is not null
order by 1,3


--% of death to total cases in Nigeria

Select location, month(date) as month,date,total_cases, total_deaths,(cast (total_deaths as int)/total_cases)*100 as death_rate__per_case
from [Project on Covid]..Covid_death_dataset
where continent is not null and location = 'Nigeria' 
order by 1,3

--% of the Nigerian population that contracted corona virus
Select location, month(date) as month,date,total_cases, population,
(total_cases/population)*100 as case_per_population
from [Project on Covid]..Covid_death_dataset
where continent is not null and location = 'Nigeria' 
order by 1,3

--Countries with the highest cases compared to population
Select location,Max(total_cases) as max_Total, population,
Max((total_cases/population))*100 as case_per_population
from [Project on Covid]..Covid_death_dataset
where continent is not null
Group by location, population
order by 4 desc

--Countries with the highest mortality count
with mortality_count as

 (Select location,Max(cast (total_deaths as int)) as max_Total
from [Project on Covid]..Covid_death_dataset
where continent is not null 
Group by location
)
select location,max_Total
from mortality_count
where max_Total is not null
order by 2 desc


--- Continents with the highest death count
select  continent, max(cast(total_deaths as int))
from [Project on Covid]..Covid_death_dataset
where continent is not null
Group by continent


/*World Statistics on Covid */

---sum of all cases by month
with month_stat as

(Select month(date) as monthly, (new_cases),new_deaths
from [Project on Covid]..Covid_death_dataset)

select  monthly, sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths
from month_stat
group by monthly
order by 2,3




---- what % of the population has been vaccinated
/* To achieve this I will combine the Covid_vaccination table with the Covid death table therough a Join*/
select det.continent as continent, vac.location as location, (max(people_fully_vaccinated)/max(population))*100 as pop_vaccinated
from [Project on Covid]..Covid_death_dataset det
join [Project on Covid]..Covid_vaccinations_dataset vac 
on det.location = vac.location 
and det.date = vac.date
where det.continent is not null 
Group by vac.location, det.continent  
order by 3 desc

---
select det.continent, det.location, det.date,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by det.location order by vac.location, det.date) as run_pop_vac
from [Project on Covid]..Covid_death_dataset det
join [Project on Covid]..Covid_vaccinations_dataset vac 
on det.location = vac.location 
and det.date = vac.date
where det.continent is not null and vac.new_vaccinations is not null
order by 2,3 desc









