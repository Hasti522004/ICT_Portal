<?php

include 'db_connection.php';

// Retrieve data sent from Flutter app
$studentName = $_POST['student_name'];
$enrollment = $_POST['enrollment_number'];
$companyName = $_POST['company_name'];
$package = $_POST['package'];
$date = $_POST['date'];
$category = $_POST['category'];
$interviewExperience = $_POST['description']; // This is the HTML content from the HtmlEditor

// Prepare SQL statement for insertion
$sql = "INSERT INTO interviewbank (studentName, enrollment, companyName, package, date, interviewExperience)
        VALUES ('$studentName', '$enrollment', '$companyName', '$package', '$date', '$interviewExperience')";

// Execute SQL statement
if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// Close connection
$conn->close();
