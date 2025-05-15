<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php';

// Get user ID from query parameters
$mobile = isset($_GET['mobile']) ? $conn->real_escape_string($_GET['mobile']) : '';

if (empty($mobile)) {
    http_response_code(400);
    die(json_encode(['error' => 'Mobile number is required']));
}

// Fetch tickets based on mobile number
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
    LEFT JOIN buses b ON b.id = p.bus_id
    WHERE p.status = 'success' 
    AND p.mobile = '$mobile'";

$result = $conn->query($sql);

if (!$result) {
    http_response_code(500);
    die(json_encode(['error' => $conn->error]));
}

$tickets = [];
while ($row = $result->fetch_assoc()) {
    // Ensure all fields are properly formatted
    $row['seats'] = !empty($row['seats']) ? explode(',', $row['seats']) : [];
    $tickets[] = $row;
}

echo json_encode($tickets);
$conn->close();
?>