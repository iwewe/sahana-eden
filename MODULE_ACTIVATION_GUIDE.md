# Panduan Aktivasi Modul Sahana Eden

## 📋 Modul yang Akan Diaktifkan

| Modul | Status | Deskripsi |
|-------|--------|-----------|
| Request Aid (req) | ✅ Sudah Aktif | Manajemen permintaan bantuan |
| Volunteer Registration (vol) | ✅ Sudah Aktif | Pendaftaran dan manajemen volunteer |
| Missing Person Registry (mpr) | ⚠️ Perlu Aktivasi | Pencatatan dan pencarian orang hilang |
| Shelter Search (cr) | ⚠️ Perlu Aktivasi | Manajemen shelter/pengungsian |
| Disease Tracking (disease) | ⚠️ Perlu Aktivasi | Pelacakan penyakit dan wabah |
| Incident Reporting (irs) | ⚠️ Perlu Aktivasi | Sistem pelaporan insiden |

---

## 🎯 Metode Aktivasi

### Metode 1: Menggunakan Script Otomatis (Recommended)

Script otomatis akan:
- ✅ Backup konfigurasi existing
- ✅ Aktivasi modul yang diperlukan
- ✅ Validasi konfigurasi
- ✅ Restart service

```bash
# Download script aktivasi
curl -fsSL -o activate_modules.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/activate_modules.sh

# Review script
less activate_modules.sh

# Jalankan script
sudo bash activate_modules.sh
```

### Metode 2: Manual (Untuk Advanced Users)

#### Langkah 1: Backup Konfigurasi

```bash
# Backup file konfigurasi
cd /opt/sahana/eden/models
sudo cp 000_config.py 000_config.py.backup.$(date +%Y%m%d_%H%M%S)
```

#### Langkah 2: Edit File Konfigurasi

```bash
sudo nano /opt/sahana/eden/models/000_config.py
```

#### Langkah 3: Tambahkan Konfigurasi Modul

Cari bagian `settings.modules` atau tambahkan di akhir file sebelum penutup:

```python
# =========================================================================
# Module Configuration
# =========================================================================
from collections import OrderedDict
from gluon.storage import Storage

# Uncomment this line if not already present
# settings.modules = OrderedDict([...])

# Or add these modules to existing settings.modules:

settings.modules = OrderedDict([
    # Core modules (sudah ada)
    ("default", Storage(
        name_nice = T("Home"),
        restricted = False,
        access = None,
        module_type = None
    )),
    ("admin", Storage(
        name_nice = T("Administration"),
        restricted = True,
        access = "|1|",
        module_type = None
    )),
    ("appadmin", Storage(
        name_nice = T("Administration"),
        restricted = True,
        module_type = None
    )),
    ("errors", Storage(
        name_nice = T("Ticket Viewer"),
        restricted = False,
        module_type = None
    )),
    ("gis", Storage(
        name_nice = T("Map"),
        restricted = True,
        module_type = 6,
    )),
    ("pr", Storage(
        name_nice = T("Person Registry"),
        restricted = True,
        access = "|1|",
        module_type = 10
    )),
    ("org", Storage(
        name_nice = T("Organizations"),
        restricted = True,
        module_type = 1
    )),
    ("hrm", Storage(
        name_nice = T("Staff"),
        restricted = True,
        module_type = 2,
    )),

    # ===== MODUL YANG SUDAH AKTIF =====
    ("vol", Storage(
        name_nice = T("Volunteers"),
        restricted = True,
        module_type = 2,
    )),
    ("req", Storage(
        name_nice = T("Requests"),
        restricted = True,
        module_type = 10,
    )),

    # ===== MODUL BARU YANG DIAKTIFKAN =====

    # Missing Person Registry
    ("mpr", Storage(
        name_nice = T("Missing Person Registry"),
        #description = "Helps to report and search for missing persons",
        restricted = True,
        module_type = 10,
    )),

    # Shelter/Camp Registry
    ("cr", Storage(
        name_nice = T("Shelters"),
        #description = "Tracks the location, capacity and breakdown of victims in Shelters",
        restricted = True,
        module_type = 10
    )),

    # Disease Tracking
    ("disease", Storage(
        name_nice = T("Disease Tracking"),
        #description = "Helps to track cases and trace contacts in disease outbreaks",
        restricted = True,
        module_type = 10
    )),

    # Incident Reporting System
    ("irs", Storage(
        name_nice = T("Incidents"),
        #description = "Incident Reporting System",
        restricted = True,
        module_type = 10
    )),

    # Modul pendukung lainnya (opsional)
    ("cms", Storage(
        name_nice = T("Content Management"),
        restricted = True,
        module_type = 10,
    )),
    ("doc", Storage(
        name_nice = T("Documents"),
        restricted = True,
        module_type = 10,
    )),
    ("msg", Storage(
        name_nice = T("Messaging"),
        restricted = True,
        module_type = None,
    )),
])
```

#### Langkah 4: Validasi Syntax Python

```bash
python3 -m py_compile /opt/sahana/eden/models/000_config.py
```

Jika tidak ada error, syntax sudah benar.

#### Langkah 5: Restart Web2py/Sahana Eden

```bash
# Jika menggunakan systemd
sudo systemctl restart sahana-eden

# Atau manual restart
cd /opt/sahana
sudo ./start_eden.sh
```

