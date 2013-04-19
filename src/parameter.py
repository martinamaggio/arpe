################################################################################
# Written by Martina Maggio
# This python class is part of the APRE development
################################################################################

class Parameter:
  def __init__(self, name, values):
    self.name = name
    self.values = sorted(values)

  def __str__(self):
    v = ": [" + ", ".join( str(x) for x in self.values) + "]"
    return self.name + v
