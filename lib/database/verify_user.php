<?php
require_once 'config.php';

session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->email)) {
        $email = $data->email;
        
        try {
            $stmt = $conn->prepare("UPDATE Users SET is_verified = 1 WHERE Email = ?");
            $stmt->execute([$email]);
            
            if ($stmt->rowCount() > 0) {
                echo json_encode(["success" => true, "message" => "User verified successfully"]);
            } else {
                echo json_encode(["success" => false, "message" => "User not found or already verified"]);
            }
        } catch(PDOException $e) {
            echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Email is required"]);
    }
}
?>