
import System : BaseException;
import System.Runtime.Serialization : SerializationInfo, StreamingContext;

import ICSharpCode.SharpZipLib;

	/// <summary>
	/// Indicates that an error occured during decoding of a input stream due to corrupt
	/// data or (unintentional) library incompability.
	/// </summary>
	//[Serializable]
	public class StreamDecodingException : SharpZipBaseException
	{
		private const string GenericMessage = "Input stream could not be decoded";

		/// <summary>
		/// Initializes a new instance of the StreamDecodingException with a generic message
		/// </summary>
		public this() { super(GenericMessage); }

		/// <summary>
		/// Initializes a new instance of the StreamDecodingException class with a specified error message.
		/// </summary>
		/// <param name="message">A message describing the exception.</param>
		public this(string message) { super(message); }

		/// <summary>
		/// Initializes a new instance of the StreamDecodingException class with a specified
		/// error message and a reference to the inner exception that is the cause of this exception.
		/// </summary>
		/// <param name="message">A message describing the exception.</param>
		/// <param name="innerException">The inner exception</param>
		public this(string message, BaseException innerException) { super(message, innerException); }

		/// <summary>
		/// Initializes a new instance of the StreamDecodingException class with serialized data.
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
