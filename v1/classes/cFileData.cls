VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFileData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
Private Const FOLDER_DELIMITER = "\"
Private Const ALL_FILES = "*.*"


Private Const Z_VERSION_ERROR = -6
Private Const Z_BUF_ERROR = -5
Private Const Z_MEM_ERROR = -4
Private Const Z_DATA_ERROR = -3
Private Const Z_STREAM_ERROR = -2
Private Const Z_ERRNO = -1
Private Const Z_OK = 0
Private Const Z_STREAM_END = 1
Private Const Z_NEED_DICT = 2

Private Type FileStructure
    Compressed          As Boolean
    FileSpec            As String
    UnCompressedSize    As Long
    CompressedSize      As Long
End Type





Private m_Contents  As FileStructure
Private m_Data()    As Byte
Private m_Err       As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDst As Any, pSrc As Any, ByVal ByteLen As Long)
Private Declare Function Zed Lib "zlib.dll" Alias "compress" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Private Declare Function UnZed Lib "zlib.dll" Alias "uncompress" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Private Function DecompressData(UncompressedData() As Byte, Size As Long) As Boolean
Dim NuSize As Long
Dim Result As Long

With m_Contents
    'caclulate a size for the temp buffer
    NuSize = .UnCompressedSize + (.UnCompressedSize * 0.01) + 12
    'create the buffer
    ReDim UncompressedData(NuSize)
    
    'Decompress data
    Result = UnZed(UncompressedData(0), NuSize, m_Data(0), .CompressedSize)
    
    'if succesful
    If Result = Z_OK Then
        ReDim Preserve UncompressedData(NuSize - 1)
        Size = NuSize
        DecompressData = True
    Else
       ReDim UncompressedData(0)
       Size = 0
       DecompressData = False
    End If
    
    'preserve error code if any
    m_Err = Result
End With
End Function


Public Function CompressData() As Boolean
Dim NuSize      As Long
Dim Buffer()    As Byte
Dim Result      As Long

With m_Contents
    NuSize = .UnCompressedSize + (.UnCompressedSize * 0.01) + 12
    ReDim Buffer(NuSize)
    
    'Compress data
    Result = Zed(Buffer(0), NuSize, m_Data(0), .UnCompressedSize)
    
    If Result = Z_OK Then
        'Set compressed size
        .CompressedSize = NuSize
        'Truncate m_Data to compressed size
        ReDim Preserve m_Data(NuSize - 1)
        'copy the compressed data back to m_Data
        CopyMemory m_Data(0), Buffer(0), NuSize
        'say compressed
        .Compressed = True
    Else
        'reset compressed size
        .CompressedSize = 0
        'say not compressed
        .Compressed = False
    End If
    
    'cleanup
    Erase Buffer
    'preserve error if any
    m_Err = Result
    'return success or failure
    CompressData = .Compressed
End With
End Function


Public Property Get errorcode() As Long
errorcode = m_Err
End Property

Friend Function ExtractToFile(ByVal FileSpec As String, Optional ByVal OverWrite As Boolean = False) As Boolean
On Error GoTo NoExtract

'if the file exists
If FileExists(FileSpec) Then
    'if overwrite
    If OverWrite Then
        'remove the existing file
        Kill FileSpec
    Else
        'exit saying the file wasn't written
        ExtractToFile = False
        Exit Function
    End If
End If

'write the file the file
Open FileSpec For Binary As #1

If m_Contents.Compressed Then
    Dim Buffer()    As Byte
    Dim Length      As Long

    If DecompressData(Buffer(), Length) Then
        Put #1, , Buffer
        Erase Buffer
    End If
Else
    Put #1, , m_Data
End If
  
Close

'say success
ExtractToFile = True
Exit Function

NoExtract:
'say failure
ExtractToFile = False
Close

End Function

Friend Function ExtractToFolder(ByVal Path As String, Optional ByVal OverWrite As Boolean = False) As Boolean
If Not FolderExists(Path) Then Exit Function
ExtractToFolder = ExtractToFile(BuildPath(Path, FileName), OverWrite)

End Function

Friend Function ExtractToSource(Optional ByVal OverWrite As Boolean = False) As Boolean
If Not FolderExists(ParentFolder) Then Exit Function
ExtractToSource = ExtractToFile(m_Contents.FileSpec, OverWrite)
End Function
Private Function FolderExists(ByVal FolderSpec As String) As Boolean
If FolderSpec = vbNullString Then Exit Function
Dim s As String

s = FolderSpec

If Mid(s, Len(s) - 1, 1) <> FOLDER_DELIMITER Then
    s = s & FOLDER_DELIMITER & ALL_FILES
Else
    s = s & ALL_FILES
End If

On Error Resume Next

FolderExists = Not (Dir(s, vbDirectory) = vbNullString)
If Err.Number <> 0 Then FolderExists = False

On Error GoTo 0
End Function


Public Property Get ParentFolder() As String
Dim ix As Long

If m_Contents.FileSpec = vbNullString Then Exit Property

ix = InStrRev(m_Contents.FileSpec, FOLDER_DELIMITER)
If ix > 0 Then
    ParentFolder = Mid(m_Contents.FileSpec, 1, ix)
Else
    ix = InStrRev(m_Contents.FileSpec, ":")
    If ix > 0 Then ParentFolder = Mid(m_Contents.FileSpec, 1, ix) & FOLDER_DELIMITER
End If
End Property

Private Function BuildPath(ByVal FPath As String, ByVal FName As String) As String
If (FName = vbNullString) Or (FPath = vbNullString) Then Err.Raise 5

If Mid(FPath, Len(FPath) - 1, 1) <> FOLDER_DELIMITER Then
    BuildPath = FPath & FOLDER_DELIMITER & FName
