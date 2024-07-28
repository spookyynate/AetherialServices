from flask import Flask, render_template, request, redirect, url_for, flash
from auth import sign_up, login

app = Flask(__name__)
app.secret_key = 'supersecretkey'

@app.route('/')
def home():
    return redirect(url_for('login_page'))

@app.route('/signup', methods=['GET', 'POST'])
def signup_page():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        success, message = sign_up(username, email, password)
        if success:
            flash(message, 'success')
            return redirect(url_for('login_page'))
        else:
            flash(message, 'error')
    return render_template('signup.html')

@app.route('/login', methods=['GET', 'POST'])
def login_page():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        success, message = login(username, password)
        if success:
            flash(message, 'success')
            return redirect(url_for('main_page'))
        else:
            flash(message, 'error')
    return render_template('login.html')

@app.route('/main')
def main_page():
    return render_template('main.html')

if __name__ == '__main__':
    app.run(debug=True)