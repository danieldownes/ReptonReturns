Attribute VB_Name = "dsGenVarableManip"
'--------- Numeic maipulation -----------



'--------  String manpiulation  ---------
Function getStringSeg(strDat, chrSeperator, intNum)
'Gets a string segment in a multi-embedded string of data

    If strDat = Empty Then Exit Function

   'Start Of String
   sos = 1

   'Lengh Of String
   los = 0

   'Commer number
   cn = 0

   n = 0
   

   'Find the segment
   Do

      n = n + 1
    
      'Look for seperator
      If Mid$(strDat, n, Len(chrSeperator)) = chrSeperator Then
    
         cn = cn + 1
         
         'Remember start of string | Do not include seperator
         If cn = intNum - 1 Then sos = n + Len(chrSeperator)

         'Remember lenth of string
         If cn = intNum Then los = n - sos
      End If
    
      'If last segment,
      If n > Len(strDat) Then
        los = n - sos
        
        'Force exit
        cn = intNum
      End If
   Loop Until cn = intNum

   'sos = sos - 2

   getStringSeg = Mid(strDat, sos, los)
    
    
End Function

Function getNumSegs(strDat As String, strSep As String) As Integer
    Dim n As Integer
    Dim intSepLenT As Integer
    
    intSepLenT = Len(strSep)
    
    For n = 1 To Len(strDat)
        If Mid(strDat, n, intSepLenT) = strSep Then getNumSegs = getNumSegs + 1
    Next n
    getNumSegs = getNumSegs + 1
End Function

Function replaceChrsInStr(theStr As String, theChr As String, withChr As String)
'Replaces 'theChr' with 'withChr' in 'theStr'.
        
    replaceChrsInStr = ""
    For n = 1 To Len(theStr)
        newChr = Mid(theStr, n, 1)
        
        If Mid(theStr, n, 1) = theChr Then
            newChr = withChr
        End If
        
        replaceChrsInStr = replaceChrsInStr + newChr
    Next n
    
End Function


Sub ReDimDsObjectArray(intObjs As Integer, intKeys As Integer)
'    ReDim temp(3, intObjs, 10, intKeys, 2) As String
'
'    temp = dsObject
'
'    ReDim dsObject(3, intObjs, 10, intKeys, 2) As String
'
'    dsObject = temp
End Sub
