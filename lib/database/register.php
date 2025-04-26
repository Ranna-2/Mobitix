<?php
require_once 'config.php';

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->email) && !empty($data->password) && !empty($data->fullName) && !empty($data->phoneNo)) {
    $email = $data->email;
    $password = password_hash($data->password, PASSWORD_BCRYPT);
    $fullName = $data->fullName;
    $phoneNo = $data->phoneNo;
    
    // Check if email already exists
    $check = $conn->prepare("SELECT Email FROM Users WHERE Email = ?");
    $check->execute([$email]);
    
    if($check->rowCount() > 0) {
        echo json_encode(["success" => false, "message" => "Email already registered"]);
        exit();
    }
    
    // Insert new user
    $query = "INSERT INTO Users (FullName, Email, PhoneNo, Password) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    
    if($stmt->execute([$fullName, $email, $phoneNo, $password])) {
        echo json_encode(["success" => true, "message" => "Registration successful"]);
    } else {
        echo json_encode(["success" => false, "message" => "Registration failed"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "All fields are required"]);
}
?>