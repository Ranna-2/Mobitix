<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

$bus_id = isset($data['bus_id']) ? intval($data['bus_id']) : 0;
$seats = isset($data['seats']) ? $data['seats'] : [];
$date = isset($data['date']) ? $conn->real_escape_string($data['date']) : date('Y-m-d');

if ($bus_id <= 0 || empty($seats)) {
    http_response_code(400);
    die(json_encode(['error' => 'Invalid input data']));
}

// Validate date format
if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
    http_response_code(400);
    die(json_encode(['error' => 'Invalid date format. Use YYYY-MM-DD']));
}

$conn->autocommit(false); // Start transaction
$success = true;

foreach ($seats as $seat_number) {
    $seat_num = intval($seat_number);
    
    // Check if seat is already reserved
    $check_sql = "SELECT id FROM seat_reservations 
                  WHERE bus_id = $bus_id 
                  AND seat_number = $seat_num
                  AND reservation_date = '$date'
                  AND status IN ('reserved', 'booked')";
    
    $check_result = $conn->query($check_sql);
    
    if ($check_result->num_rows > 0) {
        $success = false;
        break;
    }
    
    // Reserve the seat
    $insert_sql = "INSERT INTO seat_reservations (bus_id, seat_number, reservation_date, status)
                   VALUES ($bus_id, $seat_num, '$date', 'reserved')";
    
    if (!$conn->query($insert_sql)) {
        $success = false;
        break;
    }
}

if ($success) {
    $conn->commit();
    echo json_encode(['message' => 'Seats reserved successfully']);
} else {
    $conn->rollback();
    http_response_code(409);
    echo json_encode(['error' => 'One or more seats are already reserved']);
}

$conn->close();
?>