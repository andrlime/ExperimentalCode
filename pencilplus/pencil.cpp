#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <fstream>
#include <utility>
#include <cstring>

using namespace std;

struct Team {
    string teamId;
    string id1;
    pair<string, string> name1;
    string school1;
    string id2;
    pair<string, string> name2;
    string school2;
};

/// @brief Splits a string into an array of strings separated by the delimiter
/// @param in input string
/// @param delimiter separation character e.g. " " or ","
/// @return vector of strings
vector<string> split(string in, char delimiter) {

    vector<string> output;
    char buffer[in.length() + 1]; 
    strcpy(buffer, in.c_str()); 
    int i = 0;

    // A temporary string
    string s = "";
    while (buffer[i] != '\0') {

        if (buffer[i] != delimiter) {
            // Append the char to the temp string.
            s += buffer[i]; 
        } else {
            output.push_back(s);
            s.clear();
        }

        i++;

    }

    return output;

}

/// @brief Remove all leading spaces and quotes from both names,
// and then attach them with a space in between
// Then only capitalize the first letter of both
/// @param first First name of debater
/// @param last Last name of debater
/// @return First Last as one string
pair<string, string> parseName(string first, string last) {

    // Some C-style code that uses C++ iterators; it worksd
    for ( auto ch = first.begin(); ch != first.end(); ch ++ ) {

        if ( *ch >= 65 && *ch <= 90 ) *ch += 32;
        if ( *ch == ' ' || *ch == '\"' || *ch == '\'' ) {

            first.erase(ch);
            ch --;

        }

    }

    for ( auto ch = last.begin(); ch != last.end(); ch ++ ) {

        if ( *ch >= 65 && *ch <= 90 ) *ch += 32;
        if ( *ch == ' ' || *ch == '\"' || *ch == '\'' ) {

            last.erase(ch);
            ch --;

        }

    }

    first[0] -= 32;
    last[0] -= 32;

    return make_pair(first, last);

}

