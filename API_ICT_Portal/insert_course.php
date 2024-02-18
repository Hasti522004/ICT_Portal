<?php

include 'db_connection.php';
// Handle POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve data from POST request
    $heading = $_POST["heading"];
    $subject = $_POST["subject"];
    $description = $_POST["description"];

    // Prepare SQL statement
    $sql = "INSERT INTO courses (heading, subject, description) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sss", $heading, $subject, $description);

    // Execute SQL statement
    if ($stmt->execute() === TRUE) {
        echo "Course added successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    echo "hii";

    $stmt->close();
    $conn->close();
}
