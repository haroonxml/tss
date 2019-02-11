
# param(
#    [string] $p_MainCommand
#    , [Object] $p_InstallDir
#    , [Object] $p_IisWebsite
#    , [Object] $p_IisApp
#    , [Object] $p_IisAppPool
#    , [Object] $p_DbConnServer
#    , [Object] $p_DbConnSqlAuthUser
#    , [Object] $p_DbConnSqlAuthPass
#    , [Object] $p_DbConnDb
#    , [Object] $p_UploadEBSDir
#)




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


# Create local folders
New-Item -ItemType directory -Path C:\Kits\FintechOS
New-Item -ItemType directory -Path C:\Temp


# Download FintechOS files
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/7zip.zip" -OutFile "C:\temp\7zip.zip"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/MsSqlCmdLnUtilsx86.msi" -OutFile "C:\temp\MsSqlCmdLnUtilsx86.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/msodbcsqlx86.msi" -OutFile "C:\temp\msodbcsqlx86.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/MsSqlCmdLnUtils.msi" -OutFile "C:\temp\MsSqlCmdLnUtils.msi"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/msodbcsql.msi" -OutFile "C:\temp\msodbcsql.msi"
Invoke-WebRequest -Uri "http://download.microsoft.com/download/3/C/7/3C77BAD3-4E0F-4C6B-84DD-42796815AFF6/SSMS-Setup-ENU.exe" -OutFile "C:\temp\SSMS-Setup-ENU.exe"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.001" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.001"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.002" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.002"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.003" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.003"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.004" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.004"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.005" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.005"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.006" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.006"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.007" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.007"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.008" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.008"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.009" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.009"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.010" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.010"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.011" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.011"
Invoke-WebRequest -Uri "https://github.com/valentindumitrescu/FintechOS/raw/ftos_core/FTOS-CORE.7z.012" -OutFile "C:\Kits\FintechOS\FTOS-CORE.7z.012"


# Unzip 7zip to local drive
Expand-Archive "C:\temp\7zip.zip" -DestinationPath “C:\Temp\”


# Unzip FintechOS

C:\temp\7zip\7z.exe x C:\Kits\FintechOS\FTOS-CORE.7z.001 -o"C:\Kits"

#Install SQLcmd

Start-Process -Filepath "msiexec" -ArgumentList "/i `"C:\Temp\msodbcsql.msi`" /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -wait
Start-Process -Filepath "msiexec" -ArgumentList "/i `"C:\Temp\MsSqlCmdLnUtilsx86.msi`" /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -wait
Start-Process -Filepath "msiexec" -ArgumentList "/i `"C:\Temp\MsSqlCmdLnUtils.msi`" /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES" -wait
Start-Process -Filepath "C:\temp\SSMS-Setup-ENU.exe" -ArgumentList "/install /quiet /norestart" -wait


# Run FintechOS installer ( dbserver_name++suffix, databases_name, AdminUsername, AdminPassword)


Start-Process -Filepath "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe" -ArgumentList "-i -s fintechosdbsrv.database.windows.net -d fintechosdb -u FTOSadmin -p change_FTOSpassword" -wait
Start-Process -Filepath "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe" -ArgumentList "-w -s fintechosdbsrv.database.windows.net -d fintechosdb -u FTOSadmin -p change_FTOSpassword" -wait
Start-Process -Filepath "C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe" -ArgumentList "-g -s fintechosdbsrv.database.windows.net -d fintechosdb -u FTOSadmin -p change_FTOSpassword" -wait


# Install Designer 

& C:\Kits\FTOS-CORE\DesignerWebApp\DesignerWebAppInstaller.ps1 -p_MainCommand Install -p_InstallDir C:\Site\FintechOS_SFTL\Designer -p_IisWebSite "default web site" -p_IisApp SFTL_Designer -p_IisAppPool SFTL_Designer -p_DbConnServer fintechosdbsrv.database.windows.net -p_DbConnSqlAuthUser FTOSadmin -p_DbConnSqlAuthPass change_FTOSpassword -p_DbConnDb fintechosdb -p_UploadEBSDir C:\UploadEBS

# Install Portal

& C:\Kits\FTOS-CORE\PortalWebApp\PortalWebAppInstaller.ps1 -p_MainCommand Install -p_InstallDir C:\Site\FintechOS_SFTL\Portal -p_IisWebSite "default web site" -p_IisApp SFTL_Portal -p_IisAppPool SFTL_Portal -p_DbConnServer fintechosdbsrv.database.windows.net -p_DbConnSqlAuthUser FTOSadmin -p_DbConnSqlAuthPass change_FTOSpassword -p_DbConnDb fintechosdb -p_UploadEBSDir C:\UploadEBS
