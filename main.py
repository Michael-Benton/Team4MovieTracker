from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask import render_template, url_for, redirect, request


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://michaelbenton@localhost/flaskmovie'
db = SQLAlchemy(app)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(40), unique=False)
    last_name = db.Column(db.String(40), unique=False)
    username = db.Column(db.String(80), unique=True)
    password = db.Column(db.String(140), unique=True)

    def __init__(self, first_name, last_name, username, password):
        self.first_name = first_name
        self.last_name = last_name
        self.username = username
        self.password = password


@app.route('/login')
def index():
    return render_template('login.html')


@app.route('/create_account')
def create_account():
    return render_template('create_account.html')


@app.route('/post_user', methods=['POST'])
def post_user():
    user = User(request.form['first_name'], request.form['last_name'], request.form['username'], request.form['password'])
    db.session.add(user)
    db.session.commit()
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run()