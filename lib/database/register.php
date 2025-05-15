<?php
require_once 'config.php';

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->email) && !empty($data->password) && !empty($data->fullName) && !empty($data->phoneNo)) {
    // Validate email format
    if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(["success" => false, "message" => "Invalid email format"]);
        exit();
    }

    // Validate phone number (10 digits)
    if (!preg_match('/^[0-9]{10}$/', $data->phoneNo)) {
        echo json_encode(["success" => false, "message" => "Phone number must be 10 digits"]);
        exit();
    }

    // Validate password strength
    if (strlen($data->password) < 8 || 
        !preg_match('/[A-Z]/', $data->password) || 
        !preg_match('/[a-z]/', $data->password) || 
        !preg_match('/[0-9]/', $data->password) || 
        !preg_match('/[!@#$%^&*(),.?":{}|<>]/', $data->password)) {
        echo json_encode(["success" => false, "message" => "Password must be at least 8 characters with uppercase, lowercase, number, and special character"]);
        exit();
    }

    // Validate role
    if (!in_array($data->role, ['admin', 'user'])) {
        echo json_encode(["success" => false, "message" => "Invalid role specified"]);
        exit();
    }

    // Validate name length
    if (strlen($data->fullName) < 2 || strlen($data->fullName) > 100) {
        echo json_encode(["success" => false, "message" => "Name must be between 2 and 100 characters"]);
        exit();
    }

    $email = $data->email;
    $password = password_hash($data->password, PASSWORD_BCRYPT);
    $fullName = htmlspecialchars($data->fullName, ENT_QUOTES, 'UTF-8');
    $phoneNo = $data->phoneNo;
    $role = 'user';
    
    // Check if email already exists
    $check = $conn->prepare("SELECT Email FROM users WHERE Email = ?");
    $check->execute([$email]);
    
    if($check->rowCount() > 0) {
        echo json_encode(["success" => false, "message" => "Email already registered"]);
        exit();
    }
    
    // Insert new user with additional validation
    try {
        $query = "INSERT INTO users (FullName, Email, PhoneNo, Password, Role) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        
        if($stmt->execute([$fullName, $email, $phoneNo, $password, $role])) {
            echo json_encode(["success" => true, "message" => "Registration successful"]);
        } else {
            echo json_encode(["success" => false, "message" => "Registration failed"]);
        }
    } catch (PDOException $e) {
        error_log("Database error: " . $e->getMessage());
        echo json_encode(["success" => false, "message" => "Database error occurred"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "All fields are required"]);
}
?>