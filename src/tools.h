#ifndef TOOLS_H
#define TOOLS_H

#include <fstream>
#include <map>
#include <iostream>
#include <string>
#include <cstring>
#include <stdlib.h>
#include <dirent.h> //read folder
#include <vector>
/* for fork() */
#include <unistd.h>
/* for perror() and errno */
#include <errno.h>
/* for pid_t */
#include <sys/types.h>

#include <sys/wait.h>

//clear screen
#define clrscr() printf("\033[H\033[2J")

//change the color in the terminal
#define color(arg) printf("\033[%sm",arg)
/*
with arg as const char *
color("30");
std::cout << "30 black" << '\n';
color("31");
std::cout << "31 red" << '\n';
color("32");
std::cout << "32 green" << '\n';
color("33");
std::cout << "33 yellow" << '\n';
color("34");
std::cout << "33 blue" << '\n';
color("35");
std::cout << "35 magenta" << '\n';
color("36");
std::cout << "36 cyan" << '\n';
color("37");
std::cout << "37 white" << '\n';
color("7");
std::cout << "7 inverse mode" << '\n';
color("1");
std::cout << "1 big" << '\n';
*/


//load the menu in the map menu
int loadMenu(std::map<std::string,std::string> & menu, std::string adr);
//interactive display
int displayMenu(std::map<std::string,std::string> & menu);
//create an another process with a pid.
pid_t create_process(void);
// start a son process and exec
void sonWork(char ** arg, char * location);
//allow you to use easily exec and fork with thread
void launch(char ** argument, char * pathFile);
//custom the behavior of the interruption signal (CTR+C)
void sighandler(int sig);
//solve the problem of space in file path
std::string spaceEchapment(std::string str);
//read a txt file. use to display the help
int readFile(std::string path);
//browse from the path and select the file
DIR *  browseFile(std::string & path);
//browse and permit to select only file, no folders
DIR * selectFile(std::string & path);
//load default path and call selectFile
std::string selectFileFromDfPath();
//load default path and call browseFile
std::string selectFromDfPath();



#endif // TOOLS_H
