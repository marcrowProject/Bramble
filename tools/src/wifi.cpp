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

inline bool file_exist(const std::string& name) {
    if (FILE *file = fopen(name.c_str(), "r")) {
        fclose(file);
        return true;
    } else {
        return false;
    }
}

//use to have a backup
int copy_file(const std::string src,const std::string dst){
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

int add_supplicant(const std::string mac, const std::string pass, const std::string path){
    std::ofstream wpa_sup;
    wpa_sup.open(path, ios::in | ios::trunc);
    if(wpa_sup.is_open()){
        wpa_sup << "network={" << "\n";
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

int change_wifi(std::string interface, std::string mac, std::string pass, const std::string path){
    std::fstream wifiFile;
    std::ofstream configFile;
    std::string line, someString;
    int wifiSection=0;
    int lineExist=false;

    copy_file("/etc/network/interfaces","/etc/network/interfaces-old");
    wifiFile.open("/etc/network/interfaces-old", ios::in | ios::app);
    configFile.open("/etc/network/interfaces", ios::in | ios::trunc);

    if(wifiFile.is_open() && configFile.is_open()){
        while(getline(wifiFile,line)){
            if(line.find("iface "+interface+" inet dhcp") != string::npos){
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
            configFile << "iface "+interface+" inet dhcp" << "\n";
            configFile << line << "\n";
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
    if(argc<4){
        std::cerr << "Some paramaters are missing:";
        std::cerr << "Please specify the interface used, the bssid of the access point and the password" << '\n';
        return -1;
    }
    std::string interface = argv[1];
    std::string mac = argv[2];
    std::string pass = argv[3];
    if (mac_regex(mac)){
        std::string path="/etc/wpa_supplicant/wpa_supplicant_"+mac+".conf";
        if(add_supplicant(mac, pass, path)==-1){
            return -2;
        }
        if(change_wifi(interface,mac,pass,path)==-1){
            return -3;
        }
    }
    else {
        std::cerr << "Error Invalid format of Mac address" << '\n';
    }
    return 0;
}
