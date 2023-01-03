

DROP DATABASE IF EXISTS `lousi`;
CREATE DATABASE lousi;
USE lousi;


DROP TABLE IF EXISTS `players`;
CREATE TABLE players (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL,
   `handtiles` varchar(10) DEFAULT NULL UNIQUE,
    `token` varchar(100) DEFAULT NULL,
   `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(), 
    PRIMARY KEY (id) 
  /* CONSTRAINT FOREIGN KEY (handtiles) References tile (tilename) */
  /* PRIMARY KEY (handtiles) */
)ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `tile`;
CREATE TABLE tile(
`tilename` varchar (15) NOT NULL,
`firstvalue` int NOT NULL,
`secondvalue` int NOT NULL,
primary key(tilename)
/*FOREIGN KEY (playername) References players (name) */
)ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `sharetile`;
CREATE TABLE sharetile(
`id` INT NOT NULL,
`tile_name` varchar (15) DEFAULT NULL,
`player_name` varchar(10) DEFAULT NULL,
PRIMARY KEY (id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8;


INSERT INTO sharetile(id) VALUES
(0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28);



INSERT INTO tile(tilename,firstvalue,secondvalue) VALUES 
('0-0',0,0),
('0-1',0,1),
('1-1',1,1),
('0-2',0,2),
('1-2',1,2),
('2-2',2,2),
('0-3',0,3),
('1-3',1,3),
('2-3',2,3),
('3-3',3,3),
('0-4',0,4),
('1-4',1,4),
('2-4',2,4),
('3-4',3,4),
('4-4',4,4),
('0-5',0,5),
('1-5',1,5),
('2-5',2,5),
('3-5',3,5),
('4-5',4,5),
('5-5',5,5),
('0-6',0,6),
('1-6',1,6),
('2-6',2,6),
('3-6',3,6),
('4-6',4,6),
('5-6',5,6),
('6-6',6,6);


/*
INSERT INTO players(name)VALUES
	('vasilis4');
	
	SELECT count(DISTINCT  name)
	FROM players ;
	
	SELECT * FROM players ;
	
	Select count(*) from tile;
*/



DROP TABLE IF EXISTS `gameStatus`;
Create table  gameStatus(
    `id` int NOT NULL AUTO_INCREMENT,
   /* `session_id` int NOT NULL, */
    `status` enum(
        'initialized',
        'started',
        'ended',
        'aborted'
    ) NOT NULL DEFAULT 'initialized',
    `p_turn` int NOT NULL DEFAULT 1,
   /* `n_players` int NOT NULL, */
    `result` enum('1', '2') DEFAULT NULL,
    /*`first_round` BOOLEAN NOT NULL DEFAULT TRUE,*/
    /*`last_change` timestamp DEFAULT NOW(),*/
    `last_change`  timestamp NULL DEFAULT current_timestamp() 
    ON UPDATE current_timestamp(),
    
    PRIMARY KEY (id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8;





DROP TABLE IF EXISTS `board`;
CREATE TABLE board (
	`tile` varchar(10),
	`last_change`  timestamp NULL DEFAULT current_timestamp(), 
    primary key(tile,last_change)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `board_empty`;
CREATE TABLE board (
	`tile` varchar(10),
	`last_change`  timestamp NULL DEFAULT current_timestamp(), 
    primary key(tile,last_change)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8;


/*Some procedure to help us later*/

/*We create one procedure that we can manage to resart a game to clean the board*/
DROP procedure IF EXISTS `clean_board`;
DELIMITER//
CREATE PROCEDURE `clean_board` ()
BEGIN
replace into board select * from board_empty;
	 set tile=null, last_change=null;
  /*update `pieces` set `is_available`=1 Where `is_available`=0; it had not completed*/
  update `game_status` set `status`='not active', `p_turn`=null, `result`=null, `selected_piece`=null;
END//
DELIMITER ;



DROP procedure IF EXISTS `update_sharetile`;
DELIMITER //
CREATE PROCEDURE `update_sharetile` ()
BEGIN
  
 	ALTER TABLE sharetile 
 	ADD UNIQUE(tile_name);
  UPDATE sharetile
  SET tile_name = (SELECT tilename FROM tile Where tilename <> (SELECT tile_name FROM sharetile) ORDER BY RAND() LIMIT 1)
  WHERE tile_name IS NULL;
  
   UPDATE sharetile
  SET player_name = (SELECT name FROM players ORDER BY RAND() LIMIT 1)
  WHERE player_name IS NULL;
 
END //
DELIMITER ;

CALL update_sharetile();

/*DROP PROCEDURE IF EXISTS `play_tile`;
DELIMITER//
CREATE PROCEDURE `play_tile` ()
BEGIN
	 declare tile_name varchar;
    UPDATE gameStatus
    SET current_tile = tile_name;
END//
DELIMITER;*/

/*
SELECT * FROM sharetile;

/*





