-- Movie Archive: schema + sample data
-- Import via phpMyAdmin (Import tab) or paste into the SQL tab.

CREATE DATABASE IF NOT EXISTS movie_archive
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE movie_archive;

DROP TABLE IF EXISTS watchlist;
DROP TABLE IF EXISTS movie_genres;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS admins;

CREATE TABLE genres (
  id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE movies (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title        VARCHAR(150) NOT NULL,
  release_date DATE NOT NULL,
  rating       DECIMAL(3,1) NOT NULL DEFAULT 0.0,
  director     VARCHAR(120) NOT NULL,
  cast_list    VARCHAR(500) NOT NULL DEFAULT '',   -- comma-separated names
  synopsis     TEXT NOT NULL,
  poster_url   VARCHAR(500) NOT NULL DEFAULT '',   -- image link only, no files stored
  is_featured  TINYINT(1) NOT NULL DEFAULT 0,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_title (title),
  INDEX idx_release (release_date)
);

-- A movie can have several genres
CREATE TABLE movie_genres (
  movie_id INT UNSIGNED NOT NULL,
  genre_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (movie_id, genre_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE
);

-- No user accounts: each visitor gets a random token (PHP session)
CREATE TABLE watchlist (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  visitor_id VARCHAR(64) NOT NULL,
  movie_id   INT UNSIGNED NOT NULL,
  added_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_visitor_movie (visitor_id, movie_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);

CREATE TABLE admins (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL
);

-- Default admin: username "admin", password "admin123" (change it later!)
INSERT INTO admins (username, password_hash) VALUES
('admin', '$2b$10$RhVyTVMTsHFgAyMWAtjhcetYPtxFTuAy05/QAaaWAI0C4aDvFv6kO');

INSERT INTO genres (id, name) VALUES
(1,'Drama'),(2,'Sci-Fi'),(3,'Thriller'),(4,'Animation'),(5,'Fantasy'),
(6,'Crime'),(7,'Romance'),(8,'Mystery');

INSERT INTO movies (id, title, release_date, rating, director, cast_list, synopsis, poster_url, is_featured) VALUES
(1,'Arrival','2016-11-11',7.9,'Denis Villeneuve',
 'Amy Adams, Jeremy Renner, Forest Whitaker, Michael Stuhlbarg',
 'Twelve alien vessels settle over Earth without explanation. A linguist is brought in to learn their language, and the more she understands it, the less she experiences time the way she used to. A quiet, patient film about communication and grief.',
 'https://image.tmdb.org/t/p/w500/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg',1),
(2,'Parasite','2019-05-30',8.5,'Bong Joon-ho',
 'Song Kang-ho, Lee Sun-kyun, Cho Yeo-jeong, Choi Woo-shik, Park So-dam',
 'A struggling family talks its way into the household of a wealthy one, one job at a time. What begins as a clever con turns into something far darker as the two worlds collide.',
 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',0),
(3,'Spirited Away','2001-07-20',8.5,'Hayao Miyazaki',
 'Rumi Hiiragi, Miyu Irino, Mari Natsuki, Takashi Naito',
 'A ten-year-old girl wanders into a bathhouse run for spirits and has to work there to free her parents. Hand-drawn, strange and unhurried, with a world that never explains itself.',
 'https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg',0),
(4,'The Godfather','1972-03-24',8.7,'Francis Ford Coppola',
 'Marlon Brando, Al Pacino, James Caan, Robert Duvall, Diane Keaton',
 'The aging head of a crime family hands his empire to the son who never wanted it. A study of power, loyalty and the slow cost of both, shot in deep amber shadow.',
 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',0),
(5,'Blade Runner 2049','2017-10-06',7.5,'Denis Villeneuve',
 'Ryan Gosling, Harrison Ford, Ana de Armas, Jared Leto',
 'A replicant officer uncovers a buried secret that could upend the fragile order between humans and their creations, and goes looking for a man who vanished thirty years earlier.',
 'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg',0),
(6,'Moonlight','2016-10-21',7.4,'Barry Jenkins',
 'Trevante Rhodes, Mahershala Ali, Naomie Harris, Andre Holland',
 'Three chapters from the life of a boy growing up in Miami, told across childhood, adolescence and adulthood. A tender film about identity and the things left unsaid.',
 'https://image.tmdb.org/t/p/w500/4911T5FbJ9eD2Faz5Z8cT3SUhU3.jpg',0),
(7,'In the Mood for Love','2000-09-29',8.1,'Wong Kar-wai',
 'Tony Leung Chiu-wai, Maggie Cheung, Rebecca Pan',
 'Two neighbors in 1960s Hong Kong realize their spouses are having an affair, and slowly grow close themselves. Everything is in the glances, the corridors and the restraint.',
 'https://image.tmdb.org/t/p/w500/iYypPT4bhqXfq1b6EnmxvRt6b4k.jpg',0),
(8,'Pan''s Labyrinth','2006-10-11',8.2,'Guillermo del Toro',
 'Ivana Baquero, Sergi Lopez, Maribel Verdu, Doug Jones',
 'In Spain in 1944, a girl moves to a military outpost with her mother and stepfather, and finds a labyrinth with a faun waiting at its center. Fairy tale and war story, neither softened.',
 'https://image.tmdb.org/t/p/w500/s8C4whhKyEJNIQFfZuuNmTcKTqF.jpg',0),
(9,'Lost in Translation','2003-09-12',7.7,'Sofia Coppola',
 'Bill Murray, Scarlett Johansson, Giovanni Ribisi',
 'An aging actor and a newly married young woman meet by chance in a Tokyo hotel, both sleepless and a long way from home. A small, funny, melancholy friendship.',
 'https://image.tmdb.org/t/p/w500/wkSiAfXAbkvZ5g4zdvCOYQnWHP3.jpg',0),
(10,'Portrait of a Lady on Fire','2019-09-18',8.1,'Celine Sciamma',
 'Noemie Merlant, Adele Haenel, Luana Bajrami, Valeria Golino',
 'On an island in 18th-century Brittany, a painter is hired to secretly portray a reluctant bride-to-be. Looking becomes the whole language of the film.',
 'https://image.tmdb.org/t/p/w500/2LquGwEhbg3soxfVMmCwFYvcOMd.jpg',0);

INSERT INTO movie_genres (movie_id, genre_id) VALUES
(1,2),(1,1),(1,8),
(2,1),(2,3),
(3,4),(3,5),
(4,6),(4,1),
(5,2),(5,3),
(6,1),
(7,7),(7,1),
(8,5),(8,1),
(9,1),(9,7),
(10,7),(10,1);
