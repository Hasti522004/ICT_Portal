<?php
include 'db_connection.php';
// Fetch course data from the database
$sql = "SELECT * FROM courses"; // Assuming 'courses' is the name of your table
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Initialize an empty array to store course data
    $courses = array();

    // Fetch data from each row and add it to the array
    while ($row = $result->fetch_assoc()) {
        $courses[] = $row;
    }

    // Return course data in JSON format
    header('Content-Type: application/json');
    echo json_encode($courses);
} else {
    echo "No courses found";
}

// Close database connection
$conn->close();
?>
