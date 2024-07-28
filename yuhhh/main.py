import tkinter as tk
from tkinter import messagebox
from tkinter import PhotoImage
import re
import random
import string
import requests
import json

class AetherialSoftwareHubApp:
    def __init__(self, root):
        self.root = root
        self.root.geometry("800x600")
        self.root.overrideredirect(True)  # Remove the default window decorations
        self.root.configure(bg="black")

        self.create_custom_title_bar()
        self.center_window()
        self.make_window_draggable()

        self.user_data = {}
        self.load_user_data()

        self.show_login_page()

    def load_user_data(self):
        try:
            with open('user_data.json', 'r') as file:
                self.user_data = json.load(file)
        except FileNotFoundError:
            self.user_data = {}

    def save_user_data(self):
        with open('user_data.json', 'w') as file:
            json.dump(self.user_data, file)

    def create_custom_title_bar(self):
        self.title_bar = tk.Frame(self.root, bg="darkviolet", relief='raised', bd=2)
        self.title_bar.pack(fill=tk.X)

        self.title_label = tk.Label(self.title_bar, text="Aetherial Software Hub", bg="darkviolet", fg="white", font=("Helvetica", 12, "bold"))
        self.title_label.pack(side=tk.LEFT, padx=10)

        self.close_button = tk.Button(self.title_bar, text="X", command=self.root.quit, bg="darkviolet", fg="white", bd=0, font=("Helvetica", 12, "bold"))
        self.close_button.pack(side=tk.RIGHT, padx=5, pady=2)

    def center_window(self):
        self.root.update_idletasks()
        width = self.root.winfo_width()
        height = self.root.winfo_height()
        x = (self.root.winfo_screenwidth() // 2) - (width // 2)
        y = (self.root.winfo_screenheight() // 2) - (height // 2)
        self.root.geometry(f"{width}x{height}+{x}+{y}")

    def make_window_draggable(self):
        self.title_bar.bind("<ButtonPress-1>", self.start_move)
        self.title_bar.bind("<B1-Motion>", self.do_move)

    def start_move(self, event):
        self.x = event.x
        self.y = event.y

    def do_move(self, event):
        x = (event.x_root - self.x)
        y = (event.y_root - self.y)
        self.root.geometry(f"+{x}+{y}")

    def show_login_page(self):
        for widget in self.root.winfo_children():
            if widget != self.title_bar:
                widget.destroy()

        self.login_canvas = tk.Canvas(self.root, width=800, height=600)
        self.login_canvas.pack(fill="both", expand=True)

        self.login_bg_image = PhotoImage(file="images/A_T1.png")
        self.login_canvas.create_image(0, 0, image=self.login_bg_image, anchor="nw")

        self.login_frame = tk.Frame(self.login_canvas, bg="black", highlightbackground="darkviolet", highlightthickness=2)
        self.login_canvas.create_window(400, 300, window=self.login_frame)

        self.username_label = tk.Label(self.login_frame, text="Username:", font=("Helvetica", 14, "bold"), bg="black", fg="darkviolet")
        self.username_label.pack(pady=10)
        self.username_entry = tk.Entry(self.login_frame, font=("Helvetica", 14), highlightbackground="darkviolet", highlightcolor="darkviolet", highlightthickness=1)
        self.username_entry.pack(pady=10)

        self.password_label = tk.Label(self.login_frame, text="Password:", font=("Helvetica", 14, "bold"), bg="black", fg="darkviolet")
        self.password_label.pack(pady=10)
        self.password_entry = tk.Entry(self.login_frame, font=("Helvetica", 14), show='*', highlightbackground="darkviolet", highlightcolor="darkviolet", highlightthickness=1)
        self.password_entry.pack(pady=10)

        self.login_button = self.create_animated_button(self.login_frame, "Login", self.login)
        self.login_button.pack(pady=10)

        self.signup_button = self.create_animated_button(self.login_frame, "Sign Up", self.show_signup_page)
        self.signup_button.pack(pady=10)

    def show_signup_page(self):
        for widget in self.root.winfo_children():
            if widget != self.title_bar:
                widget.destroy()

        self.signup_canvas = tk.Canvas(self.root, width=800, height=600)
        self.signup_canvas.pack(fill="both", expand=True)

        self.signup_bg_image = PhotoImage(file="images/AT_3.png")
        self.signup_canvas.create_image(0, 0, image=self.signup_bg_image, anchor="nw")

        self.signup_frame = tk.Frame(self.signup_canvas, bg="black", highlightbackground="darkviolet", highlightthickness=2)
        self.signup_canvas.create_window(400, 300, window=self.signup_frame)

        self.username_label = tk.Label(self.signup_frame, text="Username:", font=("Helvetica", 14, "bold"), bg="black", fg="darkviolet")
        self.username_label.pack(pady=10)
        self.username_entry = tk.Entry(self.signup_frame, font=("Helvetica", 14), highlightbackground="darkviolet", highlightcolor="darkviolet", highlightthickness=1)
        self.username_entry.pack(pady=10)

        self.email_label = tk.Label(self.signup_frame, text="Email:", font=("Helvetica", 14, "bold"), bg="black", fg="darkviolet")
        self.email_label.pack(pady=10)
        self.email_entry = tk.Entry(self.signup_frame, font=("Helvetica", 14), highlightbackground="darkviolet", highlightcolor="darkviolet", highlightthickness=1)
        self.email_entry.pack(pady=10)

        self.password_label = tk.Label(self.signup_frame, text="Password:", font=("Helvetica", 14, "bold"), bg="black", fg="darkviolet")
        self.password_label.pack(pady=10)
        self.password_entry = tk.Entry(self.signup_frame, font=("Helvetica", 14), show='*', highlightbackground="darkviolet", highlightcolor="darkviolet", highlightthickness=1)
        self.password_entry.pack(pady=10)

        self.password_strength_label = tk.Label(self.signup_frame, text="", font=("Helvetica", 12), bg="black", fg="darkviolet")
        self.password_strength_label.pack(pady=10)

        self.password_strength_bar = tk.Frame(self.signup_frame, bg="red", height=10, width=200)
        self.password_strength_bar.pack(pady=10)

        self.signup_button = self.create_animated_button(self.signup_frame, "Sign Up", self.sign_up)
        self.signup_button.pack(pady=10)

        self.login_button = self.create_animated_button(self.signup_frame, "Back to Login", self.show_login_page)
        self.login_button.pack(pady=10)

        self.password_entry.bind('<KeyRelease>', self.check_password_strength)

    def check_password_strength(self, event=None):
        password = self.password_entry.get()
        strength, strength_message, color = self.get_password_strength_message(password)
        self.password_strength_label.config(text=strength_message)
        self.password_strength_bar.config(bg=color)

    def get_password_strength_message(self, password):
        if len(password) < 8:
            return 0, "Password must be at least 8 characters long.", "red"
        if not re.search(r'[A-Z]', password):
            return 1, "Password must contain at least one uppercase letter.", "red"
        if not re.search(r'[a-z]', password):
            return 2, "Password must contain at least one lowercase letter.", "red"
        if not re.search(r'[0-9]', password):
            return 3, "Password must contain at least one digit.", "yellow"
        if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
            return 4, "Password must contain at least one special character.", "yellow"
        return 5, "Password is strong.", "green"

    def login(self):
        username = self.username_entry.get()
        password = self.password_entry.get()
        success, message = self.perform_login(username, password)
        if success:
            messagebox.showinfo("Success", message)
            self.show_main_page()
        else:
            messagebox.showerror("Error", message)

    def perform_login(self, username, password):
        if username in self.user_data and self.user_data[username]['password'] == password:
            return True, "Login successful!"
        return False, "Incorrect username or password."

    def sign_up(self):
        username = self.username_entry.get()
        email = self.email_entry.get()
        password = self.password_entry.get()

        if username in self.user_data:
            messagebox.showerror("Error", "Username already exists.")
            return

        if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
            messagebox.showerror("Error", "Invalid email address.")
            return

        self.verification_code = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
        self.username = username
        self.email = email
        self.password = password
        self.send_verification_email(email, self.verification_code)
        self.show_verification_page()

    def show_verification_page(self):
        for widget in self.root.winfo_children():
            if widget != self.title_bar:
                widget.destroy()

        self.verification_frame = tk.Frame(self.root, bg="black", highlightbackground="darkviolet", highlightthickness=2)
        self.verification_frame.pack(expand=True)

        self.verification_label = tk.Label(self.verification_frame, text="Verification Code:", font=("Helvetica", 14, "bold"), bg="black", fg="darkviolet")
        self.verification_label.pack(pady=10)

        self.verification_entry = tk.Entry(self.verification_frame, font=("Helvetica", 14), highlightbackground="darkviolet", highlightcolor="darkviolet", highlightthickness=1)
        self.verification_entry.pack(pady=10)

        self.verify_button = self.create_animated_button(self.verification_frame, "Verify", self.verify_code)
        self.verify_button.pack(pady=10)

    def verify_code(self):
        entered_code = self.verification_entry.get()
        if entered_code == self.verification_code:
            self.user_data[self.username] = {
                "email": self.email,
                "password": self.password
            }
            self.save_user_data()
            messagebox.showinfo("Success", "Sign up successful!")
            self.show_login_page()
        else:
            messagebox.showerror("Error", "Invalid verification code.")

    def send_verification_email(self, email, code):
        url = "https://api.emailapi.net/v3/send"
        payload = json.dumps({
            "from": "youremail@example.com",
            "to": [email],
            "subject": "Verification Code",
            "text": f"Your verification code is {code}"
        })
        headers = {
            'Authorization': 'Bearer YOUR_API_KEY',
            'Content-Type': 'application/json'
        }
        response = requests.request("POST", url, headers=headers, data=payload)
        if response.status_code == 200:
            print("Verification email sent successfully!")
        else:
            print("Failed to send verification email.")

    def show_main_page(self):
        for widget in self.root.winfo_children():
            if widget != self.title_bar:
                widget.destroy()

        self.main_canvas = tk.Canvas(self.root, width=800, height=600)
        self.main_canvas.pack(fill="both", expand=True)

        self.main_bg_image = PhotoImage(file="images/main_bg.png")
        self.main_canvas.create_image(0, 0, image=self.main_bg_image, anchor="nw")

        self.main_frame = tk.Frame(self.main_canvas, bg="black", highlightbackground="darkviolet", highlightthickness=2)
        self.main_canvas.create_window(400, 300, window=self.main_frame)

        self.main_label = tk.Label(self.main_frame, text="Welcome to Aetherial Software Hub", font=("Helvetica", 18, "bold"), bg="black", fg="darkviolet")
        self.main_label.pack(pady=10)

        self.logout_button = self.create_animated_button(self.main_frame, "Logout", self.show_login_page)
        self.logout_button.pack(pady=10)

    def create_animated_button(self, parent, text, command):
        button = tk.Button(parent, text=text, font=("Helvetica", 14, "bold"), bg="darkviolet", fg="white", command=command, relief="raised")
        button.bind("<Enter>", lambda e: button.config(bg="darkmagenta"))
        button.bind("<Leave>", lambda e: button.config(bg="darkviolet"))
        return button

if __name__ == "__main__":
    root = tk.Tk()
    app = AetherialSoftwareHubApp(root)
    root.mainloop()