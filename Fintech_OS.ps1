
param(
	[Object] $p_DbConnServer,
	[Object] $p_DbConnSqlAuthUser,
	[Object] $p_DbConnSqlAuthPass,
	[Object] $p_DbConnDb
)

# Initialize secondary partition and assign drive letter

Get-Disk |

Where partitionstyle -eq 'raw' |

Initialize-Disk -PartitionStyle MBR -PassThru |

New-Partition -AssignDriveLetter -UseMaximumSize |

Format-Volume -FileSystem NTFS -NewFileSystemLabel "data" -Confirm:$false

# Set Bucharest TimeZone

Set-TimeZone -Name "GTB Standard Time"

# Create local folders
New-Item -ItemType directory -Path C:\Kits\FintechOS
New-Item -ItemType directory -Path C:\Temp
New-Item -ItemType directory -Path F:\UploadEBS

# Add Windows Defender exclusions

Add-MpPreference -ExclusionPath "F:\Sites"
Add-MpPreference -ExclusionPath "F:\UploadEBS"

# Download and install SSMS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "http://download.microsoft.com/download/3/C/7/3C77BAD3-4E0F-4C6B-84DD-42796815AFF6/SSMS-Setup-ENU.exe" -OutFile "C:\temp\SSMS-Setup-ENU.exe"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/valentindumitrescu/FintechOS/master/fintechossqlscripts.ps1" -OutFile "C:\temp\fintechossqlscripts.ps1"
Start-Process -Filepath "C:\temp\SSMS-Setup-ENU.exe" -ArgumentList "/install /quiet /norestart" -wait

#Allow PSRemoting
Set-Item wsman:\localhost\client\trustedhosts * -Force
Restart-Service WinRM
& netsh advfirewall firewall add rule name="AllowPSRemotingTest" dir=in action=allow protocol=TCP localport=5985,5986

# Install IIS feature with all needed optional features

Install-WindowsFeature -name Web-Server -IncludeManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment
Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45 -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45 -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASP -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CGI -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ServerSideIncludes -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All





# Download FintechOS files
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/7zip.zip" -OutFile "C:\temp\7zip.zip"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/PsExec.zip" -OutFile "C:\kits\psexec.zip"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/letsencrypt.zip" -OutFile "C:\kits\letsencrypt.zip"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/npp.7.5.9.Installer.x64.exe" -OutFile "C:\kits\npp.7.5.9.Installer.x64.exe"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/ChromeSetup.exe" -OutFile "C:\kits\ChromeSetup.exe"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/MsSqlCmdLnUtilsx86.msi" -OutFile "C:\temp\MsSqlCmdLnUtilsx86.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/msodbcsqlx86.msi" -OutFile "C:\temp\msodbcsqlx86.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/MsSqlCmdLnUtils.msi" -OutFile "C:\temp\MsSqlCmdLnUtils.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/msodbcsql.msi" -OutFile "C:\temp\msodbcsql.msi"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/FTOS-CORE-RLS-v18.2.5.0-b131-GOLD.zip" -OutFile "C:\Kits\FintechOS\FTOS-CORE.zip"

# Unzip 7zip to local drive
Expand-Archive "C:\temp\7zip.zip" -DestinationPath "C:\Temp\"
Expand-Archive "C:\kits\psexec.zip" -DestinationPath "C:\Kits\"
Expand-Archive "C:\kits\letsencrypt.zip" -DestinationPath "C:\Kits\"

# Unzip FintechOS
& C:\kits\npp.7.5.9.Installer.x64.exe /S
& C:\kits\chromesetup.exe /silent /install
Start-Process -Filepath "C:\temp\7zip\7z.exe" -ArgumentList "x C:\Kits\FintechOS\FTOS-CORE.zip -o`"C:\Kits\FTOS-CORE`"" -wait


#Install SQLcmd

# Start-Process -Filepath "msiexec" -ArgumentList "/i `"C:\Temp\msodbcsql.msi`" /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -wait
# Start-Process -Filepath "msiexec" -ArgumentList "/i `"C:\Temp\MsSqlCmdLnUtilsx86.msi`" /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -wait
# Start-Process -Filepath "msiexec" -ArgumentList "/i `"C:\Temp\MsSqlCmdLnUtils.msi`" /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -wait



# Run FintechOS installer ( dbserver_name++suffix, databases_name, AdminUsername, AdminPassword)


Start-Process -Filepath "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe" -ArgumentList "-i -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass" -wait

Start-Process -Filepath "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe" -ArgumentList "-w -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass" -wait

# Start-Process -Filepath "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe" -ArgumentList "-g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c `"C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE`"" -verb runAs -wait

# Install Designer 

& C:\Kits\FTOS-CORE\DesignerWebApp\DesignerWebAppInstaller.ps1 -p_MainCommand Install -p_InstallDir F:\Sites\FintechOS\Designer -p_IisWebSite "default web site" -p_IisApp FTOS_Designer -p_IisAppPool FTOS_Designer -p_DbConnServer $p_DbConnServer -p_DbConnSqlAuthUser $p_DbConnSqlAuthUser -p_DbConnSqlAuthPass $p_DbConnSqlAuthPass -p_DbConnDb $p_DbConnDb -p_UploadEBSDir F:\UploadEBS

# Install Portal

& C:\Kits\FTOS-CORE\PortalWebApp\PortalWebAppInstaller.ps1 -p_MainCommand Install -p_InstallDir F:\Sites\FintechOS\Portal -p_IisWebSite "default web site" -p_IisApp FTOS_Portal -p_IisAppPool FTOS_Portal -p_DbConnServer $p_DbConnServer -p_DbConnSqlAuthUser $p_DbConnSqlAuthUser -p_DbConnSqlAuthPass $p_DbConnSqlAuthPass -p_DbConnDb $p_DbConnDb -p_UploadEBSDir F:\UploadEBS


$BatFile = "C:\kits\applyscripts.Bat"
$Code = "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -g -s " + $p_DbConnServer + " -d " + $p_DbConnDb + " -u " + $p_DbConnSqlAuthUser + " -p " + $p_DbConnSqlAuthPass + " -c `"C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE`""
Set-Content -Path $BatFile -Value $code -Encoding ASCII
& C:\Kits\psexec.exe -i -h -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -accepteula -w "c:\kits" C:\kits\applyscripts.Bat 
& C:\Kits\psexec.exe -h -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -accepteula -w "c:\kits" C:\kits\applyscripts.Bat 


# add letsencrypt SSL certificate and create binding for https

$notificationemail = 'haroonxml@gmail.com'

Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName "HostHeader" -Value $p_fqdn

& c:\Kits\letsencrypt\wacs.exe --target iissite --siteid 1 --emailaddress $notificationemail --accepttos --usedefaulttaskuser

New-WebBinding -name 'Default Web Site' -Protocol https  -HostHeader $p_fqdn -Port 443 -SslFlags 1


##################### not final #################################
$cert = dir cert: -Recurse | Where-Object {$_.FriendlyName -like "*IIS*"}


# get-item cert:$cert.thumbprint | new-item -path IIS:\SslBindings\0.0.0.0!443!$p_fqdn

(Get-WebBinding -Name 'Default Web Site' -Port 443 -Protocol https -HostHeader $p_fqdn).AddSslCertificate($cert.Thumbprint, "WebHosting")


