<?php
require_once 'config.php';

// Add these lines at the very top
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
error_reporting(0); // Turn off error reporting to prevent output pollution

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->email) && !empty($data->password)) {
    $email = $data->email;
    $password = $data->password;
    
    try {
        $query = "SELECT * FROM users WHERE Email = ?";
        $stmt = $conn->prepare($query);
        $stmt->execute([$email]);
        
        if($stmt->rowCount() > 0) {
            $user = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if(password_verify($password, $user['Password'])) {
                // Check if admin email is authorized
                if ($user['Role'] === 'admin' && !in_array($email, ['admin@mobitix.com', 'superadmin@mobitix.com'])) {
                    echo json_encode(["success" => false, "message" => "Admin access denied"]);
                    exit();
                }
                
                unset($user['Password']);
                echo json_encode([
                    "success" => true, 
                    "message" => "Login successful", 
                    "user" => $user
                ]);
            } else {
                echo json_encode(["success" => false, "message" => "Invalid credentials"]);
            }
        } else {
            echo json_encode(["success" => false, "message" => "Invalid credentials"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["success" => false, "message" => "Database error"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Email and password are required"]);
}
?>