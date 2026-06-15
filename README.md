# Assignment properties from Petr Tureček Bayesian Stat Course

Because we claim that to be able to analyse your data the Bayesian way, you must be able to generate the data you would like to collect, your task is to:

1. Generate data from your dream experiment (we will appreciate if the total number of parameters to do this is 4 or more, but if you convince us that your dream experiment really is of the complexity of ice cream stant profits in response to temperature - 3 parameters, a, b, sigma - we will accept also a simpler system)
2. Do a basic visualization to convince us that your data generating process works.
It is great if you complete the assignment as an R markdown document that will allow you to combine text, latex equations (if needed), code and results of the code. Learning to make R markdown files is easy - just click File-New File-R Markdown, the thing itself tries to teach you how to do it. Try to click the Knit button and the plain text is converted into a decent html or pdf file. You can, of course, consult any online tutorials or chatbots (Just submit a file that you are able to take full responsibility for. If the code is too different from the one used in our course - e.g. when it uses too much tidyverse that we avoided - we might be a little bit sour, because we might interpret this as just going with the AI slop flow.)

So that is it. Optionally, if you want feedback on your analysis or on your prior choice etc. you can

3. Add a block that will demonstrate (preferably with an ulam function) that you can extract the same parameter values that you baked in from that generated data. You will see that after generating the data properly, this step comes almost for free, so we encourage you to do this.

**Some people asked me this: If you already have your dream data (collected, for instance, within work on your diploma or research in general) it is fine to start with loading the empirical data and analysing them the Bayesian way. So, just submitting a high-quality version of 3 is also a passable strategy.**

# My topic: Bayesian Analysis of Syntopy

Following the framework of Remeš and Harmáčková (2023), this assignment simulates and analyses local co-occurrence (syntopy) among sister species of birds..

Assignment Goals

1. Generate dream syntopy data for both scales (routes and stops).
2. Visualise and explore generated data.
3. Fit models for both scales using the ulam() function and compare the estimates with true values.

 Newbury, Arthur. 2025. “Bayesian Estimation of Co-Occurrence Affinity with Dyadic Regression.” bioRxiv, ahead of print. https://doi.org/10.1101/2024.01.16.575941.
Remeš, Vladimír, and Lenka Harmáčková. 2023. “Resource Use Divergence Facilitates the Evolution of Secondary Syntopy in a Continental Radiation of Songbirds (Meliphagoidea): Insights from Unbiased Co-Occurrence Analyses.” Ecography 2023 (2): e06268. https://doi.org/10.1111/ecog.06268.
