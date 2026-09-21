#!/usr/bin/env bash
#
# setup.sh - Otomasi penyiapan & verifikasi aplikasi (The First Way: Flow)
# JS-DVO-01 · JOB 4 · Challenge "Zero-Touch Verification"
#
# Pemakaian:
#   ./setup.sh            ; siapkan venv, pasang dependensi, jalankan, smoke test
#   ./setup.sh --check    ; hanya validasi prasyarat lalu keluar (exit 0/1)
#   ./setup.sh --stop     ; hentikan aplikasi yang sedang berjalan
#   PORT=5055 ./setup.sh  ; paksa port tertentu
#
# Kontrak perilaku:
#   - idempotent  : aman dijalankan berulang kali
#   - fail-fast   : set -euo pipefail, berhenti di langkah pertama yang gagal
#   - zero-touch  : tidak ada satu pun langkah yang perlu diketik manual
#
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Seluruh perintah python/pip memakai path RELATIF: interpreter Python di Windows
# tidak memahami path POSIX (/e/...). Bash sendiri tetap memakai path absolut.
cd "$APP_DIR" || { echo "GAGAL: tidak dapat masuk ke $APP_DIR" >&2; exit 1; }
VENV_DIR="$APP_DIR/.venv"
PID_FILE="$APP_DIR/.app.pid"
LOG_FILE="$APP_DIR/app.log"

PORT="${PORT:-5000}"
MAX_PORT_SCAN="${MAX_PORT_SCAN:-20}"
HEALTH_RETRIES="${HEALTH_RETRIES:-5}"
HEALTH_INTERVAL="${HEALTH_INTERVAL:-2}"

log()  { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }
fail() { printf '[%s] GAGAL: %s\n' "$(date '+%H:%M:%S')" "$*" >&2; exit 1; }

# ---------------------------------------------------------------- prasyarat
check_prereqs() {
  local ok=0

  if command -v python3 >/dev/null 2>&1; then
    log "python3   : $(python3 --version 2>&1)"
  else
    log "python3   : TIDAK DITEMUKAN"; ok=1
  fi

  if python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)' 2>/dev/null; then
    log "versi     : memenuhi syarat (>= 3.10)"
  else
    log "versi     : di bawah 3.10"; ok=1
  fi

  if command -v curl >/dev/null 2>&1; then
    log "curl      : $(curl --version 2>&1 | head -n 1)"
  else
    log "curl      : TIDAK DITEMUKAN"; ok=1
  fi

  if [ -r "$APP_DIR/requirements.txt" ]; then
    log "requirements.txt: ditemukan"
  else
    log "requirements.txt: TIDAK DITEMUKAN"; ok=1
  fi

  return "$ok"
}

