#include "steno.h"

int main(int argc, char ** argv)
{
    int strt=0;
    clrscr();
    if(argc<2) {
        std::map<std::string,std::string> menu;
        strt=loadMenu(menu,"steganography/conf/menu.txt");
        if(strt==-2) {
            clrscr();
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }

    if (strcmp(argv[1],"-h")==0) {
        clrscr();
        unsigned int i=0;
        std::string ans; //user's answers
        std::string pass; //password used to hide the file
        std::string path; //path of the password-file
        std::string pathsave; //path of the password-file copy
        std::string pathsrc; // file to hide
        std::string pathdst; // destination file

        color("32"); //text in green
        std::cout << "select the file you want to hide:" << '\n';
        color("0");
        pathsrc=selectFileFromDfPath();


        while(true) {
          clrscr();
          color("32");
          std::cout << "select the file in which you want to hide the file:" << '\n';
          color("0");
          color("36,1");
          goto_x_y(6,0);
          std::cout << "It is necessarily a bmp, jpg or wave file" << '\n';
          color("0");
          pathdst=selectFileFromDfPath();
          std::size_t found = pathdst.find_last_of(".");
          std::string extension = pathdst.substr(found+1);
          if(extension.compare("jpg") == 0 || extension.compare("jpeg") == 0 || extension.compare("bmp") == 0 || extension.compare("wave") == 0){
              break;
          }
          else {
              clrscr();
              color("31");
              std::cout << "You have selected a file type that is not compatible." << '\n';
              std::cout << "Please select a conciliable file" << '\n';
              std::cout << "Press a button to continue or Ctrl+c to stop" << '\n';
              color("0");
              std::cin >> ans;
          }
        }

        clrscr();
        std::string choice;
        std::cout << "y to use a file as password \n\t\tor\nn to use password saved\n\t\tor\nan other letter to enter with keyboard" << '\n';
        std::cin >> choice;

        clrscr();

        if(choice.compare("y")==0) {

            path=selectFileFromDfPath();

            if(path.compare(pathdst)==0) {
                std::cout << "you can't select the same file for lock and hide." << '\n';
                return 0;
            }

            pass=generateHash(path);

            std::cout << "Be carreful, don't loose or modify your passfile\n else you can't get back your hidding file\n"
                      <<"do you want to see the password generated? y/n" << '\n';

            std::cin >> ans;
            if(ans.compare("y")==0) {
                std::cout << "password : " << pass << '\n';
                std::cin >> ans;
            }
            clrscr();


            std::cout << "\nDo you want to make a copy of your passfile? y/n" << '\n';
            std::cin >> ans;

            if(ans.compare("y")==0) {
                pathsave=selectFromDfPath();
                //copy the file
                char *arg[]= { "cp",(char*) path.c_str(),(char*) pathsave.c_str(), "-R", "-u", NULL };
                std::cout << "wait the end of this operation..." << '\n';
                launch(arg,"/bin/cp");
                clrscr();
              /*  if(test==0) {
                    std::cout << "successfull copy" << '\n';
                }
                else {
                    std::cout << "Error during the copy" + test  << '\n';
                    std::cin >> ans;
                    return 0;
                }*/
            }

        }
        //end password by file

        else if(choice.compare("n")==0) {
            std::cout << "y to use the default password file or n to use a custom file" << '\n';
            std::cin >> ans;
            std::string pathPass;
            if(ans.compare("y")==0) {
                pathPass="./conf/.pass";
            }
            //load custom file
            else {
                pathPass=selectFileFromDfPath();
            }
            std::string next;
            do {
                std::ifstream file(pathPass, std::ios::in);  // on ouvre le fichier en lecture
                if(file)  // si l'ouverture a réussi
                {
                    // instructions
                    std::string line;
                    ans="n";
                        while(getline(file, line)) {
                            clrscr();
                            std::cout << "y to select / n to continue\n" << '\n';
                            color("36");
                            std::cout << line<<"\n";
                            color("0");
                            std::cout << "..." << '\n';
                            std::cin >> next;
                            if(next.compare("y")==0) {
                                break;
                            }
                        }

                    pass=line;
                    file.close();
                }
                else {
                    std::cerr << "Error file "<< path <<"can't be open." << '\n';
                    return -1;
                }
            }while(next.compare("y")!=0);

        }

        else {
            std::cout << "your password : ";
            std::cin >> pass;
        }
        pass="\""+pass+"\"";
        clrscr();
        color("1");
        char *arg[]= { "steghide","--embed","-ef",(char*) pathsrc.c_str(),"-cf",(char*) pathdst.c_str(), "-v", "-z","9","-p",(char *) pass.c_str(), NULL };
        launch(arg,"/usr/bin/steghide");
        color("0");
        color("33");
        std::cout << "do you want erase the hidding file? y/n" << '\n';
        std::cout << "Read the above information carefully to verify that your file is well hidden" << '\n';
        color("0");
        std::cin >> ans;
        if(ans.compare("y")==0) {
            remove(pathsrc.c_str());
        }
        std::cin >> ans;
    }

    if (strcmp(argv[1],"-e")==0) {

        clrscr();
        std::cout << "select the file in which you want to hide the file:" << '\n';
        std::vector<std::string> uOi; //usb or internal storage
        unsigned int i=0;
        std::string pass;
        std::string path;
        std::string ans;
        std::string choice;
        std::string pathsrc=selectFileFromDfPath();
        std::cout << pathsrc << '\n';

        clrscr();
        std::cout << "y to use a file as password \n\t\tor\nn to use password saved\n\t\tor\nan other letter to enter with keyboard" << '\n';
        std::cin >> choice;

        clrscr();

        if(choice.compare("y")==0) {
            ans="n";
            path=selectFileFromDfPath();
            pass=generateHash(path);
        }
        //end passfile


        else if(choice.compare("n")==0) {
            std::cout << "y to use the default password file or n to use a custom file" << '\n';
            std::cin >> ans;
            std::string pathPass;
            if(ans.compare("y")==0) {
                pathPass="./conf/.pass";
            }
            //load custom file
            else {
                pathPass=selectFileFromDfPath();
            }

            std::string next;
            do {
                std::ifstream file(pathPass, std::ios::in);  // on ouvre le fichier en lecture
                if(file)  // si l'ouverture a réussi
                {
                    // instructions
                    std::string line;
                    ans="n";
                        while(getline(file, line)) {
                            clrscr();
                            std::cout << "y to select / n to continue\n" << '\n';
                            color("36");
                            std::cout << line<<"\n";
                            color("0");
                            std::cout << "..." << '\n';
                            std::cin >> next;
                            if(next.compare("y")==0) {
                                break;
                            }
                        }

                    pass=line;
                    file.close();
                }
                else {
                    std::cerr << "Error file "<< path <<"can't be open." << '\n';
                    return -1;
                }
            }while(next.compare("y")!=0);

        }

        else {
            std::cout << "your password : ";
            std::cin >> pass;
        }
        clrscr();
        pass="\""+pass+"\"";
        color("1");
        std::string dest=pathsrc+"-extract";
        char *arg[]= { "steghide","--extract","-sf",(char*) pathsrc.c_str(),"-p",(char*) pass.c_str(),"-xf",(char*) dest.c_str(), NULL };
        launch(arg,"/usr/bin/steghide");
        color("0");
        std::cout << "Press a key to quit" << '\n';
        std::string tmp;
        std::cin >> tmp;
    }
}
