#include <iostream>
#include <string>
#include <thread>         // std::this_thread::sleep_for
#include <chrono>         // std::chrono::seconds
#include <fstream>
#include <map>





#include "tools.h"


int welcome() {
    printf ("\33[H\33[2J");
    std::cout << std::endl
	<< "brambleBrambleBRambleBRAmbleBRAMbleBRAMBle" << std::endl
	<< std::endl
	<< "99999                         9    999" << std::endl
	<< "99   9                        9    99" << std::endl
	<< "9  99   9999 69999    9999999 999  9  9999" << std::endl
	<< "99   9  9   9    9    9  9  9 9  9 9  99" << std::endl
	<< "99999   9   996 6996  9  9  9 999  9  9999" << std::endl
	<< std::endl
	<< "brambleBrambleBRambleBRAmbleBRAMbleBRAMBle" << std::endl;
	std::this_thread::sleep_for (std::chrono::seconds(1));
    printf ("\33[H\33[2J");
    std::cout << "/* message */" << '\n';
    printf ("\33[H\33[2J");
    std::cout << "\nHello welcome to Bramble !" <<'\n';
	std::cout << "Disclaimer : This tool are designed to\naid aspiring security enthusiast in \nlearning new skills.";
	std::cout << " We only recommend\ntesting this tool on a system that belongs\n";
	std::cout <<"to -You-.We do not accept responsibity for\nanyone who thinks it's a good idea to try\n";
	std::cout <<"to use this to attemps to hack systems\nthat do not belong to you.\n";
    std::cout <<"If you understanding press y to continue : ";
    std::string ans;
    std::cin>>ans;
    if(ans.compare("y")==0) {
        printf ("\33[H\33[2J");
        std::cout << "Here we go !" << std::endl;
        printf ("\33[H\33[2J");
        return 0;
    }
    else {
        printf ("\33[H\33[2J");
        std::cout << "If you don't understand you can't use\nBramble application :( do you want to exit? y/n";
        std::cin>>ans;
        if(ans.compare("y")==0) {
            printf ("\33[H\33[2J");
            std::cout << "\nOhhm so goodbye..." << std::endl;
            return -1;
        }
        else {
            int val=welcome();
            return val;
        }
    }
}


int main(int argc, char ** argv)
{
    //handler to stop CTRL-C
    //to comment when you code
    signal(SIGINT, &sighandler);

    //set to full screen
    //usefull when u have a regular use of bramble but it's execrable when you coding
    //char *arg[]= { "wmctrl", "-r", ":ACTIVE:", "-b", "toggle,fullscreen", NULL };

   	//launch(arg,"/usr/bin/wmctrl");

    int strt, tmp;
    std::map<std::string,std::string> menu;
    strt=welcome();

    if(strt==-1) {
        return 0;
    }


    while (1) {
        strt=loadMenu(menu,"conf/menu.txt");
        if(strt==-2) return -2;
        tmp=displayMenu(menu);
        if(tmp==1) return 0;
    }


    return 0;

}


/*
brambleBrambleBRambleBRAmbleBRAMbleBRAMBleBRA

  99999                         9    999
  99   9                        9    99
  9  99   9999 69999    9999999 999  9  9999
  99   9  9   9    9    9  9  9 9  9 9  99
  99999   9   996 6996  9  9  9 999  9  9999

brambleBrambleBRambleBRAmbleBRAMbleBRAMBleBRA
*/
