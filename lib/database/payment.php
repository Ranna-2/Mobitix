<?php
require_once 'config.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    // Validate required fields
    if (empty($data['payment_method']) || empty($data['amount']) || empty($data['reference_id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Missing required fields']);
        exit();
    }
    
    try {
        // Simulate payment processing delay
        sleep(2);
        
        // Randomly decide if payment succeeds (80% chance) or fails (20% chance)
        $success = rand(1, 100) <= 80;
        $status = $success ? 'success' : 'failed';
        
        // Insert payment record
        $stmt = $conn->prepare("INSERT INTO payments (
            payment_method, amount, reference_id, passenger_name, seats,
            boarding_point, destination, email, mobile, status
        ) VALUES (
            :payment_method, :amount, :reference_id, :passenger_name, :seats,
            :boarding_point, :destination, :email, :mobile, :status
        )");
        
        $stmt->execute([
            ':payment_method' => $data['payment_method'],
            ':amount' => $data['amount'],
            ':reference_id' => $data['reference_id'],
            ':passenger_name' => $data['passenger_name'] ?? '',
            ':seats' => $data['seats'] ?? '',
            ':boarding_point' => $data['boarding_point'] ?? '',
            ':destination' => $data['destination'] ?? '',
            ':email' => $data['email'] ?? '',
            ':mobile' => $data['mobile'] ?? '',
            ':status' => $status
        ]);
        
        $paymentId = $conn->lastInsertId();
        
        echo json_encode([
            'success' => $success,
            'status' => $status,
            'payment_id' => $paymentId,
            'message' => $success ? 'Payment processed successfully' : 'Payment failed due to mock gateway issue'
        ]);
        
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}