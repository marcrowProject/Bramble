 #include "wifi.h"

using namespace std;

int mac_regex(const std::string mac){
    //[a-fA-F0-9:]{17} all hexa value in a string of 17 char
    regex rMac("[a-fA-F0-9:]{17}");
    if(std::regex_match(mac,rMac)){
        return true;
    }
    return false;
}

int verify_interface(string interface){
    struct ifaddrs *ifap, *ifa;
    char *addr;
    getifaddrs (&ifap);
    for (ifa = ifap; ifa; ifa = ifa->ifa_next) {
        if (ifa->ifa_addr->sa_family==AF_INET) {
		std::cout << ifa->ifa_name << '\n';
            if(strcmp(interface.c_str(),ifa->ifa_name)==0){
                freeifaddrs(ifap);
                return 0;
            }
        }
    }
    freeifaddrs(ifap);
    return -1;
}

inline bool file_exist(const std::string& name) {
    if (FILE *file = fopen(name.c_str(), "r")) {
        fclose(file);
        return true;
    } else {
        return false;
    }
}

//use to have a backup
void copy_file(const std::string src,const std::string dst){
    std::fstream wifiFile;
    std::ofstream backup;
    std::string line;
    wifiFile.open(src, ios::in | ios::app);
    backup.open(dst, ios::in | ios::trunc);
    while(getline(wifiFile,line)){
	backup << line << endl;
    }
    wifiFile.close();
    backup.close();
}

int add_supplicant(const std::string essid, const std::string mac, const std::string pass, const std::string path){
    std::ofstream wpa_sup;
    wpa_sup.open(path, ios::in | ios::trunc);
    if(wpa_sup.is_open()){
        wpa_sup << "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" << "\n";
        wpa_sup << "update_config=1" << "\n";
        wpa_sup << "network={" << "\n";
        wpa_sup << "ssid=\""+essid+"\"" << "\n";
        wpa_sup << "bssid="+mac << "\n";
        wpa_sup << "psk=\""+pass <<"\"\n";
        wpa_sup << "}";
    }
    else{
        std::cerr << "Unable to create wpa_supplicant_"+mac+".conf"<< '\n';
        return -1;
    }
    wpa_sup.close();
    return 0;
}

int change_wifi(const std::string interface, const std::string path){
    std::fstream wifiFile;
    std::ofstream configFile;
    std::string line, someString;
    int wifiSection=0;
    int lineExist=false;

    copy_file("/etc/network/interfaces","/etc/network/interfaces-old");
    wifiFile.open("/etc/network/interfaces-old", ios::in);
    configFile.open("/etc/network/interfaces", ios::in | ios::trunc);

    if(wifiFile.is_open() && configFile.is_open()){
        while(getline(wifiFile,line)){
            if(line.find("iface "+interface+" inet") != string::npos){
                wifiSection=1;
                lineExist=true;
                configFile << line << "\n";
                configFile << "wpa-conf "+path << '\n';
                continue;
            }
            else if (wifiSection==1) {
                wifiSection=0;
            }
            else{
                configFile << line << "\n";
            }
        } //end while
        if(!lineExist){
	    configFile << line << "\n";
	    configFile << "allow-hotplug "+interface << "\n";
            configFile << "iface "+interface+" inet dhcp" << "\n";
            configFile << "wpa-conf "+path << '\n';
        }
    } //end if
    else{
        std::cerr << "Plroblem with the opening of /etc/network/interfaces or /etc/network/interfaces-old" << '\n';
        return -1;
    }
    wifiFile.close();
    configFile.close();
    return 0;
}




int main(int argc, char ** argv)
{
    if(argc<5){
        std::cerr << "Some paramaters are missing:";
        std::cerr << "Please specify the interface used, the essid, the bssid of the access point the password" << '\n';
        return -1;
    }
    std::string interface = argv[1];
    std::string essid = argv[2];
    std::string mac = argv[3];
    std::string pass = argv[4];

        std::cout <<" int :"+ interface <<'\n';
        std::cout <<" essid :"+ essid <<'\n';
        std::cout <<" mac :"+ mac <<'\n';
        std::cout <<" pass :"+ pass <<'\n';

//    return 0;

/*    int valid_int = verify_interface(interface);
    if(valid_int!=0) {
        std::cout << "Interface Invalide " << '\n';
        return -4;
    }*/

    if (mac_regex(mac)){
        //creates the configuration file to connect to the appropriate wifi
        std::string path="/etc/wpa_supplicant/wpa_supplicant_"+mac+".conf";
        if(add_supplicant(essid, mac, pass, path)==-1){
            return -2;
        }
        if(change_wifi(interface, path)==-1){
            return -3;
        }
    }
    else {
        std::cerr << "Error Invalid format of Mac address" << '\n';
    }
    return 0;
}
