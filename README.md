# 2022_group14_final_project
Repository for project for group 14

# Introduction

Welcome to Group 14’s Final R project repository page. 
By means of this Readme section, we would like to familiarize you with the What, Why, and How of our R project.
Below are the main points of information that will make it easy for you to understand it.

# Analysis of Proteomes Data for Breast Cancer

Our project objective was to find, collect, clean, analyze and model a particular dataset (huge!) of our interest from open source websites like Kaggle.com. 
The data we used came originally from the Clinical Proteomic Tumor Analysis Consortium (NCI/NIH).

# Know our data

We primarily had three sets of data:

1. Clinical data: included the clinical information for 77 patients, for example their cancer stage, number of tumors, HER2 status, ER-status, PR-status and such like
2. Proteomes profiling data: included log2(iTRAQ) values for more than 12,000 (12,5553 to be precise) proteins for 83 individuals including both patients and healthy people.
3. PAM50 data: included gene symbols and names of the proteins

# Our analysis

We started out with taking a manual overview of what the datasets included. We moderated our steps in line with questions like: What kind of information was given in the datasets?
Are any of the columns or rows related by common characters, names, etc.? Are there NA values?

Once the initial observation was satisfactory, we moved on to the tidying up stage followed by joining of datasets.
With one single set of clean data, it was a matter of putting the right plots in place.
We performed graphical analysis of different variables, followed by PCA and k-means clustering.

Our entire project journey also included considerations for various comparisons as well as practical applicability of our work, for example:
1. How different is the data for healthy individuals from unhealthy individuals? 
2. Can we target unhealthy individuals with specific different medicines in line with which k-means cluster they are a part of?

Thank you so much for reading through!

# Project contributors

s174584, s184338, s184284, and s220868
