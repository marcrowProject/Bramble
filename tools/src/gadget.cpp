#include "gadget.h"


int main(int argc, char ** argv)
{
    int strt=0;
    printf ("\33[H\33[2J");
    if(argc<2) {
        std::map<std::string,std::string> menu;
        strt=loadMenu(menu,"tools/conf/menu.txt");
        if(strt==-2) {
            printf ("\33[H\33[2J");
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }


    //generate password
    if (strcmp(argv[1],"-passGen")==0) {
        std::string path = selectFileFromDfPath();
        std::string pass=generateHash(path);
        std::cout << "your password : " << pass << '\n';
        std::cout << "Quit" << '\n';
        std::string ans;
        std::cin >> ans;
    }


    if (strcmp(argv[1],"-encypt")==0) {
        std::string ans, path, pass;
        std::string choice;
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
            std::ifstream file(pathPass, std::ios::in);  // open the file in read mode
            if(file)  // if open work
            {
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
                printf ("\33[H\33[2J");
                path = selectFileFromDfPath();
                pass=generateHash(path);
                printf ("\33[H\33[2J");
                ans="n";
                std::cout << "Do you want to see the password?" << '\n';
                std::cin >> ans;
                if(ans.compare("y")) {
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
        encrypt(path,pass);
        std::cin >> ans;
    }

}
