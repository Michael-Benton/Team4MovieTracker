from flask import Flask, render_template, url_for, redirect, request, abort
from flask_sqlalchemy import SQLAlchemy
from flask_security import Security, SQLAlchemyUserDatastore, UserMixin, RoleMixin, login_required
from flask_mail import Mail
from flask_security.forms import RegisterForm, StringField, Required
from flask_login import current_user, LoginManager

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:Silvertigger97!@localhost:5432/flaskmovie'
app.config['SECRET_KEY'] = 'super-secret'
app.config['SECURITY_REGISTERABLE'] = True
app.config['SECURITY_PASSWORD_SALT'] = b"xxx"
app.config['SECURITY_PASSWORD_HASH'] = "sha512_crypt"
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_USERNAME'] = 'bill.haverty1234@gmail.com'
app.config['MAIL_PASSWORD'] = 'abcd1234!@'
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
    roles = db.relationship('Role', secondary=roles_users, backref=db.backref('users', lazy='dynamic'))


class Movie(db.Model):
    __tablename__ = 'Movie'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(200), unique=True)
    releaseDate = db.Column(db.Date)
    producer = db.Column(db.String(100))
    description = db.Column(db.String(300))
    genre = db.Column(db.String(50))
    image = db.Column(db.String(300))

class TV(db.Model):
    __tablename__ = 'TV'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(200), unique=True)
    releaseDateTime = db.Column(db.DateTime)
    producer = db.Column(db.String(100))
    description = db.Column(db.String(300))
    genre = db.Column(db.String(50))
    image = db.Column(db.String(300))


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
    if not current_user.is_admin:
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

@app.route('/addTV', methods=['GET', 'POST'])
@login_required
def addTV():
    require_admin()
    error = None
    return render_template('addTV.html', error=error)

@app.route('/search', methods=["GET"])
def search():
    user_input = request.args.get("query")
    search_results_movie = Movie.query.all()
    search_results_tv = TV.query.all()
    i = 0
    j = 0
    listOfResults = []
    while j < len(search_results_movie):
        if search_results_movie[i].title.lower() == user_input.lower() or \
           search_results_movie[i].producer.lower() == user_input.lower() or \
           search_results_movie[i].genre.lower() == user_input.lower():
            print(search_results_movie[i].title)
            listOfResults.append(search_results_movie[i])
        i += 1
        j += 1
    return render_template("index.html", movies=listOfMovies)	
	
@app.route('/getRecommendations', methods=["GET"])
def getRecommendations():
	user_watchList = getUserWatchList()
	last_entry = user_watchList[-1]
	last_entry_genre = last_entry.genre
	all_movies = MovieTV.query.all()
	recommendationList =[] 
	for movie in all_movies:
		if movie.genre == last_entry_genre:
			recommendationList.append(movie)
		if (len(recommendationList) == 5):
			break
	return rend_template("index.html", recommendations=recommendationList)
	
@app.route('/getUserWatchList', methods=["GET"])
def getUserWatchList():
	user_watchList = []
	
	return user_watchList
@app.route('/profile/<email>')
@login_required
def profile(email):
    user = User.query.filter_by(email=email).first()
    search_results_movies = Movie.query.all()   # This will be changed to accommodate the watchlist eventually, don't worry about it not displaying TV shows.
    return render_template('profile.html', user=user, movies=search_results_movies)


@app.route('/post_user', methods=['POST'])
def post_user():
    user = User(request.form['first_name'], request.form['last_name'], request.form['email'], request.form['password'])
    db.session.add(user)
    db.session.commit()
    return redirect(url_for('login'))


@app.route('/MovieTVShowDescription/<string:title>')
def MovieTVShowDescription(title):
    movieItems = Movie.query.all()
    tvItems = TV.query.all()
    i = 0
    j = 0

    while j < len(movieItems):
        if movieItems[i].title == title:
            print(movieItems[i].title)
            return render_template("MovieTVShowDescription.html", result=movieItems[i])
        i+= 1
        j+= 1

    i = 0
    j = 0

    while j < len(tvItems):
        if tvItems[i].title == title:
            return render_template("MovieTVShowDescription.html", result=tvItems[i])
        i += 1
        j += 1

    return redirect(url_for('index'))


@app.route('/post_Movie', methods=['POST'])
def post_Movie():
    newItem = Movie(title=request.form['title'], releaseDate=request.form['releaseDate'],
                      producer=request.form['producer'], description=request.form['description'],
                      genre=request.form['genre'], image=request.form['image'])
    db.session.add(newItem)
    db.session.commit()
    return redirect(url_for('index'))

@app.route('/post_TVShow', methods=['POST'])
def post_TVShow():
    newItem = TV(title=request.form['title'], releaseDateTime=request.form['releaseDateTime'],
                      producer=request.form['producer'], description=request.form['description'],
                      genre=request.form['genre'], image=request.form['image'])
    db.session.add(newItem)
    db.session.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run()
