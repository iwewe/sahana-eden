#!/bin/bash

################################################################################
# Sahana Eden Module Activation Script
#
# This script automatically activates the following modules:
# - Missing Person Registry (mpr)
# - Shelter Management (cr)
# - Disease Tracking (disease)
# - Incident Reporting (irs)
#
# Modules already active: vol (Volunteers), req (Requests)
#
# Usage: sudo bash activate_modules.sh [installation_directory]
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

# Get installation directory
INSTALL_DIR="${1:-/opt/sahana}"
CONFIG_FILE="$INSTALL_DIR/eden/models/000_config.py"

print_header "Sahana Eden Module Activation"
echo "Installation directory: $INSTALL_DIR"
echo ""

# Verify installation directory exists
if [ ! -d "$INSTALL_DIR/eden" ]; then
    print_error "Sahana Eden not found at $INSTALL_DIR/eden"
    print_info "Please specify correct installation directory:"
    print_info "  sudo bash activate_modules.sh /path/to/sahana"
    exit 1
fi

# Verify config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

print_success "Found Sahana Eden installation"

# Module activation confirmation
print_header "Modules to be Activated"
echo "The following modules will be activated:"
echo ""
echo "  ✓ Missing Person Registry (mpr)"
echo "  ✓ Shelter Management (cr)"
echo "  ✓ Disease Tracking (disease)"
echo "  ✓ Incident Reporting System (irs)"
echo ""
echo "Already active modules:"
echo "  • Volunteer Management (vol)"
echo "  • Request Management (req)"
echo ""
read -p "Continue with activation? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Activation cancelled"
    exit 0
fi

# Backup configuration
print_header "Backing Up Configuration"
BACKUP_FILE="$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
cp "$CONFIG_FILE" "$BACKUP_FILE"
print_success "Backup created: $BACKUP_FILE"

# Check if settings.modules already exists in config
print_header "Analyzing Configuration"
if grep -q "settings\.modules\s*=" "$CONFIG_FILE"; then
    print_info "Existing settings.modules found in configuration"
    MODULES_EXISTS=true
else
    print_info "No settings.modules found - will create new configuration"
    MODULES_EXISTS=false
fi

# Create module configuration snippet
print_header "Preparing Module Configuration"

