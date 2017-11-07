from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask import render_template, url_for, redirect, request, flash, abort, get_flashed_messages
from flask_security import Security, SQLAlchemyUserDatastore, UserMixin, RoleMixin, login_required
from flask_mail import Mail
from flask_security.forms import RegisterForm, StringField, Required
from flask_login import current_user, LoginManager
#import flask_whooshalchemy as wa

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
app.config['SECURITY_POST_LOGOUT_VIEW'] = 'index'
app.config['SECURITY_POST_REGISTER_VIEW'] = 'profile/<email>'
mail = Mail(app)

db = SQLAlchemy(app)
login_manager = LoginManager()

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
    is_admin = db.Column(db.Boolean(), default=False)
    active = db.Column(db.Boolean())
    confirmed_at = db.Column(db.DateTime())
    roles = db.relationship('Role', secondary=roles_users,backref=db.backref('users', lazy='dynamic'))





class MovieTV(db.Model):
    #__searchable__ = ['title', 'producer', 'description']

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), unique=True)
    releaseDate = db.Column(db.Integer)
    producer = db.Column(db.String(100))
    description = db.Column(db.String(300), unique=True)
    genre = db.Column(db.String(50))


#wa.whoosh_index(app, MovieTV)


class ExtendedRegisterForm(RegisterForm):
    first_name = StringField('First Name', [Required()])
    last_name = StringField('Last Name', [Required()])


# Setup Flask-Security
user_datastore = SQLAlchemyUserDatastore(db, User, Role)
security = Security(app, user_datastore, register_form=ExtendedRegisterForm)


@login_manager.user_loader
def load_user(id):
        return User.query.get(int(id))


def require_admin():
    if current_user.is_admin == False:
        abort(403)


@app.route('/', methods=['GET', 'POST'])
def index():
    error = None
    return render_template('index.html', error=error)


@app.route('/addMovie', methods=['GET', 'POST'])
@login_required
def addMovie():
    require_admin()
    error = None
    return render_template('addMovie.html', error=error)


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


@app.route('/post_movieTVShow', methods=['POST'])
def post_movieTVShow():
    newItem = MovieTV(request.form['title'], request.form['releaseDate'], request.form['producer'], request.form['description'], request.form['genre'])
    db.session.add(newItem)
    db.session.commit()
    return redirect(url_for('profile/<email>'))


if __name__ == '__main__':
    app.run()