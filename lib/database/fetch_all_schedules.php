<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php';

// Fetch all bus schedules from the database
$query = "SELECT * FROM buses";
$result = $conn->query($query);

$schedules = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $schedules[] = $row;
    }
    echo json_encode($schedules);
} else {
    echo json_encode([]);
}

$conn->close();
?>
