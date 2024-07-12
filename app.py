from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

    def __repr__(self):
        return f'<User {self.name}>'

@app.route('/')
def index():
    return "Hello, World!"

@app.route('/users', methods=['POST'])
def add_user():
    name = request.json['name']
    email = request.json['email']
    new_user = User(name=name, email=email)
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User added successfully!"})

@app.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify([{"name": user.name, "email": user.email} for user in users])

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)
