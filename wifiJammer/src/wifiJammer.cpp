#include "wifiJammer.h"


int main(int argc, char ** argv)
{
    int strt=0;
    printf ("\33[H\33[2J");
    if(argc<2) {
        std::map<std::string,std::string> menu;
        strt=loadMenu(menu,"wifiJammer/conf/menu.txt");
        if(strt==-2) {
            printf ("\33[H\33[2J");
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }

    if (strcmp(argv[1],"-d")==0) {
      char *arg[]= { "sudo", "python", "./python/arpSpoofer.py", "-d", NULL };
      launch(arg,"/usr/bin/sudo");
    }

}
