/**
 * Contains classes used to send electronic _mail to a Simple Mail Transfer Protocol (SMTP) server for delivery.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.net.mail;

import os.win.base.core,
  os.win.base.string,
  os.win.base.text,
  os.win.base.collections,
  os.win.com.core,
  os.win.net.core;
debug import std.io : writefln;

/**
 * The exception thrown when the SmtpClient is unable to complete a send operation.
 */
class SmtpException : Exception {

  this(string message);

}

/**
 */
enum SmtpDeliveryMethod {
  Network,        ///
  PickupDirectory ///
}

// Wrap any exception in SmtpException.
private R invokeMethod(R = VARIANT)(IDispatch target, string name, ...) {
  try {
    return os.win.com.core.invokeMethod!(R)(target, name, _arguments, _argptr);
  }
  catch (Exception e) {
    throw new SmtpException(e.msg);
  }
}

private R getProperty(R = VARIANT)(IDispatch target, string name, ...) {
  try {
    return os.win.com.core.getProperty!(R)(target, name, _arguments, _argptr);
  }
  catch (Exception e) {
    throw new SmtpException(e.msg);
  }
}

private void setProperty(IDispatch target, string name, ...) ;
}

/**
 * Allows applications to send e-mail using the Simple Mail Transfer Protocol (SMTP).
 * Примеры:
 * ---
 * string from = `"Ben" ben@btinternet.com`;
 * string to = `"John" john@gmail.com`;
 * 
 * auto message = new MailMessage(from, to);
 * message.subject = "Re: Last Night";
 * message.bodyText = "Had a blast! Best, Ben.";
 *
 * string host = "smtp.btinternet.com";
 * auto client = new SmtpClient(host);
 *
 * auto credentials = new CredentialCache;
 * credentials.add(client.host, client.port, "Basic", userName, password);
 *
 * client.credentials = credentials;
 *
 * try {
 *   client.send(message);
 * }
 * catch (Exception e) {
 *   writefln("Couldn't send the message: " ~ e.toString());
 * }
 * ---
 */
class SmtpClient {

  private static int defaultPort_ = 25;

  private string host_;
  private int port_;
  private SmtpDeliveryMethod deliveryMethod_;
  private string pickupDirectoryLocation_;
  private ICredentialsByHost credentials_;
  private bool enableSsl_;
  private int timeout_;

  ///
  this() ;
  ///
  this(string host) ;
  ///
  this(string host, int port);
  /// Sends an e-mail _message to an SMTP server for delivery.
  final void send(MailMessage message) ;
  /// ditto
  final void send(string from, string recipients, string subject, string bodyText);
  /// Gets or sets the name or IP address of the _host used to send an e-mail message.
  final void host(string value);
  /// ditto
  final string host() ;
  /// Gets or sets the _port used to send an e-mail message. The default is 25.
  final void port(int value);
  /// ditto
  final int port() ;
  /// Specifies how outgoing e-mail messages will be handled.
  final void deliveryMethod(SmtpDeliveryMethod value) ;
  /// ditto
  final SmtpDeliveryMethod deliveryMethod() ;
  /// Gets or sets the folder where applications save mail messages.
  final void pickupDirectoryLocation(string value) ;
  /// ditto
  final string pickupDirectoryLocation() ;
  /// Gets or sets the _credentials used to authenticate the sender.
  final void credentials(ICredentialsByHost value);
  /// ditto
  final ICredentialsByHost credentials() ;
  /// Specifies whether to use Secure Sockets Layer (SSL) to encrypt the connection.
  final void enableSsl(bool value) ;
  /// ditto
  final bool enableSsl() ;
  /// Gets or sets the amount of time after which a send call times out.
  final void timeout(int value);
  /// ditto
  final int timeout() ;
  private void initialize();

}

/**
 * Represents the address of an electronic mail sender or recipient.
 */
class MailAddress {

  private string address_;
  private string displayName_;
  private string host_;
  private string user_;

