const express = require('express');
const mysql = require('mysql2'); // Ensure only one declaration of mysql
const { check, validationResult } = require('express-validator');
const app = express();
const PORT = 4000;

// Load environment variables
require('dotenv').config();

// Create a mysql connection pool
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    connectTimeout: 10000 // Increase timeout to 10 seconds
});

// Test database connection
pool.getConnection((err, connection) => {
    if (err) {
        console.error('Error connecting to the database:', err.message);
    } else {
        console.log('Connected to the database');
        connection.release();
    }
});

// Declares which port server is running on
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

app.use(express.json());

// Get opening title
app.get('/', (_req, res) => {
    res.send('Welcome to the Bunny Bothy Check In Service!');
});

// Gets list of rooms and occupied status
app.get('/rooms', (_req, res) => {
    const sql = 'SELECT * FROM rooms';
    pool.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching rooms:', err.message);
            return res.status(500).json({ error: `${err.message}` });
        }
        return res.status(200).json(results);
    });
});

// Post creates a new room when the bothy expands
app.post('/create-room', [
    check('room_name').notEmpty().withMessage('Room name is required'),
    check('occupied').isIn(['YES', 'NO']).withMessage('Occupied must be YES or NO')
], (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { room_name, occupied } = req.body;
    const sql = 'INSERT INTO rooms (room_name, occupied) VALUES (?, ?)';
    pool.query(sql, [room_name, occupied], (err, result) => {
        if (err) {
            console.error('Error creating room:', err.message);
            return res.status(500).json({ error: `${err.message}` });
        }
        res.status(201).json({ id: result.insertId, message: `Room: ${room_name} created successfully` });
    });
});

// Get the count of unoccupied rooms
app.get('/unoccupied-rooms-count', (req, res) => {
    const sql = "SELECT COUNT(*) AS count FROM rooms WHERE occupied = 'NO'";
    pool.query(sql, (err, result) => {
        if (err) {
            console.error('Error fetching unoccupied rooms count:', err.message);
            return res.status(500).json({ error: `${err.message}` });
        }
        res.status(200).json({ unoccupied_rooms: result[0].count });
    });
});

// Put to change the occupied status of a room at check in or check out
app.put('/toggle-occupied/:room_name', [
    check('room_name').notEmpty().withMessage('Room name is required')
], (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const room_name = req.params.room_name;
    const sql = `UPDATE rooms 
                 SET occupied = CASE WHEN occupied = 'YES' THEN 'NO' ELSE 'YES' END 
                 WHERE room_name = ?`;
    pool.query(sql, [room_name], (err, result) => {
        if (err) {
            console.error('Error toggling occupied status:', err.message);
            return res.status(500).json({ error: `${err.message}` });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: `Room '${room_name}' not found` });
        }
        res.status(200).json({ message: `Room '${room_name}' status changed successfully` });
    });
});

// Delete a room from the booking system when it must be taken off for maintenance or repairs
app.delete('/delete-room/:room_name', [
    check('room_name').notEmpty().withMessage('Room name is required')
], (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const room_name = req.params.room_name;
    const sql = 'DELETE FROM rooms WHERE room_name = ?';
    pool.query(sql, [room_name], (err, result) => {
        if (err) {
            console.error('Error deleting room:', err.message);
            return res.status(500).json({ error: `${err.message}` });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: `Room '${room_name}' not found` });
        }
        res.status(200).json({ message: `Room '${room_name}' deleted successfully` });
    });
});