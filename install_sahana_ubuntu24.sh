#!/bin/bash

################################################################################
# Sahana Eden Installation Script for Ubuntu 24.04 LTS
#
# This script installs Sahana Eden along with all its dependencies on a clean
# Ubuntu 24.04 server.
#
# Usage: sudo bash install_sahana_ubuntu24.sh
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script with sudo"
    exit 1
fi

# Check Ubuntu version
print_header "Checking System Requirements"
if ! grep -q "24.04" /etc/os-release; then
    print_warning "This script is designed for Ubuntu 24.04 LTS"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Get installation directory
print_header "Installation Configuration"
read -p "Enter installation directory [default: /opt/sahana]: " INSTALL_DIR
INSTALL_DIR=${INSTALL_DIR:-/opt/sahana}

# Get web2py admin password
while true; do
    read -sp "Enter password for web2py admin interface: " WEB2PY_PASSWORD
    echo
    read -sp "Confirm password: " WEB2PY_PASSWORD_CONFIRM
    echo
    if [ "$WEB2PY_PASSWORD" = "$WEB2PY_PASSWORD_CONFIRM" ]; then
        break
    else
        print_error "Passwords do not match. Please try again."
    fi
done

# Database selection
print_info "Select database type:"
echo "1) SQLite (default, recommended for development)"
echo "2) PostgreSQL (recommended for production)"
read -p "Enter choice [1-2, default: 1]: " DB_CHOICE
DB_CHOICE=${DB_CHOICE:-1}

DB_TYPE="sqlite"
if [ "$DB_CHOICE" = "2" ]; then
    DB_TYPE="postgres"
    read -p "Enter PostgreSQL database name [default: sahana]: " DB_NAME
    DB_NAME=${DB_NAME:-sahana}
    read -p "Enter PostgreSQL username [default: sahana]: " DB_USER
    DB_USER=${DB_USER:-sahana}
    while true; do
        read -sp "Enter PostgreSQL password: " DB_PASSWORD
        echo
        read -sp "Confirm password: " DB_PASSWORD_CONFIRM
        echo
        if [ "$DB_PASSWORD" = "$DB_PASSWORD_CONFIRM" ]; then
            break
        else
            print_error "Passwords do not match. Please try again."
        fi
    done
fi

# Python package installation method (Ubuntu 24.04 compatibility)
print_info "Select Python package installation method:"
echo "1) System-wide installation (use --break-system-packages)"
echo "   Recommended for: Dedicated server, production deployment"
echo "2) Virtual environment (isolated Python environment)"
echo "   Recommended for: Development, shared server"
read -p "Enter choice [1-2, default: 1]: " PIP_METHOD
PIP_METHOD=${PIP_METHOD:-1}

USE_VENV="no"
PIP_FLAGS=""
if [ "$PIP_METHOD" = "2" ]; then
    USE_VENV="yes"
    VENV_PATH="$INSTALL_DIR/venv"
else
    PIP_FLAGS="--break-system-packages"
fi

# Create installation directory
print_header "Creating Installation Directory"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
print_success "Installation directory created: $INSTALL_DIR"

# Update system
print_header "Updating System Packages"
apt-get update -qq
apt-get upgrade -y -qq
print_success "System packages updated"

# Install system dependencies
print_header "Installing System Dependencies"
print_info "Installing build tools, Python, Git, and other dependencies..."

apt-get install -y -qq \
    build-essential \
    git \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libgeos-dev \
    libproj-dev \
    gdal-bin \
    libgdal-dev \
    libspatialindex-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    wget \
    curl \
    unzip

if [ "$DB_TYPE" = "postgres" ]; then
    print_info "Installing PostgreSQL..."
    apt-get install -y -qq postgresql postgresql-contrib libpq-dev
fi

print_success "System dependencies installed"

# Install Python dependencies
print_header "Installing Python Dependencies"

# Setup virtual environment if selected
if [ "$USE_VENV" = "yes" ]; then
    print_info "Creating Python virtual environment..."
    python3 -m venv "$VENV_PATH"
    source "$VENV_PATH/bin/activate"
    PIP_CMD="$VENV_PATH/bin/pip"
    PYTHON_CMD="$VENV_PATH/bin/python3"
    print_success "Virtual environment created at $VENV_PATH"
else
    PIP_CMD="pip3"
    PYTHON_CMD="python3"
fi

print_info "Installing core Python packages..."

# Upgrade pip
$PIP_CMD install --upgrade pip $PIP_FLAGS

# Install core requirements
$PIP_CMD install $PIP_FLAGS python-dateutil>=2.7.3
$PIP_CMD install $PIP_FLAGS lxml>=4.4.2
$PIP_CMD install $PIP_FLAGS requests>=2.26.0

print_info "Installing optional Python packages (this may take a while)..."

