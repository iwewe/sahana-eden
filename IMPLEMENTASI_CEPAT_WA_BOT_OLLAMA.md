# 🚨 IMPLEMENTASI CEPAT: WhatsApp Bot dengan Ollama untuk Sahana Eden
## Timeline: 2-3 Hari | Situasi Darurat

**Tanggal:** 7 Desember 2025
**Status:** EMERGENCY RAPID DEPLOYMENT PLAN
**Target:** WhatsApp Bot operational dalam 72 jam

---

## ✅ JAWABAN SINGKAT

### Apakah bisa 2-3 hari?
**YA! Sangat memungkinkan** dengan scope yang difokuskan dan menggunakan Ollama.

### Model Ollama yang cocok?
**Llama 3.1 8B** atau **Mistral 7B** (no training needed!)

### Perlu training?
**TIDAK!** Gunakan **prompt engineering** saja untuk rapid deployment.

---

## 📋 PRASYARAT (Persiapan 2-4 jam)

### A. Hardware Requirements

**Server untuk Ollama Bot:**
- **CPU:** 8+ cores (Intel/AMD)
- **RAM:** 16GB minimum (32GB recommended untuk 8B model)
- **Storage:** 50GB SSD free space
- **GPU:** OPSIONAL (NVIDIA dengan 8GB+ VRAM akan 10x lebih cepat, tapi tidak wajib)
- **Network:** Stable internet connection
- **OS:** Ubuntu 20.04/22.04 LTS atau Windows 10/11

**Note:** Bisa menggunakan 1 server untuk semua atau split:
- Server 1: Sahana Eden (existing)
- Server 2: Ollama + WhatsApp Bot

### B. Akun & Credentials

| Item | Purpose | Estimasi Setup Time |
|------|---------|---------------------|
| **WhatsApp Business Account** | Bot phone number | 1-2 jam |
| **Meta Developer Account** | WhatsApp API access | 30 menit |
| **Twilio Account (Alternative)** | Jika Meta Cloud API tidak available | 15 menit |
| **Phone number** | Dedicated untuk bot | - |
| **SSL Certificate** | HTTPS untuk webhook | 30 menit (Let's Encrypt gratis) |

### C. Software Prerequisites

```bash
# Ubuntu/Debian
- Python 3.10+
- pip
- git
- nginx (untuk reverse proxy)
- curl
```

### D. Access ke Sahana Eden

- [ ] SSH access ke server Sahana Eden
- [ ] Database credentials (PostgreSQL)
- [ ] Admin user credentials
- [ ] Understanding of which modules to expose (pr, cr, req, mpr)

---

## 🎯 SCOPE RAPID DEPLOYMENT (2-3 Hari)

### ✅ Yang AKAN Diimplementasikan

**Day 1:**
- ✅ Setup Ollama + Model
- ✅ Basic WhatsApp webhook
- ✅ Simple echo bot (test koneksi)

**Day 2:**
- ✅ AI conversation handling
- ✅ 2 core use cases:
  - Report missing person
  - Find shelter
- ✅ Integration dengan Sahana Eden API

**Day 3:**
- ✅ Testing & bug fixes
- ✅ Basic error handling
- ✅ Deployment & monitoring
- ✅ User documentation

### ❌ Yang TIDAK Diimplementasikan (untuk Phase 2)

- ❌ Image processing
- ❌ Advanced NLU training
- ❌ Multi-language (fokus Bahasa Indonesia dulu)
- ❌ Proactive notifications/broadcast
- ❌ Complex conversation flows
- ❌ Dashboard/analytics

---

## 🤖 OLLAMA: MODEL RECOMMENDATIONS

### Recommended Model: **Llama 3.1 8B Instruct**

**Mengapa Llama 3.1 8B?**
- ✅ Excellent instruction following
- ✅ Good Bahasa Indonesia support
- ✅ 8B parameters = balance antara speed & quality
- ✅ Runs on CPU (meski lebih lambat)
- ✅ Gratis & open source
- ✅ No API costs!

**Alternatives:**

| Model | Size | Pros | Cons | Use When |
|-------|------|------|------|----------|
| **Llama 3.1 8B** | 4.7GB | Best overall, good Indonesian | Butuh 16GB RAM | RECOMMENDED |
| **Mistral 7B** | 4.1GB | Faster, smaller | Indonesian support kurang | Jika RAM terbatas |
| **Phi-3 Mini** | 2.3GB | Very fast, smallest | Quality lower | Jika hardware sangat terbatas |
| **Llama 3.1 70B** | 40GB | Best quality | Butuh GPU + 64GB RAM | Jika punya high-end server |

### Performance Expectations

**Llama 3.1 8B:**
- **CPU only:** 3-8 detik per response
- **GPU (RTX 3060 12GB):** 0.5-2 detik per response
- **GPU (RTX 4090 24GB):** 0.3-1 detik per response

**Untuk emergency use:** 3-8 detik masih acceptable!

---

## 🚀 IMPLEMENTATION PLAN: 3 HARI

---

## 📅 DAY 1: Setup Infrastructure (8 jam)

### Hour 1-2: Setup Ollama

```bash
# 1. Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 2. Verify installation
ollama --version

# 3. Pull Llama 3.1 8B model (download ~4.7GB)
ollama pull llama3.1:8b-instruct-q4_K_M

# 4. Test model
ollama run llama3.1:8b-instruct-q4_K_M

# Test prompt:
# "Halo, bisakah kamu berbahasa Indonesia?"
# (Harus respond dengan lancar dalam Bahasa Indonesia)

# 5. Start Ollama server
ollama serve
# Server akan run di http://localhost:11434
```

**Verify Ollama working:**
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1:8b-instruct-q4_K_M",
  "prompt": "Jelaskan dalam 1 kalimat apa itu bencana alam"
}'
```

### Hour 3-4: Setup WhatsApp Business API

**Option 1: Meta Cloud API (Recommended untuk rapid deployment)**

1. Go to https://developers.facebook.com/
2. Create App → Business → WhatsApp
3. Add WhatsApp product
4. Get test phone number (immediate!)
5. Note down:
   - Phone Number ID
   - WhatsApp Business Account ID
   - Access Token
   - Webhook Verify Token (create a random string)

**Option 2: Twilio (Faster alternative)**

1. Go to https://www.twilio.com/whatsapp
2. Sign up & verify
3. Get WhatsApp Sandbox number (instant!)
4. Note credentials

### Hour 5-6: Create Bot Service

```bash
# Create project directory
mkdir -p /opt/sahana-whatsapp-bot
cd /opt/sahana-whatsapp-bot

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install flask requests python-dotenv ollama
```

**Create `.env` file:**
```bash
# WhatsApp Configuration
WHATSAPP_API_URL=https://graph.facebook.com/v18.0
WHATSAPP_PHONE_NUMBER_ID=your_phone_number_id
WHATSAPP_ACCESS_TOKEN=your_access_token
WEBHOOK_VERIFY_TOKEN=your_random_token

