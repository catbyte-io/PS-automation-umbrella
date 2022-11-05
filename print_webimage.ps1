#function definition for select folder dialogue
function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $folderdialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderdialog.Description = "Select folder"
    $folderdialog.RootFolder = "Desktop"
    $folderdialog.SelectedPath = "C:\Users\Default\Downloads\"

    if($folderdialog.ShowDialog() -eq "OK")
    {
        $folder += $folderdialog.SelectedPath
    }
    elseif($folderdialog.ShowDialog() -eq "Cancel")
    {
        $folder += $folderdialog.RootFolder
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
#prints the location in the console
Write-Host $Location

$URL = Read-Host "Enter or copy/paste the url"

$WebResponse = Invoke-WebRequest $URL
$count = 0
ForEach ($Image in $WebResponse.Images)
{
    $FileName = "$Location/$count.jpg"
    Invoke-WebRequest $Image.src -OutFile $FileName
    $count++
}