# Install optional but recommended packages
$PIP_CMD install $PIP_FLAGS openpyxl>=3.0.9
$PIP_CMD install $PIP_FLAGS geopy>=2.0.0
$PIP_CMD install $PIP_FLAGS Shapely>=1.7.0
$PIP_CMD install $PIP_FLAGS Pillow>=8.4.0
$PIP_CMD install $PIP_FLAGS reportlab>=3.6.8
$PIP_CMD install $PIP_FLAGS xlwt>=1.3.0
$PIP_CMD install $PIP_FLAGS xlrd>=1.2.0
$PIP_CMD install $PIP_FLAGS pyserial>=2.6
$PIP_CMD install $PIP_FLAGS pyparsing>=2.2.0
$PIP_CMD install $PIP_FLAGS translate-toolkit>=1.0.1

# Try to install GDAL (may fail, not critical)
print_info "Attempting to install GDAL Python bindings..."
export GDAL_CONFIG=/usr/bin/gdal-config
$PIP_CMD install $PIP_FLAGS GDAL==$(gdal-config --version) || print_warning "GDAL Python bindings installation failed (non-critical)"

print_success "Python dependencies installed"

# Setup PostgreSQL if selected
if [ "$DB_TYPE" = "postgres" ]; then
    print_header "Configuring PostgreSQL"

    # Start PostgreSQL service
    systemctl start postgresql
    systemctl enable postgresql

    # Create database and user
    sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;" 2>/dev/null || print_warning "Database $DB_NAME already exists"
    sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || print_warning "User $DB_USER already exists"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
    sudo -u postgres psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"

    # Install PostGIS extension
    print_info "Installing PostGIS extension..."
    apt-get install -y -qq postgresql-postgis
    sudo -u postgres psql -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS postgis;"

    print_success "PostgreSQL configured"
fi

# Install web2py
print_header "Installing web2py Framework"
print_info "Cloning web2py from GitHub..."

cd "$INSTALL_DIR"
git clone --recursive https://github.com/web2py/web2py.git

cd web2py
print_info "Resetting to stable version 2.27.1 (commit 49bb23c4)..."
git reset --hard 49bb23c4
git submodule update --recursive

print_success "web2py installed"

# Clone Sahana Eden
print_header "Installing Sahana Eden"
print_info "Cloning Sahana Eden from GitHub..."

cd "$INSTALL_DIR"
git clone --recursive https://github.com/sahana/eden.git

print_info "Creating symbolic link to web2py applications..."
cd "$INSTALL_DIR/web2py/applications"
ln -sf "$INSTALL_DIR/eden" eden

print_success "Sahana Eden cloned"

# Configure Eden
print_header "Configuring Sahana Eden"

cd "$INSTALL_DIR/eden"
cp modules/templates/000_config.py models/000_config.py

print_info "Updating configuration file..."

# Enable configuration editing
sed -i 's|FINISHED_EDITING_CONFIG_FILE = False|FINISHED_EDITING_CONFIG_FILE = True|' models/000_config.py

# Enable debug mode for development
sed -i 's|#settings.base.debug = False|settings.base.debug = True|' models/000_config.py

# Configure database if PostgreSQL
if [ "$DB_TYPE" = "postgres" ]; then
    print_info "Configuring PostgreSQL database connection..."

    # Add database configuration
    cat >> models/000_config.py << EOF

# PostgreSQL Database Configuration
settings.database.db_type = "postgres"
settings.database.host = "localhost"
settings.database.port = 5432
settings.database.database = "$DB_NAME"
settings.database.username = "$DB_USER"
settings.database.password = "$DB_PASSWORD"
settings.database.pool_size = 30
EOF
fi

print_success "Sahana Eden configured"

# Setup web2py routes
print_header "Configuring web2py Routes"

cat > "$INSTALL_DIR/web2py/routes.py" << 'EOF'
#!/usr/bin/python
default_application = 'eden'
default_controller = 'default'
default_function = 'index'
routes_onerror = [
    ('eden/400', '!'),
    ('eden/401', '!'),
    ('eden/*', '/eden/errors/index'),
    ('*/*', '/eden/errors/index'),
]
EOF

print_success "web2py routes configured"

# Initialize database
print_header "Initializing Database"
print_info "This may take several minutes on first run..."

cd "$INSTALL_DIR/web2py"
$PYTHON_CMD web2py.py -S eden -M -R applications/eden/static/scripts/tools/noop.py

print_success "Database initialized"

# Set permissions
print_header "Setting Permissions"
if [ ! -z "$SUDO_USER" ]; then
    print_info "Setting ownership to $SUDO_USER..."
    chown -R $SUDO_USER:$SUDO_USER "$INSTALL_DIR"
fi

# Create systemd service file
print_header "Creating Systemd Service"

cat > /etc/systemd/system/sahana-eden.service << EOF
[Unit]
Description=Sahana Eden Web Application
After=network.target
$(if [ "$DB_TYPE" = "postgres" ]; then echo "After=postgresql.service"; fi)

