
import System : ArgumentException, ArgumentNullException, ArgumentOutOfRangeException, DateTime, TimeSpan;
import System.IO : Stream, EndOfStreamException;
import std.stdio : File;

import ICSharpCode.SharpZipLib.Core;

	/// <summary>
	/// Provides simple <see cref="Stream"/>" utilities.
	/// </summary>
	public /*sealed*/ class StreamUtils
	{
		/// <summary>
		/// Read from a <see cref="Stream"/> ensuring all the required data is read.
		/// </summary>
		/// <param name="stream">The stream to read.</param>
		/// <param name="buffer">The buffer to fill.</param>
		/// <seealso cref="ReadFully(Stream,ubyte[],int,int)"/>
		static public void ReadFully(Stream stream, ubyte[] buffer)
		{
			ReadFully(stream, buffer, 0, cast(int) buffer.length);
		}

		/// <summary>
		/// Read from a <see cref="Stream"/>" ensuring all the required data is read.
		/// </summary>
		/// <param name="stream">The stream to read data from.</param>
		/// <param name="buffer">The buffer to store data in.</param>
		/// <param name="offset">The offset at which to begin storing data.</param>
		/// <param name="count">The number of bytes of data to store.</param>
		/// <exception cref="ArgumentNullException">Required parameter is null</exception>
		/// <exception cref="ArgumentOutOfRangeException"><paramref name="offset"/> and or <paramref name="count"/> are invalid.</exception>
		/// <exception cref="EndOfStreamException">End of stream is encountered before all the data has been read.</exception>
		static public void ReadFully(Stream stream, ubyte[] buffer, int offset, int count)
		{
			if (stream is null)
			{
				throw new ArgumentNullException(__traits(identifier, stream));
			}

			if (buffer is null)
			{
				throw new ArgumentNullException(__traits(identifier, buffer));
			}

			// Offset can equal length when buffer and count are 0.
			if ((offset < 0) || (offset > buffer.length))
			{
				throw new ArgumentOutOfRangeException(__traits(identifier, offset));
			}

			if ((count < 0) || (offset + count > buffer.length))
			{
				throw new ArgumentOutOfRangeException(__traits(identifier, count));
			}

			while (count > 0)
			{
				int readCount = stream.Read(buffer, offset, count);
				if (readCount <= 0)
				{
					throw new EndOfStreamException();
				}
				offset += readCount;
				count -= readCount;
			}
		}

		/// <summary>
		/// Read as much data as possible from a <see cref="Stream"/>", up to the requested number of bytes
		/// </summary>
		/// <param name="stream">The stream to read data from.</param>
		/// <param name="buffer">The buffer to store data in.</param>
		/// <param name="offset">The offset at which to begin storing data.</param>
		/// <param name="count">The number of bytes of data to store.</param>
		/// <exception cref="ArgumentNullException">Required parameter is null</exception>
		/// <exception cref="ArgumentOutOfRangeException"><paramref name="offset"/> and or <paramref name="count"/> are invalid.</exception>
		static public int ReadRequestedBytes(Stream stream, ubyte[] buffer, int offset, int count)
		{
			if (stream is null)
			{
				throw new ArgumentNullException(__traits(identifier, stream));
			}

			if (buffer is null)
			{
				throw new ArgumentNullException(__traits(identifier, buffer));
			}

			// Offset can equal length when buffer and count are 0.
			if ((offset < 0) || (offset > buffer.length))
			{
				throw new ArgumentOutOfRangeException(__traits(identifier, offset));
			}

			if ((count < 0) || (offset + count > buffer.length))
			{
				throw new ArgumentOutOfRangeException(__traits(identifier, count));
			}

			int totalReadCount = 0;
			while (count > 0)
			{
				int readCount = stream.Read(buffer, offset, count);
				if (readCount <= 0)
				{
					break;
				}
				offset += readCount;
				count -= readCount;
				totalReadCount += readCount;
			}

			return totalReadCount;
		}

		/// <summary>
		/// Copy the contents of one <see cref="Stream"/> to another.
		/// </summary>
		/// <param name="source">The stream to source data from.</param>
		/// <param name="destination">The stream to write data to.</param>
		/// <param name="buffer">The buffer to use during copying.</param>
		static public void Copy(Stream source, Stream destination, ubyte[] buffer)
		{
			if (source is null)
			{
				throw new ArgumentNullException(__traits(identifier, source));
			}

			if (destination is null)
			{
				throw new ArgumentNullException(__traits(identifier, destination));
			}

			if (buffer is null)
			{
				throw new ArgumentNullException(__traits(identifier, buffer));
			}

			// Ensure a reasonable size of buffer is used without being prohibitive.
			if (buffer.length < 128)
			{
				throw new ArgumentException("Buffer is too small", __traits(identifier, buffer));
			}

			bool copying = true;

			while (copying)
			{
				int bytesRead = source.Read(buffer, 0, cast(int) buffer.length);
				if (bytesRead > 0)
				{
					destination.Write(buffer, 0, bytesRead);
				}
				else
				{
					destination.Flush();
					copying = false;
				}
			}
		}

		/// <summary>
		/// Copy the contents of one <see cref="Stream"/> to another.
		/// </summary>
		/// <param name="source">The stream to source data from.</param>
		/// <param name="destination">The stream to write data to.</param>
		/// <param name="buffer">The buffer to use during copying.</param>
		/// <param name="progressHandler">The <see cref="ProgressHandler">progress handler delegate</see> to use.</param>
		/// <param name="updateInterval">The minimum <see cref="TimeSpan"/> between progress updates.</param>
		/// <param name="sender">The source for this event.</param>
		/// <param name="name">The name to use with the event.</param>
		/// <remarks>This form is specialised for use within #Zip to support events during archive operations.</remarks>
		static public void Copy(Stream source, Stream destination,
			ubyte[] buffer, ProgressHandler progressHandler, TimeSpan updateInterval, Object sender, string name)
		{
			Copy(source, destination, buffer, progressHandler, updateInterval, sender, name, -1);
		}

		/// <summary>
		/// Copy the contents of one <see cref="Stream"/> to another.
		/// </summary>
		/// <param name="source">The stream to source data from.</param>
		/// <param name="destination">The stream to write data to.</param>
		/// <param name="buffer">The buffer to use during copying.</param>
		/// <param name="progressHandler">The <see cref="ProgressHandler">progress handler delegate</see> to use.</param>
		/// <param name="updateInterval">The minimum <see cref="TimeSpan"/> between progress updates.</param>
		/// <param name="sender">The source for this event.</param>
		/// <param name="name">The name to use with the event.</param>
		/// <param name="fixedTarget">A predetermined fixed target value to use with progress updates.
		/// If the value is negative the target is calculated by looking at the stream.</param>
		/// <remarks>This form is specialised for use within #Zip to support events during archive operations.</remarks>
		static public void Copy(Stream source, Stream destination,
			ubyte[] buffer,
			ProgressHandler progressHandler, TimeSpan updateInterval,
			Object sender, string name, long fixedTarget)
		{
			if (source is null)
			{
				throw new ArgumentNullException(__traits(identifier, source));
			}

			if (destination is null)
			{
				throw new ArgumentNullException(__traits(identifier, destination));
			}

			if (buffer is null)
			{
				throw new ArgumentNullException(__traits(identifier, buffer));
			}

			// Ensure a reasonable size of buffer is used without being prohibitive.
			if (buffer.length < 128)
			{
				throw new ArgumentException("Buffer is too small", __traits(identifier, buffer));
			}

			if (progressHandler is null)
			{
				throw new ArgumentNullException(__traits(identifier, progressHandler));
			}

			bool copying = true;

			DateTime marker = DateTime.Now;
			long processed = 0;
			long target = 0;

			if (fixedTarget >= 0)
			{
				target = fixedTarget;
			}
			else if (source.CanSeek)
			{
				target = source.Length - source.Position;
			}

			// Always fire 0% progress..
			auto args = new ProgressEventArgs(name, processed, target);
			progressHandler(sender, args);

			bool progressFired = true;

			while (copying)
			{
				int bytesRead = source.Read(buffer, 0, cast(int) buffer.length);
				if (bytesRead > 0)
				{
					processed += bytesRead;
					progressFired = false;
					destination.Write(buffer, 0, bytesRead);
				}
				else
				{
					destination.Flush();
					copying = false;
				}

				if (DateTime.Now - marker > updateInterval)
				{
					progressFired = true;
					marker = DateTime.Now;
					args = new ProgressEventArgs(name, processed, target);
					progressHandler(sender, args);

					copying = args.ContinueRunning;
				}
			}

			if (!progressFired)
			{
				args = new ProgressEventArgs(name, processed, target);
				progressHandler(sender, args);
			}
		}

		/// <summary>
		/// Initialise an instance of <see cref="StreamUtils"></see>
		/// </summary>
		private this()
		{
			// Do nothing.
		}
	}