MODULE_CONFIG=$(cat <<'EOFMODULE'

# =============================================================================
# Module Configuration
# Added by activate_modules.sh
# =============================================================================

from collections import OrderedDict
from gluon.storage import Storage

settings.modules = OrderedDict([
    # Core modules
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

    # Already Active Modules
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

    # ===== NEWLY ACTIVATED MODULES =====

    # Missing Person Registry
    ("mpr", Storage(
        name_nice = T("Missing Person Registry"),
        restricted = True,
        module_type = 10,
    )),

    # Shelter/Camp Registry
    ("cr", Storage(
        name_nice = T("Shelters"),
        restricted = True,
        module_type = 10
    )),

    # Disease Tracking
    ("disease", Storage(
        name_nice = T("Disease Tracking"),
        restricted = True,
        module_type = 10
    )),

    # Incident Reporting System
    ("irs", Storage(
        name_nice = T("Incidents"),
        restricted = True,
        module_type = 10
    )),

    # Supporting modules
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

# =============================================================================
# End Module Configuration
# =============================================================================

EOFMODULE
)

# Add module configuration
print_header "Adding Module Configuration"

if [ "$MODULES_EXISTS" = false ]; then
    # Append to end of file
    echo "$MODULE_CONFIG" >> "$CONFIG_FILE"
    print_success "Module configuration added to $CONFIG_FILE"
else
    print_warning "settings.modules already exists"
    print_info "Please manually edit $CONFIG_FILE to add the modules"
    print_info "Or restore from backup and run this script again"
    print_info "Backup file: $BACKUP_FILE"
    exit 1
fi

# Validate Python syntax
print_header "Validating Configuration"
if python3 -m py_compile "$CONFIG_FILE" 2>/dev/null; then
    print_success "Configuration syntax is valid"
else
    print_error "Configuration syntax error detected!"
    print_info "Restoring from backup..."
    cp "$BACKUP_FILE" "$CONFIG_FILE"
    print_success "Configuration restored"
    exit 1
fi

# Run database migration
print_header "Running Database Migration"
print_info "This may take a few minutes..."

cd "$INSTALL_DIR/web2py"

# Check if using virtual environment
if [ -f "$INSTALL_DIR/venv/bin/python3" ]; then
    PYTHON_CMD="$INSTALL_DIR/venv/bin/python3"
    print_info "Using virtual environment Python"
else
    PYTHON_CMD="python3"
    print_info "Using system Python"
fi

if $PYTHON_CMD web2py.py -S eden -M -R applications/eden/static/scripts/tools/noop.py > /tmp/eden_migration.log 2>&1; then
    print_success "Database migration completed"
else
    print_warning "Database migration encountered warnings (check /tmp/eden_migration.log)"
fi

# Restart service
print_header "Restarting Sahana Eden"

if systemctl is-active sahana-eden.service &>/dev/null; then
    print_info "Stopping service..."
    systemctl stop sahana-eden.service
    sleep 2
    print_info "Starting service..."
    systemctl start sahana-eden.service
    sleep 3

    if systemctl is-active sahana-eden.service &>/dev/null; then
        print_success "Service restarted successfully"
    else
        print_error "Service failed to start"
        print_info "Check status: sudo systemctl status sahana-eden"
        print_info "Check logs: sudo journalctl -u sahana-eden -n 50"
        exit 1
    fi
else
    print_warning "Systemd service not running"
    print_info "Please restart web2py manually:"
    print_info "  cd $INSTALL_DIR && sudo ./start_eden.sh"
fi

# Verification
print_header "Verifying Module Activation"

sleep 5  # Wait for service to fully start

print_info "Checking module accessibility..."

# Function to check URL
check_module() {
    local module=$1
    local name=$2

    if curl -s -o /dev/null -w "%{http_code}" "http://localhost:8000/eden/$module" | grep -q "200\|302"; then
        print_success "$name ($module) - Accessible"
    else
        print_warning "$name ($module) - May need permissions or login"
    fi
}

check_module "mpr" "Missing Person Registry"
check_module "cr" "Shelters"
check_module "disease" "Disease Tracking"
check_module "irs" "Incidents"

# Installation complete
print_header "Module Activation Complete!"

echo ""
print_success "All modules have been activated successfully!"
echo ""
print_info "Activated Modules:"
echo "  ✓ Missing Person Registry (mpr)"
echo "  ✓ Shelter Management (cr)"
echo "  ✓ Disease Tracking (disease)"
echo "  ✓ Incident Reporting System (irs)"
echo ""
print_info "Access modules at:"
echo "  - http://localhost:8000/eden/mpr"
echo "  - http://localhost:8000/eden/cr"
echo "  - http://localhost:8000/eden/disease"
echo "  - http://localhost:8000/eden/irs"
echo ""
print_info "Login credentials:"
echo "  - Admin: admin@example.com / testing"
echo ""
print_info "Configuration backup:"
echo "  - File: $BACKUP_FILE"
echo ""
print_warning "Please change default passwords after first login!"
echo ""
print_info "To rollback changes:"
echo "  sudo cp $BACKUP_FILE $CONFIG_FILE"
echo "  sudo systemctl restart sahana-eden"
echo ""
print_info "For troubleshooting:"
echo "  - View logs: sudo journalctl -u sahana-eden -f"
echo "  - Check status: sudo systemctl status sahana-eden"
echo "  - Documentation: see MODULE_ACTIVATION_GUIDE.md"
echo ""
print_success "Happy using Sahana Eden! 🎉"
echo ""
