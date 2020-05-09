



// reset && dub run --arch=x86_64 --build=debug



int main() {
	import std.stdio : stdout;
	import System.IO : File;
	import ICSharpCode.SharpZipLib.BZip2 : BZip2;
	import ICSharpCode.SharpZipLib.Tar : TarArchive;

	// Extract the tar.bz2 to tar
	{
		auto in_file = File.OpenRead("archive.tar.bz2");
		auto out_file = File.Create("out.tar");
		BZip2.Decompress(in_file, out_file, true);
	}

	// Compress the tar to tar.bz2
	{
		auto in_file = File.OpenRead("out.tar");
		auto out_file = File.Create("out.tar.bz2");
		BZip2.Compress(in_file, out_file, true, 9);
	}

	return 0;
}
