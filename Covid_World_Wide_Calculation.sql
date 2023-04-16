

-- Shows the likelihood of dying if you contract covid in your country 
SELECT location, DATE_FORMAT(date, '%y-%m-%d') AS formated_date_yy_mm_dd, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS Death_percentage  
FROM coviddeaths 
WHERE location LIKE '%poland%';

-- Showing what percentage of population in Poland got Covid 
SELECT location, DATE_FORMAT(date, '%y-%m-%d') AS formated_date_yy_mm_dd, population, total_cases, (total_cases / population) * 100 AS Percent_of_infected_population 
FROM coviddeaths 
WHERE location LIKE '%poland%'

-- Showing countries with highest death count 
SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM `coviddeaths` 
WHERE location NOT IN ('World', 'High income', 'Upper middle income', 'European Union', 'Lower middle income', 'South America', 'Europe', 'Africa', 'Asia', 'North America')
GROUP BY location
ORDER BY Total_Death_Count DESC;

-- Showing continets with the highest death count 
SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM `coviddeaths` 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;

-- Global numbers of death percentage grouped by date 
SELECT DATE_FORMAT(date, '%y-%m-%d') AS formated_date_yy_mm_dd, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths) / SUM(new_cases)*100 AS Death_Percentage 
FROM `coviddeaths` 
WHERE continent IS NOT NULL 
Group by date

-- Total GLOBAL death percentage and cases of covid from 2020-1-03 to 2023-3-24
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths) / SUM(new_cases)*100 AS Death_Percentage 
FROM `coviddeaths` 
WHERE continent IS NOT NULL 

-- Looking at total Population vs Vaccination, what is the precentage of population in each country that is vaccinated 
With PopVsVac 
AS
(
SELECT covid_d.continent, covid_d.location, covid_d.date, covid_d.population, covid_v.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY covid_d.location ORDER BY covid_d.location) AS Rolling_People_Vaccinated
FROM coviddeaths AS covid_d
LEFT JOIN covidvaccinations AS covid_v 
ON covid_d.location = covid_v.location
AND covid_d.date = covid_v.date
WHERE covid_d.continent IS NOT NULL
-- ORDER BY 2
)
Select *, (Rolling_People_Vaccinated/Population)*100
From popvsvac
Order by date DESC, location, new_vaccinations

-- create a view to store data for later visualization
CREATE VIEW coountries_with_the_highest_deaths_count AS 
SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM `coviddeaths` 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;

-- Looking for a country with highest death count, but taking into consederation population of the country and period between 2020-01-01 and 2021-01-01
SELECT location, MAX(total_deaths) as max_total_deaths, MAX(population) as max_population, SUM(total_deaths)/MAX(population) as death_percentage
FROM `coviddeaths`
WHERE location NOT IN ('ASIA', 'Lower middle income','Africa','High income', 'World', 'Upper middle income')
AND date BETWEEN '2020-01-01' AND '2021-01-01'
GROUP BY location
ORDER BY death_percentage DESC;

-- Which country has the most ICU and hospitalized patiens per million 
SELECT location, MAX(population), SUM(icu_patients_per_million), SUM(hosp_patients_per_million)
FROM coviddeaths
GROUP BY location 
ORDER BY SUM(icu_patients_per_million) DESC, SUM(hosp_patients_per_million) DESC ;









