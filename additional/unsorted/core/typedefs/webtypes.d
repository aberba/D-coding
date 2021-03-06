/******************************************************************//**
 * \file src/core/typedefs/webtypes.d
 * \brief Typedefs and structs for HTTP and such
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.webtypes;

import std.stdio, std.conv, core.memory;

//! Enum of all possible HTTP request methods
enum RequestMethod { OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT, UNKNOWN }

//! Internal representation of an HTTP Request
struct Request{
  RequestMethod method;  //!< HTTP RequestMethod used by the Request
  string uri;            //!< URI requested
}

//! Internal representation of an HTTP Header
struct Header{
  string name;           //!< HTTP header name
  string value;          //!< Value of header with name
}

//! Internal representation of an HTTP ResponseStatus
struct ResponseStatus{
  uint   code;              //!< HTTP response code
  string reason;            //!< Reason of the code (if there was an error)
  string description;       //!< Description of the reason (if there was an error)
}

immutable string CRLF = "\r\n";
immutable string HTTP_VERSION_1_1 = "HTTP/1.1";
immutable string HTTP_VERSION_1_0 = "HTTP/1.0";

immutable ResponseStatus
  STATUS_OK =                     {200, "OK" , ""},
  STATUS_UNAUTHORIZED =           {401, "Unauthorized" , "\t\t<blockquote>\n" ~
                                        "\t\t\tThe URL you've requested, requires a correct username and password<br>\n" ~
                                        "\t\t\tEither you entered an incorrect username/password, or your browser doesn't support this feature.<br>\n" ~
                                        "\t\t\tPlease inform the administrator of the referring page, if you think this was a mistake.\n" ~
                                        "\t\t</blockquote>\n"},
  STATUS_FORBIDDEN =              {403, "Forbidden" , "\t\t<blockquote>\n" ~
                                        "\t\t\tYou do not have permission to retrieve the URL or link you requested<br>\n" ~
                                        "\t\t\tPlease inform the administrator of the referring page, if you think this was a mistake.\n" ~
                                        "\t\t</blockquote>\n"},                                              
  STATUS_PAGE_NOT_FOUND =         {404, "Not found", "\t\t<blockquote>\n" ~
                                        "\t\t\tThe requested object or URL is not found on this server.<br>\n" ~
                                        "\t\t\tThe link you followed is either outdated, inaccurate, or the server has been instructed not to let you have it.<br>\n" ~
                                        "\t\t\tPlease inform the administrator of the referring page,  <a href='<!--#echo var=\"HTTP_REFERER\"-->'><!--#echo var=\"HTTP_REFERER\"--></a>.\n" ~
                                        "\t\t</blockquote>\n"},
  STATUS_INTERNAL_ERROR =         {500, "Internal Server Error", 
                                        "\t\t<blockquote>\n" ~
                                        "\t\t\tThe server encountered an internal error or misconfiguration and was unable to complete your request.<br>\n" ~
                                        "\t\t\tPlease inform the administrator of the referring page, and inform them of anything you might have done that may have caused the error.\n" ~
                                        "\t\t</blockquote>\n"},
  STATUS_NOT_IMPLEMENTED =        {501, "Not implemented", 
                                        "\t\t<blockquote>\n" ~
                                        "\t\t\tThe server either does not recognise the request method, or it lacks the ability to fulfill the request.<br>\n" ~
                                        "\t\t\tPlease inform the administrator of the referring page, and inform them of anything you might have done that may have caused the error.\n" ~
                                        "\t\t</blockquote>\n"},
  STATUS_VERSION_NOT_SUPPORTED =  {505, "HTTP Version Not Supported",
                                        "\t\t<blockquote>\n" ~
                                        "\t\t\tThe server does not support the HTTP protocol version used in the request.<br>\n" ~
                                        "\t\t</blockquote>\n"};
