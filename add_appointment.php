<?php
require 'dbconnect.php';

if ($_POST) {
    $client = $_POST['client_id'];
    $schedule = $_POST['schedule_id'];
    $topic = $_POST['topic'];

    $stmt = $pdo->prepare("
        INSERT INTO appointments (client_id, schedule_id, status, topic)
        VALUES (?, ?, 1, ?)
    ");

    $stmt->execute([$client, $schedule, $topic]);

    echo "Добавлено!";
}
?>

<form method="POST">
    ID клиента: <input name="client_id"><br>
    ID расписания: <input name="schedule_id"><br>
    Тема: <input name="topic"><br>
    <button>Добавить</button>
</form>