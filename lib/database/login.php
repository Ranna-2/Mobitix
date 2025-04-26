<?php
require_once 'config.php';

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->email) && !empty($data->password)) {
    $email = $data->email;
    $password = $data->password;
    
    $query = "SELECT * FROM Users WHERE Email = ?";
    $stmt = $conn->prepare($query);
    $stmt->execute([$email]);
    
    if($stmt->rowCount() > 0) {
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if(password_verify($password, $user['Password'])) {
            // Return user data except password
            unset($user['Password']);
            echo json_encode([
                "success" => true, 
                "message" => "Login successful", 
                "user" => $user
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "Invalid password"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Email not registered"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Email and password are required"]);
}
?>