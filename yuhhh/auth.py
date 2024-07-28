import re
import json
import os
from datetime import datetime

CREDENTIALS_FILE = "credentials.json"

def load_credentials():
    if not os.path.exists(CREDENTIALS_FILE):
        with open(CREDENTIALS_FILE, 'w') as file:
            json.dump({}, file)
    with open(CREDENTIALS_FILE, 'r') as file:
        return json.load(file)

def save_credentials(credentials):
    with open(CREDENTIALS_FILE, 'w') as file:
        json.dump(credentials, file)

def sign_up(username, email, password):
    if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
        return False, "Invalid email format."

    credentials = load_credentials()

    if username in credentials:
        return False, "Username already exists."

    if len(password) < 8:
        return False, "Password must be at least 8 characters long."
    if not re.search(r'[A-Z]', password):
        return False, "Password must contain at least one uppercase letter."
    if not re.search(r'[a-z]', password):
        return False, "Password must contain at least one lowercase letter."
    if not re.search(r'[0-9]', password):
        return False, "Password must contain at least one digit."
    if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
        return False, "Password must contain at least one special character."

    user_data = {
        "email": email,
        "password": password,
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    credentials[username] = user_data
    save_credentials(credentials)
    return True, "Account created successfully."

def login(username, password):
    credentials = load_credentials()

    if username not in credentials:
        return False, "Username not found."

    if credentials[username]["password"] != password:
        return False, "Incorrect password."

    return True, "Login successful."