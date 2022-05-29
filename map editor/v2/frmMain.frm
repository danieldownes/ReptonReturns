VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Repton Returns Editor v2 : Ex-D Software Development(TM)"
   ClientHeight    =   8640
   ClientLeft      =   60
   ClientTop       =   645
   ClientWidth     =   11505
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   8640
   ScaleWidth      =   11505
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.HScrollBar HScrollMap 
      Height          =   255
      Left            =   3000
      TabIndex        =   6
      Top             =   7320
      Width           =   8055
   End
   Begin VB.VScrollBar VScrollMap 
      Height          =   6975
      Left            =   11040
      Max             =   1
      TabIndex        =   5
      Top             =   240
      Width           =   255
   End
   Begin VB.Frame fraMapContainer 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Caption         =   "Frame1"
      Height          =   6855
      Left            =   3000
      TabIndex        =   2
      Top             =   240
      Width           =   7935
      Begin VB.PictureBox picMapHolder 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   5355
         Left            =   120
         ScaleHeight     =   5325
         ScaleWidth      =   6225
         TabIndex        =   3
         Top             =   120
         Width           =   6255
         Begin VB.PictureBox picPiece 
            BackColor       =   &H00E0E0E0&
            BorderStyle     =   0  'None
            FillColor       =   &H00FFFFFF&
            Height          =   255
            Index           =   0
            Left            =   240
            ScaleHeight     =   255
            ScaleWidth      =   255
            TabIndex        =   4
            Top             =   240
            Visible         =   0   'False
            Width           =   255
         End
         Begin VB.Shape shpScenery 
            BorderColor     =   &H0000FF00&
            BorderWidth     =   2
            Height          =   255
            Left            =   960
            Top             =   240
            Width           =   255
         End
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   3000
      Top             =   9360
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
   End
   Begin MSComctlLib.StatusBar StatusBar 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   8265
      Width           =   11505
      _ExtentX        =   20294
      _ExtentY        =   661
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
      EndProperty
   End
   Begin VB.VScrollBar VScrollPanels 
      Height          =   7470
      LargeChange     =   350
      Left            =   2805
      Max             =   0
      SmallChange     =   350
      TabIndex        =   0
      Top             =   75
      Width           =   150
   End
   Begin VB.Frame fraPanelContainer 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   13935
      Left            =   120
      TabIndex        =   7
      Top             =   0
      Width           =   2655
      Begin VB.Frame frmLeftInput 
         BackColor       =   &H00FFFFFF&
         Caption         =   " < - >  :  Debugging "
         Height          =   1935
         Index           =   5
         Left            =   0
         TabIndex        =   55
         Top             =   11640
         Width           =   2655
         Begin VB.CommandButton cmdTestLevel 
            Caption         =   "Test level now"
            Height          =   255
            Left            =   240
            TabIndex        =   57
            Top             =   1440
            Width           =   2100
         End
         Begin VB.TextBox txtDebugToDo 
            Height          =   1050
            Left            =   120
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   56
            Text            =   "frmMain.frx":014A
            Top             =   285
            Width           =   2415
         End
      End
      Begin VB.Frame frmLeftInput 
         BackColor       =   &H00FFFFFF&
         Caption         =   " < - >  :  Piece Types"
         Height          =   3495
         Index           =   3
         Left            =   0
         TabIndex        =   41
         Top             =   5040
         Width           =   2655
         Begin VB.CommandButton cmdSceneryAdd 
            Caption         =   "+"
            Height          =   255
            Left            =   135
            TabIndex        =   50
            Top             =   2265
            Width           =   255
         End
         Begin VB.PictureBox picPieceType 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            ForeColor       =   &H80000008&
            Height          =   255
            Index           =   0
            Left            =   120
            ScaleHeight     =   225
            ScaleWidth      =   225
            TabIndex        =   49
            Top             =   240
            Visible         =   0   'False
            Width           =   255
         End
         Begin VB.CommandButton cmdFillAll 
            Caption         =   "Clear with selected"
            Height          =   255
            Left            =   240
            TabIndex        =   48
            Top             =   1560
            Width           =   2130
         End
         Begin VB.CommandButton cmdSceneryMesh 
            Caption         =   "Mesh File"
            Height          =   255
            Left            =   240
            TabIndex        =   47
            Top             =   2640
            Width           =   1095
         End
         Begin VB.CommandButton cmdSceneryTex 
            Caption         =   "Texture File"
            Height          =   255
            Left            =   1320
            TabIndex        =   46
            Top             =   2640
            Width           =   1095
         End
         Begin VB.CheckBox chkSceneryMovableTo 
            BackColor       =   &H00FFFFFF&
            Caption         =   "Is movable to"
            Height          =   255
            Left            =   1200
            TabIndex        =   45
            Top             =   2280
            Width           =   1335
         End
         Begin VB.CommandButton cmdSceneryDel 
            Caption         =   "-"
            Height          =   255
            Left            =   375
            TabIndex        =   44
            Top             =   2265
            Width           =   255
         End
         Begin VB.CommandButton cmdSceneryPrev 
            Caption         =   "<"
            Height          =   255
            Left            =   615
            TabIndex        =   43
            Top             =   2265
            Width           =   255
         End
         Begin VB.CommandButton cmdSceneryNext 
            Caption         =   ">"
            Height          =   255
            Left            =   855
            TabIndex        =   42
            Top             =   2265
            Width           =   255
         End
         Begin MSComctlLib.ImageList ImgLstPieceTypes 
            Left            =   1080
            Top             =   240
            _ExtentX        =   1005
            _ExtentY        =   1005
            BackColor       =   -2147483643
            ImageWidth      =   16
            ImageHeight     =   16
            MaskColor       =   12632256
            _Version        =   393216
            BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
               NumListImages   =   34
               BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0153
                  Key             =   ""
               EndProperty
               BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0265
                  Key             =   ""
               EndProperty
               BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0377
                  Key             =   ""
               EndProperty
               BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0489
                  Key             =   ""
               EndProperty
               BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":059B
                  Key             =   ""
               EndProperty
               BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":06AD
                  Key             =   ""
               EndProperty
               BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":07BF
                  Key             =   ""
               EndProperty
               BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":08D1
                  Key             =   ""
               EndProperty
               BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":09E3
                  Key             =   ""
               EndProperty
               BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0AF5
                  Key             =   ""
               EndProperty
               BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0C07
                  Key             =   ""
               EndProperty
               BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0D19
                  Key             =   ""
               EndProperty
               BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0E2B
                  Key             =   ""
               EndProperty
               BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":0F3D
                  Key             =   ""
               EndProperty
               BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":104F
                  Key             =   ""
               EndProperty
               BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1161
                  Key             =   ""
               EndProperty
               BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1273
                  Key             =   ""
               EndProperty
               BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1385
                  Key             =   ""
               EndProperty
               BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1497
                  Key             =   ""
               EndProperty
               BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":15A9
                  Key             =   ""
               EndProperty
               BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":16BB
                  Key             =   ""
               EndProperty
               BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":17CD
                  Key             =   ""
               EndProperty
               BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":18DF
                  Key             =   ""
               EndProperty
               BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":19F1
                  Key             =   ""
               EndProperty
               BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1B03
                  Key             =   ""
               EndProperty
               BeginProperty ListImage26 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1C15
                  Key             =   ""
               EndProperty
               BeginProperty ListImage27 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1D27
                  Key             =   ""
               EndProperty
               BeginProperty ListImage28 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1E39
                  Key             =   ""
               EndProperty
               BeginProperty ListImage29 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":1F4B
                  Key             =   ""
               EndProperty
               BeginProperty ListImage30 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":205D
                  Key             =   ""
               EndProperty
               BeginProperty ListImage31 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":216F
                  Key             =   ""
               EndProperty
               BeginProperty ListImage32 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":2281
                  Key             =   ""
               EndProperty
               BeginProperty ListImage33 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":2393
                  Key             =   ""
               EndProperty
               BeginProperty ListImage34 {2C247F27-8591-11D1-B16A-00C0F0283628} 
                  Picture         =   "frmMain.frx":24A5
                  Key             =   ""
               EndProperty
            EndProperty
         End
         Begin VB.Line Line1 
            BorderColor     =   &H80000003&
            BorderWidth     =   2
            X1              =   120
            X2              =   2520
            Y1              =   1920
            Y2              =   1920
         End
         Begin VB.Label lblSceneryPieceNo 
            BackStyle       =   0  'Transparent
            Caption         =   "#1"
            Height          =   255
            Left            =   1350
            TabIndex        =   54
            Top             =   1995
            Width           =   855
         End
         Begin VB.Label Label2 
            BackStyle       =   0  'Transparent
            Caption         =   "Scenery piece"
            Height          =   255
            Left            =   150
            TabIndex        =   53
            Top             =   1980
            Width           =   1245
         End
         Begin VB.Label lblSceneryMeshFile 
            Alignment       =   1  'Right Justify
            BackStyle       =   0  'Transparent
            Caption         =   "<mesh file>"
            Height          =   255
            Left            =   240
            TabIndex        =   52
            Top             =   2910
            Width           =   2085
         End
         Begin VB.Label lblSceneryTexFile 
            Alignment       =   1  'Right Justify
            BackStyle       =   0  'Transparent
            Caption         =   "<texture file>"
            Height          =   255
            Left            =   240
            TabIndex        =   51
            Top             =   3135
            Width           =   2085
         End
      End
      Begin VB.Frame frmLeftInput 
         BackColor       =   &H00FFFFFF&
         Caption         =   " < - >  :  In-game Messages "
         Height          =   2880
         Index           =   4
         Left            =   0
         TabIndex        =   32
         Top             =   8640
         Width           =   2655
         Begin VB.TextBox txtGameMsgText 
            Height          =   1935
            Left            =   120
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   38
            Text            =   "frmMain.frx":25B7
            Top             =   840
            Width           =   2415
         End
         Begin VB.CommandButton cmdGameMsgTrigTog 
            Caption         =   "Add/Delete"
            Height          =   255
            Left            =   1320
            TabIndex        =   37
            Top             =   480
            Width           =   1095
         End
         Begin VB.CommandButton cmdGameMsgAdd 
            Caption         =   "+"
            Height          =   255
            Left            =   120
            TabIndex        =   36
            Top             =   480
            Width           =   255
         End
         Begin VB.CommandButton cmdGameMsgDel 
            Caption         =   "-"
            Height          =   255
            Left            =   360
            TabIndex        =   35
            Top             =   480
            Width           =   255
         End
         Begin VB.CommandButton cmdGameMsgPrev 
            Caption         =   "<"
            Height          =   255
            Left            =   600
            TabIndex        =   34
            Top             =   480
            Width           =   255
         End
         Begin VB.CommandButton cmdGameMsgNext 
            Caption         =   ">"
            Height          =   255
            Left            =   840
            TabIndex        =   33
            Top             =   480
            Width           =   255
         End
         Begin VB.Label lblGameMsgNo 
            BackStyle       =   0  'Transparent
            Caption         =   "#1"
            Height          =   255
            Left            =   240
            TabIndex        =   40
            Top             =   240
            Width           =   855
         End
         Begin VB.Label lblGameMsgTrig 
            BackStyle       =   0  'Transparent
            Caption         =   "Triggers:"
            Height          =   255
            Left            =   1320
            TabIndex        =   39
            Top             =   240
            Width           =   615
         End
      End
      Begin VB.Frame frmLeftInput 
         BackColor       =   &H00FFFFFF&
         Caption         =   " < - >  :  Level Globals "
         Height          =   1935
         Index           =   2
         Left            =   0
         TabIndex        =   18
         Top             =   3000
         Width           =   2655
         Begin VB.TextBox txtLevelName 
            Height          =   285
            Left            =   1095
            TabIndex        =   26
            Top             =   315
            Width           =   1455
         End
         Begin VB.TextBox txtLevelTime 
            Height          =   285
            Left            =   1095
            TabIndex        =   25
            Top             =   600
            Width           =   1455
         End
         Begin VB.TextBox txtMapSizeX 
            Height          =   285
            Left            =   600
            TabIndex        =   24
            Top             =   1275
            Width           =   435
         End
         Begin VB.TextBox txtMapSizeY 
            Height          =   285
            Left            =   1830
            TabIndex        =   23
            Top             =   1275
            Width           =   450
         End
         Begin VB.CommandButton cmdLevelRegen 
            Caption         =   "Regenerate with new size"
            Height          =   255
            Left            =   240
            TabIndex        =   22
            Top             =   1560
            Width           =   2130
         End
         Begin VB.VScrollBar VScrollMapSizeY 
            Height          =   285
            Left            =   2295
            Max             =   2
            TabIndex        =   21
            Top             =   1260
            Value           =   1
            Width           =   180
         End
         Begin VB.VScrollBar VScrollMapSizeX 
            Height          =   285
            Left            =   1035
            Max             =   2
            TabIndex        =   20
            Top             =   1275
            Value           =   1
            Width           =   180
         End
         Begin VB.CheckBox chkMapOnLevel 
            Height          =   195
            Left            =   1095
            TabIndex        =   19
            Top             =   930
            Width           =   195
         End
         Begin VB.Line Line2 
            BorderColor     =   &H80000003&
            BorderWidth     =   2
            X1              =   120
            X2              =   2520
            Y1              =   1200
            Y2              =   1200
         End
         Begin VB.Label Label5 
            BackStyle       =   0  'Transparent
            Caption         =   "Level name:"
            Height          =   255
            Left            =   180
            TabIndex        =   31
            Top             =   345
            Width           =   885
         End
         Begin VB.Label Label6 
            BackStyle       =   0  'Transparent
            Caption         =   "Time (sec/s):"
            Height          =   255
            Left            =   135
            TabIndex        =   30
            Top             =   615
            Width           =   1005
         End
         Begin VB.Label Label10 
            BackStyle       =   0  'Transparent
            Caption         =   "Size X:"
            Height          =   255
            Left            =   60
            TabIndex        =   29
            Top             =   1305
            Width           =   885
         End
         Begin VB.Label Label11 
            BackStyle       =   0  'Transparent
            Caption         =   "Size Y:"
            Height          =   255
            Left            =   1275
            TabIndex        =   28
            Top             =   1305
            Width           =   645
         End
         Begin VB.Label Label1 
            BackStyle       =   0  'Transparent
            Caption         =   "Map from start:"
            Height          =   255
            Left            =   30
            TabIndex        =   27
            Top             =   915
            Width           =   1095
         End
      End
      Begin VB.Frame frmLeftInput 
         BackColor       =   &H00FFFFFF&
         Caption         =   " < - >  :  Episode Globals "
         Height          =   2895
         Index           =   1
         Left            =   0
         TabIndex        =   8
         Top             =   0
         Width           =   2655
         Begin VB.CommandButton cmdAddLevel 
            Caption         =   "+"
            Height          =   255
            Left            =   2310
            TabIndex        =   14
            Top             =   1365
            Width           =   255
         End
         Begin VB.ComboBox cmbGameTypes 
            Height          =   315
            ItemData        =   "frmMain.frx":25C2
            Left            =   615
            List            =   "frmMain.frx":25C4
            Style           =   2  'Dropdown List
            TabIndex        =   13
            Top             =   615
            Width           =   1935
         End
         Begin VB.TextBox txtEpisodeName 
            Height          =   285
            Left            =   615
            TabIndex        =   12
            Text            =   "Unnamed"
            Top             =   315
            Width           =   1935
         End
         Begin VB.ListBox lstLevels 
            CausesValidation=   0   'False
            Height          =   1425
            Left            =   120
            TabIndex        =   11
            Top             =   1320
            Width           =   2175
         End
         Begin VB.CommandButton cmdDelLevel 
            Caption         =   "-"
            Height          =   255
            Left            =   2310
            TabIndex        =   10
            Top             =   1605
            Width           =   255
         End
         Begin VB.VScrollBar VScrollLevelOrder 
            Height          =   480
            Left            =   2310
            Max             =   10
            TabIndex        =   9
            Top             =   2250
            Value           =   5
            Width           =   240
         End
         Begin VB.Label Label7 
            BackStyle       =   0  'Transparent
            Caption         =   "Style:"
            Height          =   255
            Left            =   120
            TabIndex        =   17
            Top             =   645
            Width           =   525
         End
         Begin VB.Label Label8 
            BackStyle       =   0  'Transparent
            Caption         =   "Name:"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   16
            Top             =   360
            Width           =   525
         End
         Begin VB.Line Line3 
            BorderColor     =   &H80000003&
            BorderWidth     =   2
            X1              =   120
            X2              =   2520
            Y1              =   1080
            Y2              =   1080
         End
         Begin VB.Label Label9 
            BackStyle       =   0  'Transparent
            Caption         =   "Levels:"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   15
            Top             =   1080
            Width           =   1125
         End
      End
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileNew 
         Caption         =   "&New"
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Open"
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Save"
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "Save &As"
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuImport 
         Caption         =   "&Import"
         Begin VB.Menu mnuImportReptonFX 
            Caption         =   "ReptonF&X episode"
         End
      End
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelpContents 
         Caption         =   "&Contents"
      End
      Begin VB.Menu mnuHelpSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Type Corrds2D_T
    x As Integer
    y As Integer
