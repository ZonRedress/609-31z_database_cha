<?php


require 'dbconnect.php';

$query = $pdo->query("SELECT * FROM users");

$users = $query->fetchAll(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<html>
<head>
<title>Пользователи</title>
</head>

<body>

<h2>Список пользователей</h2>

<table border="1">

<tr>
<th>ID</th>
<th>Имя</th>
<th>Фамилия</th>
<th>Email</th>
<th>Роль</th>
</tr>

<?php foreach ($users as $user): ?>

<tr>
<td><?= $user['user_id'] ?></td>
<td><?= $user['first_name'] ?></td>
<td><?= $user['last_name'] ?></td>
<td><?= $user['email'] ?></td>
<td><?= $user['role'] ?></td>
</tr>

<?php endforeach; ?>

</table>

</body>
</html>