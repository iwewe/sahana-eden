# 🔧 Panduan Aktivasi Modul Sahana Eden untuk WhatsApp Bot

## Tanggal: 7 Desember 2025

---

## ⚠️ TEMUAN PENTING

Anda benar! **Tidak semua modul aktif secara default** di Sahana Eden.

Dari 6 use case yang saya sebutkan, hanya **2 yang langsung tersedia** tanpa konfigurasi tambahan.

---

## 📊 STATUS MODUL: Yang AKTIF vs TIDAK AKTIF

### ✅ AKTIF Secara Default (Langsung Bisa Dipakai)

| Modul | Controller | Deskripsi | Use Case |
|-------|------------|-----------|----------|
| **req** | req.py | Request Management | ✅ Request Aid/Supplies |
| **vol** | vol.py | Volunteer Management | ✅ Volunteer Registration |
| **hrm** | hrm.py | Human Resources | Staff management |
| **inv** | inv.py | Inventory/Warehouse | Inventory tracking |
| **org** | org.py | Organizations | Organization registry |
| **pr** | pr.py | Person Registry | People database |
| **project** | project.py | Projects | Project management |
| **asset** | asset.py | Assets | Asset tracking |
| **vehicle** | vehicle.py | Vehicles | Fleet management |

### ❌ TIDAK AKTIF Secara Default (Perlu Diaktifkan)

| Modul | Controller | Status | Use Case | Baris di Config |
|-------|------------|--------|----------|-----------------|
| **mpr** | mpr.py | COMMENTED OUT | ❌ Missing Person Reports | 1436-1440 |
| **cr** | cr.py | COMMENTED OUT | ❌ Shelter Search | 1354-1358 |
| **disease** | disease.py | COMMENTED OUT | ❌ Disease Reporting | 1389-1393 |
| **irs** | irs.py | COMMENTED OUT | ❌ Incident Reporting | 1419-1423 |
| **event** | event.py | COMMENTED OUT | Event Management | 1349-1353 |
| **hms** | hms.py | COMMENTED OUT | Hospital Management | 1364-1368 |
| **dvr** | dvr.py | COMMENTED OUT | Disaster Victim Registry | 1359-1363 |

---

## 🎯 USE CASES: Yang Bisa Langsung vs Perlu Aktivasi

### ✅ LANGSUNG TERSEDIA (No Config Needed)

#### Use Case 1: Request Aid/Supplies ✅
```
Modul: req (AKTIF)
Endpoint: /req/req.json
Status: READY TO USE
```

**Contoh Flow:**
```
User: "Kami butuh bantuan makanan dan air untuk 100 orang"
Bot: [Collect details]
API: POST /req/req.json
```

#### Use Case 2: Volunteer Registration ✅
```
Modul: vol + hrm (AKTIF)
Endpoint: /vol/volunteer.json
Status: READY TO USE
```

**Contoh Flow:**
```
User: "Saya ingin jadi relawan"
Bot: [Collect profile]
API: POST /vol/volunteer.json
```

### ❌ PERLU AKTIVASI MODUL

#### Use Case 3: Missing Person Report ❌
```
Modul: mpr (TIDAK AKTIF)
Endpoint: /mpr/person.json
Status: NEED TO ENABLE
File: modules/templates/default/config.py
Line: 1436-1440
```

#### Use Case 4: Shelter Search ❌
```
Modul: cr (TIDAK AKTIF)
Endpoint: /cr/shelter.json
Status: NEED TO ENABLE
File: modules/templates/default/config.py
Line: 1354-1358
```

#### Use Case 5: Disease Reporting ❌
```
Modul: disease (TIDAK AKTIF)
Endpoint: /disease/case.json
Status: NEED TO ENABLE
File: modules/templates/default/config.py
Line: 1389-1393
```

#### Use Case 6: Incident Reporting ❌
```
Modul: irs (TIDAK AKTIF)
Endpoint: /irs/ireport.json
Status: NEED TO ENABLE
File: modules/templates/default/config.py
Line: 1419-1423
Note: Deprecated, replaced by 'event' module
```

---

## 🔧 CARA MENGAKTIFKAN MODUL

### Metode 1: Edit Config File (Recommended)

**Step-by-step:**

```bash
# 1. SSH ke server Sahana Eden
ssh user@your-sahana-server

# 2. Backup config file
cp modules/templates/default/config.py modules/templates/default/config.py.backup

# 3. Edit config file
nano modules/templates/default/config.py

# 4. Uncomment modul yang dibutuhkan (hapus tanda #)
```

