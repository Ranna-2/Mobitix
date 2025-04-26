<?php
require_once 'config.php';

session_start();

// Debugging: Log session data
error_log("Session ID: " . session_id());
error_log("Current session: " . print_r($_SESSION, true));

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = file_get_contents("php://input");
    error_log("Received input: " . $input);
    $data = json_decode($input);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        echo json_encode(["success" => false, "message" => "Invalid JSON data"]);
        exit();
    }

    if (empty($data->email)) {
        echo json_encode(["success" => false, "message" => "Email is required"]);
        exit();
    }

    // Generate OTP request
    if (!isset($data->user_otp)) {
        $otp = rand(100000, 999999);
        $_SESSION['otp'] = $otp;
        $_SESSION['otp_email'] = $data->email;
        $_SESSION['otp_time'] = time();
        
        error_log("Generated OTP: $otp for email: " . $data->email);
        error_log("Updated session: " . print_r($_SESSION, true));
        
        echo json_encode([
            "success" => true, 
            "otp" => $otp, 
            "message" => "OTP generated"
        ]);
        exit();
    }
    
    // Verify OTP request
    if (isset($data->user_otp)) {
        error_log("Verification attempt for email: " . $data->email);
        error_log("Current session during verification: " . print_r($_SESSION, true));
        
        if (!isset($_SESSION['otp'], $_SESSION['otp_email'], $_SESSION['otp_time'])) {
            error_log("OTP session data missing");
            echo json_encode(["success" => false, "message" => "OTP not generated"]);
            exit();
        }
        
        if ($_SESSION['otp_email'] !== $data->email) {
            error_log("Email mismatch: session email is " . $_SESSION['otp_email']);
            echo json_encode(["success" => false, "message" => "Email mismatch"]);
            exit();
        }
        
        if (time() - $_SESSION['otp_time'] > 300) {
            error_log("OTP expired");
            echo json_encode(["success" => false, "message" => "OTP expired"]);
            exit();
        }
        
        if ($_SESSION['otp'] == $data->user_otp) {
            error_log("OTP verified successfully");
            echo json_encode(["success" => true, "message" => "OTP verified"]);
            unset($_SESSION['otp'], $_SESSION['otp_email'], $_SESSION['otp_time']);
        } else {
            error_log("Invalid OTP: received " . $data->user_otp . ", expected " . $_SESSION['otp']);
            echo json_encode(["success" => false, "message" => "Invalid OTP"]);
        }
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}
?>