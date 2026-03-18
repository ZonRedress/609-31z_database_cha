<?php
require 'dbconnect.php';

if (isset($_GET['id'])) {

    $id = $_GET['id'];

    $stmt = $pdo->prepare("SELECT * FROM appointments WHERE appointment_id = ?");
    $stmt->execute([$id]);

    if ($stmt->rowCount() > 0) {

        $delete = $pdo->prepare("DELETE FROM appointments WHERE appointment_id = ?");
        $delete->execute([$id]);
    }
}

header("Location: index.php");
exit;