End Type

Private Type GameMessages_T
    strMessage As String
    tTriggers(20) As Corrds2D_T
    iTotTrigs     As Integer
End Type

Private Type SceneryInfo_T
    strMeshFile    As String
    strTexFile     As String
    tSizeTopLeft   As Corrds2D_T
    tSizeBotRight  As Corrds2D_T
    bIsMovableTo   As Boolean
End Type

Private Type LevelTrans_T
    tPos        As Corrds2D_T
    sLocalFile  As String
End Type

' File data::
Dim strEpisodeName                As String
Dim intGamePlayType               As Integer
Dim strVisualTheme                As String
Dim strLevelOrder()               As String
Dim intCurSelLevel                As Integer

Dim sLogicalMap()                 As String * 1
Dim tMapSize                      As Corrds2D_T
Dim sngMapTime                    As Single
Dim tTransporterCorrds()          As Corrds2D_T
Dim tLevelTrans()                 As LevelTrans_T
Dim tInGameMessages()             As GameMessages_T
Dim SceneryPieces()               As SceneryInfo_T
Dim bNavMapFromStart              As Boolean
  

' Visual Form Control
Dim intVisualMapPieceTypesLoaded  As Integer
Dim intVisualMapPiecesLoaded      As Integer
Dim intNumberOfPanels             As Integer
Dim intPanelHeights()             As Integer

' User interactions
Dim intSelectedPieceType          As Integer
Dim intMapPreAddType              As Integer
Dim intNewestTransporterNo        As Integer
Dim intSelMsgNo                   As Integer
Dim intSelSceneryNo               As Integer
Dim bListReload                   As Boolean

' File handleing
Dim strEpisodeDir                 As String
Dim bChangesSinceSaved            As Boolean


Public Enum enmPieceType
    Space = 0
    Wall
    Dimond
    Wall8
    Wall2
    Wall6
    Wall4
    Wall9
    Wall7
    Wall3
    Wall1
    Earth
    Rock
    Safe
    Key
    Egg
    Repton
    Crown
    Cage
    Spirit
    Bomb
    Fungus
    Skull
    Barrier
    Monster
    Transporter
    TimeCapsule
    FilledWall
    FilledWall7
    FilledWall9
    FilledWall1
    FilledWall3
    NavigationalMap
    LevelTransport
End Enum



'
' General Form
'
Private Sub Form_Load()
    Dim intN As Integer
    
    Load frmLoading
    frmLoading.Visible = True
    
    DoEvents
    
    intVisualMapPieceTypesLoaded = 0
    intVisualMapPiecesLoaded = 0
        
    LoadAvilablePieceTypes
    picPieceType_Click 1
    
    ' Save panel heights
    intNumberOfPanels = frmLeftInput.UBound
    ReDim intPanelHeights(intNumberOfPanels)
    For intN = 1 To intNumberOfPanels
        intPanelHeights(intN) = frmLeftInput(intN).Height
    Next intN
    
    
    ' Set posible game types
    cmbGameTypes.AddItem "Repton 1"
'    cmbGameTypes.AddItem "Repton 2"
    cmbGameTypes.AddItem "Repton 3"
'    cmbGameTypes.AddItem "Repton Infinity"
    cmbGameTypes.AddItem "Repton Returns"

    
    ' Start new map
    mnuFileNew_Click
    
    
    Me.Visible = True
    Unload frmLoading
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If bChangesSinceSaved = True Then
        Select Case MsgBox("You will loose unsaved changes, save now?", vbYesNo, "Repton Returns Editor v2")
            Case vbYes
                mnuFileSave_Click
            
'            Case vbCancel
'                Exit Sub
'
        End Select
    End If
    
    DeleteFile App.Path + "\temp\*.*", False
End Sub

Private Sub Form_Resize()
    
    If Me.Height > 2000 And Me.Width > (fraMapContainer.Left + 2000) Then
        ' Resize other controls
        fraMapContainer.Height = Me.Height - fraMapContainer.Top - 1600
        fraMapContainer.Width = Me.Width - fraMapContainer.Left - 420
        VScrollMap.Height = fraMapContainer.Height
        HScrollMap.Width = fraMapContainer.Width
        VScrollMap.Left = fraMapContainer.Left + fraMapContainer.Width
        HScrollMap.Top = fraMapContainer.Top + fraMapContainer.Height
        
        ' Control values of Map scrolls
        If picMapHolder.Height - fraMapContainer.Height > 1 Then
            VScrollMap.Visible = True
            VScrollMap.Max = (picMapHolder.Height - fraMapContainer.Height)
            VScrollMap.LargeChange = picPiece(0).Height + 15
            VScrollMap.SmallChange = picPiece(0).Height + 15
        Else
            VScrollMap.Visible = False
        End If
        If picMapHolder.Width - fraMapContainer.Width > 1 Then
            HScrollMap.Max = (picMapHolder.Width - fraMapContainer.Width)
            HScrollMap.LargeChange = picPiece(0).Width + 15
            HScrollMap.SmallChange = picPiece(0).Width + 15
            HScrollMap.Visible = True
        Else
            HScrollMap.Visible = False
        End If
        
        ' Control values of panel scroll
        VScrollPanels.Height = Me.Height - VScrollPanels.Top - 1300
        If (fraPanelContainer.Height + 800) - Me.Height > 1 Then
            VScrollPanels.Visible = True
            VScrollPanels.Max = ((fraPanelContainer.Height + 800) - Me.Height)
        Else
            VScrollPanels.Visible = False
        End If
        
        
    End If
End Sub

Function UpdateVisualControls(Optional iMiss As Integer = 0)

'iMiss = 1 then miss out level list update (stops infinate loop)

    Dim n As Integer
    
    txtEpisodeName.Text = strEpisodeName
    
    Select Case intGamePlayType
        Case 1      '"Repton 1"
            cmbGameTypes.ListIndex = 0
            chkMapOnLevel.Enabled = False
            bNavMapFromStart = False
            
'        Case 2      '"Repton 2"
'            cmbGameTypes.ListIndex = 1
        Case 3       '"Repton 3"
            cmbGameTypes.ListIndex = 1
            chkMapOnLevel.Enabled = False
            If intCurSelLevel < 6 Then
                bNavMapFromStart = True
            Else
                bNavMapFromStart = False
            End If

