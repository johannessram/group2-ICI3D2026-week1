# Modelling the Effect of Healthcare Access on Mortality During the 1918 Influenza Pandemic in South Africa

This repository contains the R scripts, statistical tools, and numerical simulations developed for the project **"The Role of Healthcare Inequality in Shaping Mortality During the 1918 Influenza Pandemic in South Africa"**. 

This research was conducted as part of the **International Clinics on Infectious Disease Dynamics and Data (ICI3D)** program in collaboration with the **African Institute for Mathematical Sciences (AIMS) South Africa**. 

## 📌 Project Overview
The 1918 influenza pandemic resulted in catastrophic mortality worldwide and across South Africa. Driven by colonial historical structures, the outbreak was marked by severe social and economic disparities. 

This project integrates historical data analysis with epidemiological modeling to evaluate how healthcare inequalities directly influenced pandemic dynamics. Specifically, we utilize a data-driven **SIRD (Susceptible-Infected-Recovered-Deceased)** model to simulate and contrast historical pandemic outcomes under two key scenarios:
1. **Healthcare Inequality Scenario:** Where population groups experience asymmetric recovery ($\gamma$) and clinical mortality ($\mu$) rates due to disparate healthcare access.
2. **Healthcare Equality Scenario:** Where parameters converge to reflect equalized access across demographics.

The empirical core of the model focuses on historical death register subsets spanning **Paarl** and **Kuruman**.

## 📑 Foundational Base Paper
This framework builds directly upon the following foundational literature:
* **Fourie, J. and Jayes, J. (2021).** *Health Inequality and the 1918 Influenza in South Africa*. **World Development**.

Fourie and Jayes transcribed thousands of historical death certificates and established the presence of a **doctor's signature** on the certificate as a reliable proxy for active healthcare access during the pandemic. Their empirical findings demonstrated that non-white populations faced drastically lower doctor signature rates, signaling a significant structural disadvantage that our mathematical modeling aims to evaluate numerically.

## 🧮 Mathematical Framework
The pandemic dynamics are modeled using a system of deterministic ordinary differential equations (ODEs) split across demographic population strata:

$$\frac{dS}{dt} = -\frac{\beta S I}{N}$$
$$\frac{dI}{dt} = \frac{\beta S I}{N} - \gamma I - \mu I$$
$$\frac{dR}{dt} = \gamma I$$
$$\frac{dD}{dt} = \mu I$$

Where:
* $N = S + I + R + D$ (Total population size, assumed constant) 
* $\beta$: Transmission rate coefficient
* $\gamma$: Recovery rate parameter
* $\mu$: Clinical mortality rate

## 📁 Repository Contents
- [model_running.R](./model_running.R): This script implements a deterministic SIRD epidemiological model using the deSolve package to simulate and compare cumulative mortality trajectories across different population groups under historical inequality versus hypothetical equality scenarios.

- [conditional.R](./conditional.R): This script processes historical death register data to compute the conditional probabilities of a death certificate being signed by a doctor given an individual's demographic classification, establishing a proxy for healthcare access.



## 🛠️ Requirements & Installation
To run the simulations locally, ensure you have **R** installed alongside the following dependencies:

```R
install.packages(c("deSolve", "ggplot2", "dplyr", "lubridate"))
```


## Contributors :
Group 2 of preparation Week :
- [Ashton](mailto:ashton@aims.ac.za)
- [Disebo](mailto:disebo@aims.ac.za)
- [Mija](mailto:mija@aims.ac.za)
- [Nirinkoavy ( aka Johanness)](mailto:nirinkoavy@aims.ac.za)
- [Vhugala](mailto:vhugala@aims.ac.za)
