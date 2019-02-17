param(
	[Object] $p_DbConnServer,
	[Object] $p_DbConnSqlAuthUser,
	[Object] $p_DbConnSqlAuthPass,
	[Object] $p_DbConnDb
)

Start-process -Filepath C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -ArgumentList "-g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c `"C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE`"" -RedirectStandardOutput "c:\temp\output.txt" -wait


& C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -g -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass -c "C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"
