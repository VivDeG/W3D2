DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users (id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions (id),
  FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  reply VARCHAR(255),
  FOREIGN KEY (question_id) REFERENCES questions (id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (reply_id) REFERENCES replies (id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (question_id) REFERENCES questions (id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Bob', 'Ross'),
  ('Cersei', 'Lannister'),
  ('Pope John', 'Paul IV'),
  ('Darth', 'Vader');

INSERT INTO 
  questions (title, body, author_id)
VALUES 
  ('How do paint?', 'Blue with some green.', 1),
  ('How do I get out of my trial?', 'Blow up the Sepulcher', 2),
  ('Why did the Sepulcher explode?', 'Back-Taxes', 4),
  ('Where do babies come from?', 'Bedroom explosions.', 4),
  ('Will the President go to prison?', 'More likely Russia', 2),
  ('How much wood could a woodchuck chuck...?', 'What a stupid question.', 1);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 4);

INSERT INTO
  replies (question_id, reply_id, user_id, reply )
VALUES
  (3, 3, 2, 'This answer has no basis in reality.'),
  (1, 1, 4, 'I do not know what I am talking about.'),
  (2, 1, 4, 'I think you should ask someone else.'),
  (4, 4, 3, 'Only through the dark side of the force.');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 3),
  (2, 1),
  (4, 2),
  (3, 2);