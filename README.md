# Personal-KODI-Setup
Installs KODI on Linux Mint.<br>Also includes Apache2, PHP, Conky, Krusader, SimpleHTTPUploadServer. Games etc.

Use the Bash Script to install KODI. Install as Super User.

Note: The smb.conf file line<br>`client max protocol = NT1`<br>has been changed to<br>
`min protocol = CORE`<br>
`max protocol = SMB3`<br>
`client min protocol = CORE`<br>
`client max protocol = SMB3`<br>
This change has occured since the introduction of Linux Mint 20 Ulyana.<br>
This might not be the same in other Linux distributions.
