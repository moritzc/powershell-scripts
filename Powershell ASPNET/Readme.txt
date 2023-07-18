ASPLogAnalyze.ps1 durchsucht die Eventlog nach ID1309 und im Inhalt des Eintrags nach einer IP Adresse. IPs werden dann gezählt und sortiert. 

Abfrage der IPs bei Abuseipdb via API call um das Land zuzuordnen.


Standardmäßig werden nur die letzten 2 Tage nach Einträgen durchsucht. Für längeren Zeitraum einfach mit 
.\ASPLogAnalyze.ps1 <TAGE> 

----------------------------------Erklärung durch chatGPT----------------------------------------------------------------------------

This code is written in PowerShell and is used to retrieve event log entries from the "Application" log in Windows with an event ID of 1309, filter out the IP addresses from the log messages, and then perform API calls on each unique IP address to get information about the country the IP address is associated with.

The first line of code sets the variable $days to 2. If an argument is provided as the first element in the array $args, the value of $days is set to that argument.

The next line of code uses the Get-EventLog cmdlet to retrieve event log entries from the "Application" log that occurred within the past $days number of days. The log entries are filtered to only include those with an event ID of 1309. The resulting log messages are formatted into a table and output to a file called "Dummy.txt".

The next line of code uses a regular expression to find all IP addresses in the "Dummy.txt" file and outputs them to a file called "IPs.txt".

The "IPs.txt" file is then read in and the unique IP addresses are counted and sorted in descending order by the number of occurrences. The total number of unique IP addresses is output to the console.

A loop is then initiated to process API calls for each unique IP address. A progress bar is displayed to show the progress of the loop. For each IP address, an API call is made using a separate PowerShell script called "APICall.ps1" and the resulting country and count of occurrences for the IP address are added to a CSV file called "finished.csv".

Finally, the "IPs.txt" and "Dummy.txt" files are deleted.