# Database of African Protected Area Visitation (PAVIS)

## Description
This repository consists of **work in progress** on creating a Database of African Protected Area Visitation (PAVIS).

Background infromation is presented in the manuscript:

* Buschke, F., Capitani, C., Schägner, P., Nsengiyumva, C., Okelo, H., Cissé, O., & Snyman, S. (*In preparation*). A dataset of pre-pandemic African protected area visitation.

The content is accurate as of 21 November 2024. Equiries can be directed to `falko.buschke@gmail.com`

### Abstract
*When people visit protected areas, their presence can amplify public support for conservation and their spending feeds local economies. Across Africa, protected areas are often presented as engines for poverty alleviation and rural development. Yet visitation data remains scarce for most of the continent. Here we present a dataset of African protected area visitation obtained from government sources as well as peer-reviewed and grey literature. The spatially explicit dataset includes 4,216 records from 341 protected areas in 34 countries. The earliest visitor counts date back to 1965, but the majority (78%) stem from between the years 2000 and 2020. While 22% of protected areas only have visitation data for a single year, the median protected area has six years of visitation data, facilitating temporal analyses. Moreover, the dataset is compatible with the World Database of Protected Areas, making it possible to compare visitation across governance types and management categories. Ultimately, the dataset provides baselines for post-pandemic ecotourism recovery and enables analyses of the factors determining protected area visitation.*

## File structure
This respository contains three files:
  
  1. `PAVIS_v1.0.csv` - A `.csv` file containing the information in the Database of African Protected Area Visitation (PAVIS)
  2. `Summary_plot.R` -- A fully-annotated R-script to reshape, process and summarise visitation data
  3. `Composite.png` -- A single Figure summarising the infromation in the PAVIS database

## Data description
The dataset of African protected area visitation contains 4,216 visitation records from 341 protected areas in 34 African countries. The dataset has 29 columns containing the following information:

*	`ID` (included for 100% of records): A unique integer identifier code for each record. The order of the identifier codes is arbitrary and the sequence is not reflective of visitation characteristics.
*	`Country` (included for 100% of records): The name of the country from which the record originates.
*	`PA_name` (included for 100% of records): The name of the protected area, consistent with the name as recorded by the WDPA.
*	`WDPAID` (included for 100% of records): A unique identifier assigned to each protected area by UNEP-WCMC as part of the WDPA. For 7.9% of protected areas not included in the WDPA (e.g., botanical gardens and wildlife sanctuaries), arbitrary identifiers were assigned using the prefix XID followed by a unique integer (these dummy identifier codes affected 5.5% of all records). 
*	`IUCN_Cat` (included for 94.5% of records): The IUCN Management Category as reported by the WDPA. Only 10 levels permitted *Ia*; *Ib*; *II*; *III*; *IV*; *V*; *VI*; *Not Applicable*; *Not Assigned*; *Not Reported*.
*	`Longitude` (included for 100% of records): The longitude of the internal geographical centroid of the protected area. 
*	`Latitude` (included for 100% of records): The latitude of the internal geographical centroid of the protected area.
*	`REP_AREA` (included for 94.5% of records):The area in square-kilometres as reported by the data suppliers to WDPA. 
*	`GIS_AREA` (included for 94.5% of records):The area in square-kilometres calculated by UNEP-WCMC using GIS from protected area polygons in the WDPA. The GIS areas of protected areas in the WDPA only represented by points were reported as 0 km2. 
*	`STATUS_YR` (included for 94.5% of records):The age of the protected area, as inferred from the year in which the most recent status (e.g. *proposed*, *designated*, *established* etc.) was enacted according to the WDPA. The WDPA reported the status year as 0 for 2.8% of records.
*	`GOV_TYPE` (included for 94.5% of records):The type of governance in the protected area according to the WDPA. Only 12 categories permitted: *Federal or national ministry or agency*; *Sub-national ministry or agency*; *Government-delegated management*; *Transboundary governance*; *Collaborative governance*; *Joint governance*; *Individual landowners*; *Non-profit organisations*; *For-profit organisations*; *Indigenous peoples*, *Local communities*; *Not Reported*.
*	`ISO` (included for 100% of records): The 3-letter country code as defined by the International Organization for Standardisation.
*	`Visitors` (included for 100% of records): The count of visitors to the protected area.
*	`Year` (included for 100% of records):The year of the visitation count
*	`VisitationType` (included for 97.5% of records):A description on the type of visitor count in one of eight categories: *Entrants*, *International visitors*; *Reported Averages*; *Sum of international and domestic visitors*; *Unknown / other*, *Visitors*; *Visits*. 
*	`International_tot` (included for 14.2% of records): The total count of international visitors to the protected area.
*	`International_perc` (included for 14.2% of records): The number of international visitors as a percentage of the total number of visitors.
*	`ForeignResidents_tot` (included for 1.3% of records): The total count of foreign resident visitors to the protected area.
*	`ForeignResidents_perc` (included for 1.3% of records): The number of foreign resident visitors as a percentage of the total number of visitors.
*	`Domestic_tot` (included for 13.5% of records): The percentage of domestic visitors to the protected area.
*	`Domestic_perc` (included for 13.5% of records): The number of domestic visitors as a percentage of the total number of visitors.
*	`Spending` (included for 0.8% of records): The estimated total spending by all visitors. 
*	`Currency` (included for 0.8% of records): The currency of the spending estimates.
*	`Int_US$` (included for 0.8% of records): Spending presented in International US$ according exchange rates in September 2025.
*	`Method` (included for 50.9% of records): The method used to quantify visitation. Four levels: *Accounting data*; *Permit sales*; *Unknown/other*; *Visitor questionnaires*. 
*	`Confidence` (included for 97.6% of records): The confidence that the visitation count represents the reported figures accurately (i.e., this is not a certainty estimate of the counts themselves). Currently five levels: *unknown*; *speculative*; *moderate*; *high*; *very high*.
*	`Comments` (included for 9.0% of records): Any comments that may affect the interpretation of the visitation counts.
*	`Reference_original` (included for 100% of records): The reference to the original data.
*	`Citation_Comment_Sept2024` (included for 100% of records): A comment to validate whether the original data source is still available.


## Output
The output of this data and analsysis is a single graphic, summarising the main information in the PAVIS database:

<img src="https://github.com/falko-buschke/PAVIS/blob/main/Composite.png" alt="PAVIS" width="1000"/>
