###############
# Use the data in covid.csv for this exercise
#
# 10) In a separate file, write a piece of code that
# loads the covid.csv file and prints the list of countries
#  and the total average of death/confirmed among those countries
# for those countries that have more than 500, 1000 and 5000
# respectively.
# Follow DRY principles in order to complete this exercise.
#
#
# #

import os
os.chdir('G:/Mi unidad/Classroom/21DM004 Computing for Data Science 21-22 DSDM T1/dbases')
import pandas as pd
mydf = pd.read_csv("covid.csv")

for nvar in ['Deaths', 'Confirmed']:
    for lbound in [500,1000,5000]:
        selected = mydf[nvar] > lbound
        aval = mydf[selected][nvar].mean()
        print('The average of ' + nvar + ' greater than ' + str(lbound) + " is: " + str(aval))
        print(mydf[selected][['Country', nvar]])


