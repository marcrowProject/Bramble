#ifndef CRYPT_H
#define CRYPT_H

#include <fstream>
#include <dirent.h> //read folder
#include <vector>
#include <sstream>
#include <iostream>

//generate hash from a file.
std::string generateHash(std::string path);
int encrypt(std::string path,std::string pass);
int defaultEncrypt(std::string path);
int decrypt(std::string path,std::string pass);
int defaultdecrypt(std::string path);


#endif
