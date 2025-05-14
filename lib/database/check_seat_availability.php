<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php';

$bus_id = isset($_GET['bus_id']) ? intval($_GET['bus_id']) : 0;
$date = isset($_GET['date']) ? $conn->real_escape_string($_GET['date']) : date('Y-m-d');

if ($bus_id <= 0) {
    http_response_code(400);
    die(json_encode(['error' => 'Invalid bus ID']));
}

// Validate date format
if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
    http_response_code(400);
    die(json_encode(['error' => 'Invalid date format. Use YYYY-MM-DD']));
}

// Get all reserved/occupied seats for this bus on this date
$sql = "SELECT seat_number FROM seat_reservations 
        WHERE bus_id = $bus_id 
        AND reservation_date = '$date'
        AND status IN ('reserved', 'booked')";

$result = $conn->query($sql);

$reserved_seats = [];
while ($row = $result->fetch_assoc()) {
    $reserved_seats[] = $row['seat_number'];
}

echo json_encode([
    'reserved_seats' => $reserved_seats,
    'total_seats' => 52 // Assuming 52 seats per bus as per your frontend
]);

$conn->close();
?>