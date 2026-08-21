# OpenWhispr setup checklist (Phase 1)

Manual install (not automated by rebuild). Soft-checked by `machine\Ensure-OpenWhispr.ps1`.

Typical exe path after the vendor installer:

`%LOCALAPPDATA%\Programs\OpenWhispr\OpenWhispr.exe`

User data (dictionary SQLite):

`%APPDATA%\open-whispr\transcriptions.db`

Download from the OpenWhispr upstream release/installer if missing. Do not commit the installer into git.

## How transcription actually learns your words

OpenWhispr does **not** have a separate keyword-spotting engine. The official
fix for mangled names is the **custom dictionary**:

https://docs.openwhispr.com/help/customise/custom-dictionary

Words you add are passed to Whisper as an `initial_prompt` hint, so the real
spelling wins over the phonetic guess. Add the **spelling you want to read**,
not the mistake. Keep the list short - a long list dilutes the hint.

Snippets are different (exact replace after transcription). Use them only for
unique mangles you would never say in a normal sentence, written as
`trigger => Replacement` in either dictionary file. Do not snippet everyday
words (a snippet on `toledo` would rewrite the city).

Two lists, one merge:

| File | Holds |
|------|-------|
| `dev-hub\agent\openwhispr-dictionary.txt` | portable tooling/domain words |
| `dev-hub-personal\agent\openwhispr-dictionary.txt` | employers, recruiters, live pipeline names, PII |

Never put employer or contact names in the public list.

## Do this once in the Control Panel

1. Prefer **local** transcription (Whisper and/or NVIDIA Parakeet). Skip cloud / account signup if offered for Phase 1.
2. Download a local model (start with **base** or **small**; upgrade later if needed).
3. Set a global hotkey you will use in Cursor (Windows default is often Ctrl+Win; push-to-talk is available).
4. Confirm **auto-paste** is on so transcripts land at the cursor in Cursor chat.
5. Optional: disable meeting notes / cloud sync extras if you only want dictation.
6. Set **Language** to English (not auto-detect) under Settings → Preferences. Biggest cheap win besides the dictionary.
7. **Dictionary** (sidebar → Dictionary tab): Agent apply merges both dictionary files into the local DB. You can also **Import a list** in the UI. Restart OpenWhispr after a merge so the list refreshes.
8. **Auto-learn from corrections** (Settings → Preferences) will add words you fix in the target app. Prune junk (`said`, `are`) - it dilutes the Whisper prompt.
9. If a name is still wrong after dictionary: bump local model size, then consider a unique snippet. Cleanup cannot recover a word Whisper never heard.

Agent overlay (`dev-hub-personal\agent\AGENTS.overlay.md`) is a **fallback** when a mangled name still pastes into Cursor. Fix OpenWhispr first.

## Smoke test

1. Focus the Cursor agent chat input.
2. Press the hotkey and say a sentence containing three names from your dictionary.
3. Stop recording; each should paste with the spelling from the list.

## Fallback

If Electron feels heavy or you want strict offline-only: Whisper Local  
https://github.com/mggarofalo/whisper-local
