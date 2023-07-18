Das Skript RemoteIP.ps1 liest aus dem Mail Body aller Nachrichten im MSG Ordner ALLE IP Adressen heraus. Im Fall der Fortigate Notifications ist jeweils nur eine vorhanden.

Nachrichten müssen von Outlook in den MSG Ordner kopiert werden. 
OUTLOOK MUSS GESCHLOSSEN SEIN wenn das Skript gestartet wird.
Wenn Fehlermeldungen auftreten dass die Dateien bereits geöffnet sind am besten im Taskmanager Microsoft Outlook Prozess killen. 
Im falle von Fehlermeldungen Stimmt die Zählung womöglich nicht mehr! Für nicht geöffnete Dateien wird ein anderer doppelt gezählt.

APIKey in APICall.ps1 kann jederzeit ausgetauscht werden. Aktueller Account mit 5000API Checks/Tag

RemoteIP.ps1.old kann immer nur eine IP pro MSG Datei finden.

ProcessUniquesorted.ps1 führt nur die zweite Hälfte des Skripts durch.

---------------------
Mögliche weitere Outputs laut https://docs.abuseipdb.com/#check-endpoint

ipAdress			ipv4 Adresse (auch v6?)
isPublic			bool
ipVersion			int
isWhitelisted			bool
abuseConfidenceScore		int
CountryCode			string
CountryName			string
usageType			string
isp				string
domain				string
hostnames			string
totalreports			int
numDistinctUsers		int
lastReportedAt			string

sowie Reports und weiteren Infos daraus