**Contoh - Mengaktifkan Missing Person Registry:**

**SEBELUM (TIDAK AKTIF):**
```python
#("mpr", Storage(
#   name_nice = T("Missing Person Registry"),
#   #description = "Helps to report and search for missing persons",
#   module_type = 10,
#)),
```

**SESUDAH (AKTIF):**
```python
("mpr", Storage(
   name_nice = T("Missing Person Registry"),
   #description = "Helps to report and search for missing persons",
   module_type = 10,
)),
```

**5. Restart Sahana Eden:**
```bash
# Jika menggunakan systemd
sudo systemctl restart web2py

# Atau restart web server
sudo systemctl restart nginx
```

**6. Verify module aktif:**
- Login ke Sahana Eden web interface
- Check menu - "Missing Person Registry" harus muncul
- Test API endpoint: `curl http://your-sahana.org/eden/mpr/person.json`

---

## 🚀 QUICK ACTIVATION GUIDE (untuk Emergency)

### Scenario: Aktifkan 4 Modul Penting untuk Bencana

**Modul yang akan diaktifkan:**
1. **mpr** - Missing Person Registry
2. **cr** - Shelters/Camps
3. **event** - Events (pengganti irs)
4. **disease** - Disease Tracking

**One-liner activation:**

```bash
# Backup dulu
cp modules/templates/default/config.py modules/templates/default/config.py.backup

# Edit dengan sed (uncomment modules)
sed -i '1354,1358s/^[[:space:]]*#//' modules/templates/default/config.py  # cr
sed -i '1349,1353s/^[[:space:]]*#//' modules/templates/default/config.py  # event
sed -i '1389,1393s/^[[:space:]]*#//' modules/templates/default/config.py  # disease
sed -i '1436,1440s/^[[:space:]]*#//' modules/templates/default/config.py  # mpr

# Restart
sudo systemctl restart web2py
```

**Verify:**
```bash
# Check if uncommented
grep -A 4 '"mpr"' modules/templates/default/config.py
grep -A 4 '"cr"' modules/templates/default/config.py
grep -A 4 '"event"' modules/templates/default/config.py
grep -A 4 '"disease"' modules/templates/default/config.py
```

---

## 📋 COMPLETE MODULE ACTIVATION CHECKLIST

### For Emergency Response Deployment:

**Priority 1: Critical (Aktifkan untuk rapid deployment)**
- [ ] **mpr** - Missing Person Registry (line 1436-1440)
- [ ] **cr** - Camps & Shelters (line 1354-1358)
- [ ] **event** - Event Management (line 1349-1353)

**Priority 2: Important (Aktifkan jika ada waktu)**
- [ ] **disease** - Disease Tracking (line 1389-1393)
- [ ] **hms** - Hospital Management (line 1364-1368)
- [ ] **dvr** - Disaster Victim Registry (line 1359-1363)

**Priority 3: Nice to Have**
- [ ] **dvi** - Disaster Victim Identification (line 1430-1435)
- [ ] **cap** - Common Alerting Protocol (line 1425-1429)

---

## 🔄 UPDATED USE CASES (Setelah Aktivasi)

### Setelah mengaktifkan modul, use cases lengkap menjadi:

#### ✅ Use Case 1: Request Aid (SUDAH AKTIF)
```python
# sahana_client.py
def create_aid_request(request_data):
    url = f"{SAHANA_API_URL}/req/req.json"
    response = requests.post(url, headers=headers, json=request_data)
    return response.json()
```

#### ✅ Use Case 2: Volunteer Registration (SUDAH AKTIF)
```python
def register_volunteer(volunteer_data):
    url = f"{SAHANA_API_URL}/vol/volunteer.json"
    response = requests.post(url, headers=headers, json=volunteer_data)
    return response.json()
```

#### ✅ Use Case 3: Missing Person Report (SETELAH AKTIVASI)
```python
def create_missing_person_report(person_data):
    url = f"{SAHANA_API_URL}/mpr/person.json"
    response = requests.post(url, headers=headers, json=person_data)
    return response.json()
```

#### ✅ Use Case 4: Shelter Search (SETELAH AKTIVASI)
```python
def search_shelters(location=None):
    url = f"{SAHANA_API_URL}/cr/shelter.json"
    params = {"location__like": location} if location else {}
    response = requests.get(url, headers=headers, params=params)
    return response.json()
```

