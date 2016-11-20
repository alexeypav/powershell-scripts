<# Script to get KAMAR notices for wallflower
created to replace the old VBS and Batch scripts
#>

#Enter Server address for notice
$address = "http://address"




#Bellow shouldn't be modified

#Get parent directory, assuming the script is located under wallflowe\scripts
$Parent = (get-item $PSScriptRoot ).parent.FullName

#Path to Template HTML/Javascript files
$footers = Get-Content $Parent\inputfiles\static\footers.txt 
$headers = Get-Content $Parent\inputfiles\static\headers.txt 



#removes previous content
Remove-Item $Parent\content.html -force
Remove-Item $PSScriptRoot\notices.txt


#Gets notices and outputs to temp file
& "$PSScriptRoot\wget.exe" "$address" -O "$PSScriptRoot\notices.txt"

#inputs HTML/javascript content from Headers files to start of content.html

foreach ($line in $headers ){   Out-File $Parent\content.html -InputObject $line -Append}

#copies select HTML content from notices file to content.html
$flag=0
Get-Content $PSScriptRoot\notices.txt |
foreach {
    Switch -Wildcard ($_){
        '*<div id="notices">*' {$flag=1}
        '*<div id="footer">*' {$flag=0}
    }
    if ($flag -eq 1){
        Out-File $Parent\content.html -InputObject $_ -Append
    }
}

#inputs HTML content from Footers files to end of content.html

foreach ($line in $footers ){   Out-File $Parent\content.html -InputObject $line -Append}

#Optional, Copies content.html to IIS publish folder assuming the script isn't located there (Sometimes running the script from wwwroot causes issues)
#Copy-Item $Parent\content.html -destination  C:\inetpub\wwwroot\wallflower\content.html -Force