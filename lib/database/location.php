<?php
$servername = "localhost";
$username = "root"; // Default XAMPP username
$password = ""; // Default XAMPP password
$dbname = "mobitix"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle location update
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $busId = $_POST['busId'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];

    // Update or insert the bus location
    $stmt = $conn->prepare("INSERT INTO bus_locations (bus_id, latitude, longitude) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE latitude=?, longitude=?");
    $stmt->bind_param("sssss", $busId, $latitude, $longitude, $latitude, $longitude);
    $stmt->execute();
    $stmt->close();
    echo json_encode(["status" => "success"]);
}

// Handle fetching locations
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $result = $conn->query("SELECT bus_id, latitude, longitude FROM bus_locations");
    $locations = [];
    while ($row = $result->fetch_assoc()) {
        $locations[$row['bus_id']] = [
            'latitude' => $row['latitude'],
            'longitude' => $row['longitude']
        ];
    }
    echo json_encode($locations);
}

$conn->close();
?>