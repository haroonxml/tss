New-Item -ItemType directory -Path C:\Script\FintechOS
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/valentindumitrescu/FintechOS/master/testfile.txt" -OutFile "C:\Script\FintechOS\gitfile.txt"
