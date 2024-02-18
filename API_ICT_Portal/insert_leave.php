<?php
// Include the database connection file
include 'db_connection.php';

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the data sent from the Flutter app
    $category = $_POST['category'];
    $fromDate = $_POST['from_date'];
    $toDate = $_POST['to_date'];
    $reason = $_POST['reason'];
    $fileUrl = $_POST['file_url'];
    $status = 'pending'; // Set default status to 'pending'

    // Prepare and execute the SQL statement to insert the leave application
    $sql = "INSERT INTO leave_applications (category, from_date, to_date, reason, file_url, status) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssss", $category, $fromDate, $toDate, $reason, $fileUrl, $status);

    // Check if the insertion was successful
    if ($stmt->execute()) {
        // Return success response
        $response = array(
            "success" => true,
            "message" => "Leave application inserted successfully"
        );
        echo json_encode($response);
    } else {
        // Return error response
        $response = array(
            "success" => false,
            "message" => "Failed to insert leave application"
        );
        echo json_encode($response);
    }

    // Close the database connection
    $stmt->close();
    $conn->close();
} else {
    // Return error response if request method is not POST
    $response = array(
        "success" => false,
        "message" => "Invalid request method"
    );
    echo json_encode($response);
}
?>