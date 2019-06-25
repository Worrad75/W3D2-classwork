PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);


CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
  --author id is bth a local and foreign key. that key uis used to reference the users(id)
);


CREATE TABLE questions_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);


CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ("BRIAN", "Darrow"),
  ("arnold", "schwarch");

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('how much wood?', 'could a woodchuck chuck if a woodchuck could chuck wood?', 1),
  ('you lift bro?', 'nah you dont', 2);

INSERT INTO
  questions_follows(user_id, question_id)
VALUES
  (1, 1),
  (2, 2);

INSERT INTO
  replies(body, question_id, parent_reply_id, author_id)
VALUES
  ('a lot of wood!', 1, 1, 1),
  ('lmao', 2, 2, 2);
