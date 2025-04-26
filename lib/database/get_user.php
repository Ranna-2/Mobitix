<?php
header('Content-Type: application/json');
include 'db.php'; // Include your database connection file

$userId = $_GET['userId'];

$query = "SELECT * FROM users WHERE UserID = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode($user);
} else {
    echo json_encode(['error' => 'User  not found ']);
}

$stmt->close();
$conn->close();
?>