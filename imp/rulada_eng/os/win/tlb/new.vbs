Option Explicit

On Error Resume Next

Const PktPrivacy = 6 ' Authentication Level

Dim Service          ' Connection
Dim ManagementAgent  ' Management agent
Dim RetVal           ' String for the Return Value from the execute call
Dim Retry            ' Retry count
Dim RetryMax         ' Maximum retry attempts
Dim RetMsg           ' Return message string

Set Service = GetObject("winmgmts:{authenticationLevel=PktPrivacy}!root\MicrosoftIdentityIntegrationServer")
Set ManagementAgent = Service.Get("MIIS_ManagementAgent.Name='ADMA Import'")

Retry = 0
RetryMax = 3

Do

    RetVal = ManagementAgent.Execute("Full Import (Stage Only)")
    Retry=Retry + 1

    If RetVal = "no-start-connection" or RetVal = "stopped-connectivity" then
        Wscript.Echo "Unable to contact Connected Directory. Retrying connection in 30 seconds..."
        Wscript.Sleep (30000)
        WScript.Echo "Wake Up"

    End if

Loop until RetVal <> "no-start-connection" or RetVal <> "stopped-connectivity" or Retry = RetryMax
 
Select Case RetVal

   Case "success"
      RetMsg = "Success!!!"
      
   Case "completed-errors"
      RetMsg =  "Errors"
   
   Case "no-start-connection"
      RetMsg = "MA was unable to contact remote CD after 3 attempts." & vbcrlf

      RetMsg = RetMsg & "Please check remote server and network conditions then" & vbcrlf

      RetMsg = RetMsg & "Attempt to execute the MA again." 

   Case "stopped-connectivity"
      RetMsg = "Network connectivity was lost during the MA run." & vbcrlf

      RetMsg = RetMsg & "Ensure that you have network connectivity before running the MA again."  
      
   Case Else
         'Put other code here to handle errors or other important cases.
      RetMsg = "The error " & RetVal & " occurred."
    
End Select

WScript.echo RetMsg

Sub ErrorHandler (ErrorMessage)
  WScript.Echo ErrorMessage
  WScript.Quit(1)
End Sub
