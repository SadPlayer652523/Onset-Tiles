# Onset Tiles
An open-source Magic Tiles-style game.

# Features

- Custom levels and cover art.
- 4 lanes in total, and BPM adjusted speed.
- Smooth transitions between menus.
- Score only goes up when tiles are colliding with the hit line.
- Import button to easily import existing charts/levels/maps.

# Coming Soon

- In game editor
- Possibly auto-generated levels
- Possibly a better file structure

# Making levels

## File Structure

### settings.json

This contains settings and data. Here is a simple example:

```
{
    "title": "Test Track",
    "artist": "SadPlayer652523",
    "bpm": 108
}
```

Title is the name of the song, if missing, it falls back to the folder name
Rest are self-explanatory

### lanes.lrc

This contains lane data in the form of a Lyric file. Here is an example of that:

```
[00:00.00] 1
[00:00.50] 2
[00:01.00] 3
[00:01.50] 2
[00:02.00] 1
[00:02.50] 0
[00:03.00] 1
[00:03.50] 2
[00:03:76] 3
[00:04.12] 2
[00:04.50] 3
```

Lanes are 0-3 and the timestamps are when the tiles spawn into the game, not when the tiles hit the hit line. `mm:ss.ms` is the format for the timestamps like a normal `lrc` file.

### song.mp3

Contains the audio. Has to be in MP3 format or else it won't work.

### cover.png

The square album art of the song. Visual only and makes the list look better.

# Importing Songs

You should select a folder that has all song folders. Inside those sub-folders should be the required `settings.json`, `lanes.lrc`, `song.mp3` and optional `cover.png`.

# iOS Support

I don't know how to make iOS games. Don't expect an iOS release, I don't even have a single Apple device.
