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
        throw "Unable to connect to NETBOX-API.  Error code: $($ReturnXML.NETBOX.RESPONSE.APIERROR)"
    }
    else
    {
        Set-Variable -Scope Global -Name "NETBOXSessionID" -Value $($ReturnXML.NETBOX.sessionid)
    }
}