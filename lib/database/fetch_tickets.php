<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php';

// Get user ID from query parameters (you might want to use session or token in production)
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;
$mobile = isset($_GET['mobile']) ? $conn->real_escape_string($_GET['mobile']) : '';

if ($user_id <= 0 && empty($mobile)) {
    http_response_code(400);
    die(json_encode(['error' => 'Invalid user identifier']));
}

// Fetch tickets based on either user ID or mobile number
$sql = "SELECT 
        p.id as payment_id,
        p.payment_method,
        p.amount as total_amount,
        p.passenger_name,
        p.mobile,
        p.email,
        p.seats,
        p.boarding_point as boarding,
        p.destination,
        p.created_at as booking_date,
        p.reference_id,
        b.bus_name,
        b.id as bus_id,
        b.departure_time,
        b.arrival_time,
        CASE 
            WHEN b.departure_time > NOW() THEN 'upcoming'
            ELSE 'completed'
        END as status
    FROM payments p
    LEFT JOIN buses b ON JSON_CONTAINS(p.seats, (SELECT GROUP_CONCAT(CONCAT('\"', seat_number, '\"')) 
                                               FROM seat_reservations 
                                               WHERE payment_id = p.id), '$')
    WHERE p.status = 'success' 
    AND (p.mobile = '$mobile' OR p.id IN (SELECT payment_id FROM seat_reservations WHERE payment_id IS NOT NULL))";

$result = $conn->query($sql);

if (!$result) {
    http_response_code(500);
    die(json_encode(['error' => $conn->error]));
}

$tickets = [];
while ($row = $result->fetch_assoc()) {
    // Convert seats from string to array
    $seats = json_decode($row['seats']) ?: explode(', ', $row['seats']);
    
    $tickets[] = [
        'id' => 'ticket_' . $row['payment_id'],
        'passengerName' => $row['passenger_name'],
        'mobile' => $row['mobile'],
        'email' => $row['email'],
        'seats' => $seats,
        'boarding' => $row['boarding'],
        'destination' => $row['destination'],
        'totalAmount' => (float)$row['total_amount'],
        'bookingDate' => $row['booking_date'],
        'travelDate' => $row['departure_time'],
        'busName' => $row['bus_name'],
        'busId' => $row['bus_id'],
        'paymentMethod' => $row['payment_method'],
        'referenceId' => $row['reference_id'],
        'status' => $row['status']
    ];
}

echo json_encode($tickets);
$conn->close();
?>