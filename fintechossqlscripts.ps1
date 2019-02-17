param(
	[Object] $p_DbConnServer,
	[Object] $p_DbConnSqlAuthUser,
	[Object] $p_DbConnSqlAuthPass,
	[Object] $p_DbConnDb
)

Start-process -Filepath C:\Kits\FTOS-CORE\SQL\BasicDbUpgrader.exe -ArgumentList "-i -s $p_DbConnServer -d $p_DbConnDb -u $p_DbConnSqlAuthUser -p $p_DbConnSqlAuthPass"
