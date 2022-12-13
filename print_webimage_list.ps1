#function definition for select folder dialogue
function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select folder"
    $foldername.rootfolder = "Desktop"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

#main
#Get Location and number of chapters
$saveto = Read-Host -Prompt "Would you like to specify a parent directory? y/n"
if ($saveto -eq "y" -or $saveto -eq "yes")
{    
    $Location = Get-Folder
}
else 
{
    $Location = "C:\Users\Public\Downloads"
    Write-Host "Default download folder will be used"
}

$url = Read-Host "Enter url of the first chapter
$num = Read-Host "How many chapters do you want to download? NOTE: if there is already a folder named with the chapter number inside the specified directory, that chapter will be skipped"
#Split the url string to get the separated parts of the url to use as variables. Split at every = and &.  Save the separated strings into array $sub
$sub = @()
$sub = $url.Split("=").Split("&")
Write-Host $sub[3]
#Declare an array for the numbers of the chapters to be stored extracted from the url string
$no = @()
$no = $sub[3]
Write-Host $no
#Save the title id exracted from the website and save to variable to use as name for folder.
$titleid = $sub[1]
$urls = @()

$range = [int]$no + [int]$num
ForEach ($chapters in @($no..$range))
{
    $chapter = "{0:d2}" -f $chapters
    $d = "$Location\$titleid\$chapter"
    if (-not(Test-Path $d))
    {
        New-Item -ItemType Directory -Path $d
        Write-Host $d
    }
    #create new url joining the split strings with the new chapter string
    $newurl = @($sub[0],"=",$sub[1],"&",$sub[2],"=",$chapter,"&",$sub[4],"=") -join ""

    $WebResponse = Invoke-WebRequest -Uri $newurl
    $count = 0
    ForEach ($Image in $WebResponse.Images)
    {
        #changed $Filename to equal $count to fix some issues with source files names being incompatiible and not downloading.
        
        $saveto = "$d\$count.jpg"
        Invoke-WebRequest $Image.src -OutFile $saveto
        $count++
    }
}

