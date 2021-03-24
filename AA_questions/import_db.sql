DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);


CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);



CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO 
    users (fname, lname)
VALUES
    ("Daniel", "Cho"),
    ("Jae", "Lim"),
    ("Ara", "Cho"),
    ("Darren", "Eid");

INSERT INTO 
    questions (title, body, author_id)
VALUES
    ("Help for Daniel", "I need help", (SELECT id FROM users WHERE fname = "Daniel" AND lname = "Cho")),
    ("Question from Jae" , "Jae has a question", 2),
    ("Darren's question", "He has none, this was a test", 4),
    ("Question from Ara", "Insert question here later", 3);

INSERT INTO 
    question_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE author_id = 1), (SELECT id FROM users WHERE id = 1)),
    (2, 2),
    (4, 3),
    (3, 4);

INSERT INTO 
    replies (question_id, user_id, parent_reply_id, body)
VALUES
    (1, 4, NULL, "Here to help"),
    (2, 3, NULL, "What's the question?"),
    (2, 2, 2, "My question is how do I install wsl?"),
    (2, 4, 3, "You shoulda asked last night");

INSERT INTO
    question_likes (question_id, user_id)
VALUES
    (1, 3),
    (2, 4);
    