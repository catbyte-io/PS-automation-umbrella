#function definition for select folder dialogue
function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select folder"
    $foldername.RootFolder = "Desktop"
    $foldername.SelectedPath = "C:\Users\Default\Downloads\"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    elseif($foldername.ShowDialog() -eq "Cancel")
    {
        $folder += $foldername.RootFolder
    }
    return $folder
}

#Get Location and number of folders to be made by the user, then make that many folders numbered with a padding of two characters
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

Write-Host $Location

$num = Read-Host -Prompt "How many folders?"
$init = Read-Host -Prompt "Initialize with what number?"
$range = [int]$init + [int]$num
foreach($chapters in @($init..$range))
{
    $chapter = "{0:d2}" -f $chapters
    $d = "$Location\$chapter"
    if (-not(Test-Path $d))
    {
        New-Item -ItemType Directory -Path $d
        Write-Host $d  
    }
    
}
