#include "option.h"


int main(int argc, char ** argv)
{
    int strt=0;
    printf ("\33[H\33[2J");
    if(argc<2) {
        std::ifstream lvl("conf/lvl", std::ios::in);
        std::string line;
        if(lvl)
          getline(lvl, line);
        else
          line = "0";
        std::map<std::string,std::string> menu;
        if(line=="0")
          strt=loadMenu(menu,"option/conf/menu.txt");
        else
          strt=loadMenu(menu,"option/conf/menu_beginner.txt");
        if(strt==-2) {
            printf ("\33[H\33[2J");
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }
}
