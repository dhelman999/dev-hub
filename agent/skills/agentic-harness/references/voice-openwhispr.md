# Voice — OpenWhispr

- Soft-checked on Agent rebuild (`Ensure-OpenWhispr.ps1`); install is manual
- Typical exe: `%LOCALAPPDATA%\Programs\OpenWhispr\OpenWhispr.exe`
- Autostart: often HKCU `Run` value `OpenWhispr` (set by the app installer)
- Checklist: `C:\Projects\dev-hub\agent\OPENWHISPR-SETUP.md`

Prefer **local** Whisper/Parakeet; hotkey + auto-paste into Cursor chat.

Official name-fix is the **custom dictionary** (Whisper `initial_prompt` hints),
not a separate keyword engine and not AGENTS.md:
https://docs.openwhispr.com/help/customise/custom-dictionary

Word lists (merged): public `dev-hub\agent\openwhispr-dictionary.txt` +
optional private `dev-hub-personal\agent\openwhispr-dictionary.txt`.
Employer / recruiter / pipeline names go in the private one only.
Apply: `machine\Apply-OpenWhisprDictionary.ps1` (called from Ensure-OpenWhispr).
User DB: `%APPDATA%\open-whispr\transcriptions.db`

Add the spelling you want, not the phonetic mistake. Snippets
(`trigger => Replacement`) only for tokens you would never say otherwise.
Agent overlay is fallback if a mangle still pastes into Cursor.

Fallback (strict offline / lighter): [Whisper Local](https://github.com/mggarofalo/whisper-local)
