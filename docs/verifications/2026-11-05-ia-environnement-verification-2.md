# Second, independent check: séance 9 figures (water, electricity, energy per use)

Checker: second, independent pass, 5 November 2026. Every value below was re-read in the primary document. All quotes were checked against the raw text (PDF via pdftotext, or HTML via curl), not a summarizer. I downloaded the PDFs myself into `/tmp/s9ai/rv/` and did not use any file or summary from the first checker. Where a site blocked direct download, the mirror I used is named.

---

## WATER, United States

### 1. Irrigation, consumptive use, 2020: 78,400 Mgal/d. **CONFIRMÉ** (scope needs stating)
- Source: USGS Professional Paper 1894-D, *Water Use Across the Conterminous United States, Water Years 2010–20* (doi:10.3133/pp1894D). URL read: https://pubs.usgs.gov/pp/1894/d/pp1894D.pdf
- Quote (p. 26, "Crop-Irrigation Withdrawals and Consumptive Use"): « Model estimates for water withdrawals and consumptive use for crop irrigation for the CONUS in water year 2020 were 108,723 and 78,400 Mgal/d (12,526 and 9,027 Mm3/mo), respectively. »
- Scope:
  - **Contiguous US only** (CONUS, lower 48).
  - **Water year 2020** (Oct. 2019 to Sept. 2020), not the calendar year.
  - **Modelled** estimate.
  - Covers **crop** irrigation only.
- Average for 2010–20: 75,698 Mgal/d.
- **Golf is NOT included.** On p. 6 the report says model estimates cover "public supply, crop irrigation, and thermoelectric power", while golf-course irrigation is estimated with the older method "for calendar year 2015 (sidebar 2)". The golf sidebar (p. 41) says that in 2015 and earlier reports, irrigation "included water used for crops and recreational land including golf courses". In 2015, golf withdrawals in the 36 reporting States were 1,039 Mgal/d.
- Conversion (mine): 78,400 Mgal/d ≈ 108,000 billion L/year.

### 2. Thermoelectric, consumptive use, 2020: 2,382 Mgal/d. **CONFIRMÉ**
- Same source, p. 31.
- Quote: « Consumptive use for thermoelectric power, overwhelmingly fresh water, was 2,382 Mgal/d in 2020 and 2,904 Mgal/d averaged over water years 2010–20 for the CONUS, or 4 percent of thermoelectric freshwater withdrawals. »
- Scope: CONUS, water year 2020, modelled.
- Conversion (mine): ≈ 3,290 billion L/year.

### 3. Golf: 1.63 million acre-feet applied in 2024. **CONFIRMÉ** (wording matters)
- Source: GCSAA news release, 30 Dec. 2025. URL read: https://www.gcsaa.org/who-we-are/media/news-release/2025/12/30/golf-courses-reduce-water-usage-by-31-percent-according-to-national-survey
- Quote: « The report found that U.S. golf facilities applied a projected 1.63 million acre-feet of water in 2024, representing a 3.2% reduction since 2020 and a 31% reduction since 2005. »
- Peer-reviewed paper: Shaddox, Unruh, Tapp, Brown, Stacey & Fuger (2025), "Survey of water use and management practices on U.S. golf courses from 2005 to 2024", *HortTechnology* 35(5):848–857, doi:10.21273/HORTTECH05716-25.
  - I got the citation from GCSAA's magazine GCM: https://www.gcmonline.com/research/news/from-acre-feet-to-outcomes-interpreting-the-2024-gcep-water-survey
  - The journal page returned 403. I could **not** read the abstract.
- GCM, raw text: « Projected applied water represents the "total estimated volume of irrigation water used" nationally or regionally. It is calculated by multiplying the average amount of water applied to nine-, 18- or 27-plus-hole facilities by the number of facilities of each type within a region. »
- Caveats:
  - This is **applied** (withdrawn) irrigation water, **not consumptive use**. It is not strictly comparable with lines 1 and 2.
  - Scope, in GCM's words: « U.S. golf facilities », by seven GCSAA agronomic regions. 1,766 superintendents answered (12.6% response rate).
  - Some secondary sources give an exact 1,631,915 acre-feet. That number is **not** in the GCSAA release; do not use it.
- Conversion (mine): ≈ 2,010 billion L/year, or ≈ 1,455 Mgal/d.

