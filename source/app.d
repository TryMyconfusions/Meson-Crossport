import std.getopt;
import std.stdio;
import std.file;
import std.uni;
import std.bitmanip;


//the arguments for crossport
bool verbose;
string cpufamily;
string target_os;
string lang;
string endian;


string d_compiler;
string c_compiler;
string cpp_compiler;
string ar;
string strip;
string exe_wrapper;
string windres;

bool has_passedflags = false;

string[] cpu_family = 
[
	"x86",
	"x86_64",
	"arm32",
	"arm64",
];

string[] supported_os = 
[
	"windows",
	"linux",
	"macos",
];

string[] endians = 
[
	"big",
	"small"
];





string[] stuffforfile;

void generate_crossfile(string[] sts) 
{
	printv("Generating crossfile..."); 

	string final_str;
	for (int i; i < sts.length; i++) {
		string cur_s = sts[i] ~ "\n"; //gets the current stuff and adds a newline so it wont smash into one

		final_str = final_str ~ cur_s; // adds the current stuff to the finalstring 



	}
	std.file.write("crossfile.txt",final_str); // and then finally compile the finalstring 
	writeln("sucessfully compiled Crossfile!");
}


string find_e(string e, string[] arr) 
{ // finds a element in a array
	if (arr.length > 0) {
	for (int i; i < arr.length; i++) {
		string cur_i = arr[i];

		if (cur_i==e) {
			printv("Found Element!");
			return cur_i;

			}
		}
	}
	printv("Failed to find element");
	return "";
}

void passedflag() {
	if (has_passedflags==false) { //checks if you passed any flags
		has_passedflags = true;
	}
}

void printv(string message) 
{	
	if (verbose) { // prints if only the verbose boolean is verbose incase if the user wants to debug the program
		writeln(message);
	}
}



void add_obj(string thing) 
{
	stuffforfile ~= thing; // add a object to the array stufforfile that would later be compiled for the crossfile
}
void main(string[] args) 
{
	try {
	auto crossarg = getopt( // this is where the commandline parsing is handled
		args,
		"v|verbose", "mainly for debugging purposes, tells the user what the program is doing", &verbose,
		"arch|a", "Cpu architecture", &cpufamily,
		"platform|p", "Targeted OS to export to", &target_os,
		"lang|l", "Programming language", &lang,
		"endian|e","the direction cpu reads big reads from left to right while small reads from right to left", &endian,

		"d", "D compiler Path", &d_compiler,
		"c", "C Compiler Path", &c_compiler,
		"cpp","C++ Compiler", &cpp_compiler,
		"ar", "Ar Path", &ar,
		"strip|s", "strip Path", &strip,
		"exe", "exe wrapper Path", &exe_wrapper,
		"windres|w", "windres Path", &windres,
	);

	printv("created getopt");


	if (crossarg.helpWanted) 
	{
		defaultGetoptPrinter("here are the commands for crossport", crossarg.options);
		return;
	}


	add_obj("[host_machine]");
	printv("added stuffforfile [host_machine]");

	if (find_e(cpufamily,cpu_family) != "") {
		add_obj("cpu_family = '" ~ cpufamily ~ "'");
		add_obj("cpu = '" ~ cpufamily ~ "'");

		passedflag();
		writeln("sucessfully added architecture!");
		printv("added architecture: " ~ cpufamily);
	}
	if (find_e(target_os,supported_os) != "") {
		add_obj("system = '" ~ target_os ~ "'");
		

		printv("sucessfully added OS: " ~ target_os);
		passedflag();
	}

	if (find_e(endian,endians) != "") {
		add_obj("endian = '" ~ endian ~ "'");

		printv("added endian: " ~ endian);

		passedflag();
	}

	add_obj("[binaries]");

	if (c_compiler != "") {
		add_obj("c = '" ~ c_compiler ~ "'");

		printv("added C Compiler: " ~ c_compiler);
		passedflag();
	}

	if (d_compiler != "") {
		add_obj("d = '" ~ d_compiler ~ "'");

		printv("added D Compiler: " ~ d_compiler);
		passedflag();
	} 

	if (cpp_compiler != "") {
		add_obj("cpp = '" ~ cpp_compiler ~ "'");

		printv("added C++ Compiler: " ~ cpp_compiler);
		passedflag();
	}

	if (ar != "") {
		add_obj("ar = '" ~ ar ~ "'");

		printv("added ar: " ~ ar);
		passedflag();
	}

	if (windres) {
		add_obj("windres = '" ~ windres ~ "'");

		printv("added windres: " ~ windres);
		passedflag();
	}
	if (has_passedflags) {
		generate_crossfile(stuffforfile);
		return;
	} else {
		writeln("No flags please type ./crossfile -h for help info!");
		return;
	}



	}
	catch (GetOptException e) {
		if (args.length > 1) {
		writeln("Unrecognized Argument!: " ~ args[1]);
		} else {
			writeln("No value for argument found!");
		}

	}


	
	
}