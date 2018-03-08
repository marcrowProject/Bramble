#include "crypt.h"

std::string generateHash(std::string path) {
    std::ifstream file(path, std::ios::in);
    std::string h;
    std::stringstream sstream;
    unsigned long int tmp=0;
    if(!file.fail())
    {
        std::string ligne;
        char curr;
        int i=0;
        while(file.get(curr)) {
            i++;
            //i need this to have the same result on a pc and on a raspberry
            if((unsigned int)curr < 100){
            	tmp+=(unsigned int)curr;
            }
        }
      	tmp=tmp*343;
      	//avoid password as fffffffffff4d5e44
        unsigned long int tmp1=tmp%1000000000000000;
        //minimum 8 char for the password
        while(tmp1<900000000) {
        	tmp1=tmp1*33439;
        }
        tmp=tmp1;
        sstream << std::hex <<tmp;
        h=sstream.str();
        file.close();
    }

    return h;
}

int encrypt(std::string path,std::string pass) {
    std::string dest;
    dest=path+"-encrypt";
    std::string arg;
    arg="openssl enc -e -aes-256-cbc -in "+path+" -out "+dest+" -pass pass:"+pass;
    int result=system(arg.c_str());
    if(result==0) {
        int i=remove(path.c_str());
        if (i!=0) {
            std::cout << "encrypt success but the suppress process failed" << '\n';
            return -2;
        }
        std::cout << "Success." << '\n';
        return 0;
    }
    else {
        std::cout << "Encryption failed." << '\n';
        return -1;
    }
}

int defaultEncrypt(std::string path) {
    std::string pass = generateHash("./conf/dontdelete");
    int i=encrypt(path, pass);
    return i;
}



int decrypt(std::string path,std::string pass) {
    std::string dest;
    std::size_t pos = path.find("-encrypt");
    dest = path.substr(0,pos);
    std::string arg;
    arg="openssl enc -d -aes-256-cbc -in "+path+" -out "+dest+" -pass pass:"+pass;
    int result=system(arg.c_str());
    if(result==0) {
        std::cout << "Success." << '\n';
        return 0;
    }
    else {
        std::cout << "Decryption failed." << '\n';
        return -1;
    }
}

int defaultdecrypt(std::string path) {
    std::string pass = generateHash("./conf/dontdelete");
    int i=decrypt(path, pass);
    return i;
}
