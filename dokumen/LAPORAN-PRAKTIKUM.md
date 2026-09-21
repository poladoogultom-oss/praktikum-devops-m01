# Laporan Praktikum — Minggu 1 (JS-DVO-01)

**Nama / NIM** : \_\_\_\_\_\_\_\_\_\_\_\_ / \_\_\_\_\_\_\_\_\_\_\_\_
**Kelas** : \_\_\_\_\_\_\_\_\_\_\_ · **Pasangan** : \_\_\_\_\_\_\_\_\_\_\_\_
**Repo** : <https://github.com/\_\_\_\_\_/praktikum-devops-m01>

> Format akhir: PDF mengikuti template laporan praktikum Polibatam, nama berkas `M01_NIM_NamaLengkap.pdf`.
> Isi bagian ber-`[DATA]` dengan angka hasil pengukuran kalian — jawaban tanpa data tidak mendapat nilai penuh.

---

## 1. Analisis akar masalah

**Pertanyaan:** Mengapa akar masalahnya bukan kelalaian individu Developer, melainkan cacat desain sistem kerja? Sebutkan dua mekanisme sistemik.

**Kerangka jawaban (kembangkan sendiri, 2–3 paragraf):**

- Argumentasi: kegagalan terjadi \_\_\_\_ kali dari \_\_\_\_ percobaan; informasi yang hilang selalu sama
  (\_\_\_\_\_\_\_\_\_\_\_). Jika penyebabnya kelalaian orang, kegagalannya akan acak. Kenyataannya polanya
  berulang → itu ciri cacat sistem.
- Bukti: `HANDOVER.md` tidak memuat \_\_\_\_\_\_\_\_\_; `requirements.txt` tidak disertakan;
  mesin Ops tidak punya \_\_\_\_\_\_\_\_\_. Developer tidak pernah diminta oleh sistem apa pun untuk
  membuktikan aplikasinya bisa jalan di luar laptopnya.
- **Mekanisme sistemik 1** — _Dependency & environment as code_: `requirements.txt` terkunci +
  virtual environment + skrip `setup.sh`. Lingkungan didefinisikan oleh berkas di repo, bukan ingatan.
- **Mekanisme sistemik 2** — _Automated verification gate_: smoke test `/health` + exit code.
  Artefak yang tidak lulus verifikasi tidak pernah sampai ke tangan Ops.
- Opsional mekanisme 3 — _Definition of Done_ yang terukur: "selesai" = `./setup.sh` lulus di mesin bersih.

---

## 2. Evaluasi klaim otomasi (studi kasus Jenkins + Kubernetes + approval 3 hari)

**Pertanyaan:** Evaluasi dengan CALMS dan DORA, tentukan pilar mana yang gagal.

**Kerangka jawaban:**

| Pilar CALMS | Kondisi perusahaan | Terpenuhi? | Alasan singkat |
|---|---|---|---|
| **C**ulture | Dev & Ops masih terpisah, keputusan lewat eskalasi manajer | | |
| **A**utomation | Perkakas ada, tetapi langkah deploy belum otomatis | | |
| **L**ean | Approval 3 hari = antrean murni | | |
| **M**easurement | Tidak ada metrik DORA yang dipakai | | |
| **S**haring | Pengetahuan berpusat pada manajer Ops | | |

- Kesimpulan inti: **membeli perkakas ≠ DevOps.** Pilar **Automation** gagal karena alat tidak menggantikan
  keputusan manual; **Lean** gagal karena approval 3 hari adalah _wait time_ bukan nilai tambah;
  **Culture** gagal karena tanggung jawab tidak dibagi.
- Dampak ke DORA: **Lead Time for Changes** memburuk (+3 hari perubahan), **Deployment Frequency** turun
  (insentif menggabungkan banyak perubahan jadi satu rilis besar → batch size naik → **Change Failure Rate**
  ikut naik).
- Satu kalimat penutup: tanpa mengubah cara kerja, Jenkins hanya menjadi mesin yang lebih mahal dari email.

---

## 3. Kuantifikasi dampak

**Pertanyaan:** Dengan Lead Time kalian, hitung penghematan untuk 20 deployment/bulan, lalu sebut 2 manfaat non-waktu.

```
Lead Time manual (JOB 2)   = [DATA] menit
Lead Time otomatis (JOB 4) = [DATA] menit
Penghematan per deployment = [DATA] menit
Penghematan 20 deployment  = [DATA] menit = [DATA] jam/bulan
```

**Dua manfaat yang tidak terukur oleh metrik waktu:**

1. \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ (arah: kepastian/repeatability — hasil identik setiap kali, tidak bergantung
   pada siapa yang menjalankan; cognitive load Ops turun)
2. \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ (arah: auditabilitas — setiap langkah terekam di repo & log, insiden bisa
   ditelusuri; atau _onboarding_ anggota baru cukup satu perintah)

---

## 4. Perbandingan model SDLC secara kontekstual (alat kesehatan, regulasi ketat)

**Pertanyaan:** Model apa yang paling sesuai? Praktik DevOps mana yang tetap bisa diadopsi?

- Model yang dipilih: **Waterfall / V-Model bertahap berbasis dokumen** — karena regulator mensyaratkan
  spesifikasi lengkap & _traceability_ sebelum implementasi.
- **Tetap dapat diadopsi:**
  - Version control + _code review_ wajib (bahkan lebih penting untuk jejak audit)
  - Otomasi build & pengujian (CI) — justru memperkuat bukti verifikasi regulator
  - Infrastructure as Code untuk lingkungan pengujian yang reproducible
  - Pemantauan & logging pasca-rilis
- **Tidak dapat diadopsi apa adanya:**
  - Continuous _Deployment_ otomatis ke produksi (harus ada _human gate_ + persetujuan regulator)
  - Canary release / eksperimen langsung pada pengguna
  - Perubahan tanpa jejak dokumen
- Catatan: yang diadopsi adalah **praktik otomasinya**, bukan kebebasan merilis kapan saja.

---

## 5. Trade-off kecepatan dan stabilitas

**Pertanyaan:** Mengapa Deployment Frequency naik tidak otomatis menaikkan Change Failure Rate? Kapan tidak berlaku?

- Argumentasi dari data: pada JOB 2 satu "rilis" berisi seluruh aplikasi + konfigurasi tak tertulis → \_\_\_\_ kegagalan.
  Pada JOB 4 perubahan kecil dan terverifikasi → \_\_\_\_ kegagalan.
- Alasan: batch kecil → diff mudah ditinjau, _blast radius_ sempit, rollback cepat (MTTR \_\_\_\_ menit),
  dan setiap perubahan lulus gerbang yang sama.
- **Kondisi di mana asumsi itu TIDAK berlaku:** bila frekuensi naik **tanpa** gerbang otomatis
  (tidak ada pengujian/health check/rollback) atau tanpa pemantauan — maka kegagalan tidak terdeteksi,
  dan kecepatan justru memperbesar CFR. Syaratnya: otomasi verifikasi + observabilitas harus mengimbangi.

---

## Refleksi pribadi (bahan diskusi, nilai +5)

- Hal yang paling mengubah cara pandang saya tentang Dev/Ops:
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
- Bagian sistem kerja kelompok kami yang masih manual setelah praktikum ini:
  > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
