#include "tools.h"

/////////////////////////////////Terminal manipulation//////////////////////////

void goto_x_y(unsigned int y, unsigned int x)
{
    printf("\033[%u;%uH", y, x);
}

/////////////////////////////////manipulate Menu////////////////////////////////

int loadMenu(std::map<std::string, std::string>& menu, std::string adr)
{
    std::ifstream fileMenu(adr, std::ios::in);
    std::cout << "loadMenu \n";
    if (fileMenu)
    {
        // instructions

        std::string line;
        while (getline(fileMenu, line)) //read line by line
        {
            std::string tmp, name, src, path;
            //find the name
            std::size_t foundN = line.find("name");
            tmp.assign(line, foundN + 6, line.length() - foundN);
            foundN = tmp.find("\"");
            name.assign(tmp, 0, foundN);

            tmp = "";

            //find the SOURCES
            foundN = line.find("src");
            tmp.assign(line, foundN + 5, line.length() - foundN);
            foundN = tmp.find("\"");
            src.assign(tmp, 0, foundN);

            tmp = "";

            //find the path
            foundN = line.find("path");
            tmp.assign(line, foundN + 6, line.length() - foundN);
            foundN = tmp.find("\"");
            path.assign(tmp, 0, foundN);

            src = src + " #" + path;
            std::cout << "src " << src << "\n";
            menu.insert(std::pair<std::string, std::string>(name, src));
        }
        fileMenu.close();
    }
    else {
        std::cerr << "Error : file Menu not found or corrupted" << std::endl;
        return -2;
    }
    return 0;
}

int displayMenu(std::map<std::string, std::string>& menu)
{
    clrscr();

    while (1) {
        for (std::map<std::string, std::string>::iterator it = menu.begin(); it != menu.end(); ++it) {
            color("7;1");
            std::cout << "->" << it->first << "<-" << '\n';
            color("0");
            std::map<std::string, std::string>::iterator it2 = it;
            ++it2;
            if (it2 != menu.end()) {
                std::cout << "  " << it2->first << '\n';
                ++it2;
                if (it2 != menu.end()) {
                    std::cout << "  " << it2->first << '\n';
                    ++it2;
                    if (it2 != menu.end()) {
                        std::cout << "  " << it2->first << '\n';
                        ++it2;
                        if (it2 != menu.end()) {
                            std::cout << "  " << it2->first << '\n';
                            ++it2;
                            if (it2 != menu.end()) {
                                std::cout << "  " << it2->first << '\n';
                                ++it2;
                                if (it2 != menu.end()) {
                                    std::cout << "  " << it2->first << '\n';
                                    ++it2;
                                    if (it2 != menu.end()) {
                                        std::cout << "  " << it2->first << '\n';
                                        std::cout << "          |" << '\n';
                                        std::cout << "          V" << '\n';
                                    }
                                }
                            }
                        }
                    }
                }
            }
            std::string ans;
            std::cin >> ans;
            std::cout << it->first << '\n';
            clrscr();

            if (ans.compare("y") == 0) {
                clrscr();

                //extract the program, arguments and path---

                std::string program, argument, path, tmp;

                std::size_t foundN = it->second.find(" ");
                program.assign(it->second, 0, foundN);
                std::cout << "program :" << program << "\n";

                tmp = "";

                tmp.assign(it->second, foundN + 1, it->second.length());
                foundN = tmp.find("#");
                argument.assign(tmp, 0, foundN);
                std::cout << "argument(s) :" << argument << "\n";

                foundN = it->second.find("#");
                path.assign(it->second, foundN + 1, it->second.length());
                std::cout << "path :" << path << "\n";
                //----
                if (it->first.compare("~leave bramble") == 0) {
                    clrscr();
                    std::cout << "Do you want to shutdown your device?" << '\n';
                    std::cin >> ans;
                    if ( ans == "y" ){
                        char *arg[]= { "shutdown", "0", NULL };
                        launch(arg,"/sbin/shutdown");
                    }
                    return 1;
                }
                //if the user want to exit
                if (it->first.compare("~exit") == 0) {
                    std::cout << std::endl
                              << "brambleBrambleBRambleBRAmbleBRAMbleBRAMBle" << std::endl
                              << std::endl
                              << "99999                       9    999" << std::endl
                              << "99   9                      9    99" << std::endl
                              << "9  99   9999 69999  9999999 999  9  9999" << std::endl
                              << "99   9  9   9    9  9  9  9 9  9 9  99" << std::endl
                              << "99999   9   996 699 9  9  9 999  9  9999" << std::endl
                              << std::endl
                              << "brambleBrambleBRambleBRAmbleBRAMbleBRAMBle" << std::endl;
                    std::cout << "\n\t\tSee you soon"
                              << "\n\n";
                    return 1;
                }
                //if the user want to read the help file
                else if (it->first.compare("~Help") == 0) {
                    readFile(program);
                }
                //finally if he want to enter in another menu or execute a script
                else { //execute
                    //prepare the argument for exec
                    char* cPath = new char[path.length() + 1];
                    strcpy(cPath, path.c_str());

                    int i = 0;
                    tmp = argument;
                    while ((foundN = tmp.find(" ")) != std::string::npos) {
                        i++;
                        tmp.assign(tmp, foundN + 1, tmp.length());
                    }
                    std::cout << "---> i :" << i << "\n";
                    char* Cprogram = new char[program.length() + 1];
                    std::cout << "--> i :" << i << "\n";
                    strcpy(Cprogram, program.c_str());
                    std::cout << "-> Cprogam :" << Cprogram << "\n";
                    char* arg[i + 1];
                    arg[0] = Cprogram;
                    std::cout << "-> i :" << i << "\n";
                    i = 0;
                    tmp = argument;
                    std::cout << argument << " : arg \n";
                    while ((foundN = tmp.find(" ")) != std::string::npos) {
                        i++;
                        std::string res;
                        res.assign(tmp, 0, foundN);
                        std::cout << "res :" << res << "\n";
                        char* Cres = new char[res.length() + 1];
                        strcpy(Cres, res.c_str());
                        arg[i] = Cres;
                        tmp.assign(tmp, foundN + 1, tmp.length());
                    }
                    std::cout << "a:i =" << i << std::endl;
                    for (int j = 0; j <= i; j++) {
                        std::cout << "val :" << arg[j] << "\n";
                    }
                    arg[i + 1] = NULL;

                    ////

                    //Now we can lauch our programm
                    clrscr();
                    launch(arg, cPath);
                    return 0;
                }
            }
        }
    }
}

