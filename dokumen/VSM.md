# Value Stream Map — Alur Serah-Terima Manual (JOB 3)

**Tim** : PT Sentra Digital Batam (simulasi) · **Tanggal** : \_\_\_\_\_\_\_\_\_\_\_\_

## Definisi singkat

| Istilah | Arti |
|---|---|
| **Process Time (PT)** | Waktu kerja aktif yang benar-benar dihabiskan seseorang pada aktivitas itu. |
| **Wait Time (WT)** | Waktu tunggu/antrean sebelum pekerjaan diambil atau diproses ke tahap berikutnya. |
| **%C/A** | Persentase keluaran yang bisa langsung dipakai tahap berikutnya **tanpa revisi/klarifikasi**. |

## Tabel VSM — isi dengan data JOB 2 kalian

| No | Aktivitas | Pelaku | Process Time (PT) | Wait Time (WT) | %C/A |
|---|---|---|---|---|---|
| 1 | Menulis kode | Dev | …… menit | …… menit | …… % |
| 2 | Menulis dokumen serah-terima | Dev | …… menit | …… menit | …… % |
| 3 | Serah-terima artefak | Dev → Ops | …… menit | …… menit | …… % |
| 4 | Instalasi dependensi | Ops | …… menit | …… menit | …… % |
| 5 | Perbaikan galat / klarifikasi | Ops | …… menit | …… menit | …… % |
| 6 | Verifikasi aplikasi berjalan | Ops | …… menit | …… menit | …… % |
| | **TOTAL** | | **ΣPT = ……** | **ΣWT = ……** | |

## Perhitungan

```
Flow Efficiency = Σ PT / (Σ PT + Σ WT) × 100%
                = …… / (…… + ……) × 100%
                = …… %
```

**Bottleneck** : aktivitas no. \_\_\_\_ (\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_) — %C/A = \_\_\_\_ %
**Alasan dipilih sebagai sasaran otomasi** :
> \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## Cara mengisi %C/A agar tidak asal menebak

Hitung dari kejadian nyata, bukan perasaan:

```
%C/A = (jumlah serah-terima yang langsung bisa dipakai) / (total serah-terima) × 100%
```

Contoh pemakaian rumus (ganti dengan data kalian):
- Dari 10 kali Ops menerima artefak, 7 kali gagal jalan karena dependensi tidak lengkap dan harus bertanya ke Dev
  → %C/A aktivitas no. 3 = 3/10 × 100% = **30%**

---

## Catatan analisis (wajib ada di laporan)

1. Aktivitas mana yang menyumbang WT terbesar, dan apa yang menyebabkan antrean itu?
   > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
2. Jika hanya satu aktivitas yang boleh diotomasi, mana yang memberi penurunan Lead Time terbesar?
   Jawab dengan merujuk angka PT dan WT kalian.
   > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
3. Setelah JOB 4, aktivitas nomor berapa yang hilang atau menyusut? Berapa Flow Efficiency yang baru?
   > \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
