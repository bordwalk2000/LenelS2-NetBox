Function Connect-S2Service {
    <#
    .Synopsis
    Module for interfacing with the S2 NETBOX API.

    .Description
    Module for enterying and querying information from the S2 NETBOX API.

    .Parameter Username
    Valid username of an S2 Account

    .Parameter Password
    Corresponding password to specified username

    .Parameter S2Hostname
    The network location to the S2 Netbox API server.

    .Parameter S2Protocol
    Specifiy what http protocal to use.  By default it uses http.

    .Link
    Forked from bciu22/PowerShell-S2-API
    https://github.com/bciu22/PowerShell-S2-API/blob/master/src/S2.psm1
    #>
    param (
        [parameter(Mandatory=$true)][String] $Username,
        [parameter(Mandatory=$true)][String] $Password,
        [parameter(Mandatory=$true)][String] $S2Hostname,
        [String] $S2Protocol = "http://"
    )
    Set-Variable -Scope Global -Name "S2HOSTNAME" -Value $S2HOSTNAME
    Set-Variable -Scope Global -Name "S2PROTOCOL" -Value $S2PROTOCOL

    [xml]$xml = New-Object System.Xml.XmlDocument
    $wrapper = $xml.AppendChild($xml.CreateElement("NETBOX-API"))
    $command = $wrapper.AppendChild($xml.CreateElement("COMMAND"))
    $Command.SetAttribute("name","Login")
    $Command.SetAttribute("num","1")
    $Command.SetAttribute("dateformat","tzoffset")
    $Parameters=$Command.AppendChild($xml.CreateElement("PARAMS"))
    $UsernameXML = $xml.CreateElement("USERNAME")
    $UsernameXML.innerText = $Username
    $PasswordXML = $xml.CreateElement("PASSWORD")
    $PasswordXML.InnerText = $Password
    $Parameters.AppendChild($UsernameXML) | Out-Null
    $Parameters.AppendChild($PasswordXML) | Out-Null

    $Response = Invoke-WebRequest -URI "$($S2PROTOCOL)$($S2HOSTNAME)/goforms/nbapi" -Method Post -Body $($xml.innerXML)
    $ReturnXML = $([xml]$Response.content)

    if($ReturnXML.NETBOX.RESPONSE.APIERROR)
    {
        switch ($ReturnXML.NETBOX.RESPONSE.APIERROR) {
            "1" {
                    $apiError = "API_INIT_FAIL"
                    $apiErrorDescription = "Database error (database not running, etc.)"
                }
            "2" {
                    $apiError = "API_DISABLED"
                    $apiErrorDescription = "The API processor is not activated for this eMerge"
                }
            "3" {
                    $apiError = "API_NOCOMMAND"
                    $apiErrorDescription = "No APIcommand parameter was passed to the API processor"
                }
            "4" {
                    $apiError = "API_PARSE_ERROR"
                    $apiErrorDescription = "The APIcommand data could not be parsed by the XML parser"
                }
            "5" {
                    $apiError = "API_AUTH_FAILURE"
                    $apiErrorDescription = "API authorization failure (if authorization enabled in the user interface)"
                }
            "6" {
                    $apiError = "API_UNKNOWN_COMMAND"
                    $apiErrorDescription = "The API processor did not recognize the command passed in the APIcommand parameter."
                }
        }
        throw "Unable to connect to NETBOX-API.  Error code: $($ReturnXML.NETBOX.RESPONSE.APIERROR),  $($apiError): $($apiErrorDescription)"
    }
    else
    {
        Set-Variable -Scope Global -Name "NETBOXSessionID" -Value $($ReturnXML.NETBOX.sessionid)
    }
}