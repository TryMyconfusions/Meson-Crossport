module crosslib;
import std.stdio;
import std.file;
import app;
import conflib;
import std.conv;
import std.json;
import std.string;

//helper functions are placed here for the sake of reducing lines in the main file, and making it easier to maintain!




void printv(string message)
{	
	if (verbose) {  // prints if only the verbose boolean is verbose incase if the user wants to debug the program
		writeln(message);
    }
}


void generate_crossfile(string[] sts, string target_os) 
{
	printv("Generating crossfile..."); 

	string final_str;
	foreach (cur_s; sts) {
		cur_s =  cur_s ~ "\n"; //gets the current stuff and adds a newline so it wont smash into one
		final_str = final_str ~ cur_s; // adds the current stuff to the finalstring 



	}
	if (target_os.length == 0) {writeln("No targetOS selected!"); return;}
	std.file.write("crossfile-" ~ target_os ~ ".ini",final_str); // and then finally compile the finalstring 
	writeln("sucessfully compiled Crossfile!");
}


string tostring(int num) {
	string converted = to!string(num);

	printv("converted int to string: " ~  converted);

    return converted;
}


string find_e(string e, JSONValue[] arr) 
{ // finds a element in a array
	if (arr.length > 0) {
	foreach (cur_i; arr) // so this basically just loops through an array and if the element matches the object it returns it
	{

		if (cur_i.str==e) 
		{
			printv("Found Element: " ~ e);
			return cur_i.str;

			}
		}
	}
	printv("Failed to find element: " ~ e);
	return "";
}




string bool_to_str(bool boolthing) 
{
	if (boolthing) // a simple boolean to string
	{
		return "true";
	} 
	else 
	{
		return "false";
	}
}

string fix_build_ninja(string build_contents) {
	return build_contents.replace("-L=-L=","-L="); // this replaces the contents via string.split in std or phobos
}





void passedflag() 
{

	if (conflib.has_passedflags==false) 

	{ //checks if you passed any flags and if you did it will set to true this is mainly used to stop people from adding incorrect flags, and instead
	//give a clean error.
		conflib.has_passedflags = true;
	}
}


void add_section(string sect, bool hasadded) 
{
	// this function adds a new section for the crossfile.
	if (!hasadded) 
	{

		switch (sect) 
		{
			case "[host_machine]":
				add_obj("");

				add_obj(sect);

				add_obj("");
				printv("added section: " ~ sect);
				conflib.required_sections.hostmachine = true;

				break;

			case "[binaries]":
				add_obj("");

				add_obj(sect);

				add_obj("");
				printv("added section: " ~ sect);

				conflib.required_sections.binaries = true;

				break;
			
			case "[properties]":
				add_obj("");

				add_obj(sect);

				add_obj("");
				printv("added section: " ~ sect);


				conflib.required_sections.properties = true;

				break;

			case "[built-in options]":

				add_obj("");

				add_obj(sect);
				
				add_obj("");
				printv("added section: " ~ sect);

				conflib.required_sections.builtin = true;

				break;
			


		    default:

				writeln("Section is not supported");
		}
	}

}


string arrtostr(string[] arr) //array to str converts a array to a string by also removing the double quotes which make meson build system go crazy.
{
	string finalstr;

	finalstr ~= "[";
	
	foreach (string cur_str; arr) 
	{
		finalstr ~= "\n '" ~ cur_str ~ "'";
		finalstr ~= ", ";
	}
	finalstr ~= "\n ]";

	return finalstr;
}

void add_obj(string thing) 
{
	conflib.stuffforfile ~= thing; // add a object to the array stufforfile that would later be compiled for the crossfile
}
