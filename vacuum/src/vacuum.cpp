#include"vacuum.h"

std::string selectKey(std::vector<std::string> keys) {
    std::string ans;
    int i=0;
    while(ans.compare("y")!=0) {
        int j=0;
        for (std::vector<std::string>::iterator it = keys.begin(); it < keys.end(); it++) {
            if(i==j) {
                std::cout << "->"<<*it<<"<-" << '\n';
            }
            else {
                std::cout << *it << '\n';
            }
            j=(j+1)%keys.size();
        }
        std::cin >> ans;
        printf ("\33[H\33[2J");
        i=(i+1)%keys.size();
    }
    return keys[(i-1)%keys.size()];
}




int main(int argc, char ** argv)
{
    int strt=0;
    printf ("\33[H\33[2J");
    if(argc<2) {
        std::map<std::string,std::string> menu;
        strt=loadMenu(menu,"vacuum/conf/menu.txt");
        if(strt==-2) {
            printf ("\33[H\33[2J");
            strt=loadMenu(menu,"conf/menu.txt");
            if(strt==-2) return -2;
        }
        displayMenu(menu);
        return 0;
    }

    //find name of user and load the list of usb keys
    std::string user,keysrc,keydst,tmp,ans, path;
    std::vector<std::string> keys;
    user=getenv("HOME");
    std::size_t found = user.find_last_of("/");
    user=user.substr(found+1);

    struct dirent *lecture;
    DIR *rep;
    tmp="/media/"+user;
    char *dir=new char[tmp.length()+1];
    std::strcpy(dir, tmp.c_str());
    rep = opendir(dir);

    //if that doesn't work, the user select the folder
    if(rep==NULL) {
        closedir(rep);
        std::cout << "we can't open the folder where your usb is plugged.\nPlease select it manually." << '\n';
        std::vector<std::string> folder;
        std::cout << "Select the folder " << '\n';
        tmp="/media";
        char *dir=new char[tmp.length()+1];
        std::strcpy(dir, tmp.c_str());
        std::cout << dir << '\n';
        rep = opendir(dir);
        while ((lecture = readdir(rep))) {
            if(strcmp(lecture->d_name,"..")!=0 && strcmp(lecture->d_name,".")!=0)
                folder.insert(folder.begin(),lecture->d_name);
        }

        int i=0;
        while(ans.compare("y")!=0) {
            int j=0;
            for (std::vector<std::string>::iterator it = folder.begin(); it < folder.end(); it++) {
                if(i==j) {
                    std::cout << "->"<<*it<<"<-" << '\n';
                }
                else {
                    std::cout << *it << '\n';
                }
                j=(j+1)%folder.size();
            }
            std::cin >> ans;
            printf ("\33[H\33[2J");
            i=(i+1)%folder.size();
        }
        user=folder[(i-1)%folder.size()];

        tmp="/media/"+user;
        char * dir2=new char[tmp.length()+1];
        //dir=new char[tmp.length()+1];

        std::strcpy(dir2, tmp.c_str());
        rep = opendir(dir2);
    }
    while ((lecture = readdir(rep))) {
        if(strcmp(lecture->d_name,"..")!=0 && strcmp(lecture->d_name,".")!=0)
            keys.insert(keys.begin(),lecture->d_name);
        //  printf("%s\n", lecture->d_name);
    }
    closedir(rep);


    if (strcmp(argv[1],"-kk")==0) {
        std::cout << "usb to usb" << '\n';
        std::cout << "Select Source" << '\n';
        keysrc=selectKey(keys);
        path="/media/"+user+"/"+keysrc;

        std::cout << "Y to copy all / N to select a file or folder" << '\n';
        std::cin >> ans;
        if(ans.compare("n")==0||ans.compare("N")==0) {
            browseFile(path);
            std::cout << path << '\n';
        }
        std::cout << "Select Destination" << '\n';
        keydst=selectKey(keys);
        std::string arg;
        arg="cp "+path+" /media/"+user+"/"+keydst+"/ -R -u";// -r to copy all folder -u to copy only file we don't already have
        std::cout << "wait the end of this operation..." << '\n';
        int test=system(arg.c_str());
        printf ("\33[H\33[2J");
        if(test==0) {
            std::cout << "successfull copy" << '\n';
        }
        else
            std::cout << "Error during the copy" + test  << '\n';
        std::cin >> ans;
        closedir(rep);
        return 0;

    }

    if (strcmp(argv[1],"-ki")==0) {
        std::cout << "usb to internal storage" << '\n';
        std::cout << "Select Source" << '\n';
        keysrc=selectKey(keys);
        std::string arg,path;
        path="/media/"+user+"/"+keysrc;
        std::cout << "Y to copy all / N to select a file or folder" << '\n';
        std::cin >> ans;
        if(ans.compare("n")==0||ans.compare("N")==0) {
            browseFile(path);
        }
        arg="cp "+path+" result/clone -R -u";// -r to copy all folder -u to copy only file we don't already have
        std::cout << "copy : " <<  "wait the end of this operation..." << '\n';
        int test=system(arg.c_str());
        printf ("\33[H\33[2J");
        if(test==0) {
            std::cout << "successfull copy" << '\n';
        }
        else
            std::cout << "Error during the copy" + test  << '\n';

        std::cin >> ans;
        return 0;
    }

    return 0;

}
