import System;
import System.Runtime.Serialization;

import ICSharpCode.SharpZipLib;

	/// <summary>
	/// SharpZipBaseException is the base exception class for SharpZipLib.
	/// All library exceptions are derived from this.
	/// </summary>
	/// <remarks>NOTE: Not all exceptions thrown will be derived from this class.
	/// A variety of other exceptions are possible for example <see cref="ArgumentNullException"></see></remarks>
	//[Serializable]
	public class SharpZipBaseException : BaseException
	{
		/// <summary>
		/// Initializes a new instance of the SharpZipBaseException class.
		/// </summary>
		public this()
		{
		}

		/// <summary>
		/// Initializes a new instance of the SharpZipBaseException class with a specified error message.
		/// </summary>
		/// <param name="message">A message describing the exception.</param>
		public this(string message)
		{
			super(message);
		}

		/// <summary>
		/// Initializes a new instance of the SharpZipBaseException class with a specified
		/// error message and a reference to the inner exception that is the cause of this exception.
		/// </summary>
		/// <param name="message">A message describing the exception.</param>
		/// <param name="innerException">The inner exception</param>
		public this(string message, BaseException innerException)
		{
			super(message, innerException);
		}

		/// <summary>
		/// Initializes a new instance of the SharpZipBaseException class with serialized data.
		/// </summary>
		/// <param name="info">
		/// The System.Runtime.Serialization.SerializationInfo that holds the serialized
		/// object data about the exception being thrown.
		/// </param>
		/// <param name="context">
		/// The System.Runtime.Serialization.StreamingContext that contains contextual information
		/// about the source or destination.
		/// </param>
		protected this(SerializationInfo info, StreamingContext context)
		{
			super(info, context);
		}
	}