### 4. US data centres, direct on-site consumption, 2023: 66 billion L. **CONFIRMÉ**
- Source: Shehabi et al., *2024 United States Data Center Energy Usage Report*, LBNL-2001637, Dec. 2024 (doi:10.71468/P1WC7Q).
  - URL read: https://escholarship.org/content/qt32d6m0d1/qt32d6m0d1.pdf (official UC eScholarship copy).
  - The eta-publications.lbl.gov link redirects to eScholarship, and the MIT mirror served HTML.
- Quote (printed p. 55, "Direct Water Consumption"): « In 2014, data centers consumed 21.2 billion liters of water, with 64% in internal data centers. By 2023, hyperscale and colocation account for 84% of the 66-billion-liter total »
- Context: 2028 projection for hyperscale alone is 60 to 124 billion L. In US units, 66 billion L ≈ 17.4 billion gallons.

### 5. US data centres, indirect water through electricity, 2023: "nearly 800 billion liters". **CONFIRMÉ**
- Same report, printed p. 57.
- Quote: « The total indirect water footprint of U.S. data centers is nearly 800 billion liters, attributed to water consumed indirectly through electricity use, based on the regional electricity grid mix for U.S. data center locations. »
- Same page: 4.52 L/kWh for data centres, against a US average of 4.35 L/kWh. The estimate ignores power purchase agreements and behind-the-meter generation.
- **Hydro: YES, reservoir evaporation is included.**
  - LBNL p. 56: « hydroelectric reservoirs lose water through open surface evaporation, leading to water consumption ».
  - The method points to Siddik et al. (2024), *Water Resources Research* 60(12), e2024WR038350. URL read (accepted manuscript): https://par.nsf.gov/servlets/purl/10621331
  - Siddik et al., p. 5: « Water consumption does not occur at the point of generation of hydroelectric facilities but upstream of the generation plant behind the dam where water is lost through evaporation from the reservoir surface. … we take a more balanced approach by using the primary purpose allocation method … assigns all evaporation to the primary dam purpose (e.g., hydropower, irrigation, flood control). »
  - So only reservoirs whose **primary** purpose is hydropower are counted. The report gives no separate numeric hydro share.
  - Arithmetic check (mine): 176 TWh × 4.52 L/kWh ≈ 796 billion L, matching "nearly 800".

### 6. Newer (2024–2026) national estimate of US data-centre water use? **No official one found**
- *United States Data Center Energy Usage Report: 2025 Update* (Smith et al., LBNL, published 18 June 2026, doi:10.71468/P1RP4F). URL read: https://escholarship.org/content/qt33m6w3x0/qt33m6w3x0.pdf
  - **Electricity only**: « The updated estimate of data center electricity use in 2024 is 192 terawatt-hours (TWh), accounting for 4.7% of total U.S. electricity consumption » (p. 8, "Total Energy Use").
  - It gives **no water estimate**. "Water" appears only as a future research need (p. 27).
- I found no DOE or EESI national water total newer than LBNL 2024.
- Not equivalent and not to be cited as a national consumption figure:
  - an arXiv preprint on public water systems (2603.02705), not peer-reviewed;
  - Ceres, which covers 7 States.
- **The LBNL Dec. 2024 values (66 / ~800 billion L, year 2023) remain the most recent national figures.**

---

## ELECTRICITY, world, TWh/year

### 7. Space cooling: ~2,111 TWh in 2022. **CONFIRMÉ at OWID; no IEA text in TWh found**
- URLs read:
  - CSV: https://ourworldindata.org/grapher/electricity-air-conditioning.csv
  - Metadata: https://ourworldindata.org/grapher/electricity-air-conditioning.metadata.json
- CSV row: `World,OWID_WRL,2022,2111`
- Chart: « Global electricity use for air conditioning »; subtitle « Electricity use for "space cooling", which includes fans but is mostly air conditioning ».
- Citation: « International Energy Agency (IEA). Buildings. – processed by Our World in Data ». Origin is the IEA Space cooling page, accessed 21 June 2024.
- The series rises in steps of 27.8 TWh (0.1 EJ), so OWID converted an IEA series published in EJ: 2,111 TWh = 7.6 EJ.
- The current IEA pages no longer show the chart, and the Wayback Machine was offline.
- IEA primary support (consistent, not the same number): *Space cooling* tracking report, 26 Sept. 2023, https://www.iea.org/reports/space-cooling-2. Its milestone table (raw HTML) reads « Share of space cooling in final electricity consumption 9% 7% 6% 5% » for 2022 / 2030 / 2035 / 2050.
- Cite as "AIE, via Our World in Data". Strictly, the IEA series is energy for space cooling, which is almost entirely electricity.

