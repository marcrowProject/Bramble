#!/usr/bin/python

from utils.tools import *
import os

print(colors.CLEAR)
type_list = ["website's names", "passwords", "devices", "custom"]
file_name_list = ["dns_http_sniffed_proper.txt",
            "password_sniffed_proper.txt",
            "scan.txt",
            "custom_sniffed.txt"]
answer = "n"
i=-1
file_not_found = colors.FAIL + " X "+colors.ENDC
file_found = colors.OKGREEN + " V "+colors.ENDC
while answer != "y":
    i = (i+1)%len(type_list)
    print("What do you want to see ?")
    exist = file_not_found
    for f in (f for f in os.listdir("./result/scanNetwork") if f==file_name_list[i]):
        exist = file_found
    print(colors.BREVERSE+type_list[i]+colors.ENDC+exist)
    print("\n".join([lines for lines in type_list[i+1:len(type_list)]]))
    answer = raw_input()

    if answer == "y" and exist == file_not_found:
        print(colors.CLEAR+colors.FAIL+\
        "We cannot find any files of "+type_list[i]+colors.ENDC+\
        "\nthe symbol "+file_not_found+" means no file has been found \n"+\
        "and "+file_found+" means at least one file has been found \n\n"+\
        "Do you want to leave y/n")
        answer = raw_input()
        if answer == "y":
            exit()

    #come back from lines delete it and come back again
    print(colors.CLEAR)

print_file("./result/scanNetwork/"+file_name_list[i],10)