#### ✅ Use Case 5: Disease Reporting (SETELAH AKTIVASI)
```python
def report_disease_case(case_data):
    url = f"{SAHANA_API_URL}/disease/case.json"
    response = requests.post(url, headers=headers, json=case_data)
    return response.json()
```

#### ✅ Use Case 6: Event/Incident Reporting (SETELAH AKTIVASI)
```python
def report_incident(incident_data):
    url = f"{SAHANA_API_URL}/event/incident.json"
    response = requests.post(url, headers=headers, json=incident_data)
    return response.json()
```

---

## ⚡ RAPID DEPLOYMENT STRATEGY (2-3 Hari)

### Option A: Minimal (Day 1-2)
**Gunakan modul yang SUDAH AKTIF saja:**
- ✅ Request Aid (req)
- ✅ Volunteer Registration (vol)

**Benefit:**
- Zero configuration needed
- Langsung bisa mulai
- Testing lebih cepat

**Limitation:**
- Tidak ada missing person registry
- Tidak ada shelter search

### Option B: Complete (Day 1-3)
**Aktifkan semua modul yang dibutuhkan:**
- Day 1 Hour 1: Aktifkan mpr, cr, event, disease
- Day 1 Hour 2: Test all API endpoints
- Day 2-3: Implement bot seperti biasa

**Benefit:**
- All 6 use cases available
- Full functionality

**Overhead:**
- +1-2 jam untuk aktivasi & testing modul

---

## 🧪 TESTING MODUL SETELAH AKTIVASI

### Test Script: `test_modules.sh`

```bash
#!/bin/bash

SAHANA_URL="http://your-sahana.org/eden"
API_KEY="your_api_key"

echo "Testing Sahana Eden Modules..."

# Test already-active modules
echo -e "\n1. Testing req (Requests) - Should work"
curl -s "$SAHANA_URL/req/req.json?limit=1" \
  -H "Authorization: Bearer $API_KEY" | jq .

echo -e "\n2. Testing vol (Volunteers) - Should work"
curl -s "$SAHANA_URL/vol/volunteer.json?limit=1" \
  -H "Authorization: Bearer $API_KEY" | jq .

# Test newly-activated modules
echo -e "\n3. Testing mpr (Missing Person) - Should work after activation"
curl -s "$SAHANA_URL/mpr/person.json?limit=1" \
  -H "Authorization: Bearer $API_KEY" | jq .

echo -e "\n4. Testing cr (Shelters) - Should work after activation"
curl -s "$SAHANA_URL/cr/shelter.json?limit=1" \
  -H "Authorization: Bearer $API_KEY" | jq .

echo -e "\n5. Testing event (Events) - Should work after activation"
curl -s "$SAHANA_URL/event/incident.json?limit=1" \
  -H "Authorization: Bearer $API_KEY" | jq .

echo -e "\n6. Testing disease (Disease) - Should work after activation"
curl -s "$SAHANA_URL/disease/case.json?limit=1" \
  -H "Authorization: Bearer $API_KEY" | jq .

echo -e "\nDone!"
```

**Expected Output:**
- **Before activation:** 404 error untuk mpr, cr, event, disease
- **After activation:** JSON response dengan data (atau empty array `[]`)

---

## 🐛 TROUBLESHOOTING

### Problem 1: Module tidak muncul di menu setelah uncomment

**Solution:**
```bash
# Clear cache
rm -rf applications/eden/cache/*
rm -rf applications/eden/sessions/*

# Restart web2py
sudo systemctl restart web2py
```

### Problem 2: API endpoint masih 404 setelah aktivasi

**Checklist:**
1. Pastikan syntax uncomment benar (tidak ada extra space)
2. Restart web server sudah dilakukan
3. Check web2py error logs:
   ```bash
   tail -f /var/log/web2py/web2py.log
   ```

### Problem 3: Database migration error

**Solution:**
```bash
# Sahana Eden auto-migrate by default
# Tapi jika ada error, set migrate = True di models/00_db.py

# Check database
sudo -u postgres psql sahana
# \dt  # list tables
# \q   # quit
```

### Problem 4: Permission denied pada API

**Solution:**
```python
# Edit controllers/[module].py untuk allow API access
# Contoh: controllers/mpr.py

def person():
    """RESTful controller for missing persons"""

    # Allow API access
    if request.extension in ("json", "xml"):
        # Disable auth requirement for API (atau sesuaikan)
        pass

    return crud_controller("mpr", "person")
```

