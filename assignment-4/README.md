# Bunny Bothy Check In Service API

This is the Bunny Bothy Check In Service API built with Express.js and MySQL. The API allows you to check and manage rooms and manage their occupancy status.

## Prerequisites

- Node.js 
- MySQL Server

## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/your-username/bunny-bothy-api.git
   cd bunny-bothy-api
   ```

2. Install the dependencies:

   ```sh
   npm install
   ```

3. Create a `.env` file in the root directory and add your database credentials:

   ```properties
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_password
   DB_NAME=bunny_bothy
   DB_PORT=3307
   ```

4. Set up the MySQL database:

   - Create a database named `bunny_bothy`.
   - Create a table named `rooms` with the following schema:

     ```sql
     CREATE TABLE rooms (
         id INT AUTO_INCREMENT PRIMARY KEY,
         room_name VARCHAR(255) NOT NULL,
         occupied ENUM('YES', 'NO') NOT NULL
     );
     ```

## Running the API

1. Start the server:

   ```sh
   npm start
   ```

2. The server will be running on `http://localhost:4000`.

## API Endpoints

### Get Opening Title

- **URL**: `/`
- **Method**: `GET`
- **Description**: Returns a welcome message.

### Get List of Rooms

- **URL**: `/rooms`
- **Method**: `GET`
- **Description**: Returns a list of all rooms and their occupied status.

### Create a New Room

- **URL**: `/create-room`
- **Method**: `POST`
- **Description**: Creates a new room.
- **Request Body**:
  ```json
  {
      "room_name": "Lily Suite",
      "occupied": "YES"
  }
  ```

### Get Count of Unoccupied Rooms

- **URL**: `/unoccupied-rooms-count`
- **Method**: `GET`
- **Description**: Returns the count of unoccupied rooms.

### Toggle Occupied Status of a Room

- **URL**: `/toggle-occupied/:room_name`
- **Method**: `PUT`
- **Description**: Toggles the occupied status of a room.
- **URL Parameters**:
  - `room_name`: The name of the room to toggle.

### Delete a Room

- **URL**: `/delete-room/:room_name`
- **Method**: `DELETE`
- **Description**: Deletes a room.
- **URL Parameters**:
  - `room_name`: The name of the room to delete.

## Error Handling

The API returns appropriate HTTP response codes and error messages for different scenarios, such as validation errors, database errors, and not found errors.

## Expected Behavior

- When you start the server, it should connect to the MySQL database and listen on port 4000.
- You should be able to interact with the API endpoints to manage rooms and their occupancy status.
- The API should return appropriate responses and handle errors gracefully.



