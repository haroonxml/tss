
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


# Create local folders
New-Item -ItemType directory -Path C:\Kits\FintechOS
New-Item -ItemType directory -Path C:\Temp
New-Item -ItemType directory -Path F:\UploadEBS

# Download and install SSMS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "http://download.microsoft.com/download/3/C/7/3C77BAD3-4E0F-4C6B-84DD-42796815AFF6/SSMS-Setup-ENU.exe" -OutFile "C:\temp\SSMS-Setup-ENU.exe"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/valentindumitrescu/FintechOS/master/fintechossqlscripts.ps1" -OutFile "C:\temp\fintechossqlscripts.ps1"
Start-Process -Filepath "C:\temp\SSMS-Setup-ENU.exe" -ArgumentList "/install /quiet /norestart" -wait



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
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/MsSqlCmdLnUtilsx86.msi" -OutFile "C:\temp\MsSqlCmdLnUtilsx86.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/msodbcsqlx86.msi" -OutFile "C:\temp\msodbcsqlx86.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/MsSqlCmdLnUtils.msi" -OutFile "C:\temp\MsSqlCmdLnUtils.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/msodbcsql.msi" -OutFile "C:\temp\msodbcsql.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.001" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.001"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.002" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.002"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.003" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.003"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.004" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.004"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.005" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.005"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.006" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.006"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.007" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.007"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.008" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.008"


# Unzip 7zip to local drive
Expand-Archive "C:\temp\7zip.zip" -DestinationPath "C:\Temp\"


# Unzip FintechOS

Start-Process -Filepath "C:\temp\7zip\7z.exe" -ArgumentList "x C:\Kits\FintechOS\FTOS-CORE.7z.001 -o`"C:\Kits`"" -wait


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

# Repeat FintechOS script installer

# & C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c "C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

# Run BasicDB upgrader and sqlcmd under p_DbConnSqlAuthUser and with LoadUserProfile
$pass = $p_DbConnSqlAuthPass|ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PsCredential($p_DbConnSqlAuthUser,$pass)


Start-process -Filepath C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -ArgumentList "-g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c `"C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE`"" -LoadUserProfile -Credential $credential
Start-process -Filepath C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -ArgumentList "-g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c `"C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE`"" -Credential $credential -RedirectStandardOutput "c:\temp\output1.txt"

# Try to execute a second script as another user
$script =  "C:\temp\fintechossqlscripts.ps1 -p_DbConnServer $p_DbConnServer -p_DbConnDb $p_DbConnDb -p_DbConnSqlAuthUser $p_DbConnSqlAuthUser -p_DbConnSqlAuthPass $p_DbConnSqlAuthPass"
$scriptblock = [scriptblock]::Create($script)

		# Invoke-Command -FilePath $command -Credential $credential -ComputerName $env:COMPUTERNAME
Invoke-Command -scriptblock $scriptblock -Credential $credential -ComputerName localhost


<#
# Define job variables to run sqlcmd

$jobname = "ResumeRestart"
$script =  "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c `"C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE`""
$trigger = New-JobTrigger -AtStartup
 
# The script below will run elevated to use the highest privileges.
$scriptblock = [scriptblock]::Create($script)
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
Register-ScheduledJob -Name $jobname -ScriptBlock $scriptblock -Trigger $trigger -ScheduledJobOption $options

# Restart machine

# Restart-Computer -Force  #>