---

## 📖 ALTERNATIVE: Menggunakan Template Lain

Jika Anda ingin **semua modul emergency aktif by default**, gunakan template yang berbeda:

### Template IFRC (Red Cross)
```bash
# Edit models/000_config.py atau private/appconfig.ini
# Change template from "default" to "IFRC"

[base]
template = IFRC
```

**IFRC template** mengaktifkan:
- ✅ mpr
- ✅ cr
- ✅ event
- ✅ dvr
- ✅ disease
- Dan modul emergency response lainnya

### Template Disease (Khusus Pandemic/Disease)
```bash
[base]
template = Disease
```

**Disease template** fokus pada:
- ✅ disease tracking
- ✅ patient management
- ✅ hospital management

### Template Locations
```bash
ls modules/templates/
```

**Available templates:**
- default
- IFRC
- Disease
- DRKCM (German Red Cross)
- RLP
- SAMBRO (CAP/Alerting)
- dan 20+ templates lainnya

---

## 🎯 RECOMMENDED APPROACH untuk WhatsApp Bot

### For Emergency Deployment (2-3 hari):

**Day 1 Morning (2 jam): Aktivasi Modul**
```bash
# 1. Aktifkan 4 modul critical
sed -i '1354,1358s/^[[:space:]]*#//' modules/templates/default/config.py  # cr
sed -i '1349,1353s/^[[:space:]]*#//' modules/templates/default/config.py  # event
sed -i '1436,1440s/^[[:space:]]*#//' modules/templates/default/config.py  # mpr
sed -i '1359,1363s/^[[:space:]]*#//' modules/templates/default/config.py  # dvr

# 2. Restart
sudo systemctl restart web2py

# 3. Test all endpoints
bash test_modules.sh
```

**Day 1 Afternoon - Day 3: Normal Development**
```bash
# Lanjutkan dengan implementasi bot seperti di IMPLEMENTASI_CEPAT_WA_BOT_OLLAMA.md
# Semua 6 use cases sekarang available!
```

---

## ✅ CHECKLIST FINAL

### Sebelum Mulai Implementasi Bot:

- [ ] Identify modul mana yang dibutuhkan untuk use cases
- [ ] Backup config file (`config.py.backup`)
- [ ] Uncomment modul yang diperlukan
- [ ] Restart web2py/web server
- [ ] Test API endpoints dengan curl/Postman
- [ ] Verify modul muncul di web interface menu
- [ ] Check database tables created (optional)
- [ ] Document modul yang diaktifkan
- [ ] Update bot code dengan endpoint yang benar

### Setelah Aktivasi:

- [ ] All API endpoints return 200 (not 404)
- [ ] Bot dapat create records via API
- [ ] Bot dapat query data via API
- [ ] Error handling works
- [ ] Logging shows successful API calls

---

## 📞 SUMMARY

### Pertanyaan Anda: "Apakah langsung tersedia di versi ini?"

**Jawaban:**

| Use Case | Modul | Status Default | Action Required |
|----------|-------|----------------|-----------------|
| Request Aid | req | ✅ AKTIF | None - langsung pakai |
| Volunteer Reg | vol | ✅ AKTIF | None - langsung pakai |
| Missing Person | mpr | ❌ TIDAK AKTIF | Uncomment line 1436-1440 |
| Shelter Search | cr | ❌ TIDAK AKTIF | Uncomment line 1354-1358 |
| Disease Report | disease | ❌ TIDAK AKTIF | Uncomment line 1389-1393 |
| Incident Report | event | ❌ TIDAK AKTIF | Uncomment line 1349-1353 |

**Kesimpulan:**
- **2/6 use cases** langsung tersedia
- **4/6 use cases** perlu aktivasi modul (5-10 menit)
- **Semua modul sudah ada** di codebase (controllers & models exist)
- **Hanya perlu uncomment** di config file

---

## 🚀 NEXT STEPS

1. **Decide:** Mau pakai 2 use cases (minimal) atau 6 use cases (complete)?
2. **If 6:** Uncomment 4 modul (5-10 menit)
3. **Test:** Verify API endpoints work
4. **Proceed:** Lanjut implementasi bot seperti guide sebelumnya

**Total overhead untuk aktivasi semua modul: ~30 menit**

---

**Document Version:** 1.0
**Created:** 2025-12-07
**Status:** VERIFIED ✅
