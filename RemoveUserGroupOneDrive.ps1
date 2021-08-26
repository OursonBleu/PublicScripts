<#
Made by OursonBleu
Script steps: 
1. Ask name of the Removed User
2. Remove all groups from profile
3. Ask if onedrive file access is needed
    3.1 Ask Who should get access
    3.2 Get onedrine URL
    3.3 Get New Administrator
    3.4 Output URL
4. Ask if you have another Remove User - Loop back if yes
5. Completed
#>

#Install-Module -Name PnP.Powershell
#Install-Module -Name Microsoft.Online.SharePoint.PowerShell
$OneDriveAdminUrl = "Your URL"
$Credentials = Get-Credential -Message "Enter your admin credentials starting with ALPHA\"

:AskUserName do{
    $UserName = Read-Host -Prompt "Name of the user to remove all groups"
    $userinfo = get-aduser -credential $Credentials -Filter "anr -like '$Username'"
    foreach ($group in $userInfo.MemberOf) {Remove-ADGroupMember -Credential $Credentials -Identity $group -Members $userinfo.SamAccountName}

    $OnedriveAccess = Read-host -Prompt "Do you need to provide OneDrive Access? Please answer Yes or No"
        If ($OnedriveAccess -eq "Yes")
            {
                $ManagerName = Read-Host -Prompt "Who should get OneDrive Access?"
                $ManagerInfo = Get-Aduser -Credential $Credentials -Filter "anr -like '$ManagerName'"
                connect-pnponline -url "$OneDriveAdminUrl" -interactive
                Connect-SPOService -Url "$OneDriveAdminUrl"
                $OnedriveURL = Get-PnPUserProfileProperty -Account $userinfo.userprincipalname
                Set-SPOSite -Identity ($OnedriveURL.PersonalUrl).Trimend('/') -Owner $ManagerInfo.UserPrincipalName -NoWait
                Write-Host = $OnedriveURL.PersonalUrl
                $OtherUser = Read-Host -Prompt "Do you have another user? Please answer Yes or No"
            }else{
                Write-Host "The user license have been removed"
                $OtherUser = Read-Host -Prompt "Do you have another user? Please answer Yes or No"
                $OtherUser = "Yes"; Break :AskUserName
            }
        }until($OtherUser -eq "No")