#### Langkah 6: Verifikasi Aktivasi

Buka browser dan akses: `http://localhost:8000/eden`

Login sebagai admin dan periksa menu - modul baru seharusnya muncul.

---

## 🔍 Verifikasi Modul Aktif

### Melalui Web Interface

1. Login sebagai admin
2. Check menu navigasi untuk modul baru:
   - **MPR** - Missing Person Registry
   - **Shelters** - Manajemen Shelter
   - **Disease Tracking** - Pelacakan Penyakit
   - **Incidents** - Pelaporan Insiden

### Melalui Command Line

```bash
# Check if modules are accessible
curl -I http://localhost:8000/eden/mpr
curl -I http://localhost:8000/eden/cr
curl -I http://localhost:8000/eden/disease
curl -I http://localhost:8000/eden/irs
```

Status code 200 atau 302 (redirect) berarti modul aktif.

---

## 🛠️ Troubleshooting

### Error: "invalid Python syntax"

**Solusi:**
1. Periksa kembali syntax di 000_config.py
2. Pastikan semua kurung dan koma ada di tempat yang benar
3. Restore dari backup jika perlu

```bash
cd /opt/sahana/eden/models
sudo cp 000_config.py.backup.* 000_config.py
sudo systemctl restart sahana-eden
```

### Error: "Module not found"

**Solusi:**
1. Pastikan controller file exists:
```bash
ls -l /opt/sahana/eden/controllers/{mpr,cr,disease,irs}.py
```

2. Check file permissions:
```bash
sudo chown -R $USER:$USER /opt/sahana/eden
```

### Modul Tidak Muncul di Menu

**Solusi:**
1. Clear browser cache
2. Logout dan login kembali
3. Check role permissions - pastikan user memiliki akses ke modul
4. Restart web2py service

```bash
sudo systemctl restart sahana-eden
```

### Database Migration Error

Jika muncul error saat pertama kali akses modul baru:

**Solusi:**
```bash
cd /opt/sahana/web2py
python3 web2py.py -S eden -M -R applications/eden/static/scripts/tools/noop.py
```

Script ini akan membuat tabel database yang diperlukan.

---

## ⚙️ Konfigurasi Lanjutan (Opsional)

### Customisasi Label Modul

Edit `/opt/sahana/eden/models/000_config.py`:

```python
# Ganti label modul sesuai kebutuhan
("mpr", Storage(
    name_nice = T("Orang Hilang"),  # Bahasa Indonesia
    restricted = True,
    module_type = 10,
)),
```

### Mengatur Permissions

```python
# Hanya admin yang bisa akses
("disease", Storage(
    name_nice = T("Disease Tracking"),
    restricted = True,
    access = "|1|",  # Hanya admin
    module_type = 10
)),

# Semua authenticated users bisa akses
("cr", Storage(
    name_nice = T("Shelters"),
    restricted = False,  # Semua user
    module_type = 10
)),
```

### Mengatur Module Order di Menu

Module Type menentukan urutan di menu:

```python
module_type = 1   # Pertama
module_type = 2   # Kedua
module_type = 10  # Terakhir
module_type = None  # Tidak tampil di menu
```

---

## 🔄 Rollback/Disable Modul

### Untuk Disable Modul

Cukup comment (tambahkan #) pada modul yang ingin didisable:

```python
#("disease", Storage(
#    name_nice = T("Disease Tracking"),
#    restricted = True,
#    module_type = 10
#)),
```

Atau hapus seluruh block modul tersebut.

### Restore dari Backup

```bash
cd /opt/sahana/eden/models

# List available backups
ls -lt 000_config.py.backup.*

# Restore dari backup
sudo cp 000_config.py.backup.YYYYMMDD_HHMMSS 000_config.py

# Restart service
sudo systemctl restart sahana-eden
```

---

## 📊 Testing Modul

Setelah aktivasi, test setiap modul:

### 1. Missing Person Registry (MPR)
```
URL: http://localhost:8000/eden/mpr
Test: Create missing person report
```

### 2. Shelters (CR)
```
URL: http://localhost:8000/eden/cr
Test: Create shelter, add capacity info
```

### 3. Disease Tracking
```
URL: http://localhost:8000/eden/disease
Test: Report disease case
```

### 4. Incident Reporting (IRS)
```
URL: http://localhost:8000/eden/irs
Test: Report incident
```

---

## 📚 Dokumentasi Tambahan

- **Developer Guide**: https://eden-asp.readthedocs.io
- **Module Configuration**: https://eden.sahanafoundation.org/wiki/DeveloperGuidelines/Modules
- **Template Guide**: https://eden.sahanafoundation.org/wiki/DeveloperGuidelines/Templates

---

## 💡 Tips

1. **Selalu backup** sebelum edit konfigurasi
2. **Test di development** environment dulu
3. **Commit changes** ke git untuk version control
4. **Document custom settings** untuk maintenance
5. **Monitor logs** setelah aktivasi modul baru

```bash
# Monitor logs
sudo journalctl -u sahana-eden -f
```

---

## 🆘 Support

Jika mengalami masalah:
1. Check log files
2. Restore dari backup
3. Konsultasi dokumentasi
4. Contact mailing list: eden-asp@googlegroups.com

---

**Happy configuring! 🎉**
