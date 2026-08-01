# OpenWhispr setup checklist (Phase 1)

Manual install (not automated by rebuild). Soft-checked by `machine\Ensure-OpenWhispr.ps1`.

Typical exe path after the vendor installer:

`%LOCALAPPDATA%\Programs\OpenWhispr\OpenWhispr.exe`

Download from the OpenWhispr upstream release/installer if missing. Do not commit the installer into git.

## Do this once in the Control Panel

1. Prefer **local** transcription (Whisper and/or NVIDIA Parakeet). Skip cloud / account signup if offered for Phase 1.
2. Download a local model (start with **base** or **small**; upgrade later if needed).
3. Set a global hotkey you will use in Cursor (Windows default is often Ctrl+Win; push-to-talk is available).
4. Confirm **auto-paste** is on so transcripts land at the cursor in Cursor chat.
5. Optional: disable meeting notes / cloud sync extras if you only want dictation.

## Smoke test

1. Focus the Cursor agent chat input.
2. Press the hotkey, say: "Summarize this file in one sentence."
3. Stop recording; text should paste into the chat.

## Fallback

If Electron feels heavy or you want strict offline-only: Whisper Local  
https://github.com/mggarofalo/whisper-local
