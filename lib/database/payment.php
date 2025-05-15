<?php
require_once 'config.php';
include 'db.php'; // Add this line to connect to database

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    error_log("Payment request received: " . print_r($data, true));
    
    // Validate required fields with better error reporting
    if (empty($data['payment_method'])) {
        error_log("Validation failed: payment_method missing");
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Payment method is required']);
        exit();
    }
    if (empty($data['amount'])) {
        error_log("Validation failed: amount missing");
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Amount is required']);
        exit();
    }
    if (empty($data['reference_id'])) {
        error_log("Validation failed: reference_id missing");
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Reference ID is required']);
        exit();
    }
    
    try {
        error_log("Attempting to process payment with data: " . json_encode($data));
        
        // Simulate payment processing delay
        sleep(2);
        
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
        error_log("Payment processed successfully. ID: $paymentId");
        
        echo json_encode([
            'success' => $success,
            'status' => $status,
            'payment_id' => $paymentId,
            'message' => $success ? 'Payment processed successfully' : 'Payment failed due to mock gateway issue'
        ]);
        
    } catch (PDOException $e) {
        error_log("Database error: " . $e->getMessage());
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}