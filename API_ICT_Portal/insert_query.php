<?php

include 'db_connection.php';

// Get data from Flutter app
$heading = $_POST['heading'];
$subject = $_POST['subject'];
$description = $_POST['description'];

// Debugging: Log received data
file_put_contents("query_log.txt", "Received data:\nHeading: $heading\nSubject: $subject\nDescription: $description\n", FILE_APPEND);

// Prepare SQL statement
$sql = "INSERT INTO queries(heading, subject, description) VALUES ('$heading', '$subject', '$description')";

// Execute SQL statement
if ($conn->query($sql) === TRUE) {
    echo "Query inserted successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
