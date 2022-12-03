<#
#### requires ps-version 3.0 ####
<#
.SYNOPSIS
    Workspace One - Windows Policy - ADMX - This script makes it easy to set up a list of extensions contained in a text file to facilitate the generation of the custom policy
    Edge - Chrome
.DESCRIPTION

All settings were retrieved from the ADMX files of Google Chrome and Microsoft Edge.
In order to use these policies, you need to have previously deployed the admx files transformed into OMA-URI. 
This script allows you to easily configure a list of extensions contained in a text file to facilitate the generation of the custom policy.
List of allowed Edge - Chrome extensions
The value must always start with the <enabled/> element followed by <data id="[listID]" value="[string 1];[string 2];[string 3]"/>.

We will take a list under txt files like this:

www.google.com
www.duckduck.com
bing.com

to get the numbered list.
https://learn.microsoft.com/en-us/deployedge/configure-edge-with-mdm#list-of-strings-data-type

        .PARAMETER Settings
        Select the list settings you need to generate.

        .PARAMETER Browser
        Select the browser you want to set Chrome or Edge

        .PARAMETER Pathfile
        Enter the txt file path that contains the list of sites to be passed
        
        .PARAMETER Outfile
        Please put the full path of the txt file to be exported

        .PARAMETER Guid
        If you want to keep your previous guid, you will have to enter Guid, otherwise it will be autogenerated

        .PARAMETER Destination
        Choose, if you want the policy on "User" or "Device"

        
.NOTES
   Version:        0.1
   Author:         mardioslambda
   Creation Date:  Wednesday, November 23rd 2022, 9:53:27 am
   File: Generate-ListforChroniumpolicies.ps1
   Copyright (c) 2022 Poste2Travail
HISTORY:
Date      	          By	Comments
----------	          ---	----------------------------------------------------------

.LINK
   https://github.com/Poste2Travail/WorkSpaceOne

.COMPONENT
 Required Modules: 

.LICENSE
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the Software), to deal
in the Software without restriction, including without limitation the rights
to use copy, modify, merge, publish, distribute sublicense and /or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
.EXAMPLE
 PS> Generate-ListforChroniumpolicies.ps1 -Destination Device -Browser Edge -Pathfile .\PopupsAllowedForUrls.txt -Outfile .\PopupsAllowedForUrlsEdge.txt 
.EXAMPLE
 PS> Generate-ListforChroniumpolicies.ps1 -Destination Device -Pathfile .\PopupsAllowedForUrls.txt -Outfile .\PopupsAllowedForUrlsChrome.txt -Browser Chrome
.EXAMPLE
 PS> Generate-ListforChroniumpolicies.ps1 -Destination Device -Pathfile .\PopupsAllowedForUrls.txt -Outfile .\PopupsAllowedForUrlsChrome.txt -Browser Chrome -Guid 'cf1b348c-de18-4369-8792-ab4e1c85dcf8'
#
#>

