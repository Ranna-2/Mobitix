<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include 'db.php';

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Fetch all schedules
        $sql = "SELECT * FROM buses ORDER BY departure_time ASC";
        $result = $conn->query($sql);
        
        $buses = [];
        while($row = $result->fetch_assoc()) {
            $buses[] = $row;
        }
        
        echo json_encode($buses);
        break;
        
    case 'POST':
        // Add new schedule
        $data = json_decode(file_get_contents("php://input"), true);
        
        $bus_name = $conn->real_escape_string($data['bus_name']);
        $departure_time = $conn->real_escape_string($data['departure_time']);
        $arrival_time = $conn->real_escape_string($data['arrival_time']);
        $route = $conn->real_escape_string($data['route']);
        
        $sql = "INSERT INTO buses (bus_name, departure_time, arrival_time, route) 
                VALUES ('$bus_name', '$departure_time', '$arrival_time', '$route')";
        
        if ($conn->query($sql)) {
            echo json_encode(["message" => "Bus schedule added successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => $conn->error]);
        }
        break;
        
    case 'PUT':
        // Update schedule
        $data = json_decode(file_get_contents("php://input"), true);
        
        $id = intval($data['id']);
        $bus_name = $conn->real_escape_string($data['bus_name']);
        $departure_time = $conn->real_escape_string($data['departure_time']);
        $arrival_time = $conn->real_escape_string($data['arrival_time']);
        $route = $conn->real_escape_string($data['route']);
        
        $sql = "UPDATE buses SET 
                bus_name = '$bus_name',
                departure_time = '$departure_time',
                arrival_time = '$arrival_time',
                route = '$route'
                WHERE id = $id";
        
        if ($conn->query($sql)) {
            echo json_encode(["message" => "Bus schedule updated successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => $conn->error]);
        }
        break;
        
    case 'DELETE':
        // Delete schedule
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        
        if ($id > 0) {
            $sql = "DELETE FROM buses WHERE id = $id";
            
            if ($conn->query($sql)) {
                echo json_encode(["message" => "Bus schedule deleted successfully"]);
            } else {
                http_response_code(500);
                echo json_encode(["error" => $conn->error]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["error" => "Invalid bus ID"]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(["error" => "Method not allowed"]);
        break;
}

$conn->close();
?>