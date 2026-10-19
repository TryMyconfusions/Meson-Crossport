module crosslib;
import std.stdio;
import std.file;
import app;
import conflib;
import std.conv;
import std.json;

void printv(string message,bool verbose)
{	
	if (verbose) {  // prints if only the verbose boolean is verbose incase if the user wants to debug the program
		writeln(message);
    }
}


void generate_crossfile(string[] sts, string target_os) 
{
	printv("Generating crossfile...",conflib.verbose); 

	string final_str;
	for (int i; i < sts.length; i++) {
		string cur_s = sts[i] ~ "\n"; //gets the current stuff and adds a newline so it wont smash into one
		final_str = final_str ~ cur_s; // adds the current stuff to the finalstring 



	}
	if (target_os.length == 0) {writeln("No targetOS selected!"); return;}
	std.file.write("crossfile" ~ target_os[0] ~ ".txt",final_str); // and then finally compile the finalstring 
	writeln("sucessfully compiled Crossfile!");
}


string tostring(int num) {
	string converted = to!string(num);

	printv("converted int to string: " ~  converted,conflib.verbose);

    return converted;
}


string find_e(string e, JSONValue[] arr) 
{ // finds a element in a array
	if (arr.length > 0) {
	for (int i; i < arr.length; i++) 
	{
		JSONValue cur_i = arr[i];

		if (cur_i.str==e) 
		{
			printv("Found Element!",conflib.verbose);
			return cur_i.str;

			}
		}
	}
	printv("Failed to find element: " ~ e,conflib.verbose);
	return "";
}


string read_file(string filename) 
{
	printv("read file: " ~ filename, conflib.verbose);

	
	return std.file.readText(filename);

}


