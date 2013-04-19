################################################################################
# Written by Martina Maggio
# This python class is part of the APRE development
################################################################################

from parameter import Parameter

class Command:
  def __init__(self, plist, command):
    self.plist = plist
    self.command = command

  def __str__(self):
    p = "  " + "\n  ".join(str(x) for x in self.plist)
    return self.command + "\nParameters: \n" + p		