'        Case 4       '"Repton Infinity"
'            cmbGameTypes.ListIndex = 1
        Case 10       '"Repton Returns"
            cmbGameTypes.ListIndex = 2
            chkMapOnLevel.Enabled = True
    End Select

    
    ' Level order controls ...
    
    If UBound(strLevelOrder) = 1 Then
        cmdDelLevel.Enabled = False
        VScrollLevelOrder.Enabled = False
    Else
        cmdDelLevel.Enabled = True
        VScrollLevelOrder.Enabled = True
    End If
    
    If iMiss <> 1 Then
        If lstLevels.ListIndex <> (intCurSelLevel - 1) Then
            lstLevels.Clear
            For n = 1 To UBound(strLevelOrder)
                lstLevels.AddItem strLevelOrder(n)
            Next n
            lstLevels.ListIndex = (intCurSelLevel - 1)
        Else
            lstLevels.Clear
            For n = 1 To UBound(strLevelOrder)
                lstLevels.AddItem strLevelOrder(n)
            Next n
        End If
    End If
    
    ' Level controls
    txtLevelName.Text = lstLevels.List(intCurSelLevel - 1)
    txtLevelTime.Text = sngMapTime
    txtMapSizeX.Text = tMapSize.x
    txtMapSizeY.Text = tMapSize.y

    ' InGameMessages:
    If UBound(tInGameMessages) < 1 Then
        lblGameMsgNo.Caption = "#<None>"
        cmdGameMsgDel.Enabled = False
        cmdGameMsgPrev.Enabled = False
        cmdGameMsgNext.Enabled = False
        cmdGameMsgTrigTog.Enabled = False
        txtGameMsgText.Enabled = False
        txtGameMsgText.Text = "    <No Messages>"
    Else
        lblGameMsgNo.Caption = "#" + Trim(Str(intSelMsgNo))
        cmdGameMsgDel.Enabled = True
        cmdGameMsgTrigTog.Enabled = True
        txtGameMsgText.Enabled = True
        If UBound(tInGameMessages) = 1 Then
            cmdGameMsgPrev.Enabled = False
            cmdGameMsgNext.Enabled = False
        Else
            
            If intSelMsgNo = 1 Then
                cmdGameMsgPrev.Enabled = False
            Else
                cmdGameMsgPrev.Enabled = True
            End If
            If intSelMsgNo = UBound(tInGameMessages) Then
                cmdGameMsgNext.Enabled = False
            Else
                cmdGameMsgNext.Enabled = True
            End If
        End If
        txtGameMsgText.Text = tInGameMessages(intSelMsgNo).strMessage
        
        ' Show message triggers
        For n = 1 To tInGameMessages(intSelMsgNo).iTotTrigs
            picPiece(Convert2Dto1Dcoords(tInGameMessages(intSelMsgNo).tTriggers(n))).BorderStyle = 1
        Next n

    End If

    ' SceneryPieces:
    If UBound(SceneryPieces) < 1 Then
        lblSceneryPieceNo.Caption = "#<None>"
        cmdSceneryDel.Enabled = False
        cmdSceneryPrev.Enabled = False
        cmdSceneryNext.Enabled = False
        chkSceneryMovableTo.Enabled = False
        cmdSceneryMesh.Enabled = False
        cmdSceneryTex.Enabled = False
        shpScenery.Visible = False
        lblSceneryMeshFile.Caption = "<Mesh File>"
        lblSceneryTexFile.Caption = "<Texture File>"
        
    Else
    
        If UBound(SceneryPieces) = 1 Then
            cmdSceneryPrev.Enabled = False
            cmdSceneryNext.Enabled = False
        Else
            cmdSceneryPrev.Enabled = CBool(intSelSceneryNo <> 1)
            cmdSceneryNext.Enabled = CBool(intSelSceneryNo <> UBound(SceneryPieces))
        End If
        
        lblSceneryPieceNo.Caption = "#" + Trim(Str(intSelSceneryNo))
        cmdSceneryDel.Enabled = True
        chkSceneryMovableTo.Enabled = True
        chkSceneryMovableTo.Value = CInt(SceneryPieces(intSelSceneryNo).bIsMovableTo)
        cmdSceneryMesh.Enabled = True
        cmdSceneryTex.Enabled = True
        lblSceneryMeshFile.Caption = SceneryPieces(intSelSceneryNo).strMeshFile
        lblSceneryTexFile.Caption = SceneryPieces(intSelSceneryNo).strTexFile
       
        ' Show on map
        shpScenery.Visible = True
        shpScenery.Top = ((picPiece(1).Height + 15) * (SceneryPieces(intSelSceneryNo).tSizeTopLeft.y - 1)) + picPiece(1).Top
        shpScenery.Left = ((picPiece(1).Width + 15) * (SceneryPieces(intSelSceneryNo).tSizeTopLeft.x - 1)) + picPiece(1).Left
        shpScenery.Height = ((picPiece(1).Height + 15) * (SceneryPieces(intSelSceneryNo).tSizeBotRight.y - SceneryPieces(intSelSceneryNo).tSizeTopLeft.y + 1))
        shpScenery.Width = ((picPiece(1).Width + 15) * (SceneryPieces(intSelSceneryNo).tSizeBotRight.x - SceneryPieces(intSelSceneryNo).tSizeTopLeft.x + 1))
        
    End If
    
    ' Navigational map
    chkMapOnLevel.Value = Abs(CInt(bNavMapFromStart))
    
End Function

Function UpdateVisualMap()
    Dim intY As Integer
    Dim intX As Integer
    Dim intN As Integer
    
    Dim intPieceSizeX As Integer
    Dim intPieceSizeY As Integer
    
    Me.MousePointer = 11
    
    intPieceSizeX = picPiece(0).Height
    intPieceSizeY = picPiece(0).Width
    
    intN = 1
    For intY = 1 To tMapSize.y
        For intX = 1 To tMapSize.x
            
            If intN > intVisualMapPiecesLoaded Then
            
                ' Load a new control in the control array (if not already loaded)
                Load picPiece(intN)
                
                intVisualMapPiecesLoaded = intVisualMapPiecesLoaded + 1
                
            End If
            
            picPiece(intN).Visible = True
            picPiece(intN).Top = intY * (intPieceSizeY + 15)
            picPiece(intN).Left = intX * (intPieceSizeX + 15)
                        
            On Error Resume Next
            picPiece(intN).Picture = ImgLstPieceTypes.ListImages(DataStr2Int(sLogicalMap(intN)) + 1).Picture
            
            picPiece(intN).BorderStyle = 0
            
            intN = intN + 1
            
        Next intX
    Next intY
    
    ' Unload any unused controls
    intN = intN - 1
    intX = intVisualMapPiecesLoaded
    Do While (intN + 1) < intVisualMapPiecesLoaded
        Unload picPiece(intVisualMapPiecesLoaded)
        intVisualMapPiecesLoaded = intVisualMapPiecesLoaded - 1
    Loop
        
    ' Resize MAP holder
    picMapHolder.Height = (tMapSize.x + 2.5) * (intPieceSizeX + 15) - picMapHolder.Top
    picMapHolder.Width = (tMapSize.y + 2.5) * (intPieceSizeY + 15) - picMapHolder.Left
    
    
    Me.MousePointer = 0
    
End Function



Private Sub Frame1_DragDrop(Source As Control, x As Single, y As Single)

End Sub

Private Sub HScrollMap_Change()
     picMapHolder.Left = 120 - (HScrollMap.Value)
End Sub

Private Sub mnuFileOpen_Click()
    
    
    Dim strFile As String

'    Dim strDir As String


    ' Has current file been modified since last save?
    If bChangesSinceSaved = True Then
        If MsgBox("Current file has not been saved since changes were made, save now?", vbYesNo, "Save current file? : Repton Returns Editor v2") = vbYes Then
            mnuFileSave_Click
        End If
    End If

    ' Get last succesful location
'    strDir = GetSettingString(HKEY_CURRENT_USER, "Software\Ex-D Software DevelopmentTM\DialUpAutomator", "filedir")

    On Error GoTo usrcancel_FileOpen
    
    CommonDialog.DialogTitle = "Select Epsiode File to Open"
    CommonDialog.Filter = "*.rre"
'    CommonDialog.InitDir = strDir
    CommonDialog.ShowOpen
    strFile = CommonDialog.FileName

    'Resume

'    SaveSettingString HKEY_CURRENT_USER, "Software\Ex-D Software DevelopmentTM\DialUpAutomator", "filedir", Left(strFile, InStrRev(strFile, "\"))

    Load frmLoading
    frmLoading.lblLoading = "Setting up level"
    frmLoading.Visible = True
    
    Me.Visible = False
    Me.Hide
    
    DoEvents
    
    
    If OpenFileEpisode(strFile) = False Then
        MsgBox "There was a problem when trying to access the specified file.", , "Repton Returns Editor v2"
    End If
    
    UpdateVisualMap
    UpdateVisualControls
    
    EvaluateMap
    
    Me.Show
    Me.Visible = True
    
    Unload frmLoading

    Exit Sub

usrcancel_FileOpen:
    'Resume
End Sub

Private Sub mnuFileSave_Click()
    
    If strEpisodeDir <> App.Path + "\temp\" Then
    
        If SaveFileEpisode(strEpisodeDir) = False Then
            MsgBox "There was a problem when trying to save to the current file. (Use 'Save As').", , "Repton Returns Editor v2"
        End If
        
    Else
        mnuFileSaveAs_Click
    End If
    
    bChangesSinceSaved = False
End Sub

Private Sub mnuFileSaveAs_Click()
    Dim strFile As String

    On Error GoTo save_usrcancel
    CommonDialog.DialogTitle = "Enter\Select a folder to save to..."
    CommonDialog.Filter = ""
    CommonDialog.FileName = strEpisodeName
    CommonDialog.ShowSave
    strFile = CommonDialog.FileName
    'Resume


    If FileExists(strFile) = True Then
        If MsgBox("The file already exists, do you wish to overwrite?", vbYesNo, "Overwrite selected file? : Repton Returns Editor v2") = vbNo Then
            Exit Sub
        End If
    End If
    
    If SaveFileEpisode(strFile) = True Then
           
        ' File was successfully saved
            
        strEpisodeDir = strFile
        bChangesSinceSaved = False
        
    Else
        MsgBox "There was a problem when trying to save to the selected destination.", , "Repton Returns Editor v2"
    End If
    
save_usrcancel:
    
End Sub

Private Sub mnuHelpAbout_Click()
    Load frmAbout
    frmAbout.Visible = True
End Sub

Private Sub mnuHelpContents_Click()
    ShellExecute Me.hwnd, "open", App.Path & "\help.chm", vbNullString, vbNullString, 3 'SW_NORMAL
End Sub

Private Sub mnuImportReptonFX_Click()

    Dim strFile As String

    Dim strDir As String

        
    ' Has current file been modified since last save?
    If bChangesSinceSaved = True Then
        If MsgBox("Current episode has not been saved since changes were made, save now?", vbYesNo, "Save current file? : Repton Returns Editor") = vbYes Then
            mnuFileSave_Click
        End If
    End If

    On Error GoTo fxrep_file_err
    CommonDialog.DialogTitle = "Select FX-Repton episode to Import"
    CommonDialog.Filter = "*.fxr"
    CommonDialog.InitDir = strDir
    CommonDialog.ShowOpen
    strFile = CommonDialog.FileName

