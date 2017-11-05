from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask import render_template, url_for, redirect, request
from flask_security import Security, SQLAlchemyUserDatastore, UserMixin, RoleMixin, login_required
from flask_mail import Mail
from flask_security.forms import RegisterForm, StringField, Required

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://michaelbenton@localhost/flaskmovie'
app.config['SECRET_KEY'] = 'super-secret'
app.config['SECURITY_REGISTERABLE'] = True
app.config['SECURITY_PASSWORD_SALT'] = b"xxx"
app.config['SECURITY_PASSWORD_HASH'] = "sha512_crypt"
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_USERNAME'] = 'bill.haverty1234@gmail.com'
app.config['MAIL_PASSWORD'] = 'golden10'
app.config['SECURITY_EMAIL_SENDER'] = 'no-reply@localhost'
app.config['SECURITY_POST_LOGIN_VIEW'] = 'profile/<email>'
app.config['SECURITY_POST_LOGOUT_VIEW'] = 'login'
app.config['SECURITY_POST_REGISTER_VIEW'] = 'profile/<email>'
mail = Mail(app)

db = SQLAlchemy(app)

roles_users = db.Table('roles_users',
        db.Column('user_id', db.Integer(), db.ForeignKey('user.id')),
        db.Column('role_id', db.Integer(), db.ForeignKey('role.id')))


class Role(db.Model, RoleMixin):
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(80), unique=True)
    description = db.Column(db.String(255))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(120))
    last_name = db.Column(db.String(120))
    email = db.Column(db.String(180), unique=True)
    password = db.Column(db.String(255))
    active = db.Column(db.Boolean())
    confirmed_at = db.Column(db.DateTime())
    roles = db.relationship('Role', secondary=roles_users,backref=db.backref('users', lazy='dynamic'))


class ExtendedRegisterForm(RegisterForm):
    first_name = StringField('First Name', [Required()])
    last_name = StringField('Last Name', [Required()])


# Setup Flask-Security
user_datastore = SQLAlchemyUserDatastore(db, User, Role)
security = Security(app, user_datastore, register_form=ExtendedRegisterForm)


@app.route('/', methods=['GET', 'POST'])
def index():
    error = None
    return render_template('index.html', error=error)


@app.route('/profile/<email>')
@login_required
def profile(email):
    user = User.query.filter_by(email=email).first()
    return render_template('profile.html', user=user)


@app.route('/post_user', methods=['POST'])
def post_user():
    user = User(request.form['first_name'], request.form['last_name'], request.form['email'], request.form['password'])
    db.session.add(user)
    db.session.commit()
    return redirect(url_for('login'))


if __name__ == '__main__':
    app.run()