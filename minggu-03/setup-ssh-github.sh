#!/usr/bin/env bash
# setup-ssh-github.sh — JOB 1 Modul 3 (JS-DVO-03)
#
# Tujuan: Mengonfigurasi autentikasi SSH (Ed25519) ke GitHub untuk user
# praktikum DevOps Politeknik Negeri Batam.
#
# Yang dilakukan skrip ini:
#   1) Tinjau konfigurasi Git global (core.editor / init.defaultBranch / alias)
#   2) Bangkitkan pasangan kunci SSH Ed25519 dengan passphrase
#   3) Amankan izin least-privilege (700 untuk ~/.ssh, 600 untuk kunci privat)
#   4) Daftarkan kunci ke ssh-agent + tulis ~/.ssh/config (IdentitiesOnly yes)
#   5) Tampilkan kunci publik (siap salin ke GitHub)
#   6) (Opsional) Alihkan remote repo M01 ke SSH
#
# CATATAN INTERAKTIF:
#   - ssh-keygen AKAN meminta passphrase: masukkan sekarang.
#   - Setelah langkah 5, Anda HARUS:
#       a) Buka https://github.com/settings/keys
#       b) New SSH key, judul "DevOps Polibatam", paste isi .pub
#       c) Lanjut ke langkah 6 di terminal
#
# Penggunaan:
#   bash setup-ssh-github.sh                # konfigurasi penuh
#   bash setup-ssh-github.sh --test-only    # hanya uji ssh -T git@github.com
#
# Skrip ini TIDAK meng-upload kunci ke internet; hanya menyiapkan lokal.

set -euo pipefail

red()   { printf '\033[31m%s\033[0m\n' "$*" >&2; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
bold()  { printf '\033[1m%s\033[0m\n' "$*"; }

KEY_FILE="$HOME/.ssh/id_ed25519_polibatam"
GITHUB_USER="${GITHUB_USERNAME:-}"

bold "=== Job 1 / JS-DVO-03: Setup SSH ke GitHub ==="

# ---------- 1. Konfigurasi Git global ----------
bold "[1/6] Mengatur konfigurasi Git global"

git config --global core.editor "nano"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global alias.lg "log --oneline --graph --decorate --all"

git config --global --list | sort | sed 's/^/    /'

green "✓ Konfigurasi Git global siap"
echo ""

# ---------- 2. Generate SSH key Ed25519 ----------
bold "[2/6] Generate kunci SSH Ed25519"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ -f "$KEY_FILE" ]]; then
    red "✗ Kunci $KEY_FILE sudah ada. Tidak ditimpa."
    red "  Untuk re-generate, hapus dulu: rm -f $KEY_FILE $KEY_FILE.pub"
else
    # -N '' → kosongkan passphrase; user akan diminta secara interaktif
    # Kita izinkan input kosong (untuk CI); tapi PEDOMAN modul: pakai passphrase.
    ssh-keygen -t ed25519 -C "${GITHUB_USER:-nim}@students.polibatam.ac.id" \
        -f "$KEY_FILE"
    green "✓ Kunci SSH dihasilkan"
fi

echo ""

# ---------- 3. Least-privilege perms ----------
bold "[3/6] Memasang izin least-privilege"
chmod 700 "$HOME/.ssh"
chmod 600 "$KEY_FILE"
chmod 644 "$KEY_FILE.pub"

stat -c '%a  %n' "$HOME/.ssh" "$KEY_FILE" "$KEY_FILE.pub" | sed 's/^/    /'

green "✓ Izin kunci sesuai standar"
echo ""

# ---------- 4. ssh-agent + config ----------
bold "[4/6] Mendaftarkan kunci ke ssh-agent"
if [[ -n "${SSH_AUTH_SOCK:-}" ]] || ssh-add -l >/dev/null 2>&1; then
    :
else
    eval "$(ssh-agent -s)"
fi
ssh-add "$KEY_FILE"
echo ""

bold "[4/5] Menulis ~/.ssh/config"
cat >> "$HOME/.ssh/config" <<'EOF'

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_polibatam
  IdentitiesOnly yes
EOF
chmod 600 "$HOME/.ssh/config"
cat "$HOME/.ssh/config"
echo ""

# ---------- 5. Tampilkan kunci publik ----------
bold "[5/6] KUNCI PUBLIK ANDA (siap salin ke GitHub):"
echo ""
cat "$KEY_FILE.pub"
echo ""
echo "    → Buka https://github.com/settings/keys"
echo "    → New SSH key"
echo "    → Title: DevOps Polibatam"
echo "    → Key type: Authentication Key"
echo "    → Paste seluruh baris di atas"
echo ""

# ---------- 6. Uji koneksi ----------
bold "[6/6] Menguji koneksi ke GitHub"
if ssh -T -o StrictHostKeyChecking=accept-new git@github.com 2>&1 | grep -qi "successfully authenticated"; then
    green "✓ Koneksi SSH ke GitHub berhasil."
    SSH_OK=1
else
    red "✗ Koneksi SSH belum berhasil. Pastikan Anda sudah mendaftarkan kunci publik"
    red "  di https://github.com/settings/keys dan tunggu beberapa detik."
    SSH_OK=0
fi

echo ""

# ---------- 7. (Opsional) Alihkan remote repo M01 ----------
if [[ "$SSH_OK" == "1" ]]; then
    bold "[bonus] Migrasikan remote repo M01 ke SSH"

    if [[ -z "${GITHUB_USER:-}" ]]; then
        read -r -p "    Username GitHub Anda (cth: gandhi-dev): " GITHUB_USER
    fi

    REPO_DIR="$HOME/praktikum-devops/minggu-01/app-sentra"
    if [[ -d "$REPO_DIR" ]]; then
        cd "$REPO_DIR"
        echo "    Remote sebelum:"
        git remote -v | sed 's/^/      /'
        git remote set-url origin "git@github.com:${GITHUB_USER}/praktikum-devops-m01.git"
        echo "    Remote sesudah:"
        git remote -v | sed 's/^/      /'
        if git fetch origin >/dev/null 2>&1; then
            green "✓ fetch origin berhasil — autentikasi SSH aktif untuk repo M01"
        fi
    else
        red "✗ $REPO_DIR tidak ditemukan. Lewati migrasi remote (Jalankan dari repo M01)."
    fi
fi

echo ""
bold "=== Selesai ==="