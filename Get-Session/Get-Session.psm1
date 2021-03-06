<#
.SYNOPSIS
This is basically a wrapper / translation for Quser.exe
#>
Function Get-Session {
	[cmdletbinding()]
	param(
		[String]
		$ComputerName = $env:COMPUTERNAME
	)

	If ($ComputerName -eq $env:COMPUTERNAME) {
		$stringOutput = quser.exe
	}
	Else {
		try {
			$stringOutput = Invoke-Command -ComputerName $ComputerName -ScriptBlock {quser.exe}
		}
		catch [System.Management.Automation.RemoteException] {
			"No User"
		}
	}

	ForEach ($line in $stringOutput) {
		If ($line -match 'anmeldezeit') {Continue}

		[PSCustomObject]@{Username = $line.SubString(1, 20).Trim()
							SessionName = $line.SubString(23, 17).Trim()
							ID = $line.SubString(42, 2).Trim()
							State = $line.SubString(46, 6).Trim()
							LogonTime = $line.SubString(65)
						}
	}
}