  /// Initializes a new instance.
  this(string address);
  /// ditto
  this(string address, string displayName) ;
  bool equals(Object value);
  override string toString() ;
  /// Gets the e-mail _address specified.
  final string address() ;
  /// Gets the display name specified.
  final string displayName();
  /// Gets the user information from the address specified.
  final string user() ;
  /// Gets the host portion of the address specified.
  final string host() ;
  private void parse(string address);

}

/**
 * Stores e-mail addresses associated with an e-mail message.
 */
class MailAddressCollection : Collection!(MailAddress) {

  override string toString() ;

}

class NameValueCollection {

  private string[string] nameAndValue_;

  void add(string name, string value) ;
  string get(string name);
  void set(string name, string value);
  int count() ;
  void opIndexAssign(string value, string name);
  string opIndex(string name);
  int opApply(int delegate(ref string) action) ;
  int opApply(int delegate(ref string, ref string) action);

}

enum TransferEncoding {
  Unknown = -1,
  QuotedPrintable = 0,
  Base64 = 1,
  SevenBit = 2
}

/**
 * Represents an e-mail attachment.
 */
class Attachment {

  private string fileName_;
  private TransferEncoding transferEncoding_ = TransferEncoding.Unknown;

  /// Initializes a new instance.
  this(string fileName) ;
  /// Gets or sets the name of the attachment file.
  final void fileName(string value) ;
  /// ditto
  final string fileName() ;
  /// Gets or sets the type of encoding of this attachment.
  final void transferEncoding(TransferEncoding value);
  /// ditto
  final TransferEncoding transferEncoding() ;

}

/**
 * Stores attachments to be sent as part of an e-mail message.
 */
class AttachmentCollection : Collection!(Attachment) {
}

/**
 */
enum MailPriority {
  Normal, ///
  Low,    ///
  High    ///
}

/**
 * Represents an e-mail message that can be sent using the SmtpClient class.
 */
class MailMessage {

  private MailAddress from_;
  private MailAddress sender_;
  private MailAddress replyTo_;
  private MailAddressCollection to_;
  private MailAddressCollection cc_;
  private MailAddressCollection bcc_;
  private MailPriority priority_;
  private string subject_;
  private NameValueCollection headers_;
  private string bodyText_;
  private bool isBodyHtml_;
  private Encoding bodyEncoding_;
  private AttachmentCollection attachments_;

  /// Initializes a new instance.
  this() ;
  /// ditto
  this(string from, string to);
  /// ditto
  this(string from, string to, string subject, string bodyText);
  /// ditto
  this(MailAddress from, MailAddress to) ;
  /// Gets or sets the _from address.
  final void from(MailAddress value) ;
  /// ditto
  final MailAddress from() ;
  /// Gets or sets the sender's address.
  final void sender(MailAddress value);
  /// ditto
  final MailAddress sender() ;
  /// Gets or sets the ReplyTo address.
  final void replyTo(MailAddress value) ;
  /// ditto
  final MailAddress replyTo() ;
  /// Gets the address collection containing the recipients.
  final MailAddressCollection to() ;
  /// Gets the address collection containing the carbon copy (CC) recipients.
  final MailAddressCollection cc() ;
  /// Gets the address collection containing the blind carbon copy (BCC) recipients.
  final MailAddressCollection bcc() ;
  /// Gets or sets the _priority.
  final void priority(MailPriority value) ;
  /// ditto
  final MailPriority priority() ;
  /// Gets or sets the _subject line.
  final void subject(string value) ;
  /// ditto
  final string subject() ;
  /// Gets the e-mail _headers.
  final NameValueCollection headers();
  /// Gets or sets the message body.
  final void bodyText(string value);
  /// ditto
  final string bodyText() ;
  /// Gets or sets whether the mail message body is in HTML.
  final void isBodyHtml(bool value) ;
  /// ditto
  final bool isBodyHtml() ;
  /// Gets or sets the encoding used to encode the message body.
  final void bodyEncoding(Encoding value) ;
  /// ditto
  final Encoding bodyEncoding() ;
  /// Gets the attachment collection used to store data attached to this e-mail message.
  final AttachmentCollection attachments() ;

}
