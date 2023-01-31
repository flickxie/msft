# $language = "VBScript"
# $interface = "1.0"


Sub Main

  crt.Screen.Synchronous = True

  crt.Screen.Send vbCr & vbCr & vbCr & vbCr

  crt.Screen.WaitForString "$"
  
  crt.Screen.Send "sudo apt-get update" & vbCr
  
  crt.Screen.WaitForString "$"

  crt.Screen.Send "sudo apt-get upgrade -y" & vbCr

  crt.Screen.WaitForString "$"

  crt.Screen.Send "sudo apt-get dist-upgrade -y" & vbCr

  crt.Screen.Synchronous = False

End Sub