/////////////////////////////////Launch a script////////////////////////////////

int status;

/* copy the father process and return the son pid (who is the copy of her father*/
pid_t create_process(void)
{
    //std::cout << "createProcess\n";
    pid_t pid;

    //make a safe copy with an unique pid for the son
    do {
        pid = fork();
    } while ((pid == -1) && (errno == EAGAIN));
    //std::cout << "process will be created\n";
    return pid;
}

//behavior of the son
void sonWork(char** arg, char* location)
{
    //std::cout << "sonWork\n";
    if (execv(location, arg) == -1) {
        perror("execv");
        exit(EXIT_FAILURE);
    }
}

void launch(char** argument, char* pathFile)
{
    pid_t pid = create_process();

    switch (pid) {

    case -1:
        perror("fork");
        exit(EXIT_FAILURE);
        break;

    case 0:
        sonWork(argument, pathFile);
        break;

    default:

        break;
    }

    if (wait(&status) == -1) {
        perror("wait :");
        exit(EXIT_FAILURE);
    }
    //std::cout << "wait the end \n";
    waitpid(pid, &status, WUNTRACED | WCONTINUED);
}

///////////////////////////////// signal ////////////////////////////////
/*if the user press CTR+C, the son process will be stopped but the
father process will continue. */
void sighandler(int sig)
{
    //You can add others signals
    //CTRL+C
    if (sig == 2) {
        std::cout << "You can't leave like that." << std::endl;
    }
}

///////////////////////////////// string cleaner////////////////////////////////

/*add a backslash before all space

because spaces generate errors with path file for exemple
*/
std::string spaceEchapment(std::string str)
{
    std::string space;
    space = " ";
    int i = 1;
    std::size_t found = str.find(space);
    while (found != std::string::npos) {
        i++;
        str.replace(found, space.length(), "\\ ");
        found = str.find(space, found + i);
    }
    std::cout << str << '\n';
    return str;
}


/////////////////////////////////manipulate files///////////////////////////////
//////////////////////////////////////// & /////////////////////////////////////
/////////////////////////////////Browse in directory////////////////////////////

int readFile(std::string path)
{
    clrscr();
    std::ifstream file(path, std::ios::in); // open the file
    if (file) // if the opening doesn't generate an error
    {
        // instructions
        std::string next;
        std::string line;
        while (getline(file, line)) {
            std::cout << line << "\n";
            for (size_t i = 0; i < 10 && getline(file, line); i++) {
                std::cout << line << "\n";
            }
            std::cin >> next;
            if (next.compare("y") != 0) {
                clrscr();
                return 0;
            }
        }
    }
    else {
        std::cerr << "Error file " << path << "can't be open." << '\n';
        return -1;
    }
    return 0;
}

