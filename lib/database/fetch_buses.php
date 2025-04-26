<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php';

// Get and sanitize parameters
$from = isset($_GET['from']) ? $conn->real_escape_string($_GET['from']) : '';
$to = isset($_GET['to']) ? $conn->real_escape_string($_GET['to']) : '';
$date = isset($_GET['date']) ? $conn->real_escape_string($_GET['date']) : '';

// Base query
$sql = "SELECT *, 
        TIME(departure_time) as departure_time_only,
        TIME(arrival_time) as arrival_time_only
        FROM buses 
        WHERE route LIKE '%$from%' 
        AND route LIKE '%$to%'";

// Add date filter if provided
if (!empty($date)) {
    // Validate date format
    if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
        $sql .= " AND DATE(departure_time) = '$date'";
    } else {
        http_response_code(400);
        die(json_encode(['error' => 'Invalid date format. Use YYYY-MM-DD']));
    }
}

// Only show future buses
$sql .= " AND departure_time >= NOW()";

// Add sorting
$sql .= " ORDER BY departure_time ASC";

$result = $conn->query($sql);

if (!$result) {
    http_response_code(500);
    die(json_encode(['error' => $conn->error]));
}

$buses = [];
while($row = $result->fetch_assoc()) {
    // Format times for better display
    $row['formatted_departure'] = date('h:i A', strtotime($row['departure_time_only']));
    $row['formatted_arrival'] = date('h:i A', strtotime($row['arrival_time_only']));
    $buses[] = $row;
}

echo json_encode($buses);
$conn->close();
?>