<?php
   header("Access-Control-Allow-Origin: *");
   header("Content-Type: application/json; charset=UTF-8");
   include 'db.php'; // Include your database connection file

   $query = "SELECT COUNT(*) as totalBookings, SUM(amount) as totalRevenue FROM payments WHERE status = 'success'";
   $result = $conn->query($query);

   if ($result) {
       $data = $result->fetch_assoc();
       // Log the query and the result for debugging
       error_log("Query: $query");
       error_log("Result: " . json_encode($data));
       echo json_encode($data);
   } else {
       echo json_encode(['error' => 'Failed to fetch data', 'query' => $query, 'error_message' => $conn->error]);
   }

   $conn->close();
   ?>
   
