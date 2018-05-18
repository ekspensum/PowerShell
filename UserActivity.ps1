
Function UserActivity{
param ($userName)
$lu = get-localUser
for($a=0; $a -lt $lu.length; $a++){
    if($lu.name[$a] -ieq $userName){
    $pathUser = 'c:\Users\'+$lu.name[$a]
    $znaleziono = $true
    break
    }
    else {
    $znaleziono = $false
    }
}
if($znaleziono -eq $false) {
Write-Warning 'Podany u¿ytkownik nie wystêpuje'
}
else {
# Sort-Object -property @{Expression = "name"; Descending = $True}
$dni = @{}
$pliki = @{}
$dni = Get-ChildItem -recurse -file $pathUser | Group-Object {$_.LastWriteTime.ToString("yyyy-MM-dd")} -NoElement | Sort-Object -property @{Expression = "name"; Descending = $True}
$pliki = ls -recurse -file $pathUser | Sort-Object -property @{Expression = "LastWriteTime"; Descending = $True}


$dane = @{}
for ($i=0; $i -lt $dni.length; $i++) {
for ($j=0; $j -lt $pliki.Length; $j++) {
if($dni[$i].Name -eq $pliki[$j].LastWriteTime.ToString("yyyy-MM-dd")) {
    $dane[$i] += $pliki[$j].Length
}
}
}
for($b=0; $b -lt $dni.Length; $b++) {
"$b. Zapisano plików: "+ $dni[$b].Count + " w dniu: "+$dni[$b].Name + " o pojemnosci ³¹cznej: " + $dane[$b]/1MB + " MB"
}
}
}