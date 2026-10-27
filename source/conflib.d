module conflib;
import std.json;
//the arguments for crossport

//these are the variables for crossport i thought it would be nice to place it somewhere so crosslib and app.d can access it.




bool verbose;
string cpufamily;
string target_os;
string endian;

enum string jsonstuff = import("arrays.json");





string d_compiler;
string c_compiler;
string cpp_compiler;
string ar;
string strip;
string exe_wrapper;
string windres;
string fixpath;


string[] da; //D arguments
string[] ca; //C arguments
string[] cppa; //C++ arguments

string[] dla;
string[] cla;
string[] cppla;


bool needs_exe_wrap = false;

bool has_passedflags = false;


JSONValue[] cpu_family;


JSONValue[] supported_os;

JSONValue[] endians;

string sys_root; // system root
int soi; //sizeof_int
int soc; //sizeof_wchar_t
int sov; //sizeof_void*

int alc; // alignment_char
int alv; // alignment_void*
int ald; //  alignment_double

bool has_printf = false;

string pkg_conf;

string[] cstdlib;
string[] dstdlib;
string[] cppstdlib;


struct rs {
    bool binaries;
    bool hostmachine;
    bool properties;
    bool builtin;
}
rs required_sections; // the required sections for crossfiles


string[] stuffforfile;

