# Moon cycle and sleep

This is a simple script to read data from an Oura ring json export and plot it against the moon cycle phase, based on what is shown in "Moonstruck sleep: Synchronization of human sleep with the moon cycle under field conditions", Casiraghi et al (link here: https://advances.sciencemag.org/content/7/5/eabe0465.full)

The paper reports a later bedtime in different cohorts during nights of full moon (living with or without electricity, including a modern urban enviroment), hence in this script I plot bedtime as derived from Oura's data against the moon cycle (sleep duration seems to be affected by a lesser degree, as the change is mostly due to bedtime changes, while wakeup time remains more stable)

# Usage
Get the code, then create a 'data' folder, at the same level as the already present 'figures' folder. Put your Oura ring data in there. You can get your Oura ring data by loggin in at Oura Cloud and then downloading the JSON including all your data

Rename the file to oura.json and put it in the data folder, then run the script
 
# Example
Here is my own data, which seems to show some sort of cyclic pattern. Obviously there are many factors at play:

![alt text](https://www.marcoaltini.com/uploads/1/3/2/3/13234002/screenshot-2021-01-28-at-15-23-30_orig.png)

Interestingly, my data is quite consistent with the finding, despite never thinking about this before reading the paper. See below how bedtime seems to happen a bit later only around a full moon:

![alt text](https://www.marcoaltini.com/uploads/1/3/2/3/13234002/screenshot-2021-01-28-at-15-23-20_orig.png)
