# Troubleshooting Guide - Ubuntu 24.04 Python Environment Issues

## Error: externally-managed-environment

### Problem Description

When running the installation script on Ubuntu 24.04, you may encounter this error:

```
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try apt install
    python3-xyz, where xyz is the package you are trying to
    install.
```

This is a **new security feature** in Ubuntu 24.04 (Python 3.11+) that prevents pip from installing packages system-wide to avoid conflicts with system packages.

### Why This Happens

Starting with Ubuntu 24.04 and Python 3.11+, Debian/Ubuntu introduced [PEP 668](https://peps.python.org/pep-0668/) to prevent users from accidentally breaking their system Python installation by installing packages that might conflict with APT-managed packages.

---

## Solutions

Our updated installation script (`install_sahana_ubuntu24.sh`) now **automatically handles this issue** with two options:

### Option 1: System-wide Installation (Recommended for Production)

The script uses `--break-system-packages` flag to install packages system-wide.

**When to use:**
- Dedicated server for Sahana Eden
- Production deployment
- Server has only one application

**Pros:**
- Simple setup
- No need to activate virtual environment
- System service works directly

**Cons:**
- Modifies system Python packages
- Could potentially conflict with other applications

### Option 2: Virtual Environment (Recommended for Development)

The script creates an isolated Python virtual environment for Sahana Eden.

**When to use:**
- Development environment
- Shared server with multiple applications
- Testing different configurations

**Pros:**
- Completely isolated from system Python
- No risk to system packages
- Can have multiple environments

**Cons:**
- Slightly more complex
- Need to activate environment for manual operations
- Larger disk space usage

---

## How the Updated Script Works

When you run `install_sahana_ubuntu24.sh`, you'll see this prompt:

```
[INFO] Select Python package installation method:
1) System-wide installation (use --break-system-packages)
   Recommended for: Dedicated server, production deployment
2) Virtual environment (isolated Python environment)
   Recommended for: Development, shared server
Enter choice [1-2, default: 1]:
```

### If You Choose Option 1 (System-wide)

The script will:
1. Install packages with `pip3 install --break-system-packages`
2. Use system Python (`/usr/bin/python3`)
3. Create systemd service with system Python

### If You Choose Option 2 (Virtual Environment)

The script will:
1. Create virtual environment at `/opt/sahana/venv`
2. Install all packages in the virtual environment
3. Use virtual environment Python (`/opt/sahana/venv/bin/python3`)
4. Configure systemd service to use virtual environment
5. Create helper scripts with environment activation

---

## Manual Installation Methods

If you need to install packages manually:

### Method 1: Use --break-system-packages

```bash
pip3 install --break-system-packages python-dateutil lxml requests
```

### Method 2: Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv /opt/sahana/venv

# Activate it
source /opt/sahana/venv/bin/activate

# Install packages
pip install python-dateutil lxml requests

# Deactivate when done
deactivate
```

### Method 3: Use APT (Limited Packages)

Some packages are available via APT:

```bash
sudo apt-get install python3-dateutil python3-lxml python3-requests
```

**Note:** Not all required packages are available via APT, so this method alone is insufficient.

---

## Working with Virtual Environment

### If Installed with Virtual Environment

The script creates these helper files:

**Activate environment:**
```bash
source /opt/sahana/venv/bin/activate
```

**Install additional packages:**
```bash
source /opt/sahana/venv/bin/activate
pip install package-name
deactivate
```

**Run Python scripts:**
```bash
# Option 1: With activation
source /opt/sahana/venv/bin/activate
python script.py
deactivate

# Option 2: Direct path
/opt/sahana/venv/bin/python script.py
```

**Check installed packages:**
```bash
/opt/sahana/venv/bin/pip list
```

---

## Systemd Service Configuration

The script automatically configures the systemd service based on your choice:

### System-wide Installation

```ini
ExecStart=/usr/bin/python3 /opt/sahana/web2py/web2py.py --no_gui --password=*** --ip=0.0.0.0 --port=8000
```

### Virtual Environment

```ini
ExecStart=/opt/sahana/venv/bin/python3 /opt/sahana/web2py/web2py.py --no_gui --password=*** --ip=0.0.0.0 --port=8000
Environment="PATH=/opt/sahana/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

---

## Migration Between Methods

### Convert from System-wide to Virtual Environment

```bash
# Stop service
sudo systemctl stop sahana-eden

# Create virtual environment
python3 -m venv /opt/sahana/venv

# Install packages
source /opt/sahana/venv/bin/activate
pip install -r /opt/sahana/eden/requirements.txt
pip install -r /opt/sahana/eden/optional_requirements.txt

# Update systemd service
sudo nano /etc/systemd/system/sahana-eden.service
# Change ExecStart to: /opt/sahana/venv/bin/python3 ...
# Add: Environment="PATH=/opt/sahana/venv/bin:..."

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl start sahana-eden
```

### Convert from Virtual Environment to System-wide

```bash
# Stop service
sudo systemctl stop sahana-eden

# Install packages system-wide
pip3 install --break-system-packages -r /opt/sahana/eden/requirements.txt
pip3 install --break-system-packages -r /opt/sahana/eden/optional_requirements.txt

# Update systemd service
sudo nano /etc/systemd/system/sahana-eden.service
# Change ExecStart to: /usr/bin/python3 ...
# Remove Environment line

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl start sahana-eden

# Optional: Remove virtual environment
rm -rf /opt/sahana/venv
```

---

## Verification

### Check Installation Method

```bash
# Run info script
/opt/sahana/eden_info.sh

# Or check manually
sudo systemctl cat sahana-eden.service | grep ExecStart
```

### Verify Packages

**System-wide:**
```bash
pip3 list | grep -E '(lxml|dateutil|requests|openpyxl)'
```

**Virtual environment:**
```bash
/opt/sahana/venv/bin/pip list
```

---

## Common Issues

### Issue 1: Service fails to start with virtual environment

**Symptom:**
```
sahana-eden.service: Failed with result 'exit-code'
```

**Solution:**
Check that the systemd service has correct paths:
```bash
sudo systemctl cat sahana-eden.service
sudo journalctl -u sahana-eden -n 50
```

### Issue 2: Module not found

**Symptom:**
```
ModuleNotFoundError: No module named 'lxml'
```

**Solution:**
Verify packages are installed in the correct environment:
```bash
# For system-wide
pip3 list | grep lxml

# For venv
/opt/sahana/venv/bin/pip list | grep lxml

# Reinstall if missing
source /opt/sahana/venv/bin/activate
pip install lxml
```

### Issue 3: Permission denied

**Symptom:**
```
PermissionError: [Errno 13] Permission denied
```

**Solution:**
```bash
sudo chown -R $USER:$USER /opt/sahana
# If using venv
sudo chown -R $USER:$USER /opt/sahana/venv
```

---

## References

- [PEP 668 - Marking Python base environments as "externally managed"](https://peps.python.org/pep-0668/)
- [Ubuntu 24.04 Python Changes](https://ubuntu.com/blog/ubuntu-24-04-lts-noble-numbat-released)
- [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html)

---

## Getting Updated Script

Download the latest version that handles this automatically:

```bash
curl -fsSL -o install_sahana.sh https://raw.githubusercontent.com/iwewe/sahana-eden/claude/ubuntu-install-script-01HYFeoM2PANKP5hESyCP9Gj/install_sahana_ubuntu24.sh
sudo bash install_sahana.sh
```

The updated script will prompt you to choose between system-wide or virtual environment installation.
