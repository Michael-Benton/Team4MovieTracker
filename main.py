from flask import Flask
import pdb

app = Flask(__name__)


@app.route('/')
def index():
    #pdb.set_trace()
    return "hello"


if __name__ == '__main__':
    app.run()