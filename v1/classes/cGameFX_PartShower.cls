VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGameFxParticle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Private Ex3D As New exMesh



Private Type FXinstence_T
    
    ' Position
    m_x As Single
    m_y As Single
    m_z As Single
    
    ' Velocity
    m_vx As Single
    m_vy As Single
    m_vz As Single
    
    ' Gravity       (dev note: rename to 'force' would be more genneric and suitable)
    m_gx As Single
    m_gy As Single
    m_gz As Single
    
    ' Rotation
    m_rx As Single
    m_ry As Single
    m_rz As Single
    
    m_type As String
    
    m_marker As Single                 ' = 0 when instence not in use  / stop-time for emitter instence
    
    m_timer As New exTools_Timer
End Type

Private u_emit As FXinstence_T      ' Particle emitter
Private u_par(20) As FXinstence_T   ' Particles
Private iPartsAlive As Integer
'private iLastPartToDie as Integer   ' Stores the last particle that died so that when creating a new par

' Emitter properties
'TODO: Private fHzParts                 As Single   ' Frequency of particle generation (particles per second)
'TODO: Private fHzPartsRandomOffset     As Single   ' Particles per second randomisity (+/- randomness of number of particales per second)
Public fEmitBoundBoxRadiusX   As Single      ' The radius of the upper and lower plains perpendicular to the X axis
Public fEmitBoundBoxRadiusY   As Single      ' The radius of the upper and lower plains perpendicular to the Y axis
Public fEmitBoundBoxRadiusZ   As Single      ' The radius of the upper and lower plains perpendicular to the Z axis

' Partile behaviour
Public fHzRevsX As Single          ' Particle full (360) rotations per second on X axis
Public fHzRevsY As Single          ' Particle full (360) rotations per second on Y axis
Public fHzRevsZ As Single          ' Particle full (360) rotations per second on Z axis
Public fHzRevsXoffset As Single          ' Random rotations per second (upto fHzRevsXoffset) on X axis offsetted to fHzRevsX
Public fHzRevsYoffset As Single          ' Random rotations per second (upto fHzRevsXoffset) on Y axis offsetted to fHzRevsY
Public fHzRevsZoffset As Single          ' Random rotations per second (upto fHzRevsXoffset) on Z axis offsetted to fHzRevsZ

'Private sngAniSpeed As Single
'Private Const sngAniLen = 100#

'Private Enum FX_Type
'    InternalAni = 0
'    Diamond
'End Enum
'
'Private iFXtype As FX_Type
Private sType As String

Public bIsAlive As Boolean


Public Function Init(X As Single, Y As Single, z As Single, vx As Single, vy As Single, vz As Single, gx As Single, gy As Single, gz As Single, endtime As Single)

    Dim n As Integer

    bIsAlive = True
    
    u_emit.m_timer.ReSet
    u_emit.m_marker = endtime
    
    ' Position
    u_emit.m_x = X
    u_emit.m_y = Y
    u_emit.m_z = z
   
    ' Velocity
    u_emit.m_vx = vx
    u_emit.m_vy = vy
    u_emit.m_vz = vz
    
    ' Force (gravity)
    u_emit.m_gx = gx
    u_emit.m_gy = gy
    u_emit.m_gz = gz
    
    ' Current rotation amount
    
    ' Rotation speed
    
    StartParticle 0
    
End Function

Public Function DeInit()
End Function

'Public Function IsAlive() As Boolean
'    If u_emit.m_marker = 0 Then
'        IsAlive = False
'    Else
'        IsAlive = True
'    End If
'End Function

