#! /usr/bin/python
import os.path, time

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
    """User select a value in the list"""
    for value in list:
        print(colors.CLEAR+colors.HEADER+message+colors.ENDC)
        print(str(list))
        print(colors.BREVERSE+"--"+str(value)+"--"+colors.ENDC)
        answer = raw_input()
        print(colors.CLEAR)
        if answer == "y":
            return str(value)
    return select_val(list,message)

def print_file(path, nb_lines_printed=5):
    print(colors.CLEAR)
    """Display the content of a file"""
    my_file = open(path,'r')
    content = my_file.read()
    content = content.split("\n")
    i = 0
    answer="y"
    print(colors.BREVERSE+"press y to continue, n to stop to read"+colors.ENDC)
    while i < len(content) and answer != "n":
        print("\n".join([lines for lines in content[i:(i+nb_lines_printed)]]))
        answer = raw_input()
        #come back from lines delete it and come back again
        print("\033[1A\033[K\033[1A")
        i += nb_lines_printed

def dns_get_parser(path_src, path_dst="result/scanNetwork/dns_http_sniffed_proper.txt"):
    my_file = open(path_src,"r")
    output = open(path_dst, "w")
    dns_res = [ligne.split(" ") for ligne in my_file if "DNS" in ligne or "GET" in ligne and ".css" not in ligne and".js" not in ligne]
    version = 2.45 #2.4.5 #1.12
    for packets in dns_res:
    	packet = [ clean for clean in packets if clean!=""]
    	if version > 2:
    		if "DNS" in packet:
    			#packet[3]=time packet[4]=src packet[6]=dst packet[7]=type packet[13]=content
    			output.write(packet[4]+" "+packet[7]+" "+packet[13]+"\n")
    		else:
    			#packet[3]==time packet[4]==src packet[6]==dst packet[7]==type packet[10]==content
    			output.write(packet[4]+" "+packet[7]+" "+packet[10]+"\n")
    	else:
    		if "DNS" in packet:
    			#packet[2]=time packet[3]=src packet[5]=dst packet[6]=type packet[12]=content
    			output.write(packet[3]+" "+packet[6]+" "+packet[12]+"\n")
    		else:
    			#packet[2]==time packet[3]==src packet[5]==dst packet[6]==type packet[9]==content
    			output.write(packet[3]+" "+packet[6]+" "+packet[9]+"\n")

def recent_file(path, limit_time=300):
    try:
        (mode, ino, dev, nlink, uid, gid, size, atime, mtime, ctime) = os.stat(path)
        if time.time() - ctime < limit_time:
            return True
        else:
            return False
    except OSError:
        return False

def open_file(path,rwa):
    try:
        output = open(path,rwa)
        return output
    except IOError:
        print(colors.FAIL+"\nWe can't save the result"+colors.ENDC)
        print(colors.WARNING+"May be the directory doesn't exist")
        print("But it's pretty sure your output path is wrong"+colors.ENDC)
        print(colors.HEADER+"Use -o 'your_path' to change the output"+colors.ENDC)
        print("\n\n\t"+colors.FAIL+"Failed."+colors.ENDC+" Press a button to quit")
        return -1
    except:
        print(+colors.FAIL+"A problem occured"+colors.ENDC)
    return -1
