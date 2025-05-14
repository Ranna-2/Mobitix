<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

$payment_id = isset($data['payment_id']) ? intval($data['payment_id']) : 0;
$bus_id = isset($data['bus_id']) ? intval($data['bus_id']) : 0;
$seats = isset($data['seats']) ? $data['seats'] : [];
$date = isset($data['date']) ? $conn->real_escape_string($data['date']) : date('Y-m-d');

if ($payment_id <= 0 || $bus_id <= 0 || empty($seats)) {
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
    
    // Update the reservation status to 'booked' and link to payment
    $update_sql = "UPDATE seat_reservations 
                   SET status = 'booked', payment_id = $payment_id
                   WHERE bus_id = $bus_id 
                   AND seat_number = $seat_num
                   AND reservation_date = '$date'
                   AND status = 'reserved'";
    
    if ($conn->query($update_sql) {
        if ($conn->affected_rows == 0) {
            $success = false;
            break;
        }
    } else {
        $success = false;
        break;
    }
}

if ($success) {
    $conn->commit();
    echo json_encode(['message' => 'Reservation confirmed successfully']);
} else {
    $conn->rollback();
    http_response_code(409);
    echo json_encode(['error' => 'Failed to confirm reservation. Seats may have been taken.']);
}

$conn->close();
?>