Else
    BuildPath = FPath & FName
End If
End Function
Public Function Load(ByVal FileSpec As String, Optional ByVal Compress As Boolean = False) As Boolean
Dim Buffer As Long

On Error GoTo NoLoad

m_Contents.FileSpec = FileSpec

Open FileSpec For Binary As #1
ReDim m_Data(LOF(1) - 1)
Get #1, , m_Data
Close

'set uncompressed size
m_Contents.UnCompressedSize = UBound(m_Data) + 1

'handle compression
m_Contents.Compressed = Compress
If Compress Then CompressData

'say success
Load = True
Exit Function

NoLoad:
Close
Erase m_Data()

'reset sizes
m_Contents.UnCompressedSize = 0
m_Contents.CompressedSize = 0

m_Contents.FileSpec = vbNullString
Load = False
End Function





Public Property Get Size() As Long
Size = m_Contents.UnCompressedSize
End Property


Public Property Get CompressedSize() As Long
CompressedSize = m_Contents.CompressedSize
End Property
Private Function FileExists(ByVal FileSpec As String) As Boolean
If FileSpec = vbNullString Then Exit Function

On Error Resume Next
FileExists = Not (Dir(FileSpec, (vbArchive Or vbHidden Or vbReadOnly Or vbSystem)) = vbNullString)
If Err.Number Then FileExists = False
On Error GoTo 0
End Function



Public Property Get FileName() As String
If m_Contents.FileSpec = vbNullString Then Exit Property
FileName = Mid$(m_Contents.FileSpec, InStrRev(m_Contents.FileSpec, FOLDER_DELIMITER) + 1)
End Property

Public Property Get FileSpec() As String
FileSpec = m_Contents.FileSpec
End Property

Public Property Get SizeString() As String
SizeString = SizeToString(m_Contents.UnCompressedSize)
End Property

Public Property Get CompressedSizeString() As String
If m_Contents.Compressed Then
    CompressedSizeString = SizeToString(m_Contents.CompressedSize)
Else
    CompressedSizeString = "n/a"
End If
End Property
Private Function SizeToString(ByVal Size As Long) As String
If Size < 1024 Then
    SizeToString = CStr(Size) & " byte" & IIf(Size = 1, vbNullString, "s")
Else
    SizeToString = Format((Size / 1024), "######.# Kb.")
End If
End Function


Public Function ToString() As String
Dim ix          As Long
Dim Buffer()    As Byte
Dim Length      As Long
    
If m_Contents.Compressed Then
    If DecompressData(Buffer(), Length) Then
        ToString = ""
        For ix = 1 To Length        ' DDedit was Space$
            ToString = ToString & " "
        Next ix
        For ix = 1 To Length
            Mid$(ToString, ix, 1) = Chr$(Buffer(ix - 1))
        Next
        Erase Buffer
    End If
Else
    For ix = 1 To m_Contents.UnCompressedSize      ' DDedit was Space$
        ToString = ToString & " "
    Next ix
    For ix = 1 To m_Contents.UnCompressedSize
        Mid$(ToString, ix, 1) = Chr$(m_Data(ix - 1))
    Next
End If
End Function

Public Property Get Extension() As String
Dim ix As Long

Extension = vbNullString
If m_Contents.FileSpec = vbNullString Then Exit Property

ix = InStrRev(FileSpec, ".")
If ix > 0 Then Extension = Mid$(FileSpec, ix)

End Property
Public Function WriteToPackedFile(ByVal BufferNumber As Long) As Boolean
'Assumes file has been open for binary access as BufferNumber
On Error GoTo NoWrite

Put #BufferNumber, , m_Contents
'Debug.Print m_Contents.UnCompressedSize, m_Contents.CompressedSize
Put #BufferNumber, , m_Data
WriteToPackedFile = True
Exit Function

NoWrite:
WriteToPackedFile = False
End Function

Public Function ReadFromPackedFile(ByVal BufferNumber As Long) As Boolean
'Assumes file has been open for binary access as BufferNumber
On Error GoTo NoRead

'first get all the file info
Get #BufferNumber, , m_Contents
With m_Contents
    'resize the buffer accordingly
    ReDim m_Data(IIf(.Compressed, .CompressedSize - 1, .UnCompressedSize - 1))
End With
'get the file data
Get #BufferNumber, , m_Data()
ReadFromPackedFile = True
Exit Function

NoRead:
ReadFromPackedFile = False
End Function
Private Sub Class_Terminate()
Erase m_Data()
End Sub



Public Property Get Key() As String
Key = m_Contents.FileSpec
End Property

Public Property Let Key(ByVal s As String)
m_Contents.FileSpec = s
End Property

Public Property Get Compressed() As Boolean
Compressed = m_Contents.Compressed
End Property

Public Property Let Compressed(ByVal b As Boolean)
'if no change exit
If (m_Contents.Compressed = b) Then Exit Property

If b Then 'compress data
    'NOTE: m_Contents.Compressed is set according to success of CompressData function
    'in the CompressData function
    CompressData
Else 'decompress data
    'NOTE: m_Contents.Compressed is not affected by DecompressData function
    Dim Buffer()    As Byte
    Dim Length      As Long
    
    If DecompressData(Buffer(), Length) Then
        'if success then resize m_Data adjusting for zero base
        ReDim m_Data(Length - 1)
        'copy the uncompressed contents
        CopyMemory m_Data(0), Buffer(0), Length
        'cleanup
        Erase Buffer
        'say not compressed anymore
        m_Contents.Compressed = False
        'save new data sizes
        m_Contents.CompressedSize = 0
        m_Contents.UnCompressedSize = Length
    End If
End If
End Property

