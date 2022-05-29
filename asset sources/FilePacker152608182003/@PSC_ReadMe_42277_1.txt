Title: FilePacker
Description: This project is an extension of the idea previously introduced by James J. Kelly Jr.
 (http://www.planet-source-code.com/vb/scripts/ShowCode.asp?lngWId=1&txtCodeId=42171).
I have taken his idea a step further by encapsulating the packed file code in two classes, cPackedFile, a collection class and cFileData which actually stores the file data. I have also added compression to the file using the freely available zlib.dll.
The zlib.dll is included in the zip file as "zlib.dlx" to avoid it being stripped from the file. Simply rename it to "zlib.dll" and place it into the system folder.
NOTE: This application has only been tested with version 1.1.2.0 of the zlib.dll which is the included version.
The demo application is a packed file manager capable of creating, extracting and launching packed files. It too includes many useful functions.
This file came from Planet-Source-Code.com...the home millions of lines of source code
You can view comments on this code/and or vote on it at: http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=42277&lngWId=1

The author may have retained certain copyrights to this code...please observe their request and the law by reviewing all copyright conditions at the above URL.
