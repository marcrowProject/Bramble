#include "crypto.h"


int main(int argc, char ** argv) {


    int strt=0;
    printf ("\33[H\33[2J");
    if(argc<2) {
        std::map<std::string,std::string> menu;
        strt=loadMenu(menu,"cryptography/conf/menu.txt");
        if(strt==-2) {
            printf ("\33[H\33[2J");
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }

    //encrypt file
    if (strcmp(argv[1],"-encryptf")==0) {
        std::string ans, path, pass, pathsrc;
        std::string choice;

        std::cout << "Select the file you want to encrypt :" << '\n';
        pathsrc = selectFileFromDfPath();

        std::cout << "y to use a file as password \n\t\tor\nn to use password saved\n\t\tor\nan other letter to enter with keyboard" << '\n';
        std::cin >> choice;

        if(choice.compare("n")==0) {
            std::cout << "y to use the file bramble/.pass or n to use a custom file" << '\n';
            std::cin >> ans;
            std::string pathPass;
            if(ans.compare("y")==0) {
                pathPass="./.pass";
            }
            //load custom file
            else {
                pathPass = selectFileFromDfPath();
                printf ("\33[H\33[2J");
            }
            std::ifstream file(pathPass, std::ios::in);  // on ouvre le fichier en lecture
            if(file)  // si l'ouverture a réussi
            {
                // instructions
                std::string next;
                std::string line;
                while(getline(file, line)) {
                    std::cout << "y to select / n to continue" << '\n';
                    std::cout << line<<"\n";
                    std::cin >> next;
                    if(next.compare("y")!=0) {
                        break;
                    }
                }
                pass=line;
            }
        }


        else {
            if(choice.compare("y")==0) {
                path = selectFileFromDfPath();
                pass=generateHash(path);
                printf ("\33[H\33[2J");
                ans="n";
                std::cout << "Do you want to see the password?" << '\n';
                std::cin >> ans;
                if(ans.compare("y")==0) {
                    std::cout << pass << '\n';
                }
                ans="n";
                std::cout << "\nDo you want to make a copy of your passfile? y/n" << '\n';
                std::cin >> ans;

                if(ans.compare("y")==0) {
                    std::string pathsave = selectFromDfPath();
                    //copy the file
                    std::string arg;
                    arg="cp "+path+" "+pathsave+" -R -u";// -r to copy all folder -u to copy only file we don't already have
                    std::cout << "wait the end of this operation..." << '\n';
                    int test=system(arg.c_str());
                    printf ("\33[H\33[2J");
                    if(test==0) {
                        std::cout << "successfull copy" << '\n';
                    }
                }
            }
            else {
                std::cout << "your password : ";
                std::cin >> pass;
            }
        }
        printf ("\33[H\33[2J");
        encrypt(pathsrc,pass);
        int i=remove(pathsrc.c_str());
        if (i!=0) {
            std::cout << "decrypt success but the suppress process failed" << '\n';
            return -2;
        }
        std::cin >> ans;
    }
    //end encrypt file


    //decrypt file
    if (strcmp(argv[1],"-decryptf")==0) {
        std::string ans, path, pass, pathsrc;
        std::string choice;

        std::cout << "Select the file you want to decrypt :" << '\n';
        pathsrc = selectFileFromDfPath();

        std::cout << "y to use a file as password \n\t\tor\nn to use password saved\n\t\tor\nan other letter to enter with keyboard" << '\n';
        std::cin >> choice;

        if(choice.compare("n")==0) {
            std::cout << "y to use the file bramble/.pass or n to use a custom file" << '\n';
            std::cin >> ans;
            std::string pathPass;
            if(ans.compare("y")==0) {
                pathPass="./.pass";
            }
            //load custom file
            else {
                pathPass = selectFileFromDfPath();
                printf ("\33[H\33[2J");
            }
            std::ifstream file(pathPass, std::ios::in);  // on ouvre le fichier en lecture
            if(file)  // si l'ouverture a réussi
            {
                // instructions
                std::string next;
                std::string line;
                while(getline(file, line)) {
                    std::cout << "y to select / n to continue" << '\n';
                    std::cout << line<<"\n";
                    std::cin >> next;
                    if(next.compare("y")!=0) {
                        break;
                    }
                }
                pass=line;
            }
        }


        else {
            if(choice.compare("y")==0) {
                path = selectFileFromDfPath();
                pass=generateHash(path);
                printf ("\33[H\33[2J");
                ans="n";
            }
            else {
                std::cout << "your password : ";
                std::cin >> pass;
            }
        }
        printf ("\33[H\33[2J");
        decrypt(pathsrc,pass);
        std::cin >> ans;
    }
    //end decrypt file



    if (strcmp(argv[1],"-encryptd")==0) {

        //tar and encrypt the file first
        std::cout << "Select the file you want to encrypt :" << '\n';
        std::string pathsrc = selectFromDfPath();
        std::string pathdst = pathsrc+".tar.gz";
        std::size_t found = pathsrc.find_last_of("/");
        std::string pathsrcw = pathsrc.substr(0,found);
        std::string file = pathsrc.substr(found+1);
        std::string arg = "cd "+pathsrcw+" && tar -zcvf "+pathdst+" "+file;
        system(arg.c_str());

        //and encrypt it
        std::string ans, path, pass, choice;
        std::cout << "y to use a file as password \n\t\tor\nn to use password saved\n\t\tor\nan other letter to enter with keyboard" << '\n';
        std::cin >> choice;

        if(choice.compare("n")==0) {
            std::cout << "y to use the file bramble/.pass or n to use a custom file" << '\n';
            std::cin >> ans;
            std::string pathPass;
            if(ans.compare("y")==0) {
                pathPass="./.pass";
            }
            //load custom file
            else {
                pathPass = selectFileFromDfPath();
                printf ("\33[H\33[2J");
            }
            std::ifstream file(pathPass, std::ios::in);  // on ouvre le fichier en lecture
            if(file)  // si l'ouverture a réussi
            {
                // instructions
                std::string next;
                std::string line;
                while(getline(file, line)) {
                    std::cout << "y to select / n to continue" << '\n';
                    std::cout << line<<"\n";
                    std::cin >> next;
                    if(next.compare("y")!=0) {
                        break;
                    }
                }
                pass=line;
            }
            int i=remove(pathsrc.c_str());
            if (i!=0) {
                std::cout << "encrypt success but the suppress process failed" << '\n';
                return -2;
            }
        }


        else {
            if(choice.compare("y")==0) {
                path = selectFileFromDfPath();
                pass=generateHash(path);
                printf ("\33[H\33[2J");
                ans="n";
                std::cout << "Do you want to see the password?" << '\n';
                std::cin >> ans;
                if(ans.compare("y")==0) {
                    std::cout << pass << '\n';
                }
                ans="n";
                std::cout << "\nDo you want to make a copy of your passfile? y/n" << '\n';
                std::cin >> ans;

                if(ans.compare("y")==0) {
                    std::string pathsave = selectFromDfPath();
                    //copy the file
                    std::string arg;
                    arg="cp "+path+" "+pathsave+" -R -u";// -r to copy all folder -u to copy only file we don't already have
                    std::cout << "wait the end of this operation..." << '\n';
                    int test=system(arg.c_str());
                    printf ("\33[H\33[2J");
                    if(test==0) {
                        std::cout << "successfull copy" << '\n';
                    }
                }
            }
            else {
                std::cout << "your password : ";
                std::cin >> pass;
            }
        }

        encrypt(pathdst,pass);
        std::cin >> ans;

    }


    if (strcmp(argv[1],"-decryptd")==0) {

        //tar and decrypt the file first
        std::cout << "Select the file you want to decrypt :" << '\n';
        std::string pathsrc = selectFileFromDfPath();

        //and decrypt it
        std::string ans, path, pass, choice;
        std::cout << "y to use a file as password \n\t\tor\nn to use password saved\n\t\tor\nan other letter to enter with keyboard" << '\n';
        std::cin >> choice;

        if(choice.compare("n")==0) {
            std::cout << "y to use the file bramble/.pass or n to use a custom file" << '\n';
            std::cin >> ans;
            std::string pathPass;
            if(ans.compare("y")==0) {
                pathPass="./.pass";
            }
            //load custom file
            else {
                pathPass = selectFileFromDfPath();
                printf ("\33[H\33[2J");
            }
            std::ifstream file(pathPass, std::ios::in);  // on ouvre le fichier en lecture
            if(file)  // si l'ouverture a réussi
            {
                // instructions
                std::string next;
                std::string line;
                while(getline(file, line)) {
                    std::cout << "y to select / n to continue" << '\n';
                    std::cout << line<<"\n";
                    std::cin >> next;
                    if(next.compare("y")!=0) {
                        break;
                    }
                }
                pass=line;
            }
        }


        else {
            if(choice.compare("y")==0) {
                path = selectFileFromDfPath();
                pass=generateHash(path);
                printf ("\33[H\33[2J");
            }
            else {
                std::cout << "your password : ";
                std::cin >> pass;
            }
        }
        decrypt(pathsrc,pass);
        std::size_t pos = pathsrc.find("-encrypt");
        std::string pathdst = pathsrc.substr(0,pos);
        std::cout << pathdst << "\n";
        std::size_t found = pathsrc.find_last_of("/");
        std::string pathsrcw = pathsrc.substr(0,found);
        std::string arg = "cd "+pathsrcw+" && tar -zxvf "+pathdst;
        std::cout << arg << "\n";
        system(arg.c_str());
        std::cout << "supress : " << pathdst << "\n";
        int i=remove(pathdst.c_str());
        if (i!=0) {
            color("31");
            std::cout << "decrypt success but the suppress process failed" << '\n';
            color("0");
            return -2;
        }

    }

}
