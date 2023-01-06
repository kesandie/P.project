SELECT *
FROM Pportfolio. 1Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- SELECT *
-- FROM Pportfolio. covidvacc1
-- ORDER BY 3,4;


-- Select data we gonna use

SELECT location, date , total_cases, new_cases, total_deaths, population
FROM Pportfolio. 1coviddeaths
WHERE continent IS NOT NULL;


-- Looking at total cases vs total death

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Pportfolio. 1coviddeaths
WHERE location = 'Haiti'
ORDER BY 1,2;

-- Looking at total cases vs population
-- percentage of Population infected by covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
FROM Pportfolio. 1coviddeaths
WHERE location = 'Haiti'
ORDER BY 1,2


-- Countries with the highest Infection rate compared to population

SELECT location, population,
MAX(total_cases) AS Highestinfectioncount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM Pportfolio. 1coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;




-- Country with highest infection count and percentage population infected by date

SELECT location, population, date,
MAX(total_cases) AS Highestinfectioncount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM Pportfolio. 1coviddeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;

-- Showing countries with the highest Death count per Population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM Pportfolio. 1coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totaldeathcount DESC;

-- Bbreakings things down by continent

SELECT continent, MAX(total_deaths) AS Totaldeathcount
FROM Pportfolio. 1coviddeaths
WHERE continent IS NOT NULL 
GROUP BY continent 
ORDER BY totaldeathcount DESC;

-- Gobal Numbers

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
SUM(new_deaths)/SUM(new_cases) * 100 as Deathpercentage
FROM Pportfolio. 1coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Looking at population vs vaccinantions

SELECT a.continent, a.location, a.date, a.population, b.new_vaccinations
FROM Pportfolio. 1coviddeaths a
JOIN Pportfolio. covidvacc1 b
ON a.location = b.location
AND a.date = b.date
WHERE a.continent IS NOT NULL
ORDER BY 2,3;



SELECT a.continent, a.location, a.date, a.population, b.new_vaccinations,
SUM(b.new_vaccinations) OVER (partition by a.location ORDER BY a.location, a.date) AS Rollingpeoplevaccinated
FROM Pportfolio. 1coviddeaths a
JOIN Pportfolio. covidvacc1 b
ON a.location = b.location
AND a.date = b.date
WHERE a.continent IS NOT NULL
ORDER BY 2,3;


-- USE CTE

WITH popvsvac (continent, location, data, population, new_vaccinations, Rollingpeoplevaccinated)
AS
(SELECT a.continent, a.location, a.date, a.population, b.new_vaccinations,
SUM(b.new_vaccinations) OVER (partition by a.location ORDER BY a.location, a.date) AS Rollingpeoplevaccinated
FROM Pportfolio. 1coviddeaths a
JOIN Pportfolio. covidvacc1 b
ON a.location = b.location
AND a.date = b.date
WHERE a.continent IS NOT NULL
-- ORDER BY 2,3;
)
SELECT *, (Rollingpeoplevaccinated/population)*100
FROM popvsvac;






























