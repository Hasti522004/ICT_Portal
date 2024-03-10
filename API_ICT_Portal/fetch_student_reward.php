<?php

// Include the database connection file
include 'db_connection.php';

// Check if enrollment number is provided in the request
if (isset($_GET['enrollment_number'])) {
    // Sanitize the input to prevent SQL injection
    $enrollment_number = mysqli_real_escape_string($conn, $_GET['enrollment_number']);

    // Query to fetch data for a particular enrollment number
    $sql = "SELECT 
    timestamp, 
    professor_id, 
    deep_understanding, 
    problem_solving, 
    research_skills, 
    analytical_skills, 
    critical_thinking, 
    solution_proposals, 
    research_methodology, 
    data_analysis, 
    conclusions, 
    creativity, 
    innovative_solutions, 
    technical_competence, 
    tool_proficiency, 
    software_skills, 
    hardware_skills, 
    collaboration, 
    communication, 
    responsibility, 
    clarity, 
    presentation, 
    listening_skills, 
    punctuality, 
    ethics, 
    attitude, 
    social_awareness, 
    environmental_consciousness, 
    community_engagement, 
    financial_literacy, 
    resource_management, 
    cost_effectiveness, 
    fairness, 
    equality, 
    integrity, 
    curiosity, 
    adaptability, 
    continuous_improvement
    FROM student_review 
    WHERE enrollment_number = '$enrollment_number'";

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
} else {
    // If enrollment number is not provided in the request, return an error message
    echo json_encode(array('error' => 'Enrollment number is required'));
}

$conn->close();
