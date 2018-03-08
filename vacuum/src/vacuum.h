#ifndef VACUUM_H
#define VACUUM_H

#include"../../src/tools.h"

#include <iostream>
#include <string>
#include <chrono>         // std::chrono::seconds
#include <fstream>
#include <map>
#include <cstring>
#include <dirent.h> //read folder
#include <vector>
#include <sstream>

int fsize(const char * fname, long * ptr);
std::string selectKey(std::vector<std::string> keys);
std::string generateHash(std::string path);

#endif
