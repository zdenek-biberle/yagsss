#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <string>

using namespace std;
void parse(string line,ofstream& f)
{
    string token;
    bool floatMode = false;
    for(auto ch:line)
    {
        if( isspace( ch ) )
        {
            if( !token.empty() )
            {
                if(!floatMode)
                {
                    int theInt;
                    stringstream(token) >> hex >> theInt;
                    cout << "Writing:" << token <<  " as " << theInt << endl;
                    f.write((const char*)&theInt, 1);
                    token.clear();
                }
                else
                {
                    float theFloat;
                    stringstream(token) >> theFloat;
                    cout << "Writing:" << theFloat << endl;
                    f.write((const char*)&theFloat,sizeof(float));
                    floatMode = false;
                    token.clear();
                }
            }
        }
        else if(ch == '#')
        {
            break;
        }
        else if( ch == '%' )
        {
            floatMode = true;
        }
        else
        {
            token += ch;
        }
    }
}

int main()
{
    ofstream h("level1",ios::binary);
    string input_line;
    while(getline(cin, input_line)) 
    {
        parse(input_line,h);
    }
    h.close();
    return 0;
}