### 8. Data centres: 415 TWh (2024), 485 TWh (2025), 945 TWh (2030). **CONFIRMÉ, with one nuance on 2030**
- IEA, *Key Questions on Energy and AI* (16 Apr. 2026). URL read: https://www.iea.org/files/3179f7f8-01f6-4dd6-bffa-c9f7b73f1dc9/KeyQuestionsonEnergyandAI.pdf
  - Executive summary, p. 10: « Our updated projections see electricity consumption from data centres roughly doubling from 485 TWh in 2025 to 950 TWh in 2030, accounting for around 3% of global electricity demand by that date. »
  - Ch. 1, p. 24: « our Base Case still sees data centre electricity consumption growing from around 415 TWh in 2024 to around 950 TWh in 2030 ».
  - Annex tables A.1 (p. 108) and A.4 (World, Base Case): **2023: 360 | 2024: 416 | 2025: 485 | 2030: 945** TWh.
- IEA, *Energy and AI* (2025), executive summary, https://www.iea.org/reports/energy-and-ai/executive-summary:
  - « Data centres accounted for around 1.5% of the world's electricity consumption in 2024, or 415 terawatt-hours (TWh). »
  - « Data centre electricity consumption is set to more than double to around 945 TWh by 2030. »
- Nuance: the 2026 report's text rounds both ends. It says "around 415" for 2024 where Table A.4 gives 416, and "950" for 2030 where the table gives 945. The 2025 report says 415 and 945.
  - For 2030, use « ≈ 945 TWh (AIE 2025; table A.4, AIE 2026) » or « ≈ 950 TWh (AIE 2026, texte) ». Do not mix the two.
  - 2025 = 485 TWh is exact in both the text and the table.

### 9. Bitcoin: 138.2 TWh at 30 June 2024; 183 TWh at 31 Dec. 2024. **CONFIRMÉ**
- Source: CCAF, *Cambridge Digital Mining Industry Report*, April 2025. URL read: https://www.jbs.cam.ac.uk/wp-content/uploads/2025/04/2025-04-cambridge-digital-mining-industry-report.pdf
- Quotes (p. 63, "Electricity Consumption"):
  - « the annualised electricity consumption of the Bitcoin network is estimated at 138.2 TWh as of 30 June 2024 (see Figure 29), representing a 17% YoY increase … approximately 0.54% of the world's total annual electricity consumption. »
  - « By the end of December 2024, hardware efficiency improved to 23.7 J/TH, yet electricity consumption rose to 183 TWh due to a substantial increase in network hashrate, from 558.7 EH/s (30 June 2024) to 795.7 EH/s (31 December 2024). »
- Both are annualised rates at a point in time, not the energy actually used during a calendar year. The report also cites a « pre-halving all-time peak of 180 TWh in March 2024 ».

### 10. Québec: Hydro-Québec sales in Québec, 184.9 TWh in 2025. **CONFIRMÉ**
- Source: Hydro-Québec, *Rapport annuel 2025*. URL read: https://pannes.hydroquebec.com/data/documents-donnees/pdf/hq-rapport-annuel-2025-francais.pdf (official HQ domain).
- Quotes:
  - p. 22: « Les ventes d'électricité au Québec ont progressé de 7,7 TWh pour atteindre un niveau historique, soit 184,9 TWh »
  - p. 23, table « Ventes d'électricité au Québec par secteurs », Total 184,9 TWh: residential 74,7; commercial, institutional and small industrial 49,6; large industrial customers 54,0; other 6,6.
- Caveat: these are **Hydro-Québec's sales** in Québec, excluding exports. They are not, strictly, "total Québec consumption". *(Context, not verified here: some industrial self-generation, such as aluminium smelters' own plants, falls outside HQ's sales.)*

---

## ENERGY PER USE (Wh)

