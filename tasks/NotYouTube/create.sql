DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS products_to_orders CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
--
--
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS videos CASCADE;
DROP TABLE IF EXISTS playlists CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
--
DROP TABLE IF EXISTS reactions CASCADE;
DROP TABLE IF EXISTS playlists_to_videos;
DROP TABLE IF EXISTS video_reaction_list CASCADE;
DROP TABLE IF EXISTS comment_reaction_list CASCADE;

--CREATE
CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(160) NOT NULL CHECK(full_name != ''),
  nickname VARCHAR(80) NOT NULL UNIQUE CHECK(nickname != ''),
  email VARCHAR(200) NOT NULL UNIQUE CHECK(email != ''),
  passcode VARCHAR(16) NOT NULL CHECK(length(passcode) >= 8),
  birthday TIMESTAMP NOT NULL CHECK (birthday BETWEEN '1900-01-01' AND current_date)
);
--
CREATE TABLE videos(
  id SERIAL PRIMARY KEY,
  author_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
  title VARCHAR(300) NOT NULL CHECK(title != ''),
  "description" VARCHAR(1000) NOT NULL DEFAULT 'No description',
  upload_at TIMESTAMP NOT NULL DEFAULT current_timestamp
  --likes NUMERIC(10) NOT NULL DEFAULT 0 CHECK (likes >= 0),
  --dislikes NUMERIC(10) NOT NULL DEFAULT 0 CHECK (dislikes >= 0)
);
--
CREATE TABLE playlists(
  id SERIAL PRIMARY KEY,
  -- video_id INT NOT NULL REFERENCES videos,
  author_id INT NOT NULL REFERENCES users,
  acces_type_id INT NOT NULL REFERENCES acces_types,
  -- shared_users_id INT DEFAULT NULL REFERENCES users,
  "description" VARCHAR(1000)
);
--
CREATE TABLE playlists_to_videos(
  playlist_id INT NOT NULL REFERENCES playlists ON DELETE CASCADE,
  video_id INT NOT NULL REFERENCES videos,
  PRIMARY KEY(playlist_id, video_id)
);

--
CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  video_id INT NOT NULL REFERENCES videos,
  author_id INT NOT NULL REFERENCES users,
  "text" VARCHAR(500) NOT NULL CHECK("text" != '')
  --reaction_type INT NOT NULL CHECK(reaction_type)
  -- likes NUMERIC(10) NOT NULL DEFAULT 0 CHECK (likes >= 0),
  -- dislikes NUMERIC(10) NOT NULL DEFAULT 0 CHECK (dislikes >= 0)
);
--NOT SAYED DIRECTLY:


CREATE TABLE acces_types(
  id SERIAL PRIMARY KEY,
  acces_type VARCHAR(80) NOT NULL CHECK(acces_type != '')
);

--1,2
CREATE TABLE reactions(
  id SERIAL PRIMARY KEY,
  reaction_type VARCHAR(80) NOT NULL CHECK(reaction_type != '')
);

CREATE TABLE video_reaction_list(
  video_id INT NOT NULL REFERENCES videos ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
  reaction_id INT NOT NULL REFERENCES reactions ON DELETE CASCADE,
  PRIMARY KEY(video_id, user_id)
);

CREATE TABLE comment_reaction_list(
  comment_id INT NOT NULL REFERENCES comments ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
  reaction_id INT NOT NULL REFERENCES reactions ON DELETE CASCADE,
  PRIMARY KEY(comment_id, user_id)
);

DROP TABLE shared_people_list
CREATE TABLE shared_people_list(
  playlist_id INT DEFAULT NULL REFERENCES playlists ON DELETE CASCADE,
  shared_user_id INT DEFAULT NULL REFERENCES users ON DELETE CASCADE,
  PRIMARY KEY(playlist_id, shared_user_id)
);

/*
  video_reaction_list.unique(v_id, u_id)
  1 user = 1 reaction(like/dislike) під video.

  comment_reaction_list.unique(c_id, u_id)
  1 user = 1 reaction(like/dislike) під comment.

  Конкретна реакція належить конкретному користувачу.

  (u:v 1m) - video has 1 owner. 
  user may have many video

  (pl:v mm) - playlist may have many videos. 
  video may be in many playlists

  comments.author_id - NOT NULL
  Коментарі можна залишати лише користувачам.
*/



------------------------------

/*
  pl:v mm
  u:v  1m

  u:pl 1m
  v:c  1m
  u:c  1m
*/

