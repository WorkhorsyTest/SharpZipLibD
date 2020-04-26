



// reset && dub run --arch=x86_64 --build=debug



int main() {
	import std.stdio : stdout;
	import System.IO : File;
	import ICSharpCode.SharpZipLib.BZip2 : BZip2;

	auto in_file = File.OpenRead("archive.tar.bz2");
	auto out_file = File.Create("blah");
	BZip2.Decompress(in_file, out_file, true);

	return 0;
}
