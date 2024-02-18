<?php

include 'db_connection.php';

// Check if data is received from the Flutter app
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get data from Flutter app
    $professor = $_POST['professor'] ?? '';
    $feedback_text = $_POST['feedback_text'] ?? '';

    if (!empty($professor) && !empty($feedback_text)) {
        // Prepare SQL statement
        $sql = "INSERT INTO feedback (professor, feedback_text) VALUES ('$professor', '$feedback_text')";

        // Execute SQL statement
        if ($conn->query($sql) === TRUE) {
            echo "Feedback inserted successfully";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    } else {
        echo "Error: Invalid data received from Flutter app";
    }
} else {
    echo "Error: Invalid request method";
}

$conn->close();
