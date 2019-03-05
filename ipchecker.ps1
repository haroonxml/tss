###############################################################################################
# email params
$smtpuser = Get-Content ".\secureuser.txt" | ConvertTo-SecureString
$Pass = Get-Content ".\securepass.txt" | ConvertTo-SecureString
$smtpcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $smtpuser, $Pass
$ToAddress = 'valentin.dumitrescu@fintechos.com'
$FromAddress = 'valentin.dumitrescu@fintechos.com', 'dumitrescuv@yahoo.com'
$SMTPServer = 'smtp.office365.com'
$SMTPPort = '587'


while($true) {
#Start check
$i = 0
$lines = Get-Content -Path .\checklist.txt | Measure-Object –Line

# get_content of allowed IPs text file  
$ips = Get-Content -Path .\checklist.txt

    while($i -lt $lines.Lines)
    {
           
  
    # Check IP adrdess for the given url

    $resolvedip = [System.Net.Dns]::GetHostAddresses($ips[$i])[0]

    # Compare to existing rule

    if($resolvedip.IPAddressToString -eq $ips[$i+1])
    {
       # do nothing
    }
    else
    {
    # Compose message in case of failure
    $ip = $ips[$i]
    $newip = $resolvedip.IPAddressToString
    $strDate = Get-Date
    $strday = "$($strDate.Day)_$($strDate.Month)_$($strDate.Year)"
    $strhour = "$($strDate.hour):$($strDate.minute)"
    $message = "IP address for $ip is not equal to configured value. Please update. The new IP address is: $newip, changed on $strday at $strhour."
    # write the new value to host
    Write-host $message

    # Send email

    $mailparam = @{
    To = $ToAddress
    From = $FromAddress
    Subject = 'IP Changed ALERT'
    Body = $message
    Smtpserver = $SMTPServer
    Port = $SMTPPort
    Credential = $smtpcred

    }

        Send-MailMessage @mailparam -UseSsl


    # add text
    }




    $i++
    $i++
    }
    
    Start-Sleep -s 600

    }
