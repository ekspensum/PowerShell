$sciezkaZTab = @{}
$sciezkaDoTab = @{}
$nazwaPliku = @{}
$nazwaPlikuHash = @{}
$sciezkaDoHash = @{}
for($i=0;  ; $i++)
{
	$ilePlikowPrzed = ls -recurse -file c:\Users\andrzej\documents\adminWindows | measure
	$PlikiPrzed = ls -recurse -file c:\Users\andrzej\documents\adminWindows
	$PlikiHashPrzed = ls -recurse -file c:\Users\andrzej\documents\adminWindows |  get-filehash
	sleep -seconds 3600
	$ilePlikowPo = ls -recurse -file c:\Users\andrzej\documents\adminWindows | measure
	$PlikiPo = ls -recurse -file c:\Users\andrzej\documents\adminWindows
	$PlikiHashPo = ls -recurse -file c:\Users\andrzej\documents\adminWindows |  get-filehash
	if($ilePlikowPo.count -gt $ilePlikowPrzed.count)
		{
		$nowePliki = Compare-Object -ReferenceObject $PlikiPrzed -DifferenceObject $PlikiPo
		$dateNow = get-date -format filedate
		$katalog = 'c:\Users\andrzej\documents\backup\'+$dateNow+'\'
		mkdir -Path $katalog -force
		if(($ilePlikowPo.count - $ilePlikowPrzed.count) -eq 1)
			{
			$sciezkaZ = 'c:\Users\andrzej\documents\adminWindows\'+$nowePliki.inputobject.name
			$sciezkaDo = 'c:\Users\andrzej\documents\backup\'+$dateNow+'\'+$nowePliki.inputobject.name
			copy-item -Path $sciezkaZ -destination $sciezkaDo
			}
			else
			{
				for ($a=0; $a -lt ($ilePlikowPo.count - $ilePlikowPrzed.count); $a++)
					{
					$sciezkaZTab[$a] = 'c:\Users\andrzej\documents\adminWindows\'+$nowePliki.inputobject.name[$a]
					$sciezkaDoTab[$a] = 'c:\Users\andrzej\documents\backup\'+$dateNow+'\'+$nowePliki.inputobject.name[$a]
					copy-item -Path $sciezkaZTab[$a] -destination $sciezkaDoTab[$a]
					}
			}
		$ilePlikowPrzed = $ilePlikowPo
		}
	$PorownajHash = Compare-Object -ReferenceObject $PlikiHashPrzed -DifferenceObject $PlikiHashPo -property hash, path	
	if($PorownajHash.length -gt 0) 
		{
		$dateNow = get-date -format filedate
		$katalog = 'c:\Users\andrzej\documents\backup\'+$dateNow+'\'
		mkdir -Path $katalog -force
			for ($b=0; $b -lt ($PorownajHash.length/2); $b++)
			{
			$nazwaPlikuHash[$b] = $PorownajHash.path[$b].Substring(40)
			$sciezkaDoHash[$b] = 'c:\Users\andrzej\documents\backup\'+$dateNow+'\'+$nazwaPlikuHash[$b]
			copy-item -Path $PorownajHash.path[$b] -destination $sciezkaDoHash[$b]			
			}					
		}
	echo 'Dzia³a'
}