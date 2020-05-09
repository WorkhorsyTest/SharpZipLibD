

import System : EventArgs, BaseException, NotImplementedException;

import ICSharpCode.SharpZipLib.Core;


	//#region EventArgs

	/// <summary>
	/// Event arguments for scanning.
	/// </summary>
	public class ScanEventArgs : EventArgs
	{
		//#region Constructors

		/// <summary>
		/// Initialise a new instance of <see cref="ScanEventArgs"/>
		/// </summary>
		/// <param name="name">The file or directory name.</param>
		public this(string name)
		{
			name_ = name;
		}

		//#endregion Constructors

		/// <summary>
		/// The file or directory name for this event.
		/// </summary>
		public string Name()
		{
			return name_;
		}

		/// <summary>
		/// Get set a value indicating if scanning should continue or not.
		/// </summary>
		public bool ContinueRunning()
		{
			return continueRunning_;
		}
		public bool ContinueRunning(bool value)
		{
			return continueRunning_ = value;
		}

		//#region Instance Fields

		private string name_;
		private bool continueRunning_ = true;

		//#endregion Instance Fields
	}

	/// <summary>
	/// Event arguments during processing of a single file or directory.
	/// </summary>
	public class ProgressEventArgs : EventArgs
	{
		//#region Constructors

		/// <summary>
		/// Initialise a new instance of <see cref="ScanEventArgs"/>
		/// </summary>
		/// <param name="name">The file or directory name if known.</param>
		/// <param name="processed">The number of bytes processed so far</param>
		/// <param name="target">The total number of bytes to process, 0 if not known</param>
		public this(string name, long processed, long target)
		{
			name_ = name;
			processed_ = processed;
			target_ = target;
		}

		//#endregion Constructors

		/// <summary>
		/// The name for this event if known.
		/// </summary>
		public string Name()
		{
			return name_;
		}

		/// <summary>
		/// Get set a value indicating wether scanning should continue or not.
		/// </summary>
		public bool ContinueRunning()
		{
			return continueRunning_;
		}
		public bool ContinueRunning(bool value)
		{
			return continueRunning_ = value;
		}

		/// <summary>
		/// Get a percentage representing how much of the <see cref="Target"></see> has been processed
		/// </summary>
		/// <value>0.0 to 100.0 percent; 0 if target is not known.</value>
		public float PercentComplete()
		{
			float result;
			if (target_ <= 0)
			{
				result = 0;
			}
			else
			{
				result = (cast(float)processed_ / cast(float)target_) * 100.0f;
			}
			return result;
		}

		/// <summary>
		/// The number of bytes processed so far
		/// </summary>
		public long Processed()
		{
			return processed_;
		}

		/// <summary>
		/// The number of bytes to process.
		/// </summary>
		/// <remarks>Target may be 0 or negative if the value isnt known.</remarks>
		public long Target()
		{
			return target_;
		}

		//#region Instance Fields

		private string name_;
		private long processed_;
		private long target_;
		private bool continueRunning_ = true;

		//#endregion Instance Fields
	}

	/// <summary>
	/// Event arguments for directories.
	/// </summary>
	public class DirectoryEventArgs : ScanEventArgs
	{
		//#region Constructors

		/// <summary>
		/// Initialize an instance of <see cref="DirectoryEventArgs"></see>.
		/// </summary>
		/// <param name="name">The name for this directory.</param>
		/// <param name="hasMatchingFiles">Flag value indicating if any matching files are contained in this directory.</param>
		public this(string name, bool hasMatchingFiles)
		{
			super(name);
			hasMatchingFiles_ = hasMatchingFiles;
		}

		//#endregion Constructors

		/// <summary>
		/// Get a value indicating if the directory contains any matching files or not.
		/// </summary>
		public bool HasMatchingFiles()
		{
			return hasMatchingFiles_;
		}

		private /*readonly*/

		//#region Instance Fields

		bool hasMatchingFiles_;

		//#endregion Instance Fields
	}

	/// <summary>
	/// Arguments passed when scan failures are detected.
	/// </summary>
	public class ScanFailureEventArgs : EventArgs
	{
		//#region Constructors

		/// <summary>
		/// Initialise a new instance of <see cref="ScanFailureEventArgs"></see>
		/// </summary>
		/// <param name="name">The name to apply.</param>
		/// <param name="e">The exception to use.</param>
		public this(string name, BaseException e)
		{
			name_ = name;
			exception_ = e;
			continueRunning_ = true;
		}

		//#endregion Constructors

		/// <summary>
		/// The applicable name.
		/// </summary>
		public string Name()
		{
			return name_;
		}

		/// <summary>
		/// The applicable exception.
		/// </summary>
		public BaseException exception()
		{
			return exception_;
		}

		/// <summary>
		/// Get / set a value indicating wether scanning should continue.
		/// </summary>
		public bool ContinueRunning()
		{
			return continueRunning_;
		}
		public bool ContinueRunning(bool value)
		{
			return continueRunning_ = value;
		}

		//#region Instance Fields

		private string name_;
		private BaseException exception_;
		private bool continueRunning_;

		//#endregion Instance Fields
	}

	//#endregion EventArgs

	//#region Delegates

	/// <summary>
	/// Delegate invoked before starting to process a file.
	/// </summary>
	/// <param name="sender">The source of the event</param>
	/// <param name="e">The event arguments.</param>
	public alias ProcessFileHandler = void delegate(Object sender, ScanEventArgs e);

	/// <summary>
	/// Delegate invoked during processing of a file or directory
	/// </summary>
	/// <param name="sender">The source of the event</param>
	/// <param name="e">The event arguments.</param>
	public alias ProgressHandler = void delegate(Object sender, ProgressEventArgs e);

	/// <summary>
	/// Delegate invoked when a file has been completely processed.
	/// </summary>
	/// <param name="sender">The source of the event</param>
	/// <param name="e">The event arguments.</param>
	public alias CompletedFileHandler = void delegate(Object sender, ScanEventArgs e);

	/// <summary>
	/// Delegate invoked when a directory failure is detected.
	/// </summary>
	/// <param name="sender">The source of the event</param>
	/// <param name="e">The event arguments.</param>
	public alias DirectoryFailureHandler = void delegate(Object sender, ScanFailureEventArgs e);

	/// <summary>
	/// Delegate invoked when a file failure is detected.
	/// </summary>
	/// <param name="sender">The source of the event</param>
	/// <param name="e">The event arguments.</param>
	public alias FileFailureHandler = void delegate(Object sender, ScanFailureEventArgs e);

	//#endregion Delegates

	/// <summary>
	/// FileSystemScanner provides facilities scanning of files and directories.
	/// </summary>
	public class FileSystemScanner
	{
		//#region Constructors

		/// <summary>
		/// Initialise a new instance of <see cref="FileSystemScanner"></see>
		/// </summary>
		/// <param name="filter">The <see cref="PathFilter">file filter</see> to apply when scanning.</param>
		public this(string filter)
		{
			fileFilter_ = new PathFilter(filter);
		}

		/// <summary>
		/// Initialise a new instance of <see cref="FileSystemScanner"></see>
		/// </summary>
		/// <param name="fileFilter">The <see cref="PathFilter">file filter</see> to apply.</param>
		/// <param name="directoryFilter">The <see cref="PathFilter"> directory filter</see> to apply.</param>
		public this(string fileFilter, string directoryFilter)
		{
			fileFilter_ = new PathFilter(fileFilter);
			directoryFilter_ = new PathFilter(directoryFilter);
		}

		/// <summary>
		/// Initialise a new instance of <see cref="FileSystemScanner"></see>
		/// </summary>
		/// <param name="fileFilter">The file <see cref="IScanFilter">filter</see> to apply.</param>
		public this(IScanFilter fileFilter)
		{
			fileFilter_ = fileFilter;
		}

		/// <summary>
		/// Initialise a new instance of <see cref="FileSystemScanner"></see>
		/// </summary>
		/// <param name="fileFilter">The file <see cref="IScanFilter">filter</see>  to apply.</param>
		/// <param name="directoryFilter">The directory <see cref="IScanFilter">filter</see>  to apply.</param>
		public this(IScanFilter fileFilter, IScanFilter directoryFilter)
		{
			fileFilter_ = fileFilter;
			directoryFilter_ = directoryFilter;
		}

		//#endregion Constructors

		//#region Delegates
/*
		/// <summary>
		/// Delegate to invoke when a directory is processed.
		/// </summary>
		public event EventHandler<DirectoryEventArgs> ProcessDirectory;
*/
		/// <summary>
		/// Delegate to invoke when a file is processed.
		/// </summary>
		public ProcessFileHandler ProcessFile;

		/// <summary>
		/// Delegate to invoke when processing for a file has finished.
		/// </summary>
		public CompletedFileHandler CompletedFile;

		/// <summary>
		/// Delegate to invoke when a directory failure is detected.
		/// </summary>
		public DirectoryFailureHandler DirectoryFailure;

		/// <summary>
		/// Delegate to invoke when a file failure is detected.
		/// </summary>
		public FileFailureHandler FileFailure;

		//#endregion Delegates

		/// <summary>
		/// Raise the DirectoryFailure event.
		/// </summary>
		/// <param name="directory">The directory name.</param>
		/// <param name="e">The exception detected.</param>
		private bool OnDirectoryFailure(string directory, BaseException e)
		{
			DirectoryFailureHandler handler = DirectoryFailure;
			bool result = (handler !is null);
			if (result)
			{
				auto args = new ScanFailureEventArgs(directory, e);
				handler(this, args);
				alive_ = args.ContinueRunning;
			}
			return result;
		}

		/// <summary>
		/// Raise the FileFailure event.
		/// </summary>
		/// <param name="file">The file name.</param>
		/// <param name="e">The exception detected.</param>
		private bool OnFileFailure(string file, BaseException e)
		{
			FileFailureHandler handler = FileFailure;

			bool result = (handler !is null);

			if (result)
			{
				auto args = new ScanFailureEventArgs(file, e);
				FileFailure(this, args);
				alive_ = args.ContinueRunning;
			}
			return result;
		}

		/// <summary>
		/// Raise the ProcessFile event.
		/// </summary>
		/// <param name="file">The file name.</param>
		private void OnProcessFile(string file)
		{
			ProcessFileHandler handler = ProcessFile;

			if (handler !is null)
			{
				auto args = new ScanEventArgs(file);
				handler(this, args);
				alive_ = args.ContinueRunning;
			}
		}

		/// <summary>
		/// Raise the complete file event
		/// </summary>
		/// <param name="file">The file name</param>
		private void OnCompleteFile(string file)
		{
			CompletedFileHandler handler = CompletedFile;

			if (handler !is null)
			{
				auto args = new ScanEventArgs(file);
				handler(this, args);
				alive_ = args.ContinueRunning;
			}
		}

		/// <summary>
		/// Raise the ProcessDirectory event.
		/// </summary>
		/// <param name="directory">The directory name.</param>
		/// <param name="hasMatchingFiles">Flag indicating if the directory has matching files.</param>
		private void OnProcessDirectory(string directory, bool hasMatchingFiles)
		{
/*
			EventHandler!DirectoryEventArgs handler = ProcessDirectory;

			if (handler !is null)
			{
				auto args = new DirectoryEventArgs(directory, hasMatchingFiles);
				handler(this, args);
				alive_ = args.ContinueRunning;
			}
*/
			throw new NotImplementedException();
		}

		/// <summary>
		/// Scan a directory.
		/// </summary>
		/// <param name="directory">The base directory to scan.</param>
		/// <param name="recurse">True to recurse subdirectories, false to scan a single directory.</param>
		public void Scan(string directory, bool recurse)
		{
			alive_ = true;
			ScanDir(directory, recurse);
		}

		private void ScanDir(string directory, bool recurse)
		{
			import System.IO : Directory;

			try
			{
				string[] names = Directory.GetFiles(directory);
				bool hasMatch = false;
				for (int fileIndex = 0; fileIndex < names.length; ++fileIndex)
				{
					if (!fileFilter_.IsMatch(names[fileIndex]))
					{
						names[fileIndex] = null;
					}
					else
					{
						hasMatch = true;
					}
				}

				OnProcessDirectory(directory, hasMatch);

				if (alive_ && hasMatch)
				{
					foreach (fileName ; names)
					{
						try
						{
							if (fileName !is null)
							{
								OnProcessFile(fileName);
								if (!alive_)
								{
									break;
								}
							}
						}
						catch (BaseException e)
						{
							if (!OnFileFailure(fileName, e))
							{
								throw e;
							}
						}
					}
				}
			}
			catch (BaseException e)
			{
				if (!OnDirectoryFailure(directory, e))
				{
					throw e;
				}
			}

			if (alive_ && recurse)
			{
				try
				{
					string[] names = Directory.GetDirectories(directory);
					foreach (fulldir ; names)
					{
						if ((directoryFilter_ is null) || (directoryFilter_.IsMatch(fulldir)))
						{
							ScanDir(fulldir, true);
							if (!alive_)
							{
								break;
							}
						}
					}
				}
				catch (BaseException e)
				{
					if (!OnDirectoryFailure(directory, e))
					{
						throw e;
					}
				}
			}
		}

		//#region Instance Fields

		/// <summary>
		/// The file filter currently in use.
		/// </summary>
		private IScanFilter fileFilter_;

		/// <summary>
		/// The directory filter currently in use.
		/// </summary>
		private IScanFilter directoryFilter_;

		/// <summary>
		/// Flag indicating if scanning should continue running.
		/// </summary>
		private bool alive_;

		//#endregion Instance Fields
	}
