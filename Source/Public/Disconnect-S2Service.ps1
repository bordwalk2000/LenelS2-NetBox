Function Disconnect-S2Service {
    $xml = "<NETBOX-API sessionid=`"$NETBOXSessionID`"><COMMAND name=`"Logout`" num=`"1`" dateformat=`"tzoffset`"></COMMAND></NETBOX-API>"
    Invoke-WebRequest -URI "$($S2PROTOCOL)$($S2HOSTNAME)/goforms/nbapi" -Method Post -Body $xml | Out-Null
}