param(
    [parameter(mandatory = $true, HelpMessage = 'Choose, if you want the policy on "User" or "Device"', Position = 1, ValueFromPipeline = $false)]
    [ValidateSet("User", "Device")]
    [string]$Destination,
    [parameter(mandatory = $true, HelpMessage = "Select the list settings you need to generate", Position = 2, ValueFromPipeline = $false)]
    [ValidateSet("ScreenCaptureAllowedByOrigins", "WindowCaptureAllowedByOrigins", "TabCaptureAllowedByOrigins", "SameOriginTabCaptureAllowedByOrigins", "ClipboardAllowedForUrls", "ClipboardBlockedForUrls", "AutoSelectCertificateForUrls", "CookiesAllowedForUrls", "CookiesBlockedForUrls", "CookiesSessionOnlyForUrls", "FileSystemReadAskForUrls", "FileSystemReadBlockedForUrls", "FileSystemWriteAskForUrls", "FileSystemWriteBlockedForUrls", "ImagesAllowedForUrls", "ImagesBlockedForUrls", "InsecureContentAllowedForUrls", "InsecureContentBlockedForUrls", "JavaScriptAllowedForUrls", "JavaScriptBlockedForUrls", "JavaScriptJitAllowedForSites", "JavaScriptJitBlockedForSites", "LegacySameSiteCookieBehaviorEnabledForDomainList", "LocalFontsAllowedForUrls", "LocalFontsBlockedForUrls", "PopupsAllowedForUrls", "PopupsBlockedForUrls", "NotificationsAllowedForUrls", "NotificationsBlockedForUrls", "SensorsAllowedForUrls", "SensorsBlockedForUrls", "WebUsbAskForUrls", "WebUsbBlockedForUrls", "SerialAskForUrls", "SerialBlockedForUrls", "SerialAllowAllPortsForUrls", "WebHidAskForUrls", "WebHidBlockedForUrls", "WebHidAllowAllDevicesForUrls", "WindowPlacementAllowedForUrls", "WindowPlacementBlockedForUrls", "DefaultSearchProviderEncodings", "DefaultSearchProviderAlternateURLs", "DefaultSearchProviderEncodings", "DefaultSearchProviderAlternateURLs", "DisabledSchemes", "UnsafelyTreatInsecureOriginAsSecure", "ExtensionInstallAllowlist", "ExtensionInstallBlocklist", "ExtensionInstallForcelist", "ExtensionInstallSources", "ExtensionAllowedTypes", "AllHttpAuthSchemesAllowedForOrigins", "AlternativeBrowserParameters", "BrowserSwitcherChromeParameters", "BrowserSwitcherUrlList", "BrowserSwitcherUrlGreylist", "NativeMessagingBlocklist", "NativeMessagingAllowlist", "PrinterTypeDenyList", "RemoteAccessHostClientDomainList", "RemoteAccessHostDomainList", "SafeBrowsingAllowlistDomains", "PasswordProtectionLoginURLs", "RestoreOnStartupURLs", "RestoreOnStartupURLs", "AudioCaptureAllowedUrls", "AutoOpenAllowedForURLs", "AutoOpenFileTypes", "AutoplayAllowlist", "CertificateTransparencyEnforcementDisabledForCas", "CertificateTransparencyEnforcementDisabledForLegacyCas", "CertificateTransparencyEnforcementDisabledForUrls", "ClearBrowsingDataOnExitList", "EnableExperimentalPolicies", "ExplicitlyAllowedNetworkPorts", "ForcedLanguages", "HSTSPolicyBypassList", "InsecurePrivateNetworkRequestsAllowedForUrls", "LookalikeWarningAllowlistDomains", "OverrideSecurityRestrictionsOnInsecureOrigin", "PolicyDictionaryMultipleSourceMergeList", "PolicyListMultipleSourceMergeList", "SSLErrorOverrideAllowedForOrigins", "SecurityKeyPermitAttestation", "SpellcheckLanguage", "SpellcheckLanguageBlocklist", "SyncTypesListDisabled", "TabDiscardingExceptions", "URLAllowlist", "URLBlocklist", "VideoCaptureAllowedUrls", "WebRtcLocalIpsAllowedUrls")]
    [string]$Settings,
    [parameter(mandatory = $true, HelpMessage = "Select the browser you want to set Chrome or Edge", Position = 3, ValueFromPipeline = $false)]
    [ValidateSet("Edge", "Chrome")]
    [string]$Browser,
    [parameter(Mandatory = $True, HelpMessage = "Enter the txt file path that contains the list of sites to be passed", Position = 4)]
    [ValidateScript({
            if (-Not ($_ | Test-Path) ) {
                throw "File or folder does not exist"
            }
            if (-Not ($_ | Test-Path -PathType Leaf) ) {
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            if ($_ -notmatch "(\.txt)") {
                throw "The file specified in the path argument must be either of type txt"
            }
            return $true 
        })]
    [System.IO.FileInfo]$Pathfile,
    [parameter(Mandatory = $True, HelpMessage = "Please put the full path of the txt file to be exported", Position = 5)]
    [string]$Outfile,
    [parameter(HelpMessage = "If you want to keep your previous guid, you will have to enter Guid, otherwise it will be autogenerated.")]
    [ValidatePattern('(\{|\()?[A-Za-z0-9]{4}([A-Za-z0-9]{4}\-?){4}[A-Za-z0-9]{12}(\}|\()?')]
    [string]$Guid
)

# All parameters have been retrieved from ADMX files
# Chrome 108.0.5359.72
# Edge 107.0.1418.62

$PathPolicy = @(
    '~ScreenCapture/ScreenCaptureAllowedByOrigins'
    '~ScreenCapture/WindowCaptureAllowedByOrigins',
    '~ScreenCapture/SameOriginTabCaptureAllowedByOrigins',
    '~ScreenCapture/TabCaptureAllowedByOrigins',
    '~ContentSettings/ClipboardAllowedForUrls',
    '~ContentSettings/ClipboardBlockedForUrls',
    '~ContentSettings/AutoSelectCertificateForUrls',
    '~ContentSettings/CookiesAllowedForUrls',
    '~ContentSettings/CookiesBlockedForUrls',
    '~ContentSettings/CookiesSessionOnlyForUrls',
    '~ContentSettings/FileSystemReadAskForUrls',
    '~ContentSettings/FileSystemReadBlockedForUrls',
    '~ContentSettings/FileSystemWriteAskForUrls',
    '~ContentSettings/FileSystemWriteBlockedForUrls',
    '~ContentSettings/ImagesAllowedForUrls',
    '~ContentSettings/ImagesBlockedForUrls',
    '~ContentSettings/InsecureContentAllowedForUrls',
    '~ContentSettings/InsecureContentBlockedForUrls',
    '~ContentSettings/JavaScriptAllowedForUrls',
    '~ContentSettings/JavaScriptBlockedForUrls',
    '~ContentSettings/JavaScriptJitAllowedForSites',
    '~ContentSettings/JavaScriptJitBlockedForSites',
    '~ContentSettings/LegacySameSiteCookieBehaviorEnabledForDomainList',
    '~ContentSettings/LocalFontsAllowedForUrls',
    '~ContentSettings/LocalFontsBlockedForUrls',
    '~ContentSettings/PopupsAllowedForUrls',
    '~ContentSettings/PopupsBlockedForUrls',
    '~ContentSettings/NotificationsAllowedForUrls',
    '~ContentSettings/NotificationsBlockedForUrls',
    '~ContentSettings/SensorsAllowedForUrls',
    '/SensorsAllowedForUrls',
    '~ContentSettings/SensorsBlockedForUrls',
    '/SensorsBlockedForUrls',
    '~ContentSettings/WebUsbAskForUrls',
    '~ContentSettings/WebUsbBlockedForUrls',
    '~ContentSettings/SerialAskForUrls',
    '/SerialAskForUrls',
    '~ContentSettings/SerialBlockedForUrls',
    '/SerialBlockedForUrls',
    '~ContentSettings/SerialAllowAllPortsForUrls',
    '~ContentSettings/WebHidAskForUrls',
    '~ContentSettings/WebHidBlockedForUrls',
    '~ContentSettings/WebHidAllowAllDevicesForUrls',
    '~ContentSettings/WindowPlacementAllowedForUrls',
    '~ContentSettings/WindowPlacementBlockedForUrls',
    '_recommended~DefaultSearchProvider_recommended/DefaultSearchProviderEncodings_recommended',
    '~DefaultSearchProvider/DefaultSearchProviderEncodings',
    '_recommended~DefaultSearchProvider_recommended/DefaultSearchProviderAlternateURLs_recommended',
    '~DefaultSearchProvider/DefaultSearchProviderAlternateURLs',
    '~DeprecatedPolicies/DisabledSchemes',
    '~DeprecatedPolicies/UnsafelyTreatInsecureOriginAsSecure',
    '~Extensions/ExtensionInstallAllowlist',
    '~Extensions/ExtensionInstallBlocklist',
    '~Extensions/ExtensionInstallForcelist',
    '~Extensions/ExtensionInstallSources',
    '~Extensions/ExtensionAllowedTypes',
    '~HTTPAuthentication/AllHttpAuthSchemesAllowedForOrigins',
    '~BrowserSwitcher/AlternativeBrowserParameters',
    '~BrowserSwitcher/BrowserSwitcherChromeParameters',
    '~BrowserSwitcher/BrowserSwitcherUrlList',
    '~BrowserSwitcher/BrowserSwitcherUrlGreylist',
    '~NativeMessaging/NativeMessagingBlocklist',
    '~NativeMessaging/NativeMessagingAllowlist',
    '~Printing/PrinterTypeDenyList',
    '~RemoteAccess/RemoteAccessHostClientDomainList',
    '~RemoteAccess/RemoteAccessHostDomainList',
    '~SafeBrowsing/SafeBrowsingAllowlistDomains',
    '~SafeBrowsing/PasswordProtectionLoginURLs',
    '~PasswordManager/PasswordProtectionLoginURLs',
    '_recommended~Startup_recommended/RestoreOnStartupURLs_recommended',
    '~Startup/RestoreOnStartupURLs',
    '/AudioCaptureAllowedUrls',
    '/AutoOpenAllowedForURLs',
    '/AutoOpenFileTypes',
    '/AutoplayAllowlist',
    '/CertificateTransparencyEnforcementDisabledForCas',
    '/CertificateTransparencyEnforcementDisabledForLegacyCas',
    '/CertificateTransparencyEnforcementDisabledForUrls',
    '/ClearBrowsingDataOnExitList',
    '/EnableExperimentalPolicies',
    '/ExplicitlyAllowedNetworkPorts',
    '/ForcedLanguages',
    '/HSTSPolicyBypassList',
    '/InsecurePrivateNetworkRequestsAllowedForUrls',
    '~PrivateNetworkRequestSettings/InsecurePrivateNetworkRequestsAllowedForUrls',
    '/LookalikeWarningAllowlistDomains',
    '/OverrideSecurityRestrictionsOnInsecureOrigin',
    '/PolicyDictionaryMultipleSourceMergeList',
    '/PolicyListMultipleSourceMergeList',
    '/SSLErrorOverrideAllowedForOrigins',
    '/SecurityKeyPermitAttestation',
    '/SpellcheckLanguage',
    '/SpellcheckLanguageBlocklist',
    '~DeprecatedPolicies/SpellcheckLanguageBlacklist',
    '~RemovedPolicies/SpellcheckLanguageBlacklist',
    '/SyncTypesListDisabled',
    '/URLAllowlist',
    '/URLBlocklist',
    '/VideoCaptureAllowedUrls',
    '/WebRtcLocalIpsAllowedUrls'
)

# Generate a new Guid if the guid settings is not set
if (!$Guid) {
    $Guid = $((new-guid).guid)
}

# Create a Table for a one line 
[System.Collections.ArrayList]$Table = @{}

# Inject all line in Table
Get-Content -Path $Pathfile | ForEach-Object {
    $Table += $_.Trim() #remove space
}

# Add all line need for generate the one line
$list = for ($i = 0; $i -le $Table.count - 1; $i++) {
    $i + 1
    '&#xF000;'
    $Table[$i]
    '&#xF000;'
}

# Convert the table to string 
$string = $list -join ''
$string = $string.Substring(0, $string.Length - 8) #Remove the last "&#xF000;" 8 characters


# Set the BrowserPath
if ($Browser -eq 'Edge') {
    [string]$BrowserPath = 'Edge~Policy~microsoft_edge'
    [string]$Url = 'https://admx.help/?Category=EdgeChromium&Policy=Microsoft.Policies.Edge::' + $Settings
    
}
elseif ($Browser -eq 'Chrome') {
    [string]$BrowserPath = 'Chrome~Policy~googlechrome'
    [string]$Url = 'https://admx.help/?Category=Chrome&Policy=Google.Policies.Chrome::' + $Settings
}
else {
    $string | Out-File -FilePath $Outfile -Encoding utf8 -Force -NoClobber -NoNewline
    return $string
}
    
[string]$SettingsDesc = $Settings + 'Desc'

[string]$BrowserFullPath = $BrowserPath + $($PathPolicy -match $settings)

[string]$guid = $(New-Guid).Guid

# Generate the new TXT document
$out = @"
Information: $Url

Install Settings
-----------------
<Replace><CmdID>$guid</CmdID><Item>
<Target><LocURI>./$Destination/Vendor/MSFT/Policy/Config/$BrowserFullPath</LocURI></Target>
<Data><![CDATA[<enabled/><data id="$SettingsDesc" value="$string"/>]]></Data>
</Item></Replace>


Remove Settings
----------------
<Delete><CmdID>$guid</CmdID><Item>
<Target><LocURI>./$Destination/Vendor/MSFT/Policy/Config/$BrowserFullPath</LocURI></Target>
<Data></Data>
</Item></Delete>

"@

# Export and remove the old file
if (Test-Path -Path $Outfile) {
    Try {
        Remove-Item -Path $Outfile -Force
        $out | Out-File -FilePath $Outfile -Encoding utf8 -Force -NoClobber -NoNewline
    }
    Catch {
        Write-Error "The outfile can be remove please remove manually before"
    }

}
else {
    $out | Out-File -FilePath $Outfile -Encoding utf8 -Force -NoClobber -NoNewline
}
