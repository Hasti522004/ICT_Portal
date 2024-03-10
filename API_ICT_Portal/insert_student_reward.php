<?php
// Database connection
include 'db_connection.php';

// Receive JSON data from Flutter app
$data = json_decode(file_get_contents('php://input'), true);

// Define a mapping array for column names
$columnMapping = array(
    'Deep Understanding' => 'deep_understanding',
    'Problem-solving' => 'problem_solving',
    'Research Skills' => 'research_skills',
    'Analytical Skills' => 'analytical_skills',
    'Critical Thinking' => 'critical_thinking',
    'Solution Proposals' => 'solution_proposals',
    'Research Methodology' => 'research_methodology',
    'Data Analysis' => 'data_analysis',
    'Conclusions' => 'conclusions',
    'Creativity' => 'creativity',
    'Innovative Solutions' => 'innovative_solutions',
    'Technical Competence' => 'technical_competence',
    'Tool Proficiency' => 'tool_proficiency',
    'Software Skills' => 'software_skills',
    'Hardware Skills' => 'hardware_skills',
    'Collaboration' => 'collaboration',
    'Communication' => 'communication',
    'Responsibility' => 'responsibility',
    'Clarity' => 'clarity',
    'Presentation' => 'presentation',
    'Listening Skills' => 'listening_skills',
    'Punctuality' => 'punctuality',
    'Ethics' => 'ethics',
    'Attitude' => 'attitude',
    'Social Awareness' => 'social_awareness',
    'Environmental Consciousness' => 'environmental_consciousness',
    'Community Engagement' => 'community_engagement',
    'Financial Literacy' => 'financial_literacy',
    'Resource Management' => 'resource_management',
    'Cost-effectiveness' => 'cost_effectiveness',
    'Fairness' => 'fairness',
    'Equality' => 'equality',
    'Integrity' => 'integrity',
    'Curiosity' => 'curiosity',
    'Adaptability' => 'adaptability',
    'Continuous Improvement' => 'continuous_improvement'
);

// Prepare the SQL query
$sql = "INSERT INTO student_review (enrollment_number, professor_id, timestamp";

// Dynamically construct the columns and values for the SQL query
$columns = "";
$values = "";

foreach ($data as $key => $value) {
    if ($key != "enrollment_number" && $key != "professor_id") {
        // Map the received column name to the database column name
        $databaseColumnName = $columnMapping[$key];
        $columns .= ", $databaseColumnName";
        $values .= ", '$value'";
    }
}

$sql .= $columns . ") VALUES ('" . $data['enrollment_number'] . "', '" . $data['professor_id'] . "', NOW()" . $values . ")";

// Execute the SQL query
if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
