# Sahana Eden - Installation Commands

## 🚀 Quick Installation Methods

### Method 1: Using curl (Recommended - One Line Install)

```bash
curl -fsSL https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh | sudo bash
```

**Alternative dengan save file terlebih dahulu:**

```bash
# Download script
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Review script (PENTING: selalu review script sebelum dijalankan!)
less install_sahana.sh

# Jalankan instalasi
sudo bash install_sahana.sh
```

### Method 2: Using wget

```bash
# Download script
wget https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Review script
less install_sahana_ubuntu24.sh

# Jalankan instalasi
sudo bash install_sahana_ubuntu24.sh
```

### Method 3: Git Clone (Full Repository)

```bash
# Clone repository
git clone https://github.com/iwewe/sahana-eden.git
cd sahana-eden

# Checkout branch dengan installation script
git checkout claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj

# Review script
less install_sahana_ubuntu24.sh

# Jalankan instalasi
sudo bash install_sahana_ubuntu24.sh
```

### Method 4: Git Pull (Jika sudah ada local repository)

```bash
# Masuk ke directory repository
cd /path/to/sahana-eden

# Fetch updates dari remote
git fetch origin

# Checkout ke branch installation script
git checkout claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj

# Pull latest changes
git pull origin claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj

# Jalankan instalasi
sudo bash install_sahana_ubuntu24.sh
```

---

## 📥 Download Individual Files

### Installation Script Only

```bash
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh
chmod +x install_sahana_ubuntu24.sh
sudo ./install_sahana_ubuntu24.sh
```

### Verification Script

```bash
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh
chmod +x verify_installation.sh
bash verify_installation.sh
```

### Documentation

```bash
# Download installation guide
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/INSTALL_UBUNTU.md

# Download quick start guide
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/QUICK_START.md
```

### Download All Files at Once

```bash
# Create directory
mkdir -p sahana-eden-installer
cd sahana-eden-installer

# Download all files
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/INSTALL_UBUNTU.md
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/QUICK_START.md

# Make scripts executable
chmod +x install_sahana_ubuntu24.sh verify_installation.sh

# Review and run
ls -lh
sudo bash install_sahana_ubuntu24.sh
```

---

## 🔐 Security Best Practices

### Always Review Scripts Before Running

```bash
# Download first
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Review the script
cat install_sahana.sh
# or
less install_sahana.sh
# or
nano install_sahana.sh

# Only run after review
sudo bash install_sahana.sh
```

### Verify Script Integrity (Optional)

```bash
# Download script
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Calculate checksum
sha256sum install_sahana.sh

# Compare with expected checksum (akan diupdate setelah merge)
# Expected: <checksum_will_be_added>
```

---

## 🌐 Alternative: Clone Specific Branch dengan Sparse Checkout

Jika hanya ingin download script tanpa clone seluruh repository:

```bash
# Initialize git repo
mkdir sahana-installer && cd sahana-installer
git init

# Add remote
git remote add origin https://github.com/iwewe/sahana-eden.git

# Configure sparse checkout
git config core.sparseCheckout true
echo "install_sahana_ubuntu24.sh" >> .git/info/sparse-checkout
echo "verify_installation.sh" >> .git/info/sparse-checkout
echo "INSTALL_UBUNTU.md" >> .git/info/sparse-checkout
echo "QUICK_START.md" >> .git/info/sparse-checkout

# Pull specific branch
git pull origin claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj

# Run installation
sudo bash install_sahana_ubuntu24.sh
```

---

## 🔄 Update Script to Latest Version

Jika sudah download sebelumnya dan ingin update ke versi terbaru:

```bash
# Jika menggunakan git
cd /path/to/sahana-eden
git fetch origin
git pull origin claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj

# Jika download manual, download ulang
curl -fsSL -o install_sahana_ubuntu24.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh
```

---

## 📝 curl Options Explained

- `-f` atau `--fail`: Fail silently on HTTP errors
- `-s` atau `--silent`: Silent mode (no progress bar)
- `-S` atau `--show-error`: Show errors even in silent mode
- `-L` atau `--location`: Follow redirects
- `-O` atau `--remote-name`: Save with original filename
- `-o` atau `--output`: Save with specified filename

**Combined `-fsSL`**: Fail on errors, silent mode, show errors, follow redirects

---

## 🎯 Post-Installation Verification

Setelah instalasi selesai, verifikasi dengan:

```bash
# Download verification script (jika belum)
curl -fsSL -o verify_installation.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh
chmod +x verify_installation.sh

# Run verification
bash verify_installation.sh

# Or verify specific directory
bash verify_installation.sh /opt/sahana
```

---

## 💡 Troubleshooting Download Issues

### curl not found

```bash
sudo apt-get update
sudo apt-get install curl
```

### wget not found

```bash
sudo apt-get update
sudo apt-get install wget
```

### SSL Certificate Error

```bash
# Using curl (not recommended for production)
curl -k -fsSL -O https://raw.githubusercontent.com/...

# Better: Update CA certificates
sudo apt-get update
sudo apt-get install ca-certificates
sudo update-ca-certificates
```

### Connection Timeout

```bash
# Increase timeout
curl --connect-timeout 30 --max-time 300 -fsSL -O https://raw.githubusercontent.com/...
```

### Access Blocked by Firewall

```bash
# Try using proxy
curl -x http://proxy:port -fsSL -O https://raw.githubusercontent.com/...

# Or download from alternative source
wget --no-check-certificate https://raw.githubusercontent.com/...
```

---

## 🚀 Complete Installation Example (Fresh Ubuntu 24.04)

```bash
# Update system
sudo apt-get update

# Install curl if not available
sudo apt-get install -y curl

# Download installation script
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Review script (IMPORTANT!)
less install_sahana.sh

# Make executable
chmod +x install_sahana.sh

# Run installation
sudo ./install_sahana.sh

# After installation, verify
curl -fsSL https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh | bash

# Start server
sudo systemctl start sahana-eden

# Check status
sudo systemctl status sahana-eden

# Access application
echo "Open browser: http://localhost:8000/eden"
```

---

## 📞 Support

Jika mengalami masalah saat download atau instalasi:

1. Check error messages
2. Review INSTALL_UBUNTU.md untuk troubleshooting
3. Verify internet connection
4. Check firewall settings
5. Visit: https://github.com/iwewe/sahana-eden/issues

---

**Note**: Ganti URL repository sesuai dengan repository GitHub yang sebenarnya setelah merge ke main branch.
