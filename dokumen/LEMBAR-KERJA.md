# Lembar Kerja — JS-DVO-01 (Minggu 1)

**Mata Kuliah** : DevOps (RKS305) · **Program Studi** : Rekayasa Keamanan Siber
**Kelompok** : Mahasiswa A = \_\_\_\_\_\_\_\_\_\_\_\_ (NIM \_\_\_\_\_\_\_\_\_) · Mahasiswa B = \_\_\_\_\_\_\_\_\_\_\_\_ (NIM \_\_\_\_\_\_\_\_\_)
**Tanggal praktikum** : \_\_\_\_\_\_\_\_\_\_\_\_ · **Repo GitHub** : \_\_\_\_\_\_\_\_\_\_\_\_

> Semua tabel di bawah wajib diisi dengan **data hasil pengukuran kalian sendiri**.
> Rubrik menilai kedalaman analisis berbasis data — angka contoh tidak akan lulus.

---

## JOB 1 — Verifikasi Lingkungan Kerja

| Perkakas | Versi terpasang (Mahasiswa A) | Versi terpasang (Mahasiswa B) | Sesuai acuan? |
|---|---|---|---|
| OS / kernel | | | |
| Git | ≥ 2.34 | ≥ 2.34 | |
| Python 3 | ≥ 3.10 | ≥ 3.10 | |
| pip3 | | | |
| curl | | | |

**Jawaban observasi JOB 1**

- Apakah versi perkakas kedua anggota identik? Perbedaan apa yang berpotensi menimbulkan masalah?
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## JOB 2 — Simulasi Silo (Wall of Confusion)

Dikerjakan Mahasiswa A (Dev) → diserahkan ke Mahasiswa B (Ops).
**Aturan: tidak ada komunikasi lisan. HanyaHANDOVER.md.**

| Parameter Pengukuran | Hasil |
|---|---|
| Waktu mulai (Ops menerima artefak) | \_\_\_\_\_\_\_\_ : \_\_\_\_\_\_\_\_ |
| Waktu selesai / dinyatakan gagal | \_\_\_\_\_\_\_\_ : \_\_\_\_\_\_\_\_ |
| **Lead Time manual (menit)** | |
| **Jumlah kegagalan (failed attempts)** | |
| Jumlah pertanyaan yang seharusnya diajukan ke Dev | |
| Status akhir (Berhasil / Gagal) | |

### Catatan kegagalan (isi tiap baris saat galat muncul)

| No | Perintah yang dijalankan | Pesan galat (salin persis) | Akar masalah menurut Ops |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

**Jawaban observasi JOB 2**

- Pada baris ke berapa galat pertama muncul? Apakah pesannya informatif bagi orang yang tidak menulis kodenya?
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
- Berapa kali Ops ingin bertanya namun terhalang aturan? Informasi kritis apa yang absen dari HANDOVER.md?
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
- Perbedaan konkret apa antara mesin Dev dan mesin Ops?
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## JOB 3 — Value Stream Mapping

Lihat berkas terpisah: **[VSM.md](./VSM.md)**

| Ringkasan | Nilai |
|---|---|
| Σ Process Time (menit) | |
| Σ Wait Time (menit) | |
| **Flow Efficiency = ΣPT / (ΣPT + ΣWT) × 100%** | \_\_\_\_\_ % |
| Aktivitas dengan %C/A terendah (bottleneck) | |

---

## JOB 4 — Otomasi (The First Way)

Peran ditukar: Mahasiswa B = Developer, Mahasiswa A = Operations.

| Metrik | Sebelum Otomasi (JOB 2) | Sesudah Otomasi (JOB 4) | Selisih |
|---|---|---|---|
| Lead Time (menit) | | | |
| Jumlah langkah manual | | | |
| Jumlah kegagalan | | | |
| Kebutuhan komunikasi Dev ↔ Ops | | | |

### Uji ketangguhan skrip

| Pengujian | Perintah | Hasil yang diamati | Memenuhi? |
|---|---|---|---|
| Idempotensi | jalankan `./setup.sh` 3× berturut-turut | | |
| Fail-fast | hapus `requirements.txt`, lalu `./setup.sh` | berhenti di langkah ke-? | |
| Deteksi port bentrok | jalankan app di 5000, lalu `./setup.sh` | pindah ke port? | |
| Mode validasi | `./setup.sh --check` | exit code? | |
| Retry health check | app lambat start | percobaan ke-? berhasil | |
| Pembersihan aman | `./teardown.sh --purge` | .venv terhapus? path tervalidasi? | |

**Jawaban observasi JOB 4**

- Mengapa berhenti lebih awal (`set -euo pipefail`) justru lebih aman?
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
- Apakah `.venv/` muncul di `git status`? Apa dampaknya ke ukuran repo bila `.gitignore` tidak dibuat?
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## JOB 5 — Simulasi SDLC & Blameless Postmortem

| Board | Kolom | Kartu terlama tertahan di kolom | Waktu total simulasi |
|---|---|---|---|
| Waterfall | Requirement → Design → Implementation → Testing → Deployment | | |
| DevOps Flow | Backlog → In Progress (WIP 2) → Review → Deployed → Monitored | | |

Lihat berkas terpisah: **[POSTMORTEM.md](../POSTMORTEM.md)**

---

## Daftar artefak yang dikumpulkan

- [ ] `00-environment-check.log` (JOB 1)
- [ ] Tangkapan layar pesan galat Ops (JOB 2)
- [ ] `dokumen/VSM.md` terisi lengkap + perhitungan Flow Efficiency (JOB 3)
- [ ] `app-sentra/setup.sh` berjalan di mesin pasangan (JOB 4)
- [ ] Tangkapan layar keluaran `./setup.sh` sukses (JOB 4)
- [ ] Tangkapan layar `shellcheck` bersih (challenge)
- [ ] `POSTMORTEM.md` (JOB 5)
- [ ] Tautan repository GitHub **private**, collaborator: `antoni@polibatam.ac.id` + pasangan
- [ ] Laporan PDF `M01_NIM_NamaLengkap.pdf`, dikumpul H+3 pukul 23.59 WIB
