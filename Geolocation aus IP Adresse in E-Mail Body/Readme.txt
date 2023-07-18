Das Skript RemoteIP.ps1 liest aus dem Mail Body aller Nachrichten im MSG Ordner ALLE IP Adressen heraus. Im Fall der Fortigate Notifications ist jeweils nur eine vorhanden.

Nachrichten müssen von Outlook in den MSG Ordner kopiert werden. 
OUTLOOK MUSS GESCHLOSSEN SEIN wenn das Skript gestartet wird.
Wenn Fehlermeldungen auftreten dass die Dateien bereits geöffnet sind am besten im Taskmanager Microsoft Outlook Prozess killen. 
Im falle von Fehlermeldungen Stimmt die Zählung womöglich nicht mehr! Für nicht geöffnete Dateien wird ein anderer doppelt gezählt.

APIKey in APICall.ps1 kann jederzeit ausgetauscht werden. Aktueller free Account mit 1000API Checks/Tag

RemoteIP.ps1.old kann immer nur eine IP pro MSG Datei finden.