DIR* browseFile(std::string& path)
{
    //find name of user and load the list of usb keys
    std::string tmp, ans, select;
    //number of lines displayed
    int nbDisplayed=6;

    //open directory and load the name of all file in folder map
    std::vector<std::string> folder;
    struct dirent* lecture;
    DIR* rep;
    char* dir = new char[path.length() + 1];
    std::strcpy(dir, path.c_str());
    rep = opendir(dir);
    if (rep == 0) {
        std::cout << "Error we can't open the folder " << path << '\n';
        return rep;
    }
    while ((lecture = readdir(rep))) {
        if (strcmp(lecture->d_name, "..") != 0 && strcmp(lecture->d_name, ".") != 0)
            folder.insert(folder.begin(), lecture->d_name);
    }

    //let the user selected the file or directory
    int i = -1;
    ans = "n";
    while (ans.compare("y") != 0) {
        i = (i + 1) % folder.size();
        int j = 0;
        for (std::vector<std::string>::iterator it = folder.begin(); it < folder.end(); it++) {
            if (i == j) {
                color("7;1");
                std::cout << "->" << *it << "<-" << '\n';
                color("0");
            }
            else {
                if (i < j && j-i<nbDisplayed) std::cout << *it << '\n';
            }
            j = (j + 1) % folder.size();
        }
        std::cin >> ans;
        clrscr();
    }

    path += "/" + folder[i];
    std::cout << "Y if you want to select it \nN if you want to go in" << '\n';
    std::cin >> ans;
    if (ans.compare("y") == 0 || ans.compare("Y") == 0) {
        closedir(rep);
        dir = new char[path.length() + 1];
        std::strcpy(dir, path.c_str());
        rep = opendir(dir);
        return rep;
    }
    else {
        path = spaceEchapment(path);
        rep = browseFile(path);
        return rep;
    }
}

DIR* selectFile(std::string& path)
{
    //find name of user and load the list of usb keys
    std::string tmp, ans, select;
    //number of lines displayed
    int nbDisplayed=6;

    //open directory and load the name of all file in folder map
    std::vector<std::string> folder;
    struct dirent* lecture;
    DIR* rep;
    char* dir = new char[path.length() + 1];
    std::strcpy(dir, path.c_str());
    rep = opendir(dir);
    if (rep == 0) {
        std::cout << "Error we can't open the folder " << path << '\n';
        return rep;
    }
    while ((lecture = readdir(rep))) {
        if (strcmp(lecture->d_name, "..") != 0 && strcmp(lecture->d_name, ".") != 0)
            folder.insert(folder.begin(), lecture->d_name);
    }

    int i = -1;
    ans = "n";
    std::vector<std::string>::iterator it;
    while (ans.compare("y") != 0) {
        i = (i + 1) % folder.size();
        int j = 0;
        for (it = folder.begin(); it < folder.end(); it++) {
            if (i == j) {
                color("7;1");
                std::cout << "->" << *it << "<-" << '\n';
                color("0");
            }
            else {
                if (i < j && j-i<nbDisplayed) std::cout << *it << '\n';
            }
            j = (j + 1) % folder.size();
        }
        std::cin >> ans;
        clrscr();
    }
    path += "/" + folder[i];
    std::cout << path << '\n';
    path = spaceEchapment(path);
    dir = new char[path.length() + 1];
    std::strcpy(dir, path.c_str());
    rep = opendir(dir);
    if (rep == 0) {
        closedir(rep);
        return rep;
    }
    rep = selectFile(path);
    return rep;
}

std::string selectFileFromDfPath()
{
    std::string pass, path;
    std::string ans;
    size_t i;

    std::vector<std::string> uOi; //usb or internal storage
    uOi.insert(uOi.begin(), "from usb device                     ");
    uOi.insert(uOi.begin(), "from internal storage bramble/result");

    ans = "n";
    while (ans.compare("y") != 0) {
        for (i = 0; i < uOi.size(); i++) {
            goto_x_y(2,0);
            color("7;1");
            std::cout << "-> " << uOi[i % uOi.size()] << "<-" << '\n';
            color("0");
            std::cout << uOi[(i + 1) % uOi.size()] << '\n';
            std::cin >> ans;
            std::cout << ans << '\n';
            if (ans.compare("y") == 0 || ans.compare("Y") == 0)
                break;
        }
    }
    clrscr();
    if (i == 0) {
        path = "./result";
    }
    else {
        path = "/media";
    }
    selectFile(path);
    return path;
}

std::string selectFromDfPath()
{
    std::string pass, path;
    std::string ans;
    size_t i;

    std::vector<std::string> uOi; //usb or internal storage
    uOi.insert(uOi.begin(), "from usb device                     ");
    uOi.insert(uOi.begin(), "from internal storage bramble/result");

    ans = "n";
    while (ans.compare("y") != 0) {
        for (i = 0; i < uOi.size(); i++) {
            goto_x_y(2,0);
            color("7;1");
            std::cout << "->" << uOi[i % uOi.size()] << "<-" << '\n';
            color("0");
            std::cout << uOi[(i + 1) % uOi.size()] << '\n';
            std::cin >> ans;
            std::cout << ans << '\n';
            if (ans.compare("y") == 0 || ans.compare("Y") == 0)
                break;
        }
    }
    clrscr();
    if (i == 0) {
        path = "./result";
    }
    else {
        path = "/media";
    }
    browseFile(path);
    return path;
}
