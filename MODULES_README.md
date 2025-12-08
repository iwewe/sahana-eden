# 📦 Sahana Eden - Module Activation Quick Reference

## 🚀 Quick Start

### Automatic Activation (Recommended)

```bash
# Download activation script
curl -fsSL -o activate_modules.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/activate_modules.sh

# Review script
less activate_modules.sh

# Run activation
sudo bash activate_modules.sh
```

### Custom Installation Directory

```bash
sudo bash activate_modules.sh /custom/path/to/sahana
```

---

## 📋 Modules Overview

| Module | Code | URL | Status | Description |
|--------|------|-----|--------|-------------|
| **Request Aid** | `req` | `/eden/req` | ✅ Active | Manage aid requests and resource allocation |
| **Volunteers** | `vol` | `/eden/vol` | ✅ Active | Volunteer registration and management |
| **Missing Person** | `mpr` | `/eden/mpr` | ⚠️ Needs Activation | Report and search for missing persons |
| **Shelters** | `cr` | `/eden/cr` | ⚠️ Needs Activation | Shelter capacity and victim tracking |
| **Disease Tracking** | `disease` | `/eden/disease` | ⚠️ Needs Activation | Disease outbreak tracking and contact tracing |
| **Incident Reporting** | `irs` | `/eden/irs` | ⚠️ Needs Activation | Incident reporting and management |

---

## 🛠️ Common Commands

### Check Module Status

```bash
# Check if module is accessible
curl -I http://localhost:8000/eden/mpr
curl -I http://localhost:8000/eden/cr
curl -I http://localhost:8000/eden/disease
curl -I http://localhost:8000/eden/irs
```

### Restart Service

```bash
# Using systemd
sudo systemctl restart sahana-eden

# Check status
sudo systemctl status sahana-eden

# View logs
sudo journalctl -u sahana-eden -f
```

### Backup Configuration

```bash
# Manual backup
sudo cp /opt/sahana/eden/models/000_config.py \
       /opt/sahana/eden/models/000_config.py.backup.$(date +%Y%m%d)
```

### Rollback to Backup

```bash
# List backups
ls -lt /opt/sahana/eden/models/000_config.py.backup.*

# Restore
sudo cp /opt/sahana/eden/models/000_config.py.backup.YYYYMMDD \
       /opt/sahana/eden/models/000_config.py

# Restart
sudo systemctl restart sahana-eden
```

---

## 🔍 Verification

### Access Modules

After activation, access modules at:

- **Missing Person Registry**: http://localhost:8000/eden/mpr
- **Shelters**: http://localhost:8000/eden/cr
- **Disease Tracking**: http://localhost:8000/eden/disease
- **Incidents**: http://localhost:8000/eden/irs

### Check Menu

Login as admin and verify new menu items appear:
1. MPR → Missing Person Registry
2. Shelters → Shelter Management
3. Disease Tracking
4. Incidents → Incident Reports

---

## 🐛 Troubleshooting

### Module Not Appearing

```bash
# 1. Clear browser cache
# 2. Logout and login again
# 3. Restart service
sudo systemctl restart sahana-eden

# 4. Check logs
sudo journalctl -u sahana-eden -n 50
```

### Configuration Error

```bash
# Validate Python syntax
python3 -m py_compile /opt/sahana/eden/models/000_config.py

# If error, restore from backup
sudo cp /opt/sahana/eden/models/000_config.py.backup.* \
       /opt/sahana/eden/models/000_config.py
```

### Database Migration Error

```bash
# Run manual migration
cd /opt/sahana/web2py

# If using venv
/opt/sahana/venv/bin/python3 web2py.py -S eden -M -R applications/eden/static/scripts/tools/noop.py

# If system-wide
python3 web2py.py -S eden -M -R applications/eden/static/scripts/tools/noop.py
```

### Permission Issues

```bash
# Fix ownership
sudo chown -R $USER:$USER /opt/sahana/eden

# Fix permissions
chmod 644 /opt/sahana/eden/models/000_config.py
```

---

## 📖 Documentation

### Full Guides

- **Complete Activation Guide**: [MODULE_ACTIVATION_GUIDE.md](MODULE_ACTIVATION_GUIDE.md)
- **Installation Guide**: [INSTALL_UBUNTU.md](INSTALL_UBUNTU.md)
- **Quick Start**: [QUICK_START.md](QUICK_START.md)

### Online Resources

- **Developer Handbook**: https://eden-asp.readthedocs.io
- **Wiki**: https://eden.sahanafoundation.org
- **Mailing List**: https://groups.google.com/g/eden-asp

---

## ⚙️ Advanced Configuration

### Customize Module Names

Edit `/opt/sahana/eden/models/000_config.py`:

```python
("mpr", Storage(
    name_nice = T("Orang Hilang"),  # Custom name in Bahasa
    restricted = True,
    module_type = 10,
)),
```

### Change Access Permissions

```python
# Admin only
("disease", Storage(
    name_nice = T("Disease Tracking"),
    restricted = True,
    access = "|1|",  # Only admin
    module_type = 10
)),

# All authenticated users
("cr", Storage(
    name_nice = T("Shelters"),
    restricted = False,  # All users
    module_type = 10
)),
```

### Module Menu Order

```python
module_type = 1   # First in menu
module_type = 2   # Second
module_type = 10  # Last
module_type = None  # Hidden from menu
```

---

## 🔒 Security Notes

1. **Change default passwords** after activation
2. **Backup configuration** before changes
3. **Test in development** environment first
4. **Monitor logs** after activation
5. **Set proper permissions** for modules

---

## 📊 Module Details

### Missing Person Registry (MPR)

**Features:**
- Report missing persons
- Search database
- Match found persons
- Family notifications
- Photo uploads

**Use Cases:**
- Natural disasters
- Emergency evacuations
- Search and rescue operations

### Shelter Management (CR)

**Features:**
- Shelter registration
- Capacity tracking
- Resource allocation
- Occupancy management
- Location mapping

**Use Cases:**
- Disaster relief
- Refugee management
- Emergency housing

### Disease Tracking

**Features:**
- Case reporting
- Contact tracing
- Outbreak monitoring
- Symptom tracking
- Geographic distribution

**Use Cases:**
- Disease outbreaks
- Epidemic response
- Public health monitoring

### Incident Reporting (IRS)

**Features:**
- Incident documentation
- Category management
- Geographic mapping
- Status tracking
- Report generation

**Use Cases:**
- Emergency response
- Security incidents
- Public safety

---

## 💡 Tips

1. **Start with one module** at a time for testing
2. **Configure permissions** based on your organization
3. **Train users** before full deployment
4. **Backup regularly** especially before changes
5. **Monitor resource usage** after activation

---

## 🆘 Support

### Get Help

```bash
# View logs
sudo journalctl -u sahana-eden -f

# Check service status
sudo systemctl status sahana-eden

# Test database connection
cd /opt/sahana/web2py
python3 web2py.py -S eden -M
```

### Contact

- **Email**: eden-asp@googlegroups.com
- **GitHub Issues**: https://github.com/sahana/eden/issues
- **Documentation**: https://eden-asp.readthedocs.io

---

**Last Updated**: $(date +"%Y-%m-%d")

**Script Version**: 1.0

---

Made with ❤️ for humanitarian work
