



// reset && dub run --arch=x86_64 --build=debug



int main() {
	import std.stdio : stdout;
	import std.file : mkdir, isDir, rmdirRecurse, exists;
	import System.IO : File;
	import ICSharpCode.SharpZipLib.BZip2 : BZip2;
	import ICSharpCode.SharpZipLib.Tar : TarArchive;

	// Make a directory to extract files to
	if (exists("extracted") && isDir("extracted")) {
		rmdirRecurse("extracted");
	}
	mkdir("extracted");

	// Extract the tar.bz2 to tar
	{
		auto in_file = File.OpenRead("archive.tar.bz2");
		auto out_file = File.Create("extracted/out.tar");
		BZip2.Decompress(in_file, out_file, true);
	}

	// Extract the files in the tar
	{
		auto in_file = File.OpenRead("extracted/out.tar");
		auto tarArchive = TarArchive.CreateInputTarArchive(in_file);
		tarArchive.ExtractContents("extracted");
		tarArchive.Close();
		in_file.Close();
	}
/*
	// Compress the tar to tar.bz2
	{
		auto in_file = File.OpenRead("out.tar");
		auto out_file = File.Create("out.tar.bz2");
		BZip2.Compress(in_file, out_file, true, 9);
	}
*/
	return 0;
}
