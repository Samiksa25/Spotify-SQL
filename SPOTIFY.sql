-- Advanced Sql Project-- Spotify
CREATE TABLE spotify (
    artist VARCHAR (255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA
SELECT COUNT (*) FROM spotify;
SELECT COUNT (DISTINCT artist) FROM spotify; 
SELECT DISTINCT album_type FROM spotify; 
SELECT MAX (duration_min) FROM spotify;
SELECT MIN (duration_min) from spotify;

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0
SELECT * FROM spotify
WHERE duration_min = 0

SELECT DISTINCT channel FROM spotify;
SELECT DISTINCT most_played_on FROM spotify;

-------- DATA ANALYSIS EASY CATEGORY 
1.Retrieve the names of all tracks that have more than 1 billion streams.
2.List all albums along with their respective artists.
3.Get the total number of comments for tracks where licensed = TRUE.
4.Find all tracks that belong to the album type single.
5.Count the total number of tracks by each artist.
*/

1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT* FROM spotify
WHERE stream > 1000000000;

2.List all albums along with their respective artists.

SELECT  DISTINCT album , artist FROM spotify
ORDER BY 1;

3.Get the total number of comments for tracks where licensed = TRUE.

SELECT * FROM spotify
WHERE licensed = 'true';

SELECT SUM (comments)as total_comments
FROM Spotify
WHERE licensed = 'true';

4.Find all tracks that belong to the album type single

SELECT * FROM spotify
WHERE album_type ILIKE 'Single';

5.Count the total number of tracks by each artist.

SELECT
   artist,
   count(*) as total_no_songs
FROM spotify
GROUP BY artist
ORDER BY 2

 ---------------------------MEDIUM LEVEL----------------------------------------------
1. Calculate the average danceability of tracks in each album.
2.Find the top 5 tracks with the highest energy values.
3.List all tracks along with their views and likes where official_video = TRUE.
4.For each album, calculate the total views of all associated tracks.
5.Retrieve the track names that have been streamed on Spotify more than YouTube.
--------------------------------------------------------------------------------------
1. Calculate the average danceability of tracks in each album.

SELECT 
    album,
	avg (danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

2.Find the top 5 tracks with the highest energy values.

SELECT
   TRACK,
   MAX (ENERGY)
FROM SPOTIFY
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

3.List all tracks along with their views and likes where official_video = TRUE.

SELECT
    track,
	sum(views),
	sum(likes)
FROM spotify
WHERE OFFICIAL_VIDEO ='true' 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

4.For each album, calculate the total views of all associated tracks.

SELECT 
    album,
	track,
	SUM(views)
FROM SPOTIFY
GROUP BY 1,2

5.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
(SELECT  
   track,
   -- most_played_on,
  COALESCE(SUM(CASE WHEN  most_played_on = 'youtube'THEN stream END),0)as streamed_on_youtube,
  COALESCE(SUM(CASE WHEN  most_played_on = 'spotify'THEN stream END),0)as streamed_on_spotify
FROM spotify
GROUP BY 1
) as t1
WHERE 
    streamed_on_spotify > streamed_on_youtube
    AND
	streamed_on_youtube <> 0

----------------------------HARD LEVEL--------------------------------------------
1.Find the top 3 most-viewed tracks for each artist using window functions.
2.Write a query to find tracks where the liveness score is above the average.
3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
4.Find tracks where the energy-to-liveness ratio is greater than 1.2.
5.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

1.Find the top 3 most-viewed tracks for each artist using window functions.
---- each artists and total view for each track
---- track with hightest view for each artist (we need top)
----- dense rank
--- cte and filder rank <=3
WITH ranking_artist
AS
(SELECT
     artist,
	 track,
	 SUM (views) as total_view,
	 DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views)DESC) as rank
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT* FROM ranking_artist
WHERE rank<=3

2.Write a query to find tracks where the liveness score is above the average.

SELECT 
   track,
   artist,
   liveness
FROM spotify
WHERE liveness > (select AVG(liveness)from spotify)

1.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT
      album,
      max(energy) as highest_energy,
     MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
    albUm,
	highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 2 DESC
   
   