# Ollama Configuration
OLLAMA_API_URL=http://localhost:11434
OLLAMA_MODEL=llama3.1:8b-instruct-q4_K_M

# Sahana Eden Configuration
SAHANA_API_URL=http://your-sahana-instance.org/eden
SAHANA_API_KEY=your_api_key

# Bot Configuration
BOT_PORT=5000
```

**Create `bot.py` - Basic Echo Bot:**

```python
from flask import Flask, request, jsonify
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# Configuration
WHATSAPP_API_URL = os.getenv('WHATSAPP_API_URL')
PHONE_NUMBER_ID = os.getenv('WHATSAPP_PHONE_NUMBER_ID')
ACCESS_TOKEN = os.getenv('WHATSAPP_ACCESS_TOKEN')
VERIFY_TOKEN = os.getenv('WEBHOOK_VERIFY_TOKEN')

def send_whatsapp_message(to, message):
    """Send message via WhatsApp"""
    url = f"{WHATSAPP_API_URL}/{PHONE_NUMBER_ID}/messages"
    headers = {
        "Authorization": f"Bearer {ACCESS_TOKEN}",
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "to": to,
        "text": {"body": message}
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()

@app.route('/webhook', methods=['GET'])
def webhook_verify():
    """Verify webhook"""
    mode = request.args.get('hub.mode')
    token = request.args.get('hub.verify_token')
    challenge = request.args.get('hub.challenge')

    if mode == 'subscribe' and token == VERIFY_TOKEN:
        print("Webhook verified!")
        return challenge
    return 'Forbidden', 403

@app.route('/webhook', methods=['POST'])
def webhook_handler():
    """Handle incoming messages"""
    data = request.json

    try:
        # Extract message
        entry = data['entry'][0]
        changes = entry['changes'][0]
        value = changes['value']

        if 'messages' in value:
            message = value['messages'][0]
            from_number = message['from']
            message_text = message['text']['body']

            print(f"Received from {from_number}: {message_text}")

            # Simple echo response
            response_text = f"Echo: {message_text}"
            send_whatsapp_message(from_number, response_text)

    except Exception as e:
        print(f"Error: {e}")

    return jsonify({"status": "ok"})

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    port = int(os.getenv('BOT_PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
```

### Hour 7-8: Setup Webhook & Test

**1. Expose bot dengan ngrok (untuk testing):**
```bash
# Install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf ngrok-v3-stable-linux-amd64.tgz
./ngrok authtoken YOUR_NGROK_TOKEN  # Sign up di ngrok.com
./ngrok http 5000
```

**2. Start bot:**
```bash
python bot.py
```

**3. Configure webhook di Meta Developer Console:**
- Callback URL: `https://YOUR_NGROK_URL/webhook`
- Verify Token: (sama dengan di .env)
- Subscribe to: messages

**4. Test bot:**
- Send WhatsApp message ke bot number
- Should receive echo response!

**✅ Day 1 Complete:** Basic infrastructure working!

---

## 📅 DAY 2: AI Integration + Sahana API (10-12 jam)

### Hour 1-3: Integrate Ollama

**Create `ai_handler.py`:**

```python
import os
import json
import requests
from datetime import datetime

OLLAMA_API_URL = os.getenv('OLLAMA_API_URL', 'http://localhost:11434')
OLLAMA_MODEL = os.getenv('OLLAMA_MODEL', 'llama3.1:8b-instruct-q4_K_M')

# System prompt for the bot
SYSTEM_PROMPT = """Anda adalah asisten AI untuk Sahana Eden, sistem manajemen darurat dan bencana.

Tugas Anda:
1. Membantu korban bencana melaporkan orang hilang
2. Membantu mencari informasi shelter/pengungsian
3. Berbicara dengan empati, jelas, dan to-the-point
4. Mengumpulkan informasi dengan bertanya satu per satu

Format respons: Gunakan Bahasa Indonesia yang sopan dan empatik.

Anda dapat mengklasifikasikan permintaan user ke:
- report_missing_person: User ingin melaporkan orang hilang
- find_shelter: User mencari shelter/pengungsian
- request_info: User minta informasi umum
- other: Lainnya

PENTING: Selalu respond dalam Bahasa Indonesia."""

class ConversationManager:
    """Manage conversation state"""
    def __init__(self):
        self.conversations = {}

    def get_context(self, phone_number):
        """Get conversation context"""
        if phone_number not in self.conversations:
            self.conversations[phone_number] = {
                "messages": [],
                "intent": None,
                "data": {}
            }
        return self.conversations[phone_number]

    def add_message(self, phone_number, role, content):
        """Add message to conversation"""
        context = self.get_context(phone_number)
        context["messages"].append({
            "role": role,
            "content": content,
            "timestamp": datetime.now().isoformat()
        })

    def set_intent(self, phone_number, intent):
        """Set conversation intent"""
        context = self.get_context(phone_number)
        context["intent"] = intent

    def set_data(self, phone_number, key, value):
        """Store extracted data"""
        context = self.get_context(phone_number)
        context["data"][key] = value

    def clear(self, phone_number):
        """Clear conversation"""
        if phone_number in self.conversations:
            del self.conversations[phone_number]

# Global conversation manager
conversation_mgr = ConversationManager()

def call_ollama(prompt, context_messages=None):
    """Call Ollama API"""
    url = f"{OLLAMA_API_URL}/api/generate"

    # Build full prompt with context
    full_prompt = SYSTEM_PROMPT + "\n\n"

    if context_messages:
        for msg in context_messages[-5:]:  # Last 5 messages for context
            role = "User" if msg["role"] == "user" else "Assistant"
            full_prompt += f"{role}: {msg['content']}\n"

    full_prompt += f"User: {prompt}\nAssistant:"

    data = {
        "model": OLLAMA_MODEL,
        "prompt": full_prompt,
        "stream": False,
        "options": {
            "temperature": 0.7,
            "top_p": 0.9,
            "max_tokens": 300
        }
    }

    try:
        response = requests.post(url, json=data, timeout=30)
        response.raise_for_status()
        result = response.json()
        return result['response'].strip()
    except Exception as e:
        print(f"Ollama error: {e}")
        return "Maaf, saya sedang mengalami gangguan. Mohon coba lagi sebentar."

def extract_intent(user_message):
    """Extract user intent using Ollama"""
    prompt = f"""Klasifikasikan pesan berikut ke salah satu kategori:
- report_missing_person
- find_shelter
- request_info
- other

Pesan: "{user_message}"

Jawab HANYA dengan kategori (satu kata), tanpa penjelasan."""

    intent = call_ollama(prompt).strip().lower()

    # Validate intent
    valid_intents = ['report_missing_person', 'find_shelter', 'request_info', 'other']
    if intent not in valid_intents:
        intent = 'other'

    return intent

def handle_ai_message(phone_number, user_message):
    """Main AI message handler"""

    # Get conversation context
    context = conversation_mgr.get_context(phone_number)
    conversation_mgr.add_message(phone_number, "user", user_message)

    # If new conversation, detect intent
    if context["intent"] is None:
        intent = extract_intent(user_message)
        conversation_mgr.set_intent(phone_number, intent)
        print(f"Detected intent: {intent}")

    # Generate AI response
    response = call_ollama(user_message, context["messages"])
    conversation_mgr.add_message(phone_number, "assistant", response)

    return response, context["intent"]
```

**Update `bot.py` to use AI:**

```python
# Add at top
from ai_handler import handle_ai_message, conversation_mgr

# Replace webhook_handler POST method:
@app.route('/webhook', methods=['POST'])
def webhook_handler():
    """Handle incoming messages"""
    data = request.json

    try:
        entry = data['entry'][0]
        changes = entry['changes'][0]
        value = changes['value']

        if 'messages' in value:
            message = value['messages'][0]
            from_number = message['from']
            message_text = message['text']['body']

            print(f"Received from {from_number}: {message_text}")

            # AI processing
            response_text, intent = handle_ai_message(from_number, message_text)

            print(f"Intent: {intent}, Response: {response_text}")

            # Send AI response
            send_whatsapp_message(from_number, response_text)

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

    return jsonify({"status": "ok"})
```

**Test AI integration:**
```
User: "Halo"
Bot: "Halo! Saya asisten Sahana Eden. Bagaimana saya bisa membantu Anda?"

User: "Saya ingin melaporkan orang hilang"
Bot: "Baik, saya akan bantu. Siapa nama orang yang hilang?"
```

### Hour 4-6: Create Sahana API Client

**Create `sahana_client.py`:**

```python
import os
import requests
import json

SAHANA_API_URL = os.getenv('SAHANA_API_URL')
SAHANA_API_KEY = os.getenv('SAHANA_API_KEY')

class SahanaClient:
    """Client for Sahana Eden API"""

    def __init__(self):
        self.base_url = SAHANA_API_URL
        self.headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {SAHANA_API_KEY}"
        }

    def search_shelters(self, location=None, limit=5):
        """Search for shelters"""
        url = f"{self.base_url}/cr/shelter.json"
        params = {"limit": limit}

        if location:
            params["location__like"] = location

        try:
            response = requests.get(url, headers=self.headers, params=params, timeout=10)
            response.raise_for_status()
            data = response.json()
            return data
        except Exception as e:
            print(f"Sahana API error: {e}")
            return None

    def create_missing_person_report(self, person_data):
        """Create missing person report"""
        url = f"{self.base_url}/mpr/person.json"

        try:
            response = requests.post(url, headers=self.headers, json=person_data, timeout=10)
            response.raise_for_status()
            result = response.json()
            return result
        except Exception as e:
            print(f"Sahana API error: {e}")
            return None

    def create_person_contact(self, person_id, contact_method, value):
        """Add contact to person"""
        url = f"{self.base_url}/pr/contact.json"

        data = {
            "person_id": person_id,
            "contact_method": contact_method,
            "value": value
        }

        try:
            response = requests.post(url, headers=self.headers, json=data, timeout=10)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"Sahana API error: {e}")
            return None

# Global client instance
sahana = SahanaClient()
```

### Hour 7-10: Implement Use Cases

**Update `ai_handler.py` with structured flows:**

```python
from sahana_client import sahana

def handle_missing_person_flow(phone_number, user_message, context):
    """Handle missing person report flow"""
    data = context.get("data", {})

    # Progressive data collection
    if "first_name" not in data:
        # Ask for first name
        if is_name_provided(user_message):
            data["first_name"] = extract_name(user_message)
            conversation_mgr.set_data(phone_number, "first_name", data["first_name"])
            return "Terima kasih. Nama belakangnya apa?"
        else:
            return "Siapa nama depan orang yang hilang?"

    elif "last_name" not in data:
        if is_name_provided(user_message):
            data["last_name"] = extract_name(user_message)
            conversation_mgr.set_data(phone_number, "last_name", data["last_name"])
            return "Kapan terakhir kali Anda melihatnya? (contoh: kemarin sore, 2 hari lalu)"
        else:
            return "Mohon berikan nama belakang orang yang hilang."

    elif "last_seen" not in data:
        data["last_seen"] = user_message
        conversation_mgr.set_data(phone_number, "last_seen", data["last_seen"])
        return "Di mana lokasi terakhir Anda melihatnya?"

    elif "location" not in data:
        data["location"] = user_message
        conversation_mgr.set_data(phone_number, "location", data["location"])

        # All data collected - submit to Sahana
        person_data = {
            "first_name": data["first_name"],
            "last_name": data["last_name"],
            "last_seen_location": data["location"],
            "comments": f"Last seen: {data['last_seen']}. Reported via WhatsApp."
        }

        result = sahana.create_missing_person_report(person_data)

        if result:
            # Clear conversation
            conversation_mgr.clear(phone_number)

            record_id = result.get('id', 'N/A')
            return f"""✅ Laporan orang hilang telah dicatat.

Nama: {data['first_name']} {data['last_name']}
Lokasi terakhir: {data['location']}
ID Laporan: MPR-{record_id}

Tim kami akan segera menindaklanjuti. Terima kasih telah melaporkan."""
        else:
            return "Maaf, terjadi kesalahan saat menyimpan laporan. Mohon coba lagi."

def handle_shelter_search(phone_number, user_message, context):
    """Handle shelter search"""

    # Extract location from message
    location = extract_location(user_message)

    if not location:
        return "Di daerah mana Anda mencari shelter? (contoh: Jakarta Timur, Bandung, Surabaya)"

    # Search shelters
    shelters = sahana.search_shelters(location=location, limit=5)

    if not shelters or len(shelters) == 0:
        conversation_mgr.clear(phone_number)
        return f"Maaf, tidak ditemukan shelter di area {location}. Silakan coba lokasi yang berbeda atau hubungi hotline darurat."

    # Format response
    response = f"🏕️ Shelter di area {location}:\n\n"

    for i, shelter in enumerate(shelters[:5], 1):
        name = shelter.get('name', 'N/A')
        capacity = shelter.get('capacity_available', 'N/A')
        address = shelter.get('location', 'N/A')

        response += f"{i}. {name}\n"
        response += f"   Kapasitas tersisa: {capacity} orang\n"
        response += f"   Alamat: {address}\n\n"

    conversation_mgr.clear(phone_number)
    return response

# Helper functions
def is_name_provided(text):
    """Check if text contains a name"""
    return len(text.strip()) > 0 and not text.lower().startswith(('tidak', 'belum', 'ngga'))

def extract_name(text):
    """Extract name from text"""
    return text.strip()

def extract_location(text):
    """Extract location from text"""
    # Simple extraction - just return the text
    # For production, use NER or regex
    return text.strip()

# Update handle_ai_message function
def handle_ai_message(phone_number, user_message):
    """Main AI message handler"""

    context = conversation_mgr.get_context(phone_number)
    conversation_mgr.add_message(phone_number, "user", user_message)

    # Detect intent if new conversation
    if context["intent"] is None:
        intent = extract_intent(user_message)
        conversation_mgr.set_intent(phone_number, intent)
        print(f"Detected intent: {intent}")

    intent = context["intent"]

    # Route to appropriate handler
    if intent == "report_missing_person":
        response = handle_missing_person_flow(phone_number, user_message, context)
    elif intent == "find_shelter":
        response = handle_shelter_search(phone_number, user_message, context)
    else:
        # Generic AI response
        response = call_ollama(user_message, context["messages"])

    conversation_mgr.add_message(phone_number, "assistant", response)

    return response, intent
```

### Hour 11-12: Testing

**Test missing person flow:**
```
User: "Saya ingin melaporkan orang hilang"
Bot: "Siapa nama depan orang yang hilang?"
User: "Budi"
Bot: "Terima kasih. Nama belakangnya apa?"
User: "Santoso"
Bot: "Kapan terakhir kali Anda melihatnya?"
User: "Kemarin sore"
Bot: "Di mana lokasi terakhir Anda melihatnya?"
User: "Cilandak Jakarta Selatan"
Bot: "✅ Laporan orang hilang telah dicatat..."
```

**Test shelter search:**
```
User: "Cari shelter di Jakarta Timur"
Bot: "🏕️ Shelter di area Jakarta Timur:
     1. GOR Rawamangun
        Kapasitas tersisa: 50 orang
        ..."
```

**✅ Day 2 Complete:** Core functionality working!

---

## 📅 DAY 3: Hardening & Deployment (8-10 jam)

### Hour 1-2: Error Handling & Validation

**Add error handling to `bot.py`:**

```python
import logging
from logging.handlers import RotatingFileHandler

# Setup logging
if not os.path.exists('logs'):
    os.mkdir('logs')

file_handler = RotatingFileHandler('logs/bot.log', maxBytes=10240000, backupCount=10)
file_handler.setFormatter(logging.Formatter(
    '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
))
file_handler.setLevel(logging.INFO)

app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)
app.logger.info('WhatsApp Bot startup')

# Add try-catch in webhook handler
@app.route('/webhook', methods=['POST'])
def webhook_handler():
    """Handle incoming messages"""
    data = request.json
    app.logger.info(f"Received webhook: {json.dumps(data)}")

    try:
        entry = data.get('entry', [])
        if not entry:
            return jsonify({"status": "ok"})

        changes = entry[0].get('changes', [])
        if not changes:
            return jsonify({"status": "ok"})

        value = changes[0].get('value', {})

        if 'messages' in value:
            message = value['messages'][0]
            from_number = message['from']

            # Check message type
            if message.get('type') != 'text':
                send_whatsapp_message(from_number,
                    "Maaf, saat ini saya hanya bisa memproses pesan teks.")
                return jsonify({"status": "ok"})

            message_text = message['text']['body']

            app.logger.info(f"Processing message from {from_number}: {message_text}")

            # AI processing with timeout protection
            try:
                response_text, intent = handle_ai_message(from_number, message_text)
                send_whatsapp_message(from_number, response_text)
                app.logger.info(f"Sent response: {response_text[:100]}...")
            except Exception as ai_error:
                app.logger.error(f"AI processing error: {ai_error}")
                send_whatsapp_message(from_number,
                    "Maaf, terjadi kesalahan saat memproses pesan Anda. Mohon coba lagi.")

    except Exception as e:
        app.logger.error(f"Webhook handler error: {e}")
        import traceback
        traceback.print_exc()

    return jsonify({"status": "ok"})
```

### Hour 3-4: Sahana Eden API Configuration

**On Sahana Eden server, create API endpoint & authentication:**

```bash
# SSH to Sahana server
ssh user@sahana-server

# Edit models/00_settings.py or create new auth handler
# Add API key authentication
```

**Create `controllers/api.py` on Sahana (if not exists):**

```python
# controllers/api.py
def persons():
    """
    RESTful CRUD controller for persons - exposed via API
    """
    # Enable API access
    s3.prep = lambda r: r.representation in ("json", "xml")

    return crud_controller("pr", "person")

def shelters():
    """
    RESTful CRUD controller for shelters
    """
    s3.prep = lambda r: r.representation in ("json", "xml")

    return crud_controller("cr", "shelter")

def missing_persons():
    """
    RESTful CRUD controller for missing person reports
    """
    s3.prep = lambda r: r.representation in ("json", "xml")

    return crud_controller("mpr", "person")
```

**Test API endpoints:**

```bash
# Test from bot server
curl -X GET "http://your-sahana.org/eden/api/shelters.json" \
  -H "Authorization: Bearer YOUR_API_KEY"
```

### Hour 5-6: Production Deployment

**1. Create systemd service:**

```bash
sudo nano /etc/systemd/system/whatsapp-bot.service
```

```ini
[Unit]
Description=Sahana WhatsApp Bot
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/sahana-whatsapp-bot
Environment="PATH=/opt/sahana-whatsapp-bot/venv/bin"
ExecStart=/opt/sahana-whatsapp-bot/venv/bin/python bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**2. Setup nginx reverse proxy:**

```bash
sudo nano /etc/nginx/sites-available/whatsapp-bot
```

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

**3. Setup SSL with Let's Encrypt:**

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

**4. Start services:**

```bash
# Start Ollama
sudo systemctl start ollama
sudo systemctl enable ollama

# Start bot
sudo systemctl start whatsapp-bot
sudo systemctl enable whatsapp-bot

# Check status
sudo systemctl status whatsapp-bot
sudo journalctl -u whatsapp-bot -f
```

### Hour 7-8: Testing & Bug Fixes

**Create test script `test_bot.sh`:**

```bash
#!/bin/bash

echo "Testing health endpoint..."
curl http://localhost:5000/health

echo -e "\n\nTesting Ollama..."
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1:8b-instruct-q4_K_M",
  "prompt": "Test"
}'

echo -e "\n\nTesting Sahana API..."
curl http://your-sahana.org/eden/api/shelters.json
```

**End-to-end WhatsApp testing:**
- Test happy path (successful report)
- Test error cases (invalid input)
- Test conversation interruption (user changes topic mid-flow)
- Test concurrent users
- Load test (10-20 concurrent conversations)

### Hour 9-10: Documentation & Handover

**Create `README.md`:**

```markdown
# Sahana Eden WhatsApp Bot

## Cara Menggunakan

Kirim pesan WhatsApp ke: +62 XXX XXX XXXX

### Contoh:
- "Saya ingin melaporkan orang hilang"
- "Cari shelter di Jakarta"

## Monitoring

```bash
# Check bot status
sudo systemctl status whatsapp-bot

# View logs
sudo journalctl -u whatsapp-bot -f

# Check Ollama
curl http://localhost:11434/api/tags
```

## Troubleshooting

**Bot tidak merespon:**
1. Check service: `systemctl status whatsapp-bot`
2. Check logs: `journalctl -u whatsapp-bot -n 100`
3. Restart: `systemctl restart whatsapp-bot`

**Ollama slow:**
1. Check RAM: `free -h`
2. Check CPU: `top`
3. Consider GPU if available
```

**Create `OPERATOR_GUIDE.md`:**

```markdown
# Panduan Operator

## Memantau Bot

1. **Dashboard logs:**
   - Location: `/opt/sahana-whatsapp-bot/logs/bot.log`
   - View: `tail -f /opt/sahana-whatsapp-bot/logs/bot.log`

2. **Metrics to watch:**
   - Response time (should be < 10 seconds)
   - Error rate (should be < 5%)
   - User satisfaction

## Frequently Asked Questions

**Q: Bot respond lambat**
A: Normal untuk Ollama di CPU. Jika > 30 detik, restart service.

**Q: Bot salah paham user**
A: Catat contoh conversation, nanti bisa improve prompt.

**Q: Data tidak masuk ke Sahana**
A: Check Sahana API logs dan koneksi network.
```

**✅ Day 3 Complete:** Production ready!

---

## 🎯 POST-DEPLOYMENT CHECKLIST

### Day 3 Evening: Launch!

- [ ] All services running
- [ ] Webhook verified
- [ ] SSL certificate active
- [ ] Test dengan 3-5 real users
- [ ] Monitor logs for 2 hours
- [ ] Document any issues
- [ ] Prepare escalation contact list

### Week 1 Improvements (Phase 2)

- [ ] Collect user feedback
- [ ] Tune AI prompts based on actual conversations
- [ ] Add more use cases (aid request, volunteer registration)
- [ ] Improve error messages
- [ ] Add conversation timeout (auto-clear after 30 mins)
- [ ] Add admin dashboard

---

## 💰 TOTAL COST: ALMOST ZERO!

| Item | Cost | Note |
|------|------|------|
| **Ollama** | FREE | Open source |
| **Llama 3.1 Model** | FREE | Open source |
| **WhatsApp Cloud API** | $0 | 1,000 free messages/month |
| **Server** | $0 | Use existing or $20/month VPS |
| **Domain + SSL** | $0 | Let's Encrypt free |
| **Development** | $0 | DIY |
| **Total** | **~$0-20/month** | 🎉 |

**Bandingkan dengan OpenAI:** $150-300/month untuk 10K conversations!

---

## ⚡ PERFORMANCE EXPECTATIONS

### With Llama 3.1 8B on CPU:

**Hardware:** 8-core CPU, 16GB RAM, No GPU

| Metric | Expected Value |
|--------|----------------|
| Response time | 3-8 seconds |
| Concurrent users | 5-10 (acceptable) |
| Accuracy (intent) | 75-85% |
| Indonesian quality | Good |
| Uptime | 99%+ |

### With GPU (e.g., RTX 3060):

| Metric | Expected Value |
|--------|----------------|
| Response time | 0.5-2 seconds |
| Concurrent users | 20-50 |
| Accuracy | 80-90% |
| Uptime | 99%+ |

---

## 🚨 EMERGENCY FALLBACKS

### If Ollama Fails:

**Fallback 1: Rule-based bot**
```python
# Simple keyword matching
if "orang hilang" in message.lower():
    return "Silakan sebutkan nama orang yang hilang"
elif "shelter" in message.lower():
    return "Di daerah mana Anda mencari shelter?"
```

**Fallback 2: Human handoff**
```python
# Auto-escalate to human operator
send_whatsapp_message(OPERATOR_NUMBER,
    f"Need help with user {from_number}: {message_text}")
return "Anda akan dihubungi operator kami segera."
```

### If WhatsApp API Down:

**SMS Fallback:**
- Use Twilio SMS
- Same bot logic, different transport

---

## 📊 MONITORING & METRICS

**Key Metrics to Track:**

```python
# Add to bot.py
metrics = {
    "total_messages": 0,
    "successful_reports": 0,
    "errors": 0,
    "average_response_time": 0
}

# Log every interaction
app.logger.info(f"METRICS: {json.dumps(metrics)}")
```

**Simple dashboard:**
```bash
# Count today's messages
grep "Received from" logs/bot.log | grep "$(date +%Y-%m-%d)" | wc -l

# Count errors
grep "ERROR" logs/bot.log | grep "$(date +%Y-%m-%d)" | wc -l
```

---

## 🎓 TRAINING OLLAMA (Optional - Week 2+)

**No training needed untuk rapid deployment**, tapi untuk improve:

### Option 1: Prompt Engineering (Recommended)

**Iteratively improve system prompt based on real conversations:**

```python
SYSTEM_PROMPT = """Anda adalah asisten AI untuk Sahana Eden.

[Tambahkan contoh conversations yang sukses]

Contoh 1:
User: "ada orang hilang"
Assistant: "Saya akan bantu. Siapa nama lengkap orang yang hilang?"

Contoh 2:
User: "shelter dimana"
Assistant: "Di daerah mana Anda mencari shelter?"

[Tambahkan edge cases]

Jika user tidak jelas: Minta clarification dengan sopan.
Jika di luar scope: "Maaf, saya hanya dapat membantu dengan [list topics]"
"""
```

### Option 2: Fine-tuning (Advanced - Week 2+)

**Only if you have:**
- 100+ real conversation examples
- GPU server
- Time for training (2-3 days)

**Process:**
1. Collect conversation logs
2. Format as training data
3. Use `ollama create` with Modelfile
4. Test fine-tuned model

**Not recommended for rapid deployment!**

---

## ✅ SUCCESS CRITERIA

**After 3 days, you should have:**

✅ Working WhatsApp bot responding to users
✅ 2 core use cases operational (missing person + shelter search)
✅ Integration with Sahana Eden database
✅ Basic error handling
✅ Logs & monitoring
✅ Documentation for operators
✅ 24/7 availability
✅ Zero API costs (using Ollama)

---

## 🆘 SUPPORT & TROUBLESHOOTING

### Common Issues:

**1. Ollama tidak start:**
```bash
# Check if already running
ps aux | grep ollama

# Kill and restart
pkill ollama
ollama serve
```

**2. Model download gagal:**
```bash
# Manual download
wget https://ollama.ai/models/llama3.1:8b-instruct-q4_K_M
ollama create llama3.1:8b-instruct-q4_K_M -f ./model
```

**3. WhatsApp webhook verification failed:**
- Check HTTPS (must be HTTPS, not HTTP)
- Check verify token match
- Check firewall allowing port 443

**4. Bot tidak respond:**
```bash
# Check all services
systemctl status ollama
systemctl status whatsapp-bot
systemctl status nginx

# Check logs
journalctl -u whatsapp-bot -f
tail -f /var/log/nginx/error.log
```

**5. Sahana API error:**
```bash
# Test direct API call
curl -v http://your-sahana.org/eden/api/shelters.json

# Check Sahana logs
tail -f /path/to/sahana/logs/web2py.log
```

---

## 📞 EMERGENCY CONTACTS

**If you get stuck, contact:**

1. **Ollama Community:** https://github.com/ollama/ollama/discussions
2. **WhatsApp API Support:** Meta Developer Support
3. **Sahana Community:** https://groups.google.com/g/eden-asp
4. **Me (Claude):** Ask follow-up questions!

---

## 🎯 NEXT STEPS AFTER RAPID DEPLOYMENT

### Week 2-4 Enhancements:

1. **Add more use cases:**
   - Aid request
   - Volunteer registration
   - Incident reporting

2. **Improve AI:**
   - Fine-tune prompts with real conversations
   - Add Indonesian-specific training data
   - Consider fine-tuning model

3. **Better UX:**
   - Add quick reply buttons
   - Image support for missing person photos
   - Location sharing integration

4. **Operations:**
   - Admin dashboard
   - Analytics & reporting
   - A/B testing different prompts

5. **Scale:**
   - Add GPU for faster response
   - Load balancer for multiple instances
   - Redis for distributed session storage

---

**GOOD LUCK! 🚀**

**You've got this! Dalam 72 jam, WhatsApp bot Anda akan operational dan membantu korban bencana! 💪**

---

**Document Version:** 1.0
**Created:** 2025-12-07
**Status:** READY TO IMPLEMENT ✅
**Estimated Total Time:** 26-30 hours over 3 days
