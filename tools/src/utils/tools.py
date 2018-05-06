#! /usr/bin/python


class colors: #Add colors in terminal
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'        #Come back to the initial color
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    BREVERSE = '\033[7;1m'  #Used to put in the light the current item
    CLEAR = "\033[H\033[2J" #Clear the screen

def write_arp_scan_result(res_list,output="./result/scanNetwork/scanARP"):
    try:
        my_file = open(output, "w")
    except IOError:
        print(colors.FAIL+"\nWe can't save the result in "+my_output+colors.ENDC)
        print(colors.WARNING+"May be the directory doesn't exist")
        print("But it's pretty sure your output path is wrong"+colors.ENDC)
        print(colors.HEADER+"Use -o 'your_path' to change the output"+colors.ENDC)
        print("\n\n\t"+colors.FAIL+"Failed."+colors.ENDC+" Press a button to quit")
        return
    except:
        print(+colors.FAIL+"A problem occured"+colors.ENDC)
        return
    for ip in res_list:
        my_file.write(ip)
        my_file.write("\n")
    my_file.close()

def select_val(list, message="Please make a choice:"):
    for value in list:
        print(message)
        print(str(list))
        print(colors.BREVERSE+"--"+str(value)+"--"+colors.ENDC)
        answer = raw_input()
        print(colors.CLEAR)
        if answer == "y":
            return str(value)
    return select_val(list,message)
