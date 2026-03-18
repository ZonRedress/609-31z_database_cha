<?php
require 'dbconnect.php';

if (isset($_POST['register'])) {

    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $phone = $_POST['phone'];
    $email = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    // по умолчанию клиент
    $role = 'client';

    $stmt = $pdo->prepare("
        INSERT INTO users (first_name, last_name, email, phone, password, role)
        VALUES (?, ?, ?, ?, ?, ?)");

    $stmt->execute([$first_name, $last_name, $email, $phone, $password, $role]);

    header("Location: login.php");
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Регистрация</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="card p-4 shadow-sm">
        <h3>Регистрация</h3>

        <form method="POST">

            <input type="text" name="first_name" class="form-control mb-2" placeholder="Имя" required>
            <input type="text" name="last_name" class="form-control mb-2" placeholder="Фамилия" required>
            <input type="text" name="phone" class="form-control mb-2" placeholder="Телефон" required>
            <input type="email" name="email" class="form-control mb-2" placeholder="Email" required>
            <input type="password" name="password" class="form-control mb-2" placeholder="Пароль" required>

            <button type="submit" name="register" class="btn btn-success">
                Зарегистрироваться
            </button>

        </form>

        <a href="login.php" class="mt-3 d-block">Уже есть аккаунт?</a>
    </div>
</div>

</body>
</html>