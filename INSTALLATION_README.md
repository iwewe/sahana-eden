# 🚀 Sahana Eden - Installation Quick Reference

## ⚡ Super Quick Install (Copy & Paste)

```bash
curl -fsSL https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh | sudo bash
```

---

## 📥 All Installation Methods

| Method | Command | Best For |
|--------|---------|----------|
| **curl (pipe)** | `curl -fsSL [URL] \| sudo bash` | Quick testing |
| **curl (download)** | `curl -fsSL -o script.sh [URL]` | Production (review first) |
| **wget** | `wget [URL]` | Alternative to curl |
| **git clone** | `git clone [repo]` | Development |
| **git pull** | `git pull origin [branch]` | Updates |

---

## 📋 Quick Command Reference

### Download Installation Script

```bash
# Using curl
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Using wget
wget https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# Using git
git clone https://github.com/iwewe/sahana-eden.git
cd sahana-eden
git checkout claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj
```

### Download Verification Script

```bash
curl -fsSL -o verify_installation.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh
chmod +x verify_installation.sh
```

### Download All Documentation

```bash
# Create directory
mkdir sahana-docs && cd sahana-docs

# Download all files
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/INSTALL_UBUNTU.md
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/QUICK_START.md
curl -fsSL -O https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/INSTALLATION_COMMANDS.md

# Make scripts executable
chmod +x *.sh
```

---

## 🔄 Git Commands

### Fresh Clone

```bash
git clone https://github.com/iwewe/sahana-eden.git
cd sahana-eden
git checkout claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj
```

### Update Existing Repository

```bash
cd /path/to/sahana-eden
git fetch origin
git checkout claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj
git pull origin claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj
```

### Sparse Checkout (Scripts Only)

```bash
mkdir sahana-installer && cd sahana-installer
git init
git remote add origin https://github.com/iwewe/sahana-eden.git
git config core.sparseCheckout true
echo "*.sh" >> .git/info/sparse-checkout
echo "*.md" >> .git/info/sparse-checkout
git pull origin claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj
```

---

## 🎯 Complete Installation Flow

### For Ubuntu 24.04 (Fresh Server)

```bash
# 1. Update system
sudo apt-get update

# 2. Install curl
sudo apt-get install -y curl

# 3. Download installer
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh

# 4. Review (IMPORTANT!)
less install_sahana.sh

# 5. Run installation
sudo bash install_sahana.sh

# 6. Verify
curl -fsSL https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/verify_installation.sh | bash

# 7. Start server
sudo systemctl start sahana-eden

# 8. Check status
sudo systemctl status sahana-eden

# 9. Access
echo "Open: http://localhost:8000/eden"
```

---

## 📚 Documentation Files

| File | Description | Download Command |
|------|-------------|------------------|
| `install_sahana_ubuntu24.sh` | Main installation script | `curl -fsSL -O [base-url]/install_sahana_ubuntu24.sh` |
| `verify_installation.sh` | Verification script | `curl -fsSL -O [base-url]/verify_installation.sh` |
| `QUICK_START.md` | Quick start guide | `curl -fsSL -O [base-url]/QUICK_START.md` |
| `INSTALL_UBUNTU.md` | Complete installation guide | `curl -fsSL -O [base-url]/INSTALL_UBUNTU.md` |
| `INSTALLATION_COMMANDS.md` | All installation commands | `curl -fsSL -O [base-url]/INSTALLATION_COMMANDS.md` |

**Base URL**: `https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj`

---

## 🔐 Security Notes

1. **Always review scripts before running**
2. **Never pipe untrusted scripts directly to bash in production**
3. **Download and inspect first**
4. **Verify script integrity if possible**

### Safe Installation Pattern

```bash
# Download
curl -fsSL -o script.sh [URL]

# Review
cat script.sh
# or
less script.sh

# Run only after review
sudo bash script.sh
```

---

## 🛠️ Post-Installation

### Start Server

```bash
sudo systemctl start sahana-eden
```

### Enable Auto-start

```bash
sudo systemctl enable sahana-eden
```

### Check Status

```bash
sudo systemctl status sahana-eden
```

### View Logs

```bash
sudo journalctl -u sahana-eden -f
```

### Access Application

- **URL**: http://localhost:8000/eden
- **Admin**: admin@example.com / testing
- **User**: normaluser@example.com / testing

---

## ⚠️ Ubuntu 24.04 Users

If you encounter `externally-managed-environment` error, the latest script handles this automatically!

**Quick Fix:**
1. Download latest script
2. Choose installation method when prompted:
   - System-wide (production)
   - Virtual environment (development)

See: [TROUBLESHOOTING_PYTHON_ENV.md](TROUBLESHOOTING_PYTHON_ENV.md)

---

## 🆘 Need Help?

- **Quick Start**: See `QUICK_START.md`
- **Full Guide**: See `INSTALL_UBUNTU.md`
- **All Commands**: See `INSTALLATION_COMMANDS.md`
- **Python Issues**: See `TROUBLESHOOTING_PYTHON_ENV.md`
- **Issues**: https://github.com/iwewe/sahana-eden/issues

---

## 📝 curl Options Reference

```bash
-f, --fail          # Fail on HTTP errors
-s, --silent        # Silent mode
-S, --show-error    # Show errors in silent mode
-L, --location      # Follow redirects
-O, --remote-name   # Save with original name
-o, --output        # Save with specified name
```

**Combined `-fsSL`**: Fail on errors + Silent + Show errors + Follow redirects

---

**Quick Links:**
- Repository: https://github.com/iwewe/sahana-eden
- Branch: `claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj`
- Raw Files: `https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/[filename]`

---

Made with ❤️ for Sahana Eden Community
