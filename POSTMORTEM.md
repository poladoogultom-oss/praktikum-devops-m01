# Blameless Postmortem — Insiden Kegagalan Deployment Manual

> **Aturan postmortem blameless:** tidak boleh menyebut nama individu.
> Yang dicari adalah cacat pada **sistem kerja**, bukan siapa yang lupa.
> Isi setiap bagian dengan hasil JOB 2–4 kalian sendiri.

**Tanggal insiden** : \_\_\_\_\_\_\_\_\_\_\_\_ · **Durasi** : \_\_\_\_\_\_\_\_ menit
**Layanan** : sentra-digital-batam (Flask) · **Status akhir** : Berhasil / Gagal (coret yang tidak perlu)

---

## 1. Ringkasan Insiden

_Tulis 3–5 kalimat: apa yang terjadi, siapa terdampak, berapa lama, bagaimana akhirnya._

> Contoh struktur (bukan untuk disalin mentah):
> Proses serah-terima aplikasi dari Development ke Operations gagal berjalan pada lingkungan Ops.
> Penyebab langsungnya adalah \_\_____, dan baru teratasi setelah \_\_____.
> Total waktu terbuang \_\___ menit dengan \_\__ kali percobaan gagal.

Isi:
> \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## 2. Kronologi (timeline)

Gunakan waktu sebenarnya dari Lembar Kerja JOB 2.

| Waktu | Peristiwa | Aktor (peran, bukan nama) |
|---|---|---|
| \_\_:\_\_ | Dev menyerahkan paket berisi `src/` + `HANDOVER.md` | Developer |
| \_\_:\_\_ | Ops mencoba menjalankan aplikasi | Operations |
| \_\_:\_\_ | Galat pertama muncul: `\_\_\_\_\_\_\_\_\_\_\_\_` | Operations |
| \_\_:\_\_ | Percobaan ke-2, galat: `\_\_\_\_\_\_\_\_\_\_\_\_` | Operations |
| \_\_:\_\_ | Klarifikasi / tebakan konfigurasi | Operations |
| \_\_:\_\_ | Aplikasi berhasil merespons / dinyatakan gagal | Operations |

---

## 3. Dampak

| Jenis dampak | Nilai (dari pengukuran kalian) |
|---|---|
| Waktu terbuang (Lead Time manual) | \_\_\_\_\_ menit |
| Jumlah kegagalan | \_\_\_\_\_ kali |
| Percobaan komunikasi Dev ↔ Ops yang terblokir | \_\_\_\_\_ kali |
| Estimasi biaya waktu (Lead Time × tarif/jam × 20 rilis/bulan) | \_\_\_\_\_ |

---

## 4. Akar Masalah pada SISTEM (bukan pada orang)

_Tulis minimal 3 akar masalah sistemik. Setiap poin wajib menjawab:
"mekanisme apa yang seharusnya mencegah ini tanpa mengganti orangnya?"_

| # | Akar masalah sistemik | Mengapa bukan salah individu | Mekanisme pencegahan |
|---|---|---|---|
| 1 | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |
| 2 | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |
| 3 | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |

_Petunjuk arah jawaban (kembangkan dengan kata-kata sendiri):_
- Dependensi tidak pernah dikunci dan tidak dikirim → tidak ada jaminan apa pun bahwa mesin Ops sama dengan mesin Dev.
- Tidak ada verifikasi otomatis bahwa artefak bisa dijalankan → kegagalan baru ketahuan setelah manusia mencoba.
- Pengetahuan konfigurasi berada di kepala orang, bukan di repository → informasi hilang saat orangnya tidak ada.
- Tidak ada definisi "selesai" yang bisa diuji → Dev menganggap selesai, Ops menganggap belum mulai.

---

## 5. Tindakan Perbaikan (action items)

| # | Tindakan | Peran penanggung jawab | Bukti selesai | Status |
|---|---|---|---|---|
| 1 | Seluruh dependensi dikunci di `requirements.txt` | Developer | berkas ada di repo | Selesai |
| 2 | Prosedur manual diganti skrip `setup.sh` | Developer | `./setup.sh` lulus di mesin pasangan | Selesai |
| 3 | Validasi prasyarat otomatis (`--check`) | Developer | exit code 0/1 sesuai kondisi | Selesai |
| 4 | Smoke test otomatis `/health` + retry | Developer | log percobaanhealth check | Selesai |
| 5 | `.gitignore` dibuat sebelum commit pertama | Developer | `git status` tidak memuat `.venv` | Selesai |
| 6 | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ | \_\_\_\_\_\_\_ |

---

## 6. Pelajaran yang Diambil

1. Apa yang berubah pada sistem kerja kalian setelah JOB 4?
   > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
2. Metrik mana yang paling mengejutkan kalian, dan mengapa?
   > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
3. Jika besok ada anggota tim baru, apa yang membuat dia tidak akan mengulangi insiden ini?
   > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