'    Resume

    ' Get folder DIR only
    strFile = Left(strFile, InStrRev(strFile, "\"))

    ImportReptonFX strFile
    
    
    
    Load frmLoading
    frmLoading.lblLoading = "Setting up level"
    frmLoading.Visible = True
    
    Me.Visible = False
    Me.Hide
    
    DoEvents
    
    
    UpdateVisualControls
    UpdateVisualMap
    
    EvaluateMap
    
    
    Me.Show
    Me.Visible = True
    
    Unload frmLoading
    
fxrep_file_err:
    
End Sub

Private Sub mnuFileExit_Click()
    Form_Unload 0
    
    End
End Sub

'
' Episode panel controls ...
'
Private Sub txtEpisodeName_Change()
    strEpisodeName = txtEpisodeName.Text
    bChangesSinceSaved = True
End Sub

Private Sub cmbGameTypes_Click()
    Select Case cmbGameTypes.Text
        Case "Repton 1"
            intGamePlayType = 1
        Case "Repton 2"
            intGamePlayType = 2
        Case "Repton 3"
            intGamePlayType = 3
        Case "Repton Infinity"
            intGamePlayType = 4
        Case "Repton Returns"
            intGamePlayType = 10
    End Select
    
    bChangesSinceSaved = True
    
    UpdateVisualControls
End Sub

Private Sub cmdAddLevel_Click()
    
    Dim n As Long
    
    bListReload = True
    
    ' Save changes made to current level (if level present)
    If intCurSelLevel <> 0 Then
        SaveFileLevel
    Else
        ' This is the first level to be created
        ReDim strLevelOrder(0)
    End If
    
    
    tMapSize.x = 30
    tMapSize.y = 30
    sngMapTime = -1
    ReDim sLogicalMap(tMapSize.x * tMapSize.y)
    For n = 1 To (tMapSize.x * tMapSize.y)
        sLogicalMap(n) = "0"
    Next n
    
    ReDim tTransporterCorrds(0)
    ReDim tInGameMessages(0)
    ReDim SceneryPieces(0)
    
    ReDim Preserve strLevelOrder(UBound(strLevelOrder) + 1)
    
    strLevelOrder(UBound(strLevelOrder)) = "Level " + Trim(Str(UBound(strLevelOrder)))
    
    intCurSelLevel = UBound(strLevelOrder)
    
    bChangesSinceSaved = True
    
    intSelMsgNo = 0
    
    UpdateVisualControls
    UpdateVisualMap
    
    EvaluateMap
    
    
End Sub

Private Sub cmdDelLevel_Click()
    Dim n As Integer
    Dim intOldSelected
    
    bListReload = True
    
    intOldSelected = intCurSelLevel
    
    ' Move selected level to end of list
    For n = intCurSelLevel To (UBound(strLevelOrder) - 1)
        VScrollLevelOrder.Value = 6
    Next n
    
    ReDim Preserve strLevelOrder(UBound(strLevelOrder) - 1)
    
    If intOldSelected <= UBound(strLevelOrder) Then
        intCurSelLevel = intOldSelected
    Else
        intCurSelLevel = UBound(strLevelOrder)
    End If
    
    bChangesSinceSaved = True
    
    
    UpdateVisualControls
    UpdateVisualMap
    
    EvaluateMap
    
End Sub

Private Sub VScrollLevelOrder_Change()
    Dim strTemp As String
    
    bListReload = True
    
    ' Save current level
    SaveFileLevel
    
    If VScrollLevelOrder.Value = 4 Then
        ' Move selected up
        If intCurSelLevel <> 1 Then
            strTemp = strLevelOrder(intCurSelLevel)
            strLevelOrder(intCurSelLevel) = strLevelOrder(intCurSelLevel - 1)
            strLevelOrder(intCurSelLevel - 1) = strTemp
            intCurSelLevel = intCurSelLevel - 1
        Else
            Beep
        End If
    End If
    If VScrollLevelOrder.Value = 6 Then
        ' Move selected down
        If intCurSelLevel <> UBound(strLevelOrder) Then
            strTemp = strLevelOrder(intCurSelLevel)
            strLevelOrder(intCurSelLevel) = strLevelOrder(intCurSelLevel + 1)
            strLevelOrder(intCurSelLevel + 1) = strTemp
            intCurSelLevel = intCurSelLevel + 1
        Else
            Beep
        End If
    End If
    
    VScrollLevelOrder.Value = 5
    
    bChangesSinceSaved = True
    
    ' Load selected level
    LoadFileLevel
    
    
    UpdateVisualControls
    UpdateVisualMap
    
    EvaluateMap

End Sub

'
' Level panel
'
Private Sub txtLevelName_LostFocus()
    Dim n As Integer
    Dim bOk As Boolean

    ' Check if any changes were made, if not then don't bother to check/update values
    If strLevelOrder(intCurSelLevel) <> txtLevelName.Text Then
    
        ' Two levels can not have the same name
        bOk = True
        For n = 1 To UBound(strLevelOrder)
            If strLevelOrder(n) = txtLevelName.Text Then bOk = False
        Next n
    
        If bOk = True Then
            strLevelOrder(intCurSelLevel) = txtLevelName.Text
            
            bChangesSinceSaved = True
            
            UpdateVisualControls
        Else
            MsgBox "Two levels can not have the same name, retry", , "Repton Returns Editor v2"
            txtLevelName.SetFocus
        End If
    End If
End Sub

Private Sub txtLevelTime_LostFocus()
    ' Check if time entered is within limits
    If (Int(txtLevelTime.Text) >= 10 And Int(txtLevelTime.Text) <= 600) Or ((intGamePlayType = 2 Or intGamePlayType = 10) And Int(txtLevelTime.Text) = -1) Then
        ' Value is ok, set logical varible
        sngMapTime = Val(txtLevelTime.Text)
    Else
        MsgBox "Level time value must be a number between (and including) 10 and 600 (or -1 is relevent game play type is selected)", , "Repton Returns Editor v2"
        txtLevelTime.SetFocus
    End If
    
    bChangesSinceSaved = True
End Sub

Private Sub txtMapSizeX_LostFocus()
    If Int(txtMapSizeX.Text) < 1 Or Int(txtMapSizeX.Text) > 99 Or Not (InStr(1, txtMapSizeX.Text, ".") = 0) Then
        MsgBox "Level Size X value must be a whole number between (and including) 1 and 99", , "Repton Returns Editor v2"
        txtMapSizeX.SetFocus
    End If
End Sub

Private Sub VScrollMap_Change()
    picMapHolder.Top = 120 - (VScrollMap.Value)
End Sub

Private Sub VScrollMapSizeX_Change()
    If VScrollMapSizeX.Value = 0 Then
        If txtMapSizeX < 99 Then txtMapSizeX.Text = Int(txtMapSizeX.Text) + 1
    End If
    If VScrollMapSizeX.Value = 2 Then
        If txtMapSizeX.Text > 1 Then txtMapSizeX.Text = Int(txtMapSizeX.Text) - 1
    End If
    VScrollMapSizeX.Value = 1
End Sub

Private Sub txtMapSizeY_LostFocus()
    If Int(txtMapSizeY.Text) < 1 Or Int(txtMapSizeY.Text) > 99 Or Not (InStr(1, txtMapSizeY.Text, ".") = 0) Then
        MsgBox "Level Size Y value must be a whole number between (and including) 1 and 99", , "Repton Returns Editor v2"
        txtMapSizeY.SetFocus
    End If
End Sub

Private Sub VScrollMapSizeY_Change()
    If VScrollMapSizeY.Value = 0 Then
        If txtMapSizeY < 99 Then txtMapSizeY.Text = Int(txtMapSizeY.Text) + 1
    End If
    If VScrollMapSizeY.Value = 2 Then
        If txtMapSizeY.Text > 1 Then txtMapSizeY.Text = Int(txtMapSizeY.Text) - 1
    End If
    VScrollMapSizeY.Value = 1
End Sub

Private Sub cmdLevelRegen_Click()
    Dim sTempMap(99, 99) As String * 1
    Dim x As Integer
    Dim y As Integer
    Dim n As Long
    
    ' Check if data will be erased, if so, prompt user
    If Int(txtMapSizeX.Text) < tMapSize.x Or Int(txtMapSizeY.Text) < tMapSize.y Then
        If MsgBox("Some level pieces will be deleted, sure to continue?", vbYesNo, "Repton Returns Editor v2") = vbNo Then Exit Sub
    End If
    
    ' If we are going to be loading new controls, hide form (quicker)
    Load frmLoading
    frmLoading.lblLoading = "Resizing Level"
    frmLoading.Show
    frmLoading.Visible = True
    Me.Visible = False
    Me.Hide
    DoEvents


    ' Make sure 2D array is blank
    For y = 1 To Int(txtMapSizeY.Text)
        For x = 1 To Int(txtMapSizeX.Text)
            sTempMap(x, y) = "0"
        Next x
    Next y

    ' Copy map to the blank 2D string array
    n = 1
    For y = 1 To tMapSize.y
        For x = 1 To tMapSize.x
            sTempMap(x, y) = sLogicalMap(n)
            n = n + 1
        Next x
    Next y
    
    ReDim sLogicalMap(Int(txtMapSizeX.Text) * Int(txtMapSizeY.Text))
    
    ' Put data back into map string (at new desiered size)
    n = 1
    For y = 1 To Int(txtMapSizeY.Text)
        For x = 1 To Int(txtMapSizeX.Text)
            sLogicalMap(n) = sTempMap(x, y)
            n = n + 1
        Next x
    Next y
    
    ' Set new size
    tMapSize.x = Int(txtMapSizeX.Text)
    tMapSize.y = Int(txtMapSizeY.Text)
    
    UpdateVisualMap
    
    Me.Show
    Me.Visible = True
    Unload frmLoading
    
    bChangesSinceSaved = True
    
End Sub

Private Sub chkMapOnLevel_Click()
     bNavMapFromStart = CBool(chkMapOnLevel.Value)
End Sub

'
' Piece types panel controls ...
'
Function LoadAvilablePieceTypes()
    Dim intY As Integer
    Dim intX As Integer
    Dim intN As Integer
    
    Dim intPieceSizeX As Integer
    Dim intPieceSizeY As Integer
    
    Dim sTemp As String
    
    intPieceSizeX = picPieceType(0).Height
    intPieceSizeY = picPieceType(0).Width
    
    intN = 1
    For intY = 1 To 4
        For intX = 1 To 9
            
            If intN < 35 Then
                
                If intVisualMapPieceTypesLoaded < intN Then
                
                    ' Load a new control in the control array (if not already loaded)
                    Load picPieceType(intN)
                    
                End If
                            
                picPieceType(intN).Visible = True
                picPieceType(intN).Top = intY * intPieceSizeY + 90
                picPieceType(intN).Left = (intX - 1) * intPieceSizeX + 50
                
                ' Set picture
                picPieceType(intN).Picture = ImgLstPieceTypes.ListImages(intN).Picture
                
                
                ' Hint data:
                Select Case (intN - 1)
                    Case Space
                        sTemp = "Blank space : movabled to : no support"
                    Case Wall
                        sTemp = "Wall with no frills : not movable to : no slant"
                    Case Dimond
                        sTemp = "Diamond : all must be collected : movable to : LEFT slant"
                    Case Wall8
                        sTemp = "Wall with top frill : not movable to : no slant"
                    Case Wall2
                        sTemp = "Wall with bottom frill : not movable to : no slant"
                    Case Wall6
                        sTemp = "Wall with left frill : not movable to : no slant"
                    Case Wall4
                        sTemp = "Wall with right frill : not movable to : no slant"
                    Case Wall9
                        sTemp = "Wall with top-right frill : not movable to : RIGHT slant"
                    Case Wall7
                        sTemp = "Wall with top-left frill : not movable to : LEFT slant"
                    Case Wall3
                        sTemp = "Wall with bottom-right frill : not movable to : no slant"
                    Case Wall1
                        sTemp = "Wall with bottom-left frill : not movable to : no slant"
                    Case Earth
                        sTemp = "Earth : temporary support : movable to : no slant"
                    Case Rock
                        sTemp = "Rock : fall if not supported : movable to, if rock is movable : LEFT slant"
                    Case Safe
                        sTemp = "Safe/strong-box : replaced by diamond when key collected : not movable to : no slant"
                    Case Key
                        sTemp = "Key : unlocks safes : movable to : LEFT slant"
                    Case Egg
                        sTemp = "Egg : releases egg if falls : movable to, if egg is movable : LEFT slant"
                    Case Repton
                        sTemp = "Player starting position : replaced by 'space' in game : movable to : no support"
                    Case Crown
                        sTemp = "Crown : must be collected, only one per level : movable to : LEFT slant"
                    Case Cage
                        sTemp = "Cage/spirt-catcher : replaced by diamond when spirt enteres : not movable to : no support"
                    Case Spirit
                        sTemp = "Spirit : moving 'hugs wall left' : deadly on move to : LEFT slant"
                    Case Bomb
                        sTemp = "Bomb : Player ending position, must be collected once all diamond, monsters, etc are gone : movable to (if conditions met) : LEFT slant"
                    Case Fungus
                        sTemp = "Fungus : 'grows' into 'spaces' : deadly on move to : no slant"
                    Case Skull
                        sTemp = "Skull : a deadly wall? : deadly on move to : no slant"
                    Case Barrier
                        sTemp = "Barrier : like a wall : not movable to : no slant"
                    Case Monster
                        sTemp = "Monster : moving 'follow player directly' - gets stuck behind walls : deadly on move to : no support"
                    Case Transporter
                        sTemp = "Transporter : relocates player : movable to : no slant"
                    Case TimeCapsule
                        sTemp = "Time Capsule : resets the time-bomb : movable to : LEFT slant??"
                End Select
                picPieceType(intN).ToolTipText = sTemp
                
                               
                intN = intN + 1
                
            End If
        Next intX
    Next intY

End Function

Private Sub cmdFillAll_Click()
    Dim n As Integer
    Dim bOk As Boolean
    
    bOk = False
        
    ' Check only sensiable pieces are used with this function
    Select Case intSelectedPieceType
        Case enmPieceType.Transporter
        Case enmPieceType.Bomb
        Case enmPieceType.Monster
        Case enmPieceType.Egg
        Case enmPieceType.Spirit
        Case enmPieceType.Repton
        Case enmPieceType.Crown
        
        Case Else
            bOk = True
            For n = 1 To UBound(sLogicalMap)
                sLogicalMap(n) = DataInt2Str(intSelectedPieceType - 0)
            Next n
            
            bChangesSinceSaved = True
            
            UpdateVisualMap
            
            EvaluateMap
            
    End Select
    
    If bOk = False Then MsgBox "The selected piece type can not be applied to this operation", , "Repton Returns Editor v2"
    
End Sub

Private Sub cmdSceneryAdd_Click()
    
    ReDim Preserve SceneryPieces(UBound(SceneryPieces) + 1)
    
    intSelSceneryNo = UBound(SceneryPieces)
    SceneryPieces(intSelSceneryNo).tSizeTopLeft.x = -1
    
    MsgBox "Set the upper left limit of scenery piece on map", , "Repton Returns Editor v2"
    intMapPreAddType = 3
    
    bChangesSinceSaved = True
    
End Sub

Private Sub cmdSceneryDel_Click()
    Dim n As Integer
    
    ' Delete
    For n = intSelSceneryNo To UBound(SceneryPieces) - 1
        SceneryPieces(n) = SceneryPieces(n + 1)
    Next n
    
    If intSelSceneryNo = UBound(SceneryPieces) Then intSelSceneryNo = intSelSceneryNo - 1
    
    ReDim Preserve SceneryPieces(UBound(SceneryPieces) - 1)
    
    bChangesSinceSaved = True
    
    UpdateVisualControls
End Sub

Private Sub cmdSceneryPrev_Click()
    intSelSceneryNo = intSelSceneryNo - 1
    
    UpdateVisualControls
End Sub

Private Sub cmdSceneryNext_Click()
    intSelSceneryNo = intSelSceneryNo + 1

    UpdateVisualControls
End Sub

Private Sub chkSceneryMovableTo_Click()
    SceneryPieces(intSelSceneryNo).bIsMovableTo = CBool(chkSceneryMovableTo.Value)
    bChangesSinceSaved = True
End Sub

Private Sub cmdSceneryMesh_Click()
    
    
    Dim strFile As String

'    Dim strDir As String



    ' Get last succesful location
'    strDir = GetSettingString(HKEY_CURRENT_USER, "Software\Ex-D Software DevelopmentTM\DialUpAutomator", "filedir")

'    On Error GoTo usrcancel_FileOpen
    
    CommonDialog.DialogTitle = "Select/Enter Scenery Mesh File"
    CommonDialog.Filter = "*.x"
'    CommonDialog.InitDir = strDir
    CommonDialog.ShowOpen
    strFile = CommonDialog.FileName

 '   Resume

'    SaveSettingString HKEY_CURRENT_USER, "Software\Ex-D Software DevelopmentTM\DialUpAutomator", "filedir", Left(strFile, InStrRev(strFile, "\"))

    
    
    If FileExists(strFile) = False Then
        MsgBox "There was a problem when trying to locate the specified file.", , "Repton Returns Editor v2"
    Else
        
        SceneryPieces(intSelSceneryNo).strMeshFile = Right(strFile, Len(strFile) - InStrRev(strFile, "\"))
    
        UpdateVisualControls
        
        bChangesSinceSaved = True
        
    End If
    
    
End Sub

Private Sub cmdSceneryTex_Click()
    
    
    Dim strFile As String

'    Dim strDir As String



    ' Get last succesful location
'    strDir = GetSettingString(HKEY_CURRENT_USER, "Software\Ex-D Software DevelopmentTM\DialUpAutomator", "filedir")

'    On Error GoTo usrcancel_FileOpen
    
    CommonDialog.DialogTitle = "Select/Enter Scenery Texture File"
    CommonDialog.Filter = "*.bmp"
'    CommonDialog.InitDir = strDir
    CommonDialog.ShowOpen
    strFile = CommonDialog.FileName

 '   Resume

'    SaveSettingString HKEY_CURRENT_USER, "Software\Ex-D Software DevelopmentTM\DialUpAutomator", "filedir", Left(strFile, InStrRev(strFile, "\"))

    
    
    If FileExists(strFile) = False Then
        MsgBox "There was a problem when trying to locate the specified file.", , "Repton Returns Editor v2"
    Else
        
        SceneryPieces(intSelSceneryNo).strTexFile = Right(strFile, Len(strFile) - InStrRev(strFile, "\"))
    
        UpdateVisualControls
        
        bChangesSinceSaved = True
        
    End If
End Sub


'
' In-Game Messages panel
'
Private Sub cmdGameMsgAdd_Click()
    
    ReDim Preserve tInGameMessages(UBound(tInGameMessages) + 1)
    
    intSelMsgNo = UBound(tInGameMessages)
    
    bChangesSinceSaved = True
    
    UpdateVisualMap
    UpdateVisualControls
End Sub

Private Sub cmdGameMsgDel_Click()
    Dim n As Integer
    
    ' Delete
    For n = intSelMsgNo To UBound(tInGameMessages) - 1
        tInGameMessages(n) = tInGameMessages(n + 1)
    Next n
    
    If intSelMsgNo = UBound(tInGameMessages) Then intSelMsgNo = intSelMsgNo - 1
    
    ReDim Preserve tInGameMessages(UBound(tInGameMessages) - 1)
    
    bChangesSinceSaved = True
    
    UpdateVisualMap
    UpdateVisualControls
End Sub

Private Sub cmdGameMsgPrev_Click()
    
    intSelMsgNo = intSelMsgNo - 1

    UpdateVisualMap
    UpdateVisualControls
End Sub

Private Sub cmdGameMsgNext_Click()
    
    intSelMsgNo = intSelMsgNo + 1
    
    UpdateVisualMap
    UpdateVisualControls
End Sub

Private Sub cmdGameMsgTrigTog_Click()
    intMapPreAddType = 2
    MsgBox "Now Add/Delete a trigger for this message", , "Repton Returns Editor v2"
    bChangesSinceSaved = True
End Sub

Private Sub txtGameMsgText_LostFocus()
    tInGameMessages(intSelMsgNo).strMessage = txtGameMsgText.Text
    bChangesSinceSaved = True
End Sub


'
' Debug panel
'
Private Sub cmdTestLevel_Click()
'    ShellExecute Me.hWnd, "open", "ReptonReturns.exe -test" + lstLevels.List(intCurSelLevel - 1) + ".rrl", vbNullString, vbNullString, SW_NORMAL
End Sub


' User interaction functions...
Private Sub VScrollPanels_Change()
    fraPanelContainer.Top = -VScrollPanels.Value
End Sub

Private Sub frmLeftInput_Click(Index As Integer)
    
    Dim blnJustOpened As Boolean
    Dim intN As Integer
    Dim intCurTop As Integer
   
   
    ' Show/Hide panel
    If frmLeftInput(Index).Height = 255 Then        ' Is closed
        ' Open this panel
        frmLeftInput(Index).Height = intPanelHeights(Index)
        
        ' Change caption to show if panel is open
        frmLeftInput(Index).Caption = " < - >  :  " + Right(frmLeftInput(Index).Caption, Len(frmLeftInput(Index).Caption) - 11)
        
        blnJustOpened = True
    Else
        frmLeftInput(Index).Height = 255
        
        ' Change caption to show if panel is closed
        frmLeftInput(Index).Caption = " < + >  :  " + Right(frmLeftInput(Index).Caption, Len(frmLeftInput(Index).Caption) - 11)
    
        blnJustOpened = False
    End If
    
    ' Move other panels to accept change
    intCurTop = frmLeftInput(1).Top
    For intN = 2 To intNumberOfPanels
        intCurTop = intCurTop + frmLeftInput(intN - 1).Height + 100  ' Prev Panel's height + spacing
        frmLeftInput(intN).Top = intCurTop               ' Move panel
    Next intN
    
    ' Set holder size
    fraPanelContainer.Height = frmLeftInput(intNumberOfPanels).Top + frmLeftInput(intNumberOfPanels).Height
    Form_Resize
    
End Sub


Private Sub lstLevels_DblClick()
    
'    If bListReload = True Then
        Load frmLoading
        frmLoading.lblLoading = "Setting up level"
        frmLoading.Visible = True
        
        Me.Visible = False
        Me.Hide
        
        DoEvents
        
        ' Save current level
        SaveFileLevel
        
        intCurSelLevel = lstLevels.ListIndex + 1
        
        ' Load selected level
        LoadFileLevel
        
        UpdateVisualMap
        UpdateVisualControls 1
        
        EvaluateMap
        
        Me.Show
        Me.Visible = True
        
        Unload frmLoading
 '   End If
    
 '   bListReload = False

End Sub

Private Sub mnuFileNew_Click()
    ' (Re)set defaults...

    strEpisodeName = "Unnamed"
    intGamePlayType = 10
    strVisualTheme = "standard"
    
    intCurSelLevel = 0
    
    strEpisodeDir = App.Path + "\temp\"
    bChangesSinceSaved = True
    
    picPieceType_Click 1
    
    cmdAddLevel_Click

End Sub

Private Sub picPiece_MouseDown(Index As Integer, Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim sTemp As String
    Dim n As Integer
    Dim b As Integer
    
    
    ' Left mouse button (act as normal)
    If Button = 1 Then
        
        Select Case intMapPreAddType
            Case 1                      ' New Transporter
            
                ReDim Preserve tTransporterCorrds(UBound(tTransporterCorrds) + 1)
                
                ' Move others to make room for this new transporter
                For n = UBound(tTransporterCorrds) To intNewestTransporterNo Step -1
                    tTransporterCorrds(n) = tTransporterCorrds(n - 1)
                Next n
                
                ' Insert new
                tTransporterCorrds(intNewestTransporterNo) = Convert1Dto2Dcoords(Index)
                
                intMapPreAddType = 0
                
            Case 2                      ' In-game message coord
                ' Check if not already a trigger, if so, then delete, else add
                If picPiece(Index).BorderStyle = 0 Then
                    tInGameMessages(intSelMsgNo).iTotTrigs = tInGameMessages(intSelMsgNo).iTotTrigs + 1
                    tInGameMessages(intSelMsgNo).tTriggers(tInGameMessages(intSelMsgNo).iTotTrigs) = Convert1Dto2Dcoords(Index)
                    
                Else
                    ' Delete clicked upon trigger ...
                    
                    ' Get trigger number
                    n = 1
                    Do While Not (tInGameMessages(intSelMsgNo).tTriggers(n).x = Convert1Dto2Dcoords(Index).x And tInGameMessages(intSelMsgNo).tTriggers(n).y = Convert1Dto2Dcoords(Index).y)
                        n = n + 1
                    Loop
                    
                    ' Delete
                    For b = n To tInGameMessages(intSelMsgNo).iTotTrigs - 1
                        tInGameMessages(intSelMsgNo).tTriggers(b) = tInGameMessages(intSelMsgNo).tTriggers(b + 1)
                    Next b
                    tInGameMessages(intSelMsgNo).iTotTrigs = tInGameMessages(intSelMsgNo).iTotTrigs - 1
                    
                    UpdateVisualMap
                    
                End If
                
                UpdateVisualControls
                intMapPreAddType = 0
                
            Case 3                      ' Scenery piece
            
                If SceneryPieces(intSelSceneryNo).tSizeTopLeft.x = -1 Then
            
                    SceneryPieces(intSelSceneryNo).tSizeTopLeft = Convert1Dto2Dcoords(Index)
                
                    MsgBox "Now set the lower right limit of scenery piece on map", , "Repton Returns Editor v2"
                    intMapPreAddType = 3
                Else
                    
                    SceneryPieces(intSelSceneryNo).tSizeBotRight = Convert1Dto2Dcoords(Index)
                    
                    ' Make sure up left is < low right
                    If SceneryPieces(intSelSceneryNo).tSizeBotRight.x < SceneryPieces(intSelSceneryNo).tSizeTopLeft.x _
                     Or SceneryPieces(intSelSceneryNo).tSizeBotRight.y < SceneryPieces(intSelSceneryNo).tSizeTopLeft.y Then
                        
                        MsgBox "Lower-right boundary must be greater or equal to the upper-left boundary, try again; set the lower right limit of scenery piece on map", , "Repton Returns Editor v2"
                    Else
                        UpdateVisualControls
                        intMapPreAddType = 0
                    End If
                        
                End If
            
            Case Else                   ' Normal add piece operation
            
                ' Do not allow pieces to be added if restricted by selected 'game play type'
                'If intGamePlayType = 1 And d Then
            
                ' Check we are overwritting any special piece's. if so keep track.
                Select Case DataStr2Int(sLogicalMap(Index))
                    Case Transporter
                        ' Get transporter number
                        b = 0
                        For n = 1 To Index
                            If sLogicalMap(n) = DataInt2Str(Transporter) Then b = b + 1
                        Next n
                        
                        ' Delete
                        For n = b To UBound(tTransporterCorrds) - 1
                            tTransporterCorrds(n) = tTransporterCorrds(n + 1)
                        Next n
                        
                        ReDim Preserve tTransporterCorrds(UBound(tTransporterCorrds) - 1)
                        
                End Select
                
                ' Update logical map
                sTemp = DataInt2Str(intSelectedPieceType - 1)
                sLogicalMap(Index) = sTemp
                
                ' Set picture to currently selected piece type
                picPiece(Index).Picture = picPieceType(intSelectedPieceType).Picture
                
                intMapPreAddType = 0
                
                ' Speceil piece?
                Select Case (intSelectedPieceType - 1)
                    
                    Case enmPieceType.Transporter
                        MsgBox "Now select destiation", "Repton Returns Editor v1"
                        
                        ' Get transporter number
                        b = 0
                        For n = 1 To Index
                            If sLogicalMap(n) = DataInt2Str(Transporter) Then b = b + 1
                        Next n
                        intNewestTransporterNo = b
                        intMapPreAddType = 1
                        
                    Case enmPieceType.LevelTransport
                                                                        
                        CommonDialog.DialogTitle = "Select a saved Epsiode or Level filename"
                        CommonDialog.Filter = "*.rre; *.rrl"
                        CommonDialog.ShowOpen
                        sTemp = CommonDialog.FileName

                        If FileExists(sTemp) Then
                            ReDim Preserve tLevelTrans(UBound(tLevelTrans) + 1)
                            
                            
                            
                            tLevelTrans(UBound(tLevelTrans)).sLocalFile = sTemp
                            tLevelTrans(UBound(tLevelTrans)).tPos = Convert1Dto2Dcoords(Index)
                        Else
                            picPiece(Index).Picture = picPieceType(1).Picture
                        End If
                        
                End Select
                
                
                EvaluateMap
                
                
                
                bChangesSinceSaved = True
            
        End Select
        
    Else
        ' Give info about clicked upon piece::
        
        ' If transporter than show 'TO' piece
        If sLogicalMap(Index) = "n" Then
            ' Get transporter number
            b = 0
            For n = 1 To Index
                If sLogicalMap(n) = DataInt2Str(Transporter) Then b = b + 1
            Next n
            
            b = Convert2Dto1Dcoords(tTransporterCorrds(b))
            
            picPiece(b).Picture = picPiece(0).Picture
            picPiece(b).BackColor = shpScenery.BorderColor

            MsgBox "Selected transporter 'GO TO' position is " + Trim(Str(Convert1Dto2Dcoords(b).x)) + "," + Trim(Str(Convert1Dto2Dcoords(b).y)) + " as highlighted (green).", , "Repton Returns Editor v2"
            
            picPiece(b).Picture = picPieceType(DataStr2Int(sLogicalMap(b)) + 1).Picture
            picPiece(b).BackColor = picPiece(0).BackColor
            
        End If
        
    End If
    
End Sub

Private Sub picPiece_MouseMove(Index As Integer, Button As Integer, Shift As Integer, x As Single, y As Single)
    ' auto paint?

End Sub

Private Sub picPieceType_Click(Index As Integer)
    
    Dim bOk As Boolean
    
    bOk = True
    
    ' Control which pieces can be selected
    Select Case (Index - 1)
        Case enmPieceType.NavigationalMap
            If intGamePlayType = 3 Then bOk = False
    End Select
    
    If bOk = True Then
        
        ' Visually 'unselect' last selected piece type
        picPieceType(intSelectedPieceType).Appearance = 0
        
        intSelectedPieceType = Index
        
        ' Visually 'select' last selected piece type
        picPieceType(intSelectedPieceType).Appearance = 1
        
    Else
        MsgBox "Invalid piece under currently slected game play type", , "Repton Returns Editor v2"
    End If
End Sub



Function EvaluateMap(Optional iNewPiece As Integer = -1) As Boolean
'Returns 'true' if map is ready to publish

    Dim iPieceCounts(32) As Integer
    Dim intY As Integer
    Dim intX As Integer
    Dim intN As Integer
    
    Dim iT As Integer

    EvaluateMap = True      ' Presume true
    
    
    ' Read though map (if no new piece given)
    If iNewPiece = -1 Then
    
        intN = 1
        For intY = 1 To tMapSize.y
            For intX = 1 To tMapSize.x
                
                iT = DataStr2Int(sLogicalMap(intN))
                iPieceCounts(iT) = iPieceCounts(iT) + 1
            
                intN = intN + 1
            Next intX
        Next intY
    End If
    
    txtDebugToDo.Text = "To Do:" + vbCrLf
    
    ' Check start position = 1
    If iPieceCounts(enmPieceType.Repton) = 0 Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Add starting point" + vbCrLf
        EvaluateMap = False
    Else
        If iPieceCounts(enmPieceType.Repton) > 1 Then
            txtDebugToDo.Text = txtDebugToDo.Text + " - Delete " + Str(iPieceCounts(enmPieceType.Repton) - 1) + " starting points" + vbCrLf
            EvaluateMap = False
        End If
    End If
    
    ' Check time-bomb = 1  (if Repton 3 style game)
    If iPieceCounts(enmPieceType.Bomb) = 0 Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Add time-bomb" + vbCrLf
        EvaluateMap = False
    Else
        If iPieceCounts(enmPieceType.Bomb) > 1 Then
            txtDebugToDo.Text = txtDebugToDo.Text + " - Delete " + Str(iPieceCounts(enmPieceType.Bomb) - 1) + " time-bombs" + vbCrLf
            EvaluateMap = False
        End If
    End If
        
    ' Check diamonds > 0
    If iPieceCounts(enmPieceType.Dimond) = 0 Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Add some diamonds" + vbCrLf
        EvaluateMap = False
    End If
    
    ' Check Crowns = 1
    If iPieceCounts(enmPieceType.Crown) = 0 Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Add a crown" + vbCrLf
        EvaluateMap = False
    End If
    If iPieceCounts(enmPieceType.Crown) > 1 Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Delete " + Trim(Str(iPieceCounts(enmPieceType.Crown) - 1)) + " crown(s)" + vbCrLf
        EvaluateMap = False
    End If
    
    ' Check Spirts >= Cages
    If iPieceCounts(enmPieceType.Spirit) < iPieceCounts(enmPieceType.Cage) Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Must be equal or more spirts than cages" + vbCrLf
        EvaluateMap = False
    End If
    
    ' Check key > 0 if safes > 0
    If iPieceCounts(enmPieceType.Safe) > 0 And Not (iPieceCounts(enmPieceType.Key) > 0) Then
        txtDebugToDo.Text = txtDebugToDo.Text + " - Add a key (safes are present)" + vbCrLf
        EvaluateMap = False
    End If
    
    ' Check nav-map <> 1 when Repton 3 is select else check <= 1 when RR or Rep1 is selected
    Select Case intGamePlayType
        Case 1
            If iPieceCounts(enmPieceType.NavigationalMap) > 1 Then
                txtDebugToDo.Text = txtDebugToDo.Text + " - Delete " + Trim(Str(iPieceCounts(enmPieceType.NavigationalMap) - 1)) + " navigational-map(s)" + vbCrLf
                EvaluateMap = False
            
            End If
        
        Case 3
            If iPieceCounts(enmPieceType.NavigationalMap) > 0 Then
                txtDebugToDo.Text = txtDebugToDo.Text + " - Delete " + Trim(Str(iPieceCounts(enmPieceType.NavigationalMap))) + " navigational-map(s)" + vbCrLf
                EvaluateMap = False
            End If
        
        Case 10
            If iPieceCounts(enmPieceType.NavigationalMap) > 1 Then
                txtDebugToDo.Text = txtDebugToDo.Text + " - Delete " + Trim(Str(iPieceCounts(enmPieceType.NavigationalMap) - 1)) + " navigational-map(s)" + vbCrLf
                EvaluateMap = False
            End If
    End Select
    
    
    
    ' Check if level has been tested and competed
    'if
        txtDebugToDo.Text = txtDebugToDo.Text + " - Test if is completable level" + vbCrLf
        EvaluateMap = False
    'endif
End Function

Private Function Convert1Dto2Dcoords(int1Dcoord As Integer) As Corrds2D_T
    Dim x As Integer
    Dim y As Integer
    Dim n As Integer
    
    n = 1
    For y = 1 To tMapSize.y
        For x = 1 To tMapSize.x
            If n = int1Dcoord Then
                Convert1Dto2Dcoords.x = x
                Convert1Dto2Dcoords.y = y
                Exit Function
            End If
            
            n = n + 1
        Next x
    Next y
    
End Function

Private Function Convert2Dto1Dcoords(int2Dcoord As Corrds2D_T) As Integer
    Convert2Dto1Dcoords = (tMapSize.x * (int2Dcoord.y - 1)) + int2Dcoord.x
End Function

' RR Save files::
'
'   Episode info::
'     - RR file version
'     - Episode name
'     - Game play type
'     - Visual Theme name
'     - Level order (using levelID)
'
'   Individual level info::
'     - RR file version
'     - Level Name
'     - Time allowed
'     - Map Size
'     - Map data
'     - Transporter info (in order as from map)
'     - Sceinary filenames (in order as IDed)
'     - In-game messages data (in order as IDed)
'     - Navigation map is present from start


'Dim strEpisodeName                As String
'Dim intGamePlayType               As Integer
'Dim strLevelOrder()               As String
'
'Dim sLogicalMap()                 As String * 1
'Dim tMapSize                      As Corrds2D_T
'Dim sMapTime                      As Single
'Dim tTransporterCorrds()          As Corrds2D_T
'Dim tInGameMessages()             As GameMessages_T
'Dim SceneryPieces()               As SceneryInfo_T


Function OpenFileEpisode(strFile As String) As Boolean
' Return = True when all is ok

    Dim n As Integer
    Dim iLevel As Integer
    Dim sTemp As String
    

    OpenFileEpisode = False
    
    
    ' Episode info::
    
    strEpisodeDir = Left(strFile, InStrRev(strFile, "\"))
    
    On Error GoTo open_file_err
    Open strFile For Input As #1
        
        ' RR file version
        Input #1, sTemp
        If Left(sTemp, 20) = "ReptonReturnsEpisode" Then
            If Val(Right(sTemp, 3)) > 1 Then
                MsgBox "The Repton Returns level file requieres a newer version of this editor, check the website for updates", , "Repton Returns Editor v2"
                
                Exit Function
            End If
        Else
            MsgBox "The selected file is not a compatable Repton Returns episode file", , "Repton Returns Editor v2"
            
            Exit Function
        End If
        
        ' Episode name
        Input #1, strEpisodeName
        
        ' Game play type
        Input #1, sTemp
        intGamePlayType = Int(sTemp)
        
        ' Visual Theme name
        Input #1, strVisualTheme
        
        ' Level order (using levelID)
        n = 1
        Do
            ReDim Preserve strLevelOrder(n)
            Input #1, strLevelOrder(n)
            
            ' Copy level to temp DIR
            CopyFile strEpisodeDir + strLevelOrder(n) + ".rrl", App.Path + "\temp\"
            
            n = n + 1
        Loop Until EOF(1)
        
        
        
        OpenFileEpisode = True
        
 '       Resume
        
    Close #1
    
    ' Load the levels
    For n = 1 To UBound(strLevelOrder)
        intCurSelLevel = n
        LoadFileLevel     'strEpisodeDir + strLevelOrder(n)
    Next n

open_file_err:

End Function

Function SaveFileEpisode(strFile As String) As Boolean
' Return = True when all is ok

    Dim n As Integer
    Dim iLevel As Integer
    Dim sTemp As String
    
    Dim fso As Object
    Dim fld As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Save current level
    SaveFileLevel

    SaveFileEpisode = False
    
    ' Does file exist? if so, we are already in the working dir, else create new folder
    If fso.folderexists(strFile) = False Then
        Set fld = fso.createfolder(strFile)
    End If
    
    ' Episode info::
    On Error GoTo save_file_err
    Open strFile + "\" + strEpisodeName + ".rre" For Output As #1
        
        ' RR file version
        Print #1, "ReptonReturnsEpisodeV1.0"
        
        ' Episode name
        Print #1, strEpisodeName
        
        ' Game play type
        Print #1, Trim(Str(intGamePlayType))
        
        ' Visual Theme name
        Print #1, strVisualTheme
        
        ' Level order (using levelID)
        For n = 1 To UBound(strLevelOrder)
            Print #1, strLevelOrder(n)
        Next n
        
        strEpisodeDir = strFile
        
        SaveFileEpisode = True
        
 '       Resume
        
    Close #1
    
    ' Copy all temp levels to this folder
    For n = 1 To UBound(strLevelOrder)
        CopyFile App.Path + "\temp\" + strLevelOrder(n) + ".rrl", strFile + "\"
    Next n

save_file_err:
    
End Function

Function SaveFileLevel() As Boolean

    Dim n As Integer
    Dim x As Integer
    Dim y As Integer
    Dim sTemp As String

    SaveFileLevel = False

    ' Individual level info::

    Open App.Path + "\temp\" + strLevelOrder(intCurSelLevel) + ".rrl" For Output As #1
    
        ' RR file version
        Print #1, "ReptonReturnsLevelV1.1"
        
        ' Level Name
        Print #1, strLevelOrder(intCurSelLevel)
        
        ' Time allowed
        Print #1, Trim(Str(sngMapTime))
        
        ' Map Size
        Print #1, Trim(Str(tMapSize.x)) + "," + Trim(Str(tMapSize.y))
       
        ' Map data
        n = 1
        For y = 1 To tMapSize.y
            sTemp = ""
            For x = 1 To tMapSize.x
                If sLogicalMap(n) = "" Or sLogicalMap(n) = " " Then sLogicalMap(n) = "0"
                sTemp = sTemp + sLogicalMap(n)
            
                n = n + 1
            Next x
            Print #1, sTemp
        Next y
        
        ' Transporter info (in order as from map)
        If UBound(tTransporterCorrds) > 0 Then
            For n = 1 To UBound(tTransporterCorrds)
                Print #1, Trim(Str(tTransporterCorrds(n).x)) + "," + Trim(Str(tTransporterCorrds(n).y))
            Next n
        End If
        
        ' Sceinary filenames (in order as IDed)
        Print #1, Trim(Str(UBound(SceneryPieces)))              ' How many
        If UBound(SceneryPieces) > 0 Then
            For n = 1 To UBound(SceneryPieces)
                Print #1, Trim(Str(SceneryPieces(n).tSizeTopLeft.x)) + "," + Trim(Str(SceneryPieces(n).tSizeTopLeft.y))
               
                Print #1, Trim(Str(SceneryPieces(n).tSizeBotRight.x)) + "," + Trim(Str(SceneryPieces(n).tSizeBotRight.y))
                
                Print #1, CStr(SceneryPieces(n).bIsMovableTo)
                
                Print #1, SceneryPieces(n).strMeshFile
                Print #1, SceneryPieces(n).strTexFile
            Next n

        End If
        
        ' In-game messages data (in order as IDed)
        Print #1, Trim(Str(UBound(tInGameMessages)))                  ' How many
        If UBound(tInGameMessages) > 0 Then
        
            For n = 1 To UBound(tInGameMessages)
                
                Print #1, Trim(Str(tInGameMessages(n).iTotTrigs))
                If tInGameMessages(n).iTotTrigs > 0 Then
                    For x = 1 To tInGameMessages(n).iTotTrigs
                        Print #1, Trim(Str(tInGameMessages(n).tTriggers(x).x)) + "," + Trim(Str(tInGameMessages(n).tTriggers(x).y))
                    Next x
                End If
                
                sTemp = tInGameMessages(n).strMessage
                
                Print #1, sTemp
                Replace sTemp, ",", "<comma>"
                
                Print #1, "</game-message>"
            Next n
        End If
        
        ' Navigation map is present from start
        Print #1, CStr(bNavMapFromStart)
        
        SaveFileLevel = True

    Close #1
    
End Function


Function LoadFileLevel() As Boolean

    Dim n As Integer
    Dim x As Integer
    Dim y As Integer
    Dim sTemp As String
    
    LoadFileLevel = False

    ' Individual level info::

    Open App.Path + "\temp\" + strLevelOrder(intCurSelLevel) + ".rrl" For Input As #1
    
        ReDim tTransporterCorrds(0)
    
        ' RR file version
        Input #1, sTemp   '"ReptonReturnsLevelV1.1"
        If Left(sTemp, 18) = "ReptonReturnsLevel" Then
            If Val(Right(sTemp, 3)) > 1.1 Then
                MsgBox "The Repton Returns level file requieres a newer version of this editor, check the website for updates", , "Repton Returns Editor v2"
                
                Exit Function
            End If
        Else
            MsgBox "The selected file is not a compatable Repton Returns level", , "Repton Returns Editor v2"
            
            Exit Function
        End If
        
        ' Level Name
        Input #1, strLevelOrder(intCurSelLevel)
        
        ' Time allowed
        Input #1, sngMapTime
        
        ' Map Size
        Input #1, sTemp
        tMapSize.x = Int(sTemp)
        Input #1, sTemp
        tMapSize.y = Int(sTemp)
        
        ' Map data
        ReDim sLogicalMap(tMapSize.x * tMapSize.y)
        n = 1
        For y = 1 To tMapSize.y
            Input #1, sTemp
            For x = 1 To tMapSize.x
            
                sLogicalMap(n) = Mid(sTemp, x, 1)
                
                If sLogicalMap(n) = "n" Then ReDim tTransporterCorrds(UBound(tTransporterCorrds) + 1) ' Keep track of no of transporters
            
                n = n + 1
            Next x
        Next y
        
        ' Transporter info (in order as from map)
        If UBound(tTransporterCorrds) > 0 Then
            For n = 1 To UBound(tTransporterCorrds)
                Input #1, sTemp
                tTransporterCorrds(n).x = Int(sTemp)
                Input #1, sTemp
                tTransporterCorrds(n).y = Int(sTemp)
            Next n
        End If
        
        ' Sceinary filenames (in order as IDed)
        Input #1, sTemp                              ' How many
        ReDim SceneryPieces(Int(sTemp))
        If UBound(SceneryPieces) > 0 Then
            For n = 1 To UBound(SceneryPieces)
                Input #1, sTemp
                SceneryPieces(n).tSizeTopLeft.x = Int(sTemp)
                Input #1, sTemp
                SceneryPieces(n).tSizeTopLeft.y = Int(sTemp)
                
                Input #1, sTemp
                SceneryPieces(n).tSizeBotRight.x = Int(sTemp)
                Input #1, sTemp
                SceneryPieces(n).tSizeBotRight.y = Int(sTemp)
                
                Input #1, sTemp
                SceneryPieces(n).bIsMovableTo = CBool(sTemp)
                
                Input #1, SceneryPieces(n).strMeshFile
                Input #1, SceneryPieces(n).strTexFile
                
            Next n
            
            intSelSceneryNo = 1

        End If
        
        ' In-game messages data (in order as IDed)
        Input #1, sTemp                              ' How many
        ReDim tInGameMessages(Int(sTemp))
            
        If UBound(tInGameMessages) > 1 Then
            For n = 1 To UBound(tInGameMessages)
                Input #1, sTemp
                tInGameMessages(n).iTotTrigs = Int(sTemp)
                
                If tInGameMessages(n).iTotTrigs > 0 Then
                    For x = 1 To tInGameMessages(n).iTotTrigs
                        Input #1, sTemp
                        tInGameMessages(n).tTriggers(x).x = Int(sTemp)
                        Input #1, sTemp
                        tInGameMessages(n).tTriggers(x).y = Int(sTemp)
                    Next x
                End If
                
                Input #1, sTemp
                Do While sTemp <> "</game-message>"
                    tInGameMessages(n).strMessage = tInGameMessages(n).strMessage + vbCrLf + sTemp
                    Input #1, sTemp
                Loop
                Replace tInGameMessages(n).strMessage, "<comma>", ","
            Next n
            intSelMsgNo = 1
        End If
        
        ' Navigation map is present from start
        Input #1, sTemp
        bNavMapFromStart = CBool(sTemp)
        
        LoadFileLevel = True
        
    Close #1
    
End Function


Function DataInt2Str(intIn As enmPieceType) As String

' Used charicters:   abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ%*)^$(&£!|\`¬¦@;:.<>#~=+-_
'  (underlined)      ------- - - -- - ----  - -----------                          -    ----

   If intIn = 0 Then DataInt2Str = "0"    'Space...
   If intIn = 1 Then DataInt2Str = "5"
   If intIn = 2 Then DataInt2Str = "d"    'Dimond
   If intIn = 3 Then DataInt2Str = "8"    'Walls...
   If intIn = 4 Then DataInt2Str = "2"
   If intIn = 5 Then DataInt2Str = "6"
   If intIn = 6 Then DataInt2Str = "4"
   If intIn = 7 Then DataInt2Str = "9"
   If intIn = 8 Then DataInt2Str = "7"
   If intIn = 9 Then DataInt2Str = "3"
   If intIn = 10 Then DataInt2Str = "1"
   If intIn = 11 Then DataInt2Str = "e"   'Earth
   If intIn = 12 Then DataInt2Str = "r"   'Rock
   If intIn = 13 Then DataInt2Str = "s"   'Safe
   If intIn = 14 Then DataInt2Str = "k"   'Key
   If intIn = 15 Then DataInt2Str = "g"   'Egg
   If intIn = 16 Then DataInt2Str = "i"   'Repton stating point
   If intIn = 17 Then DataInt2Str = "t"   'Crown
   If intIn = 18 Then DataInt2Str = "c"   'Cage
   If intIn = 19 Then DataInt2Str = "p"   'Spirit stating point
   If intIn = 20 Then DataInt2Str = "b"   'Bomb
   If intIn = 21 Then DataInt2Str = "f"   'Fungus
   If intIn = 22 Then DataInt2Str = "u"   'Skull
   If intIn = 23 Then DataInt2Str = "a"   'Barrier (looks like batteries)
   If intIn = 24 Then DataInt2Str = "m"   'Monster
   If intIn = 25 Then DataInt2Str = "n"   'Transporter
   If intIn = 26 Then DataInt2Str = "z"   'TimeCapsule
   
   If intIn = enmPieceType.FilledWall Then DataInt2Str = "%"
   If intIn = enmPieceType.FilledWall7 Then DataInt2Str = "&"
   If intIn = enmPieceType.FilledWall9 Then DataInt2Str = "("
   If intIn = enmPieceType.FilledWall1 Then DataInt2Str = "!"
   If intIn = enmPieceType.FilledWall3 Then DataInt2Str = "£"
   
   If intIn = enmPieceType.NavigationalMap Then DataInt2Str = "x"
   
End Function


Function DataStr2Int(strIn As String) As Integer

   DataStr2Int = 0
   
   If strIn = "0" Then DataStr2Int = 0
   If strIn = "5" Then DataStr2Int = 1
   If strIn = "d" Then DataStr2Int = 2
   If strIn = "8" Then DataStr2Int = 3
   If strIn = "2" Then DataStr2Int = 4
   If strIn = "6" Then DataStr2Int = 5
   If strIn = "4" Then DataStr2Int = 6
   If strIn = "9" Then DataStr2Int = 7
   If strIn = "7" Then DataStr2Int = 8
   If strIn = "3" Then DataStr2Int = 9
   If strIn = "1" Then DataStr2Int = 10
   If strIn = "e" Then DataStr2Int = 11
   If strIn = "r" Then DataStr2Int = 12
   If strIn = "s" Then DataStr2Int = 13
   If strIn = "k" Then DataStr2Int = 14
   If strIn = "g" Then DataStr2Int = 15
   If strIn = "i" Then DataStr2Int = 16
   If strIn = "t" Then DataStr2Int = 17
   If strIn = "c" Then DataStr2Int = 18
   If strIn = "p" Then DataStr2Int = 19
   If strIn = "b" Then DataStr2Int = 20
   If strIn = "f" Then DataStr2Int = 21    'Fungus
   If strIn = "u" Then DataStr2Int = 22    'Skull
   If strIn = "a" Then DataStr2Int = 23    'Barrier (looks like batteries)
   If strIn = "m" Then DataStr2Int = 24
   If strIn = "n" Then DataStr2Int = 25
   If strIn = "z" Then DataStr2Int = 26
   
   If strIn = "%" Then DataStr2Int = enmPieceType.FilledWall
   If strIn = "&" Then DataStr2Int = enmPieceType.FilledWall7
   If strIn = "(" Then DataStr2Int = enmPieceType.FilledWall9
   If strIn = "!" Then DataStr2Int = enmPieceType.FilledWall1
   If strIn = "£" Then DataStr2Int = enmPieceType.FilledWall3
   
   If strIn = "x" Then DataStr2Int = enmPieceType.NavigationalMap
      
End Function


Function ImportReptonFX(strFolder As String)
    Dim sTemp As String
    Dim sName As String
    Dim n As Integer
    Dim x As Integer
    Dim y As Integer
    Dim iMap As Integer
    
    Dim tTranFrom(10) As Corrds2D_T
    Dim tTranTo(10) As Corrds2D_T

    For iMap = 1 To 8
    
          
        sName = strFolder + "map" + Trim(Str(iMap)) + ".fxr"
        If FileExists(sName) = True Then
            
            Open sName For Input As #1
            Open App.Path + "\temp\fromrepfx.tmp" For Output As #2
            
            
            Input #1, sTemp
            Do
                Print #2, Left(sTemp, InStr(1, sTemp, vbLf) - 1)
                sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, vbLf))
            Loop Until Len(sTemp) = 0
            
            Close #2
            Close #1
        
            Open App.Path + "\temp\fromrepfx.tmp" For Input As #1
            
                ReDim tTransporterCorrds(0)
            
                ' map size x : map size y : no of transporters : time bomb time
                Input #1, sTemp
                tMapSize.x = Int(Left(sTemp, InStr(1, sTemp, " ") - 1))
                sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, " "))
                
                tMapSize.y = Int(Left(sTemp, InStr(1, sTemp, " ") - 1))
                sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, " "))
                
                ReDim tTransporterCorrds(Int(Left(sTemp, InStr(1, sTemp, " ") - 1)))
                sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, " "))
                
                sngMapTime = (Val(sTemp) * 2)
                        
                ' Password (level name) - note, is encoded
                Input #1, sTemp
                sName = ""
                For y = 1 To Len(sTemp)
                    
                    ' Decode
                    x = Asc(Mid(sTemp, y))
                    x = x - 13
                    If x < Asc("a") Then
                        'x = Asc("a") + x - Asc("z") - 1
                        x = Asc("z") + x - Asc("a") + 1
                    End If
                    
                    ' Make first charictor upper case
                    If y = 1 Then x = x - 32
                    sName = sName + Chr(x)
                    
                Next y
                
                ReDim Preserve strLevelOrder(iMap)
                strLevelOrder(iMap) = sName
                
                
                
                ' Transporter coords (if any)  - 1 to&from coords per line
                If UBound(tTransporterCorrds) > 1 Then
                    
                    ' Load data into tempary structures ...
                    For x = 1 To UBound(tTransporterCorrds)
                        Input #1, sTemp
                        
                        
                        tTranFrom(x).x = Int(Left(sTemp, InStr(1, sTemp, " ") - 1))
                        sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, " "))
                        
                        tTranFrom(x).y = Int(Left(sTemp, InStr(1, sTemp, " ") - 1))
                        sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, " "))
                        
                        tTranTo(x).x = Int(Left(sTemp, InStr(1, sTemp, " ") - 1))
                        sTemp = Right(sTemp, Len(sTemp) - InStr(1, sTemp, " "))
                        
                        tTranTo(x).y = Int(sTemp)
                        
                    Next x
                    
                    ' Sort transporters so that first to 'apper' in map is first in array ...
                    Do
                        y = 0
                        
                        For x = 1 To (UBound(tTransporterCorrds) - 1)  ' - (x-1)  ???
                            If Convert2Dto1Dcoords(tTranFrom(x)) > Convert2Dto1Dcoords(tTranFrom(x + 1)) Then
                                
                                tTranFrom(0) = tTranFrom(x)
                                tTranTo(0) = tTranTo(x)
                                
                                tTranFrom(x) = tTranFrom(x + 1)
                                tTranTo(x) = tTranTo(x + 1)
                                
                                tTranFrom(x + 1) = tTranFrom(0)
                                tTranTo(x + 1) = tTranTo(0)
                                
                                y = 1       ' Say that there has been a change
                            End If
                        Next x
                    
                    Loop Until y = 0
                    
                    ' Save transporter corrds
                    For x = 1 To UBound(tTransporterCorrds)
                        tTransporterCorrds(x).x = tTranTo(x).x + 1
                        tTransporterCorrds(x).y = tTranTo(x).y + 1
                    Next x
                End If
                
                
                ' Map data
                n = 1
                ReDim sLogicalMap(tMapSize.x * tMapSize.y)
                For y = 1 To tMapSize.y
                    Input #1, sTemp
                    For x = 1 To tMapSize.x
                    
                        sLogicalMap(n) = DataInt2Str(DataFxRepton2RRInt(Mid(sTemp, x, 1)))
                        n = n + 1
                    Next x
                Next y
                
            Close #1
            
            ' Set episode name
            If iMap = 1 Then strEpisodeName = sName
        
            intCurSelLevel = iMap
        
            SaveFileLevel
                
        End If
        
    Next iMap
    
    intGamePlayType = 3
