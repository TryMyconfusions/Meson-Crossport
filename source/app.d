
//THIS PROJECT IS LARGELY BASED OF MESONS DOCUMENTATION ABOUT CROSS COMPILATION!!
//CrossPort

//crossport simplifies making cross compiled binaries from meson by generating crossfiles for meson build system!

import std.getopt;
import std.stdio;
import std.file;
import std.uni;
import std.bitmanip;
import std.conv;
import std.algorithm.searching;




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


string sys_root; // system root
int soi; //sizeof_int
int soc; //sizeof_wchar_t
int sov; //sizeof_void*

int alc; // alignment_char
int alv; // alignment_void*
int ald; //  alignment_double

bool has_printf = false;

string pkg_conf;




bool needs_exe_wrap = false;

bool has_passedflags = false;


string[] cpu_family = 
[
	"x86",
	"x86_64",
	"arm",
	"aarch64",
	"mips"
];


string[] supported_os = 
[
	"windows",
	"linux",
	"macos",
	"android",
	"ios",
];


string[] endians = 
[
	"big",
	"little"
];


string find_e(string e, string[] arr) 
{ // finds a element in a array
	if (arr.length > 0) {
	for (int i; i < arr.length; i++) 
	{
		string cur_i = arr[i];

		if (cur_i==e) 
		{
			printv("Found Element!");
			return cur_i;

			}
		}
	}
	printv("Failed to find element: " ~ e);
	return "";
}


string tostring(int num) {
    return to!string(num);
}





void printv(string message) 
{	
	if (verbose) { // prints if only the verbose boolean is verbose incase if the user wants to debug the program
		writeln(message);
	}
}


string[] stuffforfile;


void add_obj(string thing) 
{
	stuffforfile ~= thing; // add a object to the array stufforfile that would later be compiled for the crossfile
}


string bool_to_str(bool boolthing) 
{
	if (boolthing) 
	{
		return "true";
	} 
	else 
	{
		return "false";
	}
}


void generate_crossfile(string[] sts) 
{
	printv("Generating crossfile..."); 

	string final_str;
	for (int i; i < sts.length; i++) {
		string cur_s = sts[i] ~ "\n"; //gets the current stuff and adds a newline so it wont smash into one
		final_str = final_str ~ cur_s; // adds the current stuff to the finalstring 



	}
	if (target_os.length == 0) {writeln("No targetOS selected!"); return;}
	std.file.write("crossfile" ~ target_os[0] ~ ".txt",final_str); // and then finally compile the finalstring 
	writeln("sucessfully compiled Crossfile!");
}


void passedflag() {
	if (has_passedflags==false) 
	{ //checks if you passed any flags
		has_passedflags = true;
	}
}


