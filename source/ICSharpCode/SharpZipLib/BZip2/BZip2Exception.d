
import System : BaseException;
import System.Runtime.Serialization : SerializationInfo, StreamingContext;
import ICSharpCode.SharpZipLib : SharpZipBaseException;

import ICSharpCode.SharpZipLib.BZip2;

	/// <summary>
	/// BZip2Exception represents exceptions specific to BZip2 classes and code.
	/// </summary>
	//[Serializable]
	public class BZip2Exception : SharpZipBaseException
	{
		/// <summary>
		/// Initialise a new instance of <see cref="BZip2Exception" />.
		/// </summary>
		public this()
		{
		}

		/// <summary>
		/// Initialise a new instance of <see cref="BZip2Exception" /> with its message string.
		/// </summary>
		/// <param name="message">A <see cref="string"/> that describes the error.</param>
		public this(string message)
		{
			super(message);
		}

		/// <summary>
		/// Initialise a new instance of <see cref="BZip2Exception" />.
		/// </summary>
		/// <param name="message">A <see cref="string"/> that describes the error.</param>
		/// <param name="innerException">The <see cref="BaseException"/> that caused this exception.</param>
		public this(string message, BaseException innerException)
		{
			super(message, innerException);
		}

		/// <summary>
		/// Initializes a new instance of the BZip2Exception class with serialized data.
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
