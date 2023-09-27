function Merge-Json( $source, $extend ){
    if( $source -is [PSCustomObject] -and $extend -is [PSCustomObject] ){

        # Ordered hashtable for collecting properties
        $merged = [ordered] @{}

        # Copy $source properties or overwrite by $extend properties recursively
        foreach( $Property in $source.PSObject.Properties ){
            if( $null -eq $extend.$($Property.Name) ){
                $merged[ $Property.Name ] = $Property.Value
            }
            else {
                $merged[ $Property.Name ] = Merge-Json $Property.Value $extend.$($Property.Name)
            }
        }

        # Add $extend properties
        foreach( $Property in $extend.PSObject.Properties ){
            if( $null -eq $source.$($Property.Name) ) {
                $merged[ $Property.Name ] = $Property.Value
            }
        }

        # Convert hashtable into PSCustomObject and output
        [PSCustomObject] $merged
    }
    elseif( $source -is [Collections.IList] -and $extend -is [Collections.IList] ){
        , ($source + $extend)
    }
    else{
        # Output extend object (scalar or different types)
        $extend
    }
}

$data1 = Get-Content .\BicycleQuests.json -Raw | ConvertFrom-Json
$data2 = Get-Content .\GoMapQuests.json -Raw | ConvertFrom-Json
Merge-Json $data1 $data2 | ConvertTo-Json -Depth 10 | Set-Content AllQuests.json