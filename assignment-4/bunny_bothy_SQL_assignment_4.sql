USE bunny_bothy;

SELECT * FROM bunny;

CREATE TABLE rooms
(id INT PRIMARY KEY AUTO_INCREMENT,
room_name VARCHAR(50) UNIQUE NOT NULL,
occupied VARCHAR(3) NOT NULL
);

INSERT INTO rooms (room_name, occupied) VALUES
('Daffodil Suite', 'YES'),
('Bluebell Suite', 'NO'),
('Thistle Suite', 'YES'),
('Heather Suite', 'NO'),
('Rose Suite', 'YES'),
('Lavender Suite', 'NO'),
('Snowdrop Suite', 'YES'),
('Foxglove Suite', 'NO'),
('Primrose Suite', 'YES'),
('Honeysuckle Suite', 'NO');

SELECT * FROM rooms;