[Service]
Type=simple
User=${SUDO_USER:-root}
WorkingDirectory=$INSTALL_DIR/web2py
$(if [ "$USE_VENV" = "yes" ]; then
    echo "ExecStart=$PYTHON_CMD $INSTALL_DIR/web2py/web2py.py --no_gui --password=$WEB2PY_PASSWORD --ip=0.0.0.0 --port=8000"
else
    echo "ExecStart=/usr/bin/python3 $INSTALL_DIR/web2py/web2py.py --no_gui --password=$WEB2PY_PASSWORD --ip=0.0.0.0 --port=8000"
fi)
Restart=on-failure
RestartSec=10
$(if [ "$USE_VENV" = "yes" ]; then echo "Environment=\"PATH=$VENV_PATH/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\""; fi)

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
print_success "Systemd service created"

# Create helper scripts
print_header "Creating Helper Scripts"

# Start script
cat > "$INSTALL_DIR/start_eden.sh" << EOF
#!/bin/bash
cd $INSTALL_DIR/web2py
$(if [ "$USE_VENV" = "yes" ]; then
    echo "source $VENV_PATH/bin/activate"
fi)
$PYTHON_CMD web2py.py --no_gui -a $WEB2PY_PASSWORD -i 0.0.0.0 -p 8000
EOF
chmod +x "$INSTALL_DIR/start_eden.sh"

# Status script
cat > "$INSTALL_DIR/eden_status.sh" << EOF
#!/bin/bash
systemctl status sahana-eden.service
EOF
chmod +x "$INSTALL_DIR/eden_status.sh"

# Environment info script
cat > "$INSTALL_DIR/eden_info.sh" << EOF
#!/bin/bash
echo "Sahana Eden Installation Information"
echo "====================================="
echo "Installation Directory: $INSTALL_DIR"
echo "Database Type: $DB_TYPE"
$(if [ "$DB_TYPE" = "postgres" ]; then
    echo "echo \"Database Name: $DB_NAME\""
    echo "echo \"Database User: $DB_USER\""
fi)
echo "Python Environment: $(if [ "$USE_VENV" = "yes" ]; then echo "Virtual Environment"; else echo "System-wide"; fi)"
$(if [ "$USE_VENV" = "yes" ]; then
    echo "echo \"Virtual Environment: $VENV_PATH\""
fi)
echo ""
echo "Python Version:"
$PYTHON_CMD --version
echo ""
echo "Installed Packages:"
$(if [ "$USE_VENV" = "yes" ]; then
    echo "$VENV_PATH/bin/pip list"
else
    echo "pip3 list | grep -E '(lxml|dateutil|requests|openpyxl|geopy|shapely|reportlab)'"
fi)
EOF
chmod +x "$INSTALL_DIR/eden_info.sh"

print_success "Helper scripts created"

# Installation complete
print_header "Installation Complete!"

echo ""
print_success "Sahana Eden has been successfully installed!"
echo ""
print_info "Installation Details:"
echo "  - Installation directory: $INSTALL_DIR"
echo "  - Database type: $DB_TYPE"
if [ "$DB_TYPE" = "postgres" ]; then
    echo "  - Database name: $DB_NAME"
    echo "  - Database user: $DB_USER"
fi
echo "  - Python environment: $(if [ "$USE_VENV" = "yes" ]; then echo "Virtual Environment ($VENV_PATH)"; else echo "System-wide"; fi)"
echo ""
print_info "To start Sahana Eden:"
echo ""
echo "  Option 1 - Using systemd service (recommended):"
echo "    sudo systemctl start sahana-eden"
echo "    sudo systemctl enable sahana-eden  # Start on boot"
echo ""
echo "  Option 2 - Manual start:"
echo "    cd $INSTALL_DIR"
echo "    sudo ./start_eden.sh"
echo ""
print_info "Access Sahana Eden:"
echo "  URL: http://localhost:8000/eden"
echo "  or http://YOUR_SERVER_IP:8000/eden"
echo ""
print_info "Default login credentials:"
echo "  Admin user: admin@example.com"
echo "  Password: testing"
echo ""
echo "  Normal user: normaluser@example.com"
echo "  Password: testing"
echo ""
print_warning "Important: Change these default passwords after first login!"
echo ""
print_info "Additional commands:"
echo "  - Check status: sudo systemctl status sahana-eden"
echo "  - Stop server: sudo systemctl stop sahana-eden"
echo "  - View logs: sudo journalctl -u sahana-eden -f"
echo "  - View installation info: $INSTALL_DIR/eden_info.sh"
echo ""
if [ "$USE_VENV" = "yes" ]; then
    echo ""
    print_info "Virtual Environment:"
    echo "  - Activate: source $VENV_PATH/bin/activate"
    echo "  - Deactivate: deactivate"
    echo "  - Python: $VENV_PATH/bin/python3"
    echo "  - Pip: $VENV_PATH/bin/pip"
    echo ""
fi
print_info "For more information, visit:"
echo "  - Documentation: https://eden-asp.readthedocs.io"
echo "  - Wiki: https://eden.sahanafoundation.org"
echo ""
print_success "Happy coding with Sahana Eden!"
echo ""