Public Function RenderInstences()
    Dim n As Integer
    Dim b As Integer
    
    ' Exit if this emitter is not alive & active
    If u_emit.m_marker = 0 Then Exit Function

    ' Render active particles
    For n = 0 To UBound(u_par)
        If u_par(n).m_marker <> 0 Then

            ' Update locations
            ddPysVelocityUpdate n, 0
            
            ' Render
            Ex3DParticles(u_par(n).m_type).ResetMatrix
            Ex3DParticles(u_par(n).m_type).Rotate u_par(n).m_rx, u_par(n).m_ry, u_par(n).m_rz, True
            Ex3DParticles(u_par(n).m_type).position u_par(n).m_x, u_par(n).m_y, u_par(n).m_z, True
            Ex3DParticles(u_par(n).m_type).Render
            
            ' Particle has died?
            If u_par(n).m_z < (u_emit.m_z - 10) Then
                u_par(n).m_marker = 0
                iPartsAlive = iPartsAlive - 1
            End If
        End If
    Next n
    
    ' Emitter has died and inactive (i.e. no falling particles)?
    If u_emit.m_timer.LocalTime > u_emit.m_marker And iPartsAlive <= 0 Then
        u_emit.m_marker = 0
        bIsAlive = False
    End If
    
    ' Activate a new particle?
    If u_emit.m_timer.LocalTime < u_emit.m_marker Then  ' Only if emitter is alive
        
        StartParticle GetRandomPartType(u_emit.m_type)
    End If
    
End Function



Private Function StartParticle(sParticleType As String) As Integer
' Returns: -1 if there are no free particles

    ' Find free particle
    StartParticle = -1
    Do
        StartParticle = StartParticle + 1
        If StartParticle > UBound(u_par) Then StartParticle = -1: Exit Function
    Loop While u_par(StartParticle).m_marker <> 0

    
    ' Set starting position
    u_par(StartParticle).m_x = u_emit.m_x + ((Rnd() * (fEmitBoundBoxRadiusX * 2)) - fEmitBoundBoxRadiusX)
    u_par(StartParticle).m_y = u_emit.m_y + ((Rnd() * (fEmitBoundBoxRadiusY * 2)) - fEmitBoundBoxRadiusY)
    u_par(StartParticle).m_z = u_emit.m_z + ((Rnd() * (fEmitBoundBoxRadiusZ * 2)) - fEmitBoundBoxRadiusZ)
    
    ' Gravity (* particle mass)
    u_par(StartParticle).m_gx = u_emit.m_gx
    u_par(StartParticle).m_gy = u_emit.m_gy
    u_par(StartParticle).m_gz = u_emit.m_gz  '* Rnd(Timer())
    
    ' Set random velocaty
    u_par(StartParticle).m_vx = u_emit.m_vx + ((Rnd() * 10) - 5)
    u_par(StartParticle).m_vy = u_emit.m_vy + ((Rnd() * 10) - 5)
    u_par(StartParticle).m_vz = u_emit.m_vz + ((Rnd() * 0.5) - 0.5)
    
    ' Set random rotation (only if particle rotation values have been set up)
    If fHzRevsX = 0 And fHzRevsY = 0 And fHzRevsZ = 0 Then
        fHzRevsX = fHzRevsX + ((Rnd() * (fHzRevsXoffset * 2)) - fHzRevsXoffset)
        fHzRevsY = fHzRevsY + ((Rnd() * (fHzRevsYoffset * 2)) - fHzRevsYoffset)
        fHzRevsZ = fHzRevsX + ((Rnd() * (fHzRevsZoffset * 2)) - fHzRevsZoffset)
    End If
    

 
    u_par(StartParticle).m_marker = 1
    u_par(StartParticle).m_timer.ReSet
    u_par(StartParticle).m_type = sParticleType
    
    iPartsAlive = iPartsAlive + 1
    
End Function

Private Function GetRandomPartType(fountain_type As String) As String

End Function

Private Sub ddPysVelocityUpdate(i As Integer, fTime As Single)

    ' Add force to velocity
    u_par(i).m_vx = u_par(i).m_vx + u_emit.m_gx * 0.5 '* fTime
    u_par(i).m_vy = u_par(i).m_vy + u_emit.m_gy * 0.5 '* fTime
    u_par(i).m_vz = u_par(i).m_vz + u_emit.m_gz * 0.5 ' * fTime

    ' Update position by applying velocity
    u_par(i).m_x = u_par(i).m_x + u_par(i).m_vx
    u_par(i).m_y = u_par(i).m_y + u_par(i).m_vy
    u_par(i).m_z = u_par(i).m_z + u_par(i).m_vz
    
    ' Update rotaion
    u_par(i).m_rx = u_par(i).m_rx + fHzRevsX
    u_par(i).m_ry = u_par(i).m_ry + fHzRevsY
    u_par(i).m_rz = u_par(i).m_rz + fHzRevsZ

End Sub


