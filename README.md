# PowerShell-Skriptsammlung

Diese Sammlung enthält verschiedene PowerShell-Skripte für unterschiedliche administrative Aufgaben.

## Inhaltsverzeichnis
1. [Geolocation aus IP-Adresse in E-Mail Body](#geolocation-aus-ip-adresse-in-e-mail-body)
2. [Powershell ASP.NET Log-Analyse](#powershell-aspnet-log-analyse)
3. [Monitoring Abfragen (Hyper-V)](#monitoring-abfragen-hyper-v)
4. [Random Data Creator](#random-data-creator)

---

### Geolocation aus IP-Adresse in E-Mail Body

Dieser Ordner enthält Skripte, um IP-Adressen aus `.msg`-Dateien (Outlook-E-Mails) zu extrahieren und diese über die AbuseIPDB-API auf ihre Herkunft und Reputation zu überprüfen. Das ist nützlich, um beispielsweise die Herkunft von Anmeldeversuchen oder Spam-Nachrichten zu verfolgen.

**Wichtige Voraussetzung:** Für die Ausführung muss Microsoft Outlook **geschlossen** sein, da das Skript per COM-Objekt auf Outlook-Funktionen zugreift.

**Skripte:**
- `RemoteIPMulti.ps1`: Das Hauptskript. Es liest alle `.msg`-Dateien aus dem Unterordner `MSG`, extrahiert die IP-Adressen, zählt deren Vorkommen und ruft `APICall.ps1` auf, um die Daten anzureichern. Das Ergebnis wird in `finished.csv` gespeichert.
- `APICall.ps1`: Führt die eigentliche API-Abfrage bei `api.abuseipdb.com` durch. **Hinweis:** Sie müssen Ihren eigenen API-Key im Skript eintragen.
- `ProcessUniquesorted.ps1`: Eine verkürzte Version, die nur den zweiten Teil (API-Abfrage und CSV-Erstellung) ausführt. Sie setzt voraus, dass bereits eine `UniqueIPs.txt`-Datei mit den zu prüfenden IP-Adressen existiert.

---

### Powershell ASP.NET Log-Analyse

Diese Skripte dienen der Analyse des Windows Application Event Logs auf spezifische ASP.NET-Fehler (Event ID 1309). Aus diesen Fehlermeldungen werden IP-Adressen extrahiert und ebenfalls über AbuseIPDB überprüft.

**Anwendung:**
Das Skript durchsucht standardmäßig die Logs der letzten 2 Tage. Um einen anderen Zeitraum zu wählen, übergeben Sie die Anzahl der Tage als Parameter:
```powershell
.\ASPLogAnalyze.ps1 10
```

**Skripte:**
- `ASPLogAnalyze.ps1`: Das Hauptskript. Es filtert das Event Log, extrahiert die IPs, zählt sie und generiert am Ende eine `finished.csv`-Datei mit den Ergebnissen.
- `APICall.ps1`: Dasselbe Helfer-Skript wie oben zur Abfrage der IP-Reputation bei AbuseIPDB. Auch hier muss ein API-Key hinterlegt werden.

---

### Monitoring Abfragen (Hyper-V)

Diese Skripte helfen bei der Überwachung eines Hyper-V-Hosts, indem sie nach vorhandenen Snapshots suchen. Snapshots können schnell zu Performanceproblemen oder Speicherplatzmangel führen und sollten regelmäßig überprüft werden. Die Skripte benötigen das Hyper-V PowerShell-Modul.

**Skripte:**
- `snapshot-check.ps1`: Ein einfaches Skript, das den Befehl `Get-VMSnapshot` verwendet, um alle offiziell registrierten Snapshots auf dem Host zu finden und aufzulisten.
- `snapshot-check incl avhdx.ps1`: Eine erweiterte Version, die nicht nur `Get-VMSnapshot` ausführt, sondern zusätzlich das Dateisystem des VM-Speicherpfads nach `.avhdx`-Dateien (Differencing Disks) durchsucht. Dies hilft, auch verwaiste oder "versteckte" Snapshots zu identifizieren, die im Hyper-V-Manager möglicherweise nicht mehr sichtbar sind.

---

### Random Data Creator

Dies ist ein einfaches Hilfsskript, um eine Struktur aus Ordnern und Dateien mit zufälligem Inhalt zu Testzwecken zu erstellen.

**Skript:**
- `Create Junkdata.ps1`: Erstellt standardmäßig im Verzeichnis `C:\test` eine verschachtelte Ordnerstruktur und befüllt jeden Ordner mit Textdateien, die zufällige Zeichen enthalten. Die Ziel- und Mengenangaben können direkt im Skript angepasst werden.