End Function

Function DataFxRepton2RRInt(strIn As String) As Integer

   If strIn = "G" Then DataFxRepton2RRInt = enmPieceType.Space
   If strIn = "H" Then DataFxRepton2RRInt = enmPieceType.Wall
   If strIn = "B" Then DataFxRepton2RRInt = enmPieceType.Dimond
   If strIn = "K" Then DataFxRepton2RRInt = enmPieceType.Wall8
   If strIn = "L" Then DataFxRepton2RRInt = enmPieceType.Wall2
   If strIn = "J" Then DataFxRepton2RRInt = enmPieceType.Wall6
   If strIn = "I" Then DataFxRepton2RRInt = enmPieceType.Wall4
   If strIn = "N" Then DataFxRepton2RRInt = enmPieceType.Wall9
   If strIn = "M" Then DataFxRepton2RRInt = enmPieceType.Wall7
   If strIn = "P" Then DataFxRepton2RRInt = enmPieceType.Wall3
   If strIn = "O" Then DataFxRepton2RRInt = enmPieceType.Wall1
   If strIn = "C" Or strIn = "D" Then DataFxRepton2RRInt = enmPieceType.Earth
   If strIn = "A" Then DataFxRepton2RRInt = enmPieceType.Rock
   If strIn = "W" Then DataFxRepton2RRInt = enmPieceType.Safe
   If strIn = "Z" Then DataFxRepton2RRInt = enmPieceType.Key
   If strIn = "Y" Then DataFxRepton2RRInt = enmPieceType.Egg
   If strIn = "_" Then DataFxRepton2RRInt = enmPieceType.Repton
   If strIn = "^" Then DataFxRepton2RRInt = enmPieceType.Crown
   If strIn = "X" Then DataFxRepton2RRInt = enmPieceType.Cage
   If strIn = "`" Or strIn = "a" Then DataFxRepton2RRInt = enmPieceType.Spirit
   If strIn = "\" Then DataFxRepton2RRInt = enmPieceType.Bomb
   If strIn = "[" Then DataFxRepton2RRInt = enmPieceType.Fungus
   If strIn = "F" Then DataFxRepton2RRInt = enmPieceType.Skull
   If strIn = "V" Then DataFxRepton2RRInt = enmPieceType.Barrier
   If strIn = "b" Or strIn = "c" Then DataFxRepton2RRInt = enmPieceType.Monster
   If strIn = "]" Then DataFxRepton2RRInt = enmPieceType.Transporter
   If strIn = "E" Then DataFxRepton2RRInt = enmPieceType.TimeCapsule
   
   If strIn = "Q" Then DataFxRepton2RRInt = enmPieceType.FilledWall
   If strIn = "R" Then DataFxRepton2RRInt = enmPieceType.FilledWall7
   If strIn = "S" Then DataFxRepton2RRInt = enmPieceType.FilledWall9
   If strIn = "T" Then DataFxRepton2RRInt = enmPieceType.FilledWall1
   If strIn = "U" Then DataFxRepton2RRInt = enmPieceType.FilledWall3
   
