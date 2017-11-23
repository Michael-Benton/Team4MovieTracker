# Team4MovieTracker

Create an admin user:
  - Make sure you created a new user table before following along since I changed the column names
  - register a new user like normal
  - try to access this page /addMovie
  - you should get a 403 page saying you don't have permission
  - pull up command line/terminal and head over to the directory where main.py is
  - Follow terminal/command line commands below:
    - python3
    - from main import db
    - from main import User
    - user = User.query.get(1)
    - user.is_admin = True
    - db.session.commit()
    
  - Now try and access the /addMovie page again and you should be able to add a movie/TV show now

  Feature List:
  Search
  Add Movie
  Add TV Show
  Login
  Register
  Forget Password Email Sent
  Add Movie/TV Show to watchlist
  Delete Movie/TV show from watchlist
  Logout
  Click on movie/tv show after searching to visit profile page of said movie/tv show
