
import System : BaseException;
import System.Runtime.Serialization : SerializationInfo, StreamingContext;

import ICSharpCode.SharpZipLib;

	/// <summary>
	/// Indicates that a value was outside of the expected range when decoding an input stream
	/// </summary>
	//[Serializable]
	public class ValueOutOfRangeException : StreamDecodingException
	{
		/// <summary>
		/// Initializes a new instance of the ValueOutOfRangeException class naming the the causing variable
		/// </summary>
		/// <param name="nameOfValue">Name of the variable, use: nameof()</param>
		public this(string nameOfValue)
		{
			import std.string : format;
			super("%s out of range".format(nameOfValue));
		}

		/// <summary>
		/// Initializes a new instance of the ValueOutOfRangeException class naming the the causing variable,
		/// it's current value and expected range.
		/// </summary>
		/// <param name="nameOfValue">Name of the variable, use: nameof()</param>
		/// <param name="value">The invalid value</param>
		/// <param name="maxValue">Expected maximum value</param>
		/// <param name="minValue">Expected minimum value</param>
		public this(string nameOfValue, long value, long maxValue, long minValue = 0)
		{
			import std.string : format;
			this(nameOfValue, "%s".format(value), "%s".format(maxValue), "%s".format(minValue));
		}

		/// <summary>
		/// Initializes a new instance of the ValueOutOfRangeException class naming the the causing variable,
		/// it's current value and expected range.
		/// </summary>
		/// <param name="nameOfValue">Name of the variable, use: nameof()</param>
		/// <param name="value">The invalid value</param>
		/// <param name="maxValue">Expected maximum value</param>
		/// <param name="minValue">Expected minimum value</param>
		public this(string nameOfValue, string value, string maxValue, string minValue = "0")
		{
			import std.string : format;
			super("%s out of range: %s, should be %s..%s".format(nameOfValue, value, minValue, maxValue));
		}

		private this()
		{
		}

		private this(string message, BaseException innerException)
		{
			super(message, innerException);
		}

		/// <summary>
		/// Initializes a new instance of the ValueOutOfRangeException class with serialized data.
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
