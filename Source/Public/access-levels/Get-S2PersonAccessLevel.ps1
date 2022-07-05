Function Get-S2PersonAccessLevel {
    param(
        [parameter(Mandatory=$true, ParameterSetName = 'ID')][String] $S2_PersonID,
        [parameter(ParameterSetName = 'Search')][String] $FirstName,
        [parameter(ParameterSetName = 'Search')][String] $LastName,
        [parameter(ParameterSetName = 'Search')][int] $PersonID
    )

    if ([string]::IsNullOrEmpty($S2_PersonID)) {
        $Params = @{
            "FirstName" = $FirstName
            "LastName" = $LastName
            "UDF3" = $PersonID
        }
        foreach( $Key in @($Params.Keys) ){
            if( -not $Params[$Key] ){
                $Params.Remove($Key)
                }
            }

        $S2_PersonID = Search-S2Person @Params | Select-Object -ExpandProperty PersonID
    }

    Return Get-S2Person $S2_PersonID
    | Select-Object -ExpandProperty ACCESSLEVELS
    | Select-Object -ExpandProperty ACCESSLEVEL
}