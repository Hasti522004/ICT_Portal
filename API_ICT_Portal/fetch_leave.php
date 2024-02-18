<?php

// Include the database connection file
include 'db_connection.php';

// SQL query to fetch leave applications data
$sql = "SELECT id, category, from_date, to_date, reason, file_url, status FROM leave_applications";

// Execute the query
$result = $conn->query($sql);

$leaveApplications = array();

if ($result->num_rows > 0) {
    // Fetch data from each row and add it to the $leaveApplications array
    while ($row = $result->fetch_assoc()) {
        $leaveApplications[] = $row;
    }
}

// Convert the array to JSON format and output it
echo json_encode($leaveApplications);

// Close the database connection
$conn->close();
?>