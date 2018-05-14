#include "sniffer.h"


int main(int argc, char ** argv)
{
    signal(SIGINT, &sighandler);
    int strt=0;
    printf ("\33[H\33[2J");
    if(argc<2) {
        std::map<std::string,std::string> menu;
        strt=loadMenu(menu,"sniffer/conf/menu.txt");
        if(strt==-2) {
            printf ("\33[H\33[2J");
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }


    if (strcmp(argv[1],"-dns")==0) {
      char *arg[]= { "sudo", "python", "./python/sniffer.py", NULL };
      launch(arg,"/usr/bin/sudo");
    }

    if (strcmp(argv[1],"-reader")==0) {
      char *arg[]= { "python", "./python/reader.py", NULL };
      launch(arg,"/usr/bin/python2.7");
    }




}
