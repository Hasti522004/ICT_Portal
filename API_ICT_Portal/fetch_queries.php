<?php

include 'db_connection.php';

// Fetch queries from the database
$sql = "SELECT * FROM queries";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $queries = array();
    // Output data of each row
    while ($row = $result->fetch_assoc()) {
        // Add query data to the queries array
        $query_data = array(
            "heading" => $row["heading"],
            "subject" => $row["subject"],
            "description" => $row["description"]
        );
        array_push($queries, $query_data);
    }
    // Convert the queries array to JSON format and output it
    echo json_encode($queries);
} else {
    echo "0 results";
}
$conn->close();
