$data1 = Get-Content .\Quests\GeneralQuests.json -Raw | ConvertFrom-Json
$data2 = Get-Content .\Quests\BicycleQuests.json -Raw | ConvertFrom-Json

@($data1; $data2) | ConvertTo-Json -depth 10 | Set-Content .\AllQuests.json