### 11. Gemini, median text prompt: 0.24 Wh. **CONFIRMÉ**
- Source: Elsworth et al. (Google), "Measuring the environmental impact of delivering AI at Google Scale", arXiv:2508.15734, v1 21 Aug. 2025. URL read: https://arxiv.org/pdf/2508.15734v1
- Quotes:
  - Abstract: « we find the median Gemini Apps text prompt consumes 0.24 Wh of energy ».
  - §4.1: « the median energy consumption for a Gemini Apps text prompt in May 2025 is 0.24 Wh ».
  - Table 1: accelerators 0.14 + CPU/DRAM 0.06 + idle 0.02 + overhead 0.02 = 0.24 Wh.
- Scope: this is a median, not an average. It includes idle machines and data-centre overhead. It excludes external networking and the user's device. The narrower "existing approach" gives 0.10 Wh.

### 12. ChatGPT, average query: 0.34 Wh. **CONFIRMÉ** (unaudited claim)
- Source: Sam Altman, "The Gentle Singularity", blog, posted 10 June 2025 (Posthaven timestamp 1749589967). URL read: https://blog.samaltman.com/the-gentle-singularity
- Quote: « the average query uses about 0.34 watt-hours, about what an oven would use in a little over one second … It also uses about 0.000085 gallons of water ».
- No method, model or query definition is given.

### 13. Epoch AI: ≈ 0.3 Wh per GPT-4o query. **CONFIRMÉ**
- Source: Josh You, "How much energy does ChatGPT use?", Epoch AI *Gradient Updates*, 7 Feb. 2025. URL read: https://epoch.ai/gradient-updates/how-much-energy-does-chatgpt-use
- Quote (raw HTML): « We find that typical ChatGPT queries using GPT-4o likely consume roughly 0.3 watt-hours, which is ten times less than the older estimate. » Metadata: datePublished 2025-02-07; author Josh You.
- This is an estimate, not a measurement. Assumptions: 500 output tokens, about 100 billion active parameters, H100 GPUs.

### 14. Microsoft, arXiv 2509.20241 v2: 0.31 Wh typical, 3.91 Wh long query, overstatement 4–20×. **CONFIRMÉ** (adjust the label)
- Source: Oviedo et al. (Microsoft), "Energy Use of AI Inference, Efficiency Pathways, and Test-Time Scaling". v1 24 Sept. 2025; **v2 9 June 2026**. URL read: https://arxiv.org/pdf/2509.20241v2
- Quote (Summary, p. 1): « For frontier-scale models (>200B parameters) on H100 nodes, we estimate a median energy of 0.31 Wh/query (IQR 0.16–0.60), indicating widely cited estimates are overstated by 4–20×. In test-time scaling scenarios 15× longer than typical queries, the median energy rises 13× to 3.91 Wh (IQR 2.15–7.05). »
- Same page: « many public estimates assume non-production settings, leading to systematic overestimation ».
- Conclusions: « Energy estimates or measurements based on small-scale or non-optimized deployments overestimate the energy use of inference by 4–20×. »
- Nuances:
  - The paper does not say "reasoning query". It says "test-time scaling scenarios 15× longer than typical queries" (long reasoning). « Requête de raisonnement longue » is an acceptable paraphrase.
  - Both values are modelled medians, not measurements.

### 15. MIT Technology Review (20 May 2025): image 2,282 J, video ~3.4 MJ. **CONFIRMÉ** (specify the conditions)
- Source: James O'Donnell & Casey Crownhart, "We did the math on AI's energy footprint. Here's the story you haven't heard." URL read: https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/
- Image quote: « Generating a standard-quality image (1024 x 1024 pixels) with Stable Diffusion 3 Medium … requires about 1,141 joules of GPU energy … That means an estimated 2,282 joules total. Improving the image quality by doubling the number diffusion steps to 50 just about doubles the energy required, to about 4,402 joules. »
  - 2,282 J is GPU energy × 2 to cover overhead, for a standard-quality image. It is about 0.63 Wh.
- Video quote: « The new model uses more than 30 times more energy on each 5-second video: about 3.4 million joules, more than 700 times the energy required to generate a high-quality image. This is equivalent to riding 38 miles on an e-bike, or running a microwave for over an hour. »
  - This is CogVideoX at 16 frames per second, measured by S. Luccioni with Code Carbon. The article does not say whether the ×2 overhead factor applies.
  - 3.4 MJ ≈ 944 Wh ≈ 0.94 kWh.

