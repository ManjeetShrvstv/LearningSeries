SELECT * 
FROM [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where continent is not null
Order By 3,4

--SELECT * 
--FROM [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
--Order By 3,4

--Select data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where continent is not null
Order By 1,2

--Looking at Total Cases VS Total Deaths
--Shows likelihood of dying if you contract covid
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where location like '%India%'
Order By 1,2

--Looking at Total Cases VS Population
--Shows what percentage of population got covid
Select location, date, population, total_cases,(total_cases/population)*100 as Infected_Percentage
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where location like '%India%'
Order By 1,2

--Looking at countries with highest infection rates against population
Select location, population, MAX(total_cases) AS highest_infected_Count, MAX((total_cases/population))*100 as Total_Infected_Percentage
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
--Where location like '%India%'
Where continent is not null
Group By location, population
Order By Total_Infected_Percentage desc

--Showing countries with highest Death counts against population
Select location, MAX(cast(total_deaths as int)) as Total_death_count
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where continent is not null
Group By location
Order By Total_death_count desc


--Let's break down things by Continents

--Showing the highest deaths by continents against population
Select continent, MAX(cast(total_deaths as int)) as Total_death_count
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where continent is not null
Group By continent
Order By Total_death_count desc


--Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as total_death_Percentage
From [ManjeetShrivastav-MyPortfolio]..CovidDeaths$
Where continent is not null
Order By 1, 2 



--Looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations))
 OVER (Partition by dea.Location Order By dea.location, dea.Date) as Rolling_peopleVaccinated
from [ManjeetShrivastav-MyPortfolio]..CovidDeaths$ as dea
join [ManjeetShrivastav-MyPortfolio]..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3


--USE CTE
with PopvsVac ( continent, location, date, population, new_vaccinations, Rolling_peopleVaccinated) as
(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations))
	 OVER (Partition by dea.Location Order By dea.location, dea.Date) as Rolling_peopleVaccinated
	from [ManjeetShrivastav-MyPortfolio]..CovidDeaths$ as dea
	join [ManjeetShrivastav-MyPortfolio]..CovidVaccinations$ as vac
		on dea.location = vac.location
		and dea.date = vac.date
	WHERE dea.continent is not null
	--ORDER BY 2, 3
)
select * , (Rolling_peopleVaccinated/population)*100
from PopvsVac




--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	Rolling_peopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations))
	 OVER (Partition by dea.Location Order By dea.location, dea.Date) as Rolling_peopleVaccinated
	from [ManjeetShrivastav-MyPortfolio]..CovidDeaths$ as dea
	join [ManjeetShrivastav-MyPortfolio]..CovidVaccinations$ as vac
		on dea.location = vac.location
		and dea.date = vac.date

--WHERE dea.continent is not null
--ORDER BY 2, 3
select * , (Rolling_peopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating view to store data for later visualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations))
	 OVER (Partition by dea.Location Order By dea.location, dea.Date) as Rolling_peopleVaccinated
	from [ManjeetShrivastav-MyPortfolio]..CovidDeaths$ as dea
	join [ManjeetShrivastav-MyPortfolio]..CovidVaccinations$ as vac
		on dea.location = vac.location
		and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3

select *
from PercentPopulationVaccinated