port_in_use() {
  # Bash /dev/tcp: tanpa dependensi tambahan (ss/lsof/netstat boleh tidak ada)
  (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null
}

find_free_port() {
  local start="$1" p
  for ((p = start; p < start + MAX_PORT_SCAN; p++)); do
    if ! port_in_use "$p"; then
      printf '%s' "$p"
      return 0
    fi
  done
  return 1
}

stop_app() {
  if [ -f "$PID_FILE" ]; then
    local pid
    pid="$(cat "$PID_FILE")"
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      log "Aplikasi dihentikan (PID $pid)."
    fi
    rm -f "$PID_FILE"
  else
    log "Tidak ada aplikasi yang berjalan (pid file tidak ditemukan)."
  fi
}

# ---------------------------------------------------------------- mode --check
if [ "${1:-}" = "--check" ]; then
  log "Mode --check: hanya memvalidasi prasyarat, aplikasi TIDAK dijalankan."
  if check_prereqs; then
    if free="$(find_free_port "$PORT")"; then
      if [ "$free" -ne "$PORT" ]; then
        log "Port $PORT terpakai; port bebas terdekat: $free"
      else
        log "Port $PORT tersedia."
      fi
      log "SUKSES: lingkungan siap."
      exit 0
    fi
    fail "tidak ditemukan port bebas dalam rentang $PORT-$((PORT + MAX_PORT_SCAN - 1))."
  fi
  fail "lingkungan belum memenuhi prasyarat."
fi

if [ "${1:-}" = "--stop" ]; then
  stop_app
  exit 0
fi

# ---------------------------------------------------------------- alur utama
log "[1/6] Memeriksa prasyarat..."
check_prereqs || fail "prasyarat tidak terpenuhi."

log "[2/6] Menentukan port..."
if port_in_use "$PORT"; then
  NEXT_PORT="$(find_free_port "$PORT")" \
    || fail "tidak ada port bebas dalam rentang $PORT-$((PORT + MAX_PORT_SCAN - 1))."
  log "Port $PORT sudah terpakai -> otomatis pindah ke port $NEXT_PORT"
  PORT="$NEXT_PORT"
else
  log "Port $PORT tersedia."
fi

log "[3/6] Menyiapkan virtual environment..."
if [ -d "$VENV_DIR" ]; then
  log "venv sudah ada, digunakan kembali (idempotent)."
else
  python3 -m venv .venv
  log "venv dibuat di $VENV_DIR"
fi

# Linux/WSL2 -> .venv/bin/activate ; Windows (Git Bash) -> .venv/Scripts/activate
if [ -f "$VENV_DIR/bin/activate" ]; then
  # shellcheck source=/dev/null
  source "$VENV_DIR/bin/activate"
elif [ -f "$VENV_DIR/Scripts/activate" ]; then
  # shellcheck source=/dev/null
  source "$VENV_DIR/Scripts/activate"
else
  fail "berkas aktivasi venv tidak ditemukan di $VENV_DIR"
fi

log "[4/6] Memasang dependensi terkunci..."
# Pakai interpreter MILIK venv, bukan python3 global:
#   Linux/WSL2 -> .venv/bin/python3 ; Windows (Git Bash) -> .venv/Scripts/python.exe
if [ -x "$VENV_DIR/bin/python3" ]; then
  PY="$VENV_DIR/bin/python3"
elif [ -x "$VENV_DIR/Scripts/python.exe" ]; then
  PY="$VENV_DIR/Scripts/python.exe"
else
  PY="python3"
fi
log "interpreter: $PY"

# `python -m pip` (bukan `pip`): kebal terhadap pip.exe yang sedang dikunci (Windows)
# dan terhadap PATH yang belum diperbarui.
"$PY" -m pip install --quiet --upgrade pip
"$PY" -m pip install --quiet -r requirements.txt

log "[5/6] Menjalankan aplikasi pada port $PORT..."
: > "$LOG_FILE"
PORT="$PORT" BUILD_ID="${BUILD_ID:-local-$(date +%Y%m%d%H%M%S)}" \
  "$PY" src/app.py >> "$LOG_FILE" 2>&1 &
APP_PID=$!
echo "$APP_PID" > "$PID_FILE"
trap 'kill "$APP_PID" 2>/dev/null || true; rm -f "$PID_FILE"' EXIT

log "[6/6] Smoke test /health (maks $HEALTH_RETRIES percobaan, jeda ${HEALTH_INTERVAL}s)..."
attempt=1
while [ "$attempt" -le "$HEALTH_RETRIES" ]; do
  if curl -fsS "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
    log "SUKSES: aplikasi sehat pada percobaan ke-$attempt."
    log "  URL      : http://127.0.0.1:$PORT/"
    log "  Health   : http://127.0.0.1:$PORT/health"
    log "  Log      : $LOG_FILE"
    log "  PID      : $APP_PID"
    log "Tekan Ctrl+C untuk menghentikan. Atau jalankan: ./setup.sh --stop"
    wait "$APP_PID"
    exit 0
  fi
  log "  percobaan $attempt/$HEALTH_RETRIES belum merespons, menunggu..."
  sleep "$HEALTH_INTERVAL"
  attempt=$((attempt + 1))
done

echo "--- 20 baris terakhir $LOG_FILE ---" >&2
tail -n 20 "$LOG_FILE" >&2 || true
fail "aplikasi tidak lulus health check setelah $HEALTH_RETRIES percobaan."
