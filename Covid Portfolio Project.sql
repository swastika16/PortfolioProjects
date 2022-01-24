SELECT * 
FROM PortfolioProject..CovidDeaths
Where continent is not NULL
order by 3,4


--Looking at Total Cases vs Total Deaths

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%india'
order by 1,2

--Looking at the Total Cases vs Population
--Shows what percentage of the Population got Infected

SELECT location,date,total_cases,population, (total_cases/population)*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%india'
order by 1,2


--Looking at the Countries with Highest Infection Rates as compared to the Population

SELECT location, population, MAX(total_cases) as Max_InfectionCount,  MAX(total_cases/population)*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%india'
GROUP by location, population
order by 4 desc

--Showing Countries with highest Death Count per Population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not NULL
--Where location like '%india'
GROUP by continent
order by TotalDeathCount desc

--Showing Continents with the Highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not NULL
--Where location like '%india'
GROUP by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, Sum(cast(total_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not NULL
--Where location like '%india'
--GROUP by date
order by 1,2

-- USING CTE

--Looking at Total Population vs Vaccinations
With PopvsVac(Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 as
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from popvsvac






--TEMP TABLE





Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 as
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualization
DROP view if exists PercentPopulationVaccinated
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 as
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3


Select * 
from PercentPopulationVaccinated