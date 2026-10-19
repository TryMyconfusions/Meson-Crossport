module conflib;
import std.json;
//the arguments for crossport
bool verbose;
string cpufamily;
string target_os;
string endian;





string d_compiler;
string c_compiler;
string cpp_compiler;
string ar;
string strip;
string exe_wrapper;
string windres;
bool needs_exe_wrap = false;

bool has_passedflags = false;


JSONValue[] cpu_family;


JSONValue[] supported_os;

string[] endians;

string sys_root; // system root
int soi; //sizeof_int
int soc; //sizeof_wchar_t
int sov; //sizeof_void*

int alc; // alignment_char
int alv; // alignment_void*
int ald; //  alignment_double

bool has_printf = false;

string pkg_conf;

