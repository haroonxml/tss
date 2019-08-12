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

# Set TimeZone

Set-TimeZone -Name "GTB Standard Time"

# Create local folders
New-Item -ItemType directory -Path C:\Kits\FintechOS
New-Item -ItemType directory -Path C:\Temp
New-Item -ItemType directory -Path F:\Services

# Add Windows Defender exclusions

Add-MpPreference -ExclusionPath "F:\Services"

# Download and install SSMS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "http://download.microsoft.com/download/3/C/7/3C77BAD3-4E0F-4C6B-84DD-42796815AFF6/SSMS-Setup-ENU.exe" -OutFile "C:\temp\SSMS-Setup-ENU.exe"
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




# Download apps files
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/7zip.zip" -OutFile "C:\temp\7zip.zip"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/PsExec.zip" -OutFile "C:\kits\psexec.zip"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/letsencrypt.zip" -OutFile "C:\kits\letsencrypt.zip"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/npp.7.5.9.Installer.x64.exe" -OutFile "C:\kits\npp.7.5.9.Installer.x64.exe"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/kits/ChromeSetup.exe" -OutFile "C:\kits\ChromeSetup.exe"
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/fintechosnn/JobServices18.1.zip" -OutFile "C:\kits\JobServices18.1.zip"

# Unzip 7zip to local drive
Expand-Archive "C:\temp\7zip.zip" -DestinationPath "C:\Temp\"
Expand-Archive "C:\kits\psexec.zip" -DestinationPath "C:\Kits\"
Expand-Archive "C:\kits\letsencrypt.zip" -DestinationPath "C:\Kits\"
Expand-Archive "C:\kits\JobServices18.1.zip" -DestinationPath "F:\Services\"

# Unzip FintechOS
& C:\kits\npp.7.5.9.Installer.x64.exe /S
& C:\kits\chromesetup.exe /silent /install


# download job server files
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://ftosautodeploystorage.blob.core.windows.net/fintechosnn/JobServices18.1.zip" -OutFile "C:\kits\JobServices18.1.zip"

Expand-Archive "C:\kits\JobServices18.1.zip" -DestinationPath "F:\Services\"


# configure Job Services


((Get-Content -path 'F:\Services\JobServer\services.config' -Raw) -replace 'SqlServerName',$p_DbConnServer) | Set-Content -Path 'F:\Services\JobServer\services.config'
((Get-Content -path 'F:\Services\JobServer\services.config' -Raw) -replace 'DataBaseName',$p_DbConnDb) | Set-Content -Path 'F:\Services\JobServer\services.config'
((Get-Content -path 'F:\Services\JobServer\services.config' -Raw) -replace 'userName',$p_DbConnSqlAuthUser) | Set-Content -Path 'F:\Services\JobServer\services.config'
((Get-Content -path 'F:\Services\JobServer\services.config' -Raw) -replace 'userPassword',$p_DbConnSqlAuthPass) | Set-Content -Path 'F:\Services\JobServer\services.config'

((Get-Content -path 'F:\Services\JobServer\connections.config' -Raw) -replace 'Data Source=.',('Data Source=' + $p_DbConnServer)) | Set-Content -Path 'F:\Services\JobServer\connections.config'
((Get-Content -path 'F:\Services\JobServer\connections.config' -Raw) -replace 'ftosdb',$p_DbConnDb) | Set-Content -Path 'F:\Services\JobServer\connections.config'
((Get-Content -path 'F:\Services\JobServer\connections.config' -Raw) -replace 'ID=sa',('ID=' + $p_DbConnSqlAuthUser)) | Set-Content -Path 'F:\Services\JobServer\connections.config'
((Get-Content -path 'F:\Services\JobServer\connections.config' -Raw) -replace 'SA6122019sa',$p_DbConnSqlAuthPass) | Set-Content -Path 'F:\Services\JobServer\connections.config'

((Get-Content -path 'F:\Services\JobServer - OCB\connections.config' -Raw) -replace 'Data Source=.',('Data Source=' + $p_DbConnServer)) | Set-Content -Path 'F:\Services\JobServer - OCB\connections.config'
((Get-Content -path 'F:\Services\JobServer - OCB\connections.config' -Raw) -replace 'ftosdb',$p_DbConnDb) | Set-Content -Path 'F:\Services\JobServer - OCB\connections.config'
((Get-Content -path 'F:\Services\JobServer - OCB\connections.config' -Raw) -replace 'userName',$p_DbConnSqlAuthUser) | Set-Content -Path 'F:\Services\JobServer - OCB\connections.config'
((Get-Content -path 'F:\Services\JobServer - OCB\connections.config' -Raw) -replace 'userPassword',$p_DbConnSqlAuthPass) | Set-Content -Path 'F:\Services\JobServer - OCB\connections.config'


((Get-Content -path 'F:\Services\MessageBus (OCB)\connections.config' -Raw) -replace 'Data Source=.',('Data Source=' + $p_DbConnServer)) | Set-Content -Path 'F:\Services\MessageBus (OCB)\connections.config'
((Get-Content -path 'F:\Services\MessageBus (OCB)\connections.config' -Raw) -replace 'ftosdb',$p_DbConnDb) | Set-Content -Path 'F:\Services\MessageBus (OCB)\connections.config'
((Get-Content -path 'F:\Services\MessageBus (OCB)\connections.config' -Raw) -replace 'userName',$p_DbConnSqlAuthUser) | Set-Content -Path 'F:\Services\MessageBus (OCB)\connections.config'
((Get-Content -path 'F:\Services\MessageBus (OCB)\connections.config' -Raw) -replace 'userPassword',$p_DbConnSqlAuthPass) | Set-Content -Path 'F:\Services\MessageBus (OCB)\connections.config'

# Add Windows Services

& "C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe"  /ServiceName="FTOS.JobServer" /i "F:\Services\JobServer\FTOS.JobServer.Service.exe"
& "C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe"  /ServiceName="FTOS.JobServer.OCB" /i "F:\Services\JobServer - OCB\FTOS.JobServer.Service.exe"