/// @brief Reads a file and maps division names to arrays of teams
/// @param file_name file name
/// @param division_count amount of divisions in this file
/// @return map of division names to vectors of teams
map<string, vector<Team>> readFile(string file_name, int division_count) {

    // Map to store the output
    map<string, vector<Team>> output;

    // Open the file
    ifstream file;
    file.open(file_name);
    if ( !file.is_open() ) {

        cout << "[ERROR] Invalid file " << file_name << endl;
        exit(2);

    }

    // read each line of the file

    // Buffer to store the entire line
    string buffer;

    // Have I found the first non-heading row
    bool foundFirst = false;

    // Vector for current division teams, and current division's name
    vector<Team> currentDivision;
    string currentDivisionName = "";

    // Am I looking at the first or second speaker?
    bool second = false;

    // How many divisions have I checked?
    int parsedDivisions = 0;

    // Current team
    struct Team currentTeam;

    // While there's a new line
    while(!file.eof()) {
        getline(file, buffer);

        // If I've parsed all divisions I want to parse, I'm done!
        if ( parsedDivisions == division_count ) break;

        // Continue if there aren't any letters aka ",,,,,,,,,"
        if ( buffer.find_first_of("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == string::npos ) {

            if ( currentDivisionName != "" ) parsedDivisions ++; // Add a parsed division the first time there's a line of commas
            output[currentDivisionName] = currentDivision; // Store the vector into the map
            currentDivisionName = ""; // Reset division name
            currentDivision.clear(); // Clear the vector
            continue;

        }

        // Determine if the line is a team/debater
        if ( buffer.find("1,") != string::npos ) foundFirst = true;

        // If I've found the first debater...
        if ( foundFirst ) {
            // Split the string into an array
            vector<string> dataArray = split(buffer, ',');

            // Set current division name, and teamID iff its not blank
            currentDivisionName = dataArray[1];
            if(dataArray[2].length() > 0)
                currentTeam.teamId = dataArray[2];

            // Debater's name
            pair<string, string> name = parseName(dataArray[5], dataArray[6]);
            if ( name.first == " " || name.second == " " || name.first == "" || name.second == "" ) continue;

            // If this is a second speaker set their data and add to vector,
            // else set first speaker and continue
            if ( second ) {

                currentTeam.name2 = name;
                currentTeam.school2 = dataArray[14];
                currentTeam.id2 = dataArray[3];
                currentDivision.push_back(currentTeam);
                second = false;

            } else {

                currentTeam.name1 = name;
                currentTeam.school1 = dataArray[14];
                currentTeam.id1 = dataArray[3];
                second = true;

            }
        }
        
    }

    // Remove the vector pointed to by a blank string
    output.erase("");
    return output;

}

/// @brief Parses teams from the map into csv file strings
/// @param team_lists map from readFile()
/// @return a map of division name to csv strings
map<string, string> parseTeams(map<string, vector<Team>> team_lists) {

    const string HEADER = "School Name,State/Prov,Entry Code,Pairing Seed (1-100),Speaker 1 First,Speaker 1 Middle,Speaker 1 Last,Speaker 1 Novice (Y/N),Speaker 1 Gender (F/M/O),Speaker 1 Email,Speaker 2 First,Speaker 2 Middle,Speaker 2 Last,Speaker 2 Novice (Y/N),Speaker 2 Gender (F/M/O),Speaker 2 Email,Speaker 3 First,Speaker 3 Middle,Speaker 3 Last,Speaker 3 Novice (Y/N),Speaker 3 Gender (F/M/O),Speaker 3 Email\n";
    map<string, string> output;

    for ( auto division : team_lists ) {

        string data = HEADER;
        for ( auto &team : division.second ) {

            if(team.teamId != (team.id1 + "" + team.id2)) {
                cout << "[ERROR] Ironman debater not handled properly, STOPPING. To fix, add N/A as the second speaker." << endl;
                exit(1);
            }

            data += team.school1;
            data += ",";
            data += ",";
            data += team.teamId;
            data += ",";
            data += ",";
            data += team.name1.second;
            data += ",";
            data += ",";
            data += team.id1;
            data += " ";
            data += team.name1.first;
            data += ",N,O,,";
            data += team.name2.second;
            data += ",";
            data += ",";
            data += team.id2;
            data += " ";
            data += team.name2.first;
            data += ",N,O,,,,,,,,\n";
            
            output[division.first] = data;

        }

        cout << "[LOG]" << division.first << "succeeded, " << division.second.size() << " total teams." << endl;

    }

    return output;

}

/// @brief Writes csv strings from parseTeams
/// @param input_file_name input file name
/// @param csv_strings data from parseTeams
void writeFiles(string input_file_name, map<string, string> csv_strings) {

    for ( auto &csv_str : csv_strings ) {

        string file_name = input_file_name + "_" + csv_str.first + ".csv";
        ofstream file;
        file.open(file_name);
        file << csv_str.second;
        file.close();

    }

}

/// @brief Self explanatory
void printHelpMsg() {
    cout << "------------" << endl;
    cout << "Usage:" << endl;
    cout << "pencil (file name) (number of divisions)" << endl;
    cout << "  file name: name of your csv file" << endl;
    cout << "  number of divisions: # of divisions inside of this file, defaults to 1" << endl;
    cout << "Flags:" << endl;
    cout << "  -H or --h: show help message" << endl;
    cout << "------------" << endl;
}

/// @brief main lol
/// @param argc arg count
/// @param argv arg values
/// @return 0
int main(int argc, char ** argv) {
    
    // Argument 1: file name
    if ( argc == 1 || ( argc > 1 && ( strcmp(argv[1], "-H") == 0 || strcmp(argv[1], "--h") == 0 || strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--H") == 0 ) ) ) {

        printHelpMsg();
        return 1;

    }

    // Have arguments, so let's parse them
    string input_file = argv[1];

    // Ensure it's a csv file
    bool valid = input_file.find(".csv") != string::npos;
    if ( !valid ) {

        cout << "[ERROR] Not a csv file. Make sure you input a csv file." << endl;
        return 1;

    }

    // Division count
    int division_count = 1;
    if(argc > 2) {

        try {

            division_count = atoi(argv[2]);

        } catch(const exception& e) {

            cerr << "[ERROR] Second argument must be an INTEGER NUMBER" << endl;

        }
        
    } else {
        cout << "[WARNING] You did not specify a division count. I strongly recommend you do." << endl;
    }

    // Presumably a valid file, let's read it maps division -> list of teams
    map<string, vector<Team>> teams = readFile(input_file, division_count);

    // Parse all of the teams into csv strings
    map<string, string> output = parseTeams(teams);

    // Write the files
    writeFiles(input_file, output);

    return 0;

}