### 16. IEA commentary (2020), "The carbon footprint of streaming video". **CONFIRMÉ**
- Source: George Kamiya, IEA commentary, 10 Dec. 2020 (originally published in Carbon Brief). URL read: https://www.iea.org/commentaries/the-carbon-footprint-of-streaming-video-fact-checking-the-headlines
- Quotes:
  - « streaming a Netflix video in 2019 typically consumed around 0.077 kWh of electricity per hour »
  - « Streaming an hour-long SD video through a phone on WiFi (Scenario C) uses just 0.037 kWh »
  - « Based on average viewing habits, my updated analysis shows that viewing devices account for the majority of energy use (72%), followed by data transmission (23%) and data centres (5%). »
- Note: the 72 / 23 / 5 split applies to the average viewing mix, about 70% on TVs. For the phone case, transmission is « more than 80% » of the total.

---

## Summary table

| # | Figure | Verdict | Value to use | Source to cite (short) |
|---|---|---|---|---|
| 1 | Crop irrigation, consumptive use | CONFIRMÉ | 78,400 Mgal/d (≈ 108,000 billion L/yr); CONUS, water year 2020, crops only, golf excluded | USGS PP 1894-D (2025), p. 26 |
| 2 | Thermoelectric, consumptive use | CONFIRMÉ | 2,382 Mgal/d (≈ 3,290 billion L/yr); CONUS, 2020 | USGS PP 1894-D, p. 31 |
| 3 | Golf, applied irrigation | CONFIRMÉ | 1.63 million acre-feet in 2024 (≈ 2,010 billion L); *applied*, not consumptive | GCSAA, 30 Dec. 2025; Shaddox et al., *HortTechnology* 35(5) |
| 4 | Data centres, direct water | CONFIRMÉ | 66 billion L (2023) | LBNL, Shehabi et al. 2024, p. 55 |
| 5 | Data centres, indirect water | CONFIRMÉ | "nearly 800 billion L" (2023); includes hydro-reservoir evaporation (primary-purpose allocation) | LBNL 2024, p. 57 |
| 6 | Newer US water estimate | None found | Keep LBNL 2024; the 2025 update (June 2026) covers electricity only (192 TWh in 2024) | LBNL 2025 Update |
| 7 | Space cooling, world | CONFIRMÉ (secondary) | ≈ 2,111 TWh (2022); IEA: 9% of final electricity in 2022 | IEA via OWID; IEA *Space cooling* |
| 8 | Data centres, world | CONFIRMÉ | 415 TWh (2024; Table A.4 2026: 416); 485 TWh (2025); ≈ 945 TWh in 2030 (2026 text: "950") | IEA *Energy and AI* 2025; IEA *Key Questions* 2026, p. 10 and Table A.4 |
| 9 | Bitcoin | CONFIRMÉ | 138.2 TWh annualised (30 June 2024); 183 TWh annualised (31 Dec. 2024) | CCAF, *Digital Mining Industry Report* 2025, p. 63 |
| 10 | Hydro-Québec sales in Québec | CONFIRMÉ | 184.9 TWh (2025), HQ sales, not total consumption | HQ, *Rapport annuel 2025*, pp. 22–23 |
| 11 | Gemini text prompt | CONFIRMÉ | 0.24 Wh (median, May 2025) | Elsworth et al., arXiv 2508.15734 |
| 12 | ChatGPT query | CONFIRMÉ (company claim) | 0.34 Wh (average, no method given) | Altman, blog, 10 June 2025 |
| 13 | GPT-4o query (Epoch) | CONFIRMÉ | ≈ 0.3 Wh (estimate, 500 tokens) | Epoch AI, J. You, 7 Feb. 2025 |
| 14 | Microsoft, inference | CONFIRMÉ | 0.31 Wh typical; 3.91 Wh for a query 15× longer ("test-time scaling"); non-production setups overstate by 4–20× | Oviedo et al., arXiv 2509.20241 v2 (June 2026) |
| 15 | Image / video | CONFIRMÉ | Image: 2,282 J ≈ 0.63 Wh (SD3 Medium, 1024², standard quality; 4,402 J at 50 steps). Video: ≈ 3.4 MJ ≈ 0.94 kWh (CogVideoX, 5 s) | MIT Technology Review, 20 May 2025 |
| 16 | Streaming | CONFIRMÉ | 0.077 kWh/h (2019); 0.037 kWh/h (SD, phone on WiFi); 72 / 23 / 5% devices / network / data centres | IEA commentary, Kamiya, 10 Dec. 2020 |
