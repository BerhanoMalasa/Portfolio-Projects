select *
From PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

select *
From PortfolioProject.dbo.CovidVaccinations
where continent is not null
order by 3,4

--select data that we are going to be using

SELECT Location,date,total_cases,new_cases,total_deaths,population
FROM portfolioProject..CovidDeaths
order by 1,2 --total_deaths asc

--Looking at Total cases vs Total Deaths
--Shows liklihood of dying if you contract covid in your coutry

select location,date,year(date) as Year,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
from PortfolioProject..CovidDeaths
where location like '%israel%'
order by 1,2


--Looking total deaths vs population
--Show what precentage of pupolation got covid

select location,date,year(date) as Year,population,total_cases, round((total_cases/population)*100,2) as PopulationPercentage  
from PortfolioProject..CovidDeaths
where location like '%israel%'
order by 1,2

--Looking at countries with highest infaction rate compared to population

select location,population,max(total_cases) as highestInfacscount, round(Max((total_cases/population))*100,2) as PercentagePopulationInfaction  
from PortfolioProject..CovidDeaths
--where location like '%israel%'
group by location,population
order by percentagePopulationInfaction desc

--Showing Countries with highest death count per population
select location,MAX(cast(total_deaths as int)) as TotaldeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotaldeathCount desc

--Copy Showing Countries with highest death count per population
select location,YEAR(date),MONTH(date),sum(cast(total_deaths as int)) as TotaldeathCount,max(cast(total_deaths as int)) as TotaldeathCountw
from PortfolioProject..CovidDeaths
where location like '%israel%' and continent is not null
group by location,date
order by TotaldeathCount asc


--LET'S BREAK THINGS DOWN BY CONTINENT
select continent,MAX(cast(total_deaths as int)) as TotaldeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotaldeathCount desc

--showing continent with the highest death count per population

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
       sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by continent
order by 1,2

--Looking at Total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
       ,sum(convert(int,vac.new_vaccinations) ) over (partition by dea.location order by dea.location,dea.date)    
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3