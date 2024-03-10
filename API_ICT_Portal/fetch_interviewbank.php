<?php

// Include the database connection file
include 'db_connection.php';

$sql = "SELECT * FROM interviewbank";
$result = $conn->query($sql);

$students = array();

if ($result->num_rows > 0) {
    // Fetch data from each row and add it to the $students array
    while ($row = $result->fetch_assoc()) {
        $students[] = $row;
    }
}

// Convert the array to JSON format and output it
echo json_encode($students);

$conn->close();
?>