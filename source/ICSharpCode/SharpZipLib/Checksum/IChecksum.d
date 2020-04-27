
import System : ArraySegment, ArgumentNullException;

import ICSharpCode.SharpZipLib.Checksum;

	/// <summary>
	/// Interface to compute a data checksum used by checked input/output streams.
	/// A data checksum can be updated by one ubyte or with a ubyte array. After each
	/// update the value of the current checksum can be returned by calling
	/// <code>getValue</code>. The complete checksum object can also be reset
	/// so it can be used again with new data.
	/// </summary>
	public interface IChecksum
	{
		/// <summary>
		/// Resets the data checksum as if no update was ever called.
		/// </summary>
		void Reset();

		/// <summary>
		/// Returns the data checksum computed so far.
		/// </summary>
		long Value();
/*
		{
			get;
		}
*/

		/// <summary>
		/// Adds one ubyte to the data checksum.
		/// </summary>
		/// <param name = "bval">
		/// the data value to add. The high ubyte of the int is ignored.
		/// </param>
		void Update(int bval);

		/// <summary>
		/// Updates the data checksum with the bytes taken from the array.
		/// </summary>
		/// <param name="buffer">
		/// buffer an array of bytes
		/// </param>
		void Update(ubyte[] buffer);

		/// <summary>
		/// Adds the ubyte array to the data checksum.
		/// </summary>
		/// <param name = "segment">
		/// The chunk of data to add
		/// </param>
		void Update(ArraySegment!ubyte segment);
	}