void main(string[] args) 
{
	try {
	auto crossarg = getopt( // this is where the commandline parsing is handled
		args,
		"v|verbose", "mainly for debugging purposes, tells the user what the program is doing", &verbose,
		"arch|a", "Cpu architecture", &cpufamily,
		"platform|p", "Targeted OS to export to", &target_os,
		"endian|e","the direction cpu reads big reads from left to right while little reads from right to left", &endian,

		"d", "D compiler Path", &d_compiler,
		"c", "C Compiler Path", &c_compiler,
		"cpp","C++ Compiler", &cpp_compiler,
		"ar", "Ar Path", &ar,
		"strip|s", "strip Path", &strip,
		"exe", "exe wrapper Path", &exe_wrapper,
		"windres|w", "windres Path", &windres,
		

		"soi", "[advanced] sizeof_int", &soi,
		"soc", "[advanced] sizeof_wchar_t", &soc,
		"sov", "[advanced] sizeof_void*", &sov,

		"alc", "[advanced] alignment_char", &alc,
		"alv", "[advanced] alignment_void*", &alv,
		"ald", "[advanced] alignment_double", &ald,

		"hfpf", "[advanced] has_function_printf", &has_printf,
		"sysroot", "[advanced] system root path", &sys_root,
		"pkgconf", "[advanced] pkg_config_libdir path", &pkg_conf,
		"needwrapper", "need exe wrapper", &needs_exe_wrap,

	);

	printv("created getopt");
	

	if (crossarg.helpWanted) 
	{
		defaultGetoptPrinter("here are the commands for crossport", crossarg.options);
		return;
	}


	add_obj("[host_machine]");


	printv("added stuffforfile [host_machine]");

	if (find_e(cpufamily,cpu_family) != "") 
	{ 
		add_obj("cpu_family = '" ~ cpufamily ~ "'");
		add_obj("cpu = '" ~ cpufamily ~ "'");

		passedflag();

		writeln("sucessfully added architecture!");
		printv("added architecture: " ~ cpufamily);
	}


	if (find_e(target_os,supported_os) != "") 
	{ 
		add_obj("system = '" ~ target_os ~ "'"); 
		printv("sucessfully added OS: " ~ target_os);
		 passedflag();
		 }


	if (find_e(endian,endians) != "") 
	{ 
		add_obj("endian = '" ~ endian ~ "'"); 
		printv("added endian: " ~ endian); 
		passedflag();
	}


	add_obj("[binaries]");


	// adding the c compiler if the user told it to add
	if (c_compiler != "") 
	{ 
		if (!c_compiler.canFind("[")) 
		{ 
			add_obj("c = '" ~ c_compiler ~ "'");
		} 
		else 
		{
			add_obj("c = " ~ c_compiler);
		} 
			printv("added C Compiler: " ~ c_compiler); 
			passedflag();
	}


	// find the [ to identify if its a array if it does have then dont quote it if it doenst have quote it!
	if (d_compiler != "") 
	{ 
		if (!d_compiler.canFind("[")) 
		{ 
			add_obj("d = '" ~ d_compiler ~ "'");
		} 
		else 
		{
			add_obj("d = " ~ d_compiler);
		} 
			printv("added D Compiler: " ~ d_compiler); 
			passedflag();} 


	if (cpp_compiler != "") 
	{ 
		if (!cpp_compiler.canFind("[")) 
		{ 
			add_obj("cpp = '" ~ cpp_compiler ~ "'");
		} 
		else 
		{
			add_obj("cpp = " ~ cpp_compiler);
		} 
			printv("added C++ Compiler: " ~ cpp_compiler); 
			passedflag();
	}


	if (ar != "") 
	{ 
		add_obj("ar = '" ~ ar ~ "'"); 
		printv("added ar: " ~ ar); 
		passedflag();
	}


	if (windres != "") 
	{ 
		add_obj("windres = '" ~ windres ~ "'"); 
		printv("added windres: " ~ windres); 
		passedflag(); 
	}


	if (strip != "") 
	{ 
		add_obj("strip = '" ~ strip ~ "'");
		 printv("added strip: " ~ strip); 
		 passedflag(); 
	}


	add_obj("[properties]");


	if (soi != 0) 
	{ 
		add_obj("sizeof_int = " ~ tostring(soi)); passedflag(); 
	}


	if (soc != 0) 
	{ 
		add_obj("sizeof_wchar_t = " ~ tostring(soc)); 
		passedflag();
	}


	if (sov != 0) 
	{ 

		add_obj("sizeof_void* = " ~ tostring(sov)); 
		passedflag();

	}


	if (has_printf) 
	{ 
		add_obj("has_function_printf = " ~ bool_to_str(has_printf)); 
		passedflag();

	}


	if (needs_exe_wrap) 
	{

	add_obj("needs_exe_wrapper = " ~ bool_to_str(needs_exe_wrap)); 
	
	passedflag();

	}


	if (pkg_conf != "") 
	{ 
	add_obj("pkg_config_libdir = '" ~ pkg_conf ~ "'");
    passedflag();
	}


	if (sys_root != "") 
	{ 
	add_obj("sys_root = '" ~ sys_root ~ "'"); 
	passedflag();
	}




	if (has_passedflags) 
	{
		generate_crossfile(stuffforfile);
		return;
	} 
	else 
	{
		writeln("No flags please type ./crossfile -h for help info!");
		return;
	}



	}
	catch (GetOptException e) 
	{
		if (args.length > 1) 
		{
		writeln("Unrecognized Argument!: " ~ args[1]);
		} 
		else 
		{
			writeln("No value for argument found!");
		}

	}


	
	
}