End Function


'ReptonFX  ::   Orgigonal Repton map info
'A    OBJ_ROCK = 0,
'B    OBJ_DIAMOND,
'C    OBJ_GROUND1,
'D    OBJ_GROUND2,
'E    OBJ_TIMECAPSULE,
'F    OBJ_SKULL,
'G    OBJ_EMPTY,
'H    OBJ_WALL,
'I    OBJ_WALL_WEST,
'J    OBJ_WALL_EAST,
'K    OBJ_WALL_NORTH,
'L    OBJ_WALL_SOUTH,
'M    OBJ_WALL_NORTH_WEST,
'N    OBJ_WALL_NORTH_EAST,
'O    OBJ_WALL_SOUTH_WEST,
'P    OBJ_WALL_SOUTH_EST,
'Q    OBJ_FILLED_WALL,
'R    OBJ_FILLED_WALL_NORTH_WEST,
'S    OBJ_FILLED_WALL_NORTH_EAST,
'T    OBJ_FILLED_WALL_SOUTH_WEST,
'U    OBJ_FILLED_WALL_SOUTH_EST,
'V    OBJ_WALL_MIRROR,              ' Barrier??
'W    OBJ_STRONGBOX,
'X    OBJ_CAGE,
'Y    OBJ_EGG,
'Z    OBJ_KEY,
'[    OBJ_FUNGUS,
'\    OBJ_BOMB,
']    OBJ_TRANSPORTER,
'^    OBJ_CROWN,
'_    OBJ_REPTON,
'`    OBJ_SPIRIT,
'a    OBJ_SPIRIT2,
'b    OBJ_MONSTER,
'c    OBJ_MONSTER2,
'd    OBJ_REPTON_LOOK_LEFT,
'e    OBJ_REPTON_LOOK_RIGHT,
'f    OBJ_REPTON_GO_RIGHT1,
'g    OBJ_REPTON_GO_RIGHT2,
'h    OBJ_REPTON_GO_RIGHT3,
'i    OBJ_REPTON_GO_RIGHT4,
'j    OBJ_REPTON_GO_LEFT1,
'k    OBJ_REPTON_GO_LEFT2,
'l    OBJ_REPTON_GO_LEFT3,
'm    OBJ_REPTON_GO_LEFT4,
'n    OBJ_REPTON_GO_UP1,
'o    OBJ_REPTON_GO_UP2,
'p    OBJ_BROKEN_EGG
