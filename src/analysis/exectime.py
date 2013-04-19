################################################################################
# Written by Martina Maggio
# This python class is part of the APRE development
################################################################################

import numpy as np
import statsmodels.api as sm

# read the timed.txt files produced by the shell script
def read_timed():
  import csv
  filetimes = open("timed.txt") # name for the times
  reader = csv.reader(filetimes, delimiter=" ") # delimited by spaces
  data = list()
  for row in reader:
    data.append(row)
  return data

# fits a linear model with statsmodel
def fitting_model(parameters, effect):
  X = np.array(parameters, dtype=float)
  X = sm.add_constant(X, prepend=False)
  Y = np.array(effect, dtype=float)
  model = sm.OLS(Y,X).fit()
  print model.summary()
  return model

def main():
  # timevalued contains a list
  timevalues = read_timed()
  # get the parameter list, and the times
  real_times = [x[0] for x in timevalues]
  user_times = [x[1] for x in timevalues]
  system_times = [x[2] for x in timevalues]
  parameters = [x[3:] for x in timevalues]
  # linear model identification part normal
  real_times_model = fitting_model(parameters, real_times)
  user_times_model = fitting_model(parameters, user_times)
  system_times_model = fitting_model(parameters, system_times)
  # here it is possible to add different combinations of the parameters
  # as an example, one can build a linear model between the product of
  # all the parameters and the real execution time as follows:
  # parameters_product = []
  # for i in range(len(parameters)):
  #   parameters_product.append(reduce(lambda x, y: 
  #   x*y, np.array(parameters[i], dtype=float)))
  # real_times_model = fitting_model(parameters_product, real_times)
  
if __name__ == "__main__":
  main()