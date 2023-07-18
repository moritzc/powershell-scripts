Param(
	[Parameter(Mandatory=$True)]
	[ValidatePattern("((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))")]
	[String]$IP,

	[Parameter(Mandatory=$False)]
	[AllowEmptyString()]
	[String]$Categories,

	[Parameter(Mandatory=$False)]
	[AllowEmptyString()]
	[String]$Comment
)

<###   USER VARIABLES   ###>
$APIKey = "xxxxxxxxxxxxxxxxxxxxxx"

<#  Begin Script  #>

<#  Clear out error variable  #>
$Error.Clear()

<#  Set header  #>
$Header = @{
	'Key' = $APIKey;
}

<#  If Categories and Comment empty, then the call must be to check  #>
If (([string]::IsNullOrEmpty($Categories)) -and ([string]::IsNullOrEmpty($Comment))){

	$URICheck = "https://api.abuseipdb.com/api/v2/check"
	$BodyCheck = @{
		'ipAddress' = $IP;
		'maxAgeInDays' = '90';
		'verbose' = '';
	}
	Try {
		<#  GET abuse confidence score and set status if successful  #>
		$AbuseIPDB = Invoke-RestMethod -Method GET $URICheck -Header $Header -Body $BodyCheck -ContentType 'application/json; charset=utf-8' 
		$StatusNum = "200"
		$ConfidenceScore = $AbuseIPDB.data.abuseConfidenceScore
		$country = $AbuseIPDB.data.countryName
	}
	Catch {
		<#  If error, capture status number from message  #>
		$ErrorMessage = $_.Exception.Message
		[regex]$RegexErrorNum = "\d{3}"
		$StatusNum = ($RegexErrorNum.Matches($ErrorMessage)).Value	
	}

<#  If Categories or Comment exist, then the call must be to report  #>
} Else {

	$URIReport = "https://api.abuseipdb.com/api/v2/report"
	$BodyReport = @{
		'ip' = $IP;
		'categories' = $Categories;
		'comment' = $Comment;
	} | ConvertTo-JSON 

	Try {
		<#  GET abuse confidence score and set status if successful  #>
		$AbuseIPDB = Invoke-RestMethod -Method POST $URIReport -Header $Header -Body $BodyReport -ContentType 'application/json; charset=utf-8' 
		$StatusNum = "200"
		$ConfidenceScore = $AbuseIPDB.data.abuseConfidenceScore
		$country = $AbuseIPDB.data.countryName
	}
	Catch {
		<#  If error, capture status number from message  #>
		$ErrorMessage = $_.Exception.Message
		[regex]$RegexErrorNum = "\d{3}"
		$StatusNum = ($RegexErrorNum.Matches($ErrorMessage)).Value	
	}
}

<#  Return result in a parseable hash  #>
$Response = @{
	'Status' = $StatusNum;
	'Confidence' = $ConfidenceScore;
	'Country' = $country
}
Return $Response