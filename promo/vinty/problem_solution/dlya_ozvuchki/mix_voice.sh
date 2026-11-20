#!/usr/bin/env bash
# mix_voice.sh VIDEO MUSIC.wav VOICE(any format) OUT.mp4 [voice_delay_seconds]
# Voice: cleaned (low cut, light compression, loudness -16 LUFS); music ducks under the voice by itself.
set -euo pipefail
VIDEO=$1 MUSIC=$2 VOICE=$3 OUT=$4 DELAY=${5:-0}
MS=$(python3 -c "print(int(float('$DELAY')*1000))")
ffmpeg -loglevel error -y -i "$VIDEO" -i "$MUSIC" -i "$VOICE" -filter_complex "
[2:a]aformat=sample_rates=44100:channel_layouts=mono,highpass=f=90,acompressor=threshold=-20dB:ratio=3:attack=5:release=120,loudnorm=I=-16:TP=-1.5:LRA=11,adelay=${MS}:all=1,apad,asplit=2[vo][sc];
[1:a]aformat=sample_rates=44100:channel_layouts=mono,volume=0.55[mu];
[mu][sc]sidechaincompress=threshold=0.03:ratio=8:attack=20:release=350[duck];
[duck][vo]amix=inputs=2:duration=first:normalize=0,alimiter=limit=0.95[a]" \
  -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k -shortest -movflags +faststart "$OUT"
