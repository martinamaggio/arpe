################################################################################
# Written by Martina Maggio
# This python class is part of the APRE development
################################################################################

import itertools
from parameter import Parameter
from command import Command

def main():
  ### User input part:
  iterations = int(raw_input("Number of iterations: "))
  string_command = str(raw_input("Command to be executed: \n"))
  parameters = int(raw_input("Number of parameters: "))
  parameter_list = list()
  for par in range(0, parameters):
    print "Parameter " + str(par)
    par_name = str(raw_input("  Enter name: "))
    par_values = str(raw_input("  Enter values (space separated): "))
    par_listval = map(str, par_values.split())
    parameter_list.append(Parameter(par_name, par_listval))

  ### Initializing structures:
  cmd = Command(parameter_list, string_command)
  list_of_values = [cmd.plist[i].values for i in range(len(cmd.plist))]

  ### Writing script file:
  file_script=open('./execute.bash', 'w+')
  print >> file_script, "rm -rf results"
  print >> file_script, "mkdir results"
  for element in itertools.product(*list_of_values):
    cmd_line = cmd.command # Starting from initial command
    par_spaced = str(element).replace("(","").replace(")","")
    par_spaced = par_spaced.replace("'","").replace(",","")
    par_string = par_spaced.replace(" ", "-")
    print >> file_script, "mkdir results/" + par_string
    for i in range(0, len(cmd.plist)):
      cmd_line = cmd_line.replace(cmd.plist[i].name, element[i])
    print >> file_script, "for i in `seq 1 " + str(iterations) + "`; do"
    print >> file_script, '  ./before.bash'
    print >> file_script, '  export CMD_EXECUTED="' + cmd_line + '"'
    print >> file_script, '  export PAR_SPACED="' + par_spaced + '"'
    print >> file_script, "  (time -p " + cmd_line + " >/dev/null 2>/dev/null) 2>&1 | awk '{print $2 $4 $6}' > timed &"
    print >> file_script, '  ./after.bash'
    print >> file_script, "  mkdir results/" + par_string + "/${i}"
    print >> file_script, "  mv APRE_* results/" + par_string + "/${i}"
    print >> file_script, "done"

if __name__ == "__main__":
  main()
