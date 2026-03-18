<?php
session_start();

if (!isset($_SESSION['user'])) {
    header("Location: login.php");
    exit;
}

require 'dbconnect.php';

$user_id = $_SESSION['user']['user_id'];
$role = $_SESSION['user']['role'];
$name = $_SESSION['user']['first_name'] . ' ' . $_SESSION['user']['last_name'];


// ==========================================
// ✅ 1. ДОБАВЛЕНИЕ КОНСУЛЬТАЦИИ (psychologist)
// ==========================================
if (isset($_POST['add']) && $role === 'psychologist') {

    $client_id = $_POST['client_id'];
    $topic = $_POST['topic'];
    $notes = $_POST['notes'] ?? null;
    $datetime_from = $_POST['datetime_from'];
    $datetime_to = $_POST['datetime_to'];

    // создаём слот в schedule
    $stmt = $pdo->prepare("
        INSERT INTO schedule (psychologist_id, datetime_from, datetime_to, status)
        VALUES (?, ?, ?, 'booked')
    ");
    $stmt->execute([$user_id, $datetime_from, $datetime_to]);

    $schedule_id = $pdo->lastInsertId();

    // создаём запись консультации
    $stmt = $pdo->prepare("
        INSERT INTO appointments (client_id, schedule_id, status, topic, notes)
        VALUES (?, ?, 1, ?, ?)
    ");
    $stmt->execute([$client_id, $schedule_id, $topic, $notes]);

    header("Location: index.php");
    exit;
}


// ==========================================
// ✅ 2. ЗАГРУЗКА ФОТО (psychologist)
// ==========================================
if (isset($_POST['upload_photo']) && $role === 'psychologist') {

    if (!empty($_FILES['photo']['name'])) {

        // проверка типа файла
        $allowed = ['image/jpeg', 'image/png'];
        if (!in_array($_FILES['photo']['type'], $allowed)) {
            die("Только JPG и PNG!");
        }

        $file_name = time() . '_' . $_FILES['photo']['name'];
        $target = 'uploads/' . $file_name;

        // создаём папку если нет
        if (!is_dir('uploads')) {
            mkdir('uploads', 0777, true);
        }

        if (move_uploaded_file($_FILES['photo']['tmp_name'], $target)) {

            // сохраняем в БД
            $stmt = $pdo->prepare("UPDATE users SET photo = ? WHERE user_id = ?");
            $stmt->execute([$target, $user_id]);

            // обновляем сессию
            $_SESSION['user']['photo'] = $target;
        }
    }

    header("Location: index.php");
    exit;
}


// ==========================================
// ✅ 3. СПИСОК КЛИЕНТОВ (для формы)
// ==========================================
$clients = $pdo->query("
    SELECT user_id, first_name, last_name 
    FROM users 
    WHERE role = 'client'
")->fetchAll(PDO::FETCH_ASSOC);


// ==========================================
// ✅ 4. ЗАПРОСЫ ДАННЫХ
// ==========================================
if ($role === 'client') {

    $title = "Мои консультации";

    $query = $pdo->prepare("
        SELECT 
            a.appointment_id,
            c.first_name AS client_first_name,
            c.last_name AS client_last_name,
            p.first_name AS psychologist_first_name,
            p.last_name AS psychologist_last_name,
            p.phone AS psychologist_phone,
            p.photo AS psychologist_photo,
            s.datetime_from,
            s.datetime_to
        FROM appointments a
        JOIN schedule s ON a.schedule_id = s.schedule_id
        JOIN users c ON a.client_id = c.user_id
        JOIN users p ON s.psychologist_id = p.user_id
        WHERE a.client_id = ?
        ORDER BY s.datetime_from DESC
    ");

} else {

    $title = "Мои клиенты и консультации";

    $query = $pdo->prepare("
        SELECT 
            a.appointment_id,
            c.first_name AS client_first_name,
            c.last_name AS client_last_name,
            c.phone AS client_phone,
            s.datetime_from,
            s.datetime_to,
            a.topic,
            a.notes
        FROM appointments a
        JOIN schedule s ON a.schedule_id = s.schedule_id
        JOIN users c ON a.client_id = c.user_id
        WHERE s.psychologist_id = ?
        ORDER BY s.datetime_from DESC
    ");
}

$query->execute([$user_id]);
$data = $query->fetchAll(PDO::FETCH_ASSOC);
?>


<!DOCTYPE html>
<html>
<head>
    <title>Консультации</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">

    <!-- ========================================== -->
    <!-- ✅ ВЕРХНИЙ БЛОК (ПРОФИЛЬ) -->
    <!-- ========================================== -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body d-flex justify-content-between align-items-center">

            <!-- Левая часть -->
            <div class="d-flex align-items-center">

                <!-- Фото психолога -->
                <?php if ($role === 'psychologist'): ?>
                    <div class="me-3">
                        <?php if (!empty($_SESSION['user']['photo'])): ?>
                            <img src="<?= $_SESSION['user']['photo'] ?>" 
                                 width="70" height="70"
                                 style="object-fit: cover; border-radius: 50%;">
                        <?php else: ?>
                            <div style="
                                width:70px;
                                height:70px;
                                border-radius:50%;
                                background:#ccc;
                                display:flex;
                                align-items:center;
                                justify-content:center;
                            ">
                                👤
                            </div>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>

                <!-- Имя -->
                <div>
                    <h5 class="mb-0"><?= $name ?></h5>
                    <small>
                        Роль: 
                        <strong><?= $role === 'client' ? 'Клиент' : 'Психолог' ?></strong>
                    </small>
                </div>
            </div>

            <!-- Правая часть -->
            <div class="text-end">

                <!-- Загрузка фото -->
                <?php if ($role === 'psychologist'): ?>
                    <form method="POST" enctype="multipart/form-data" class="mb-2">
                        <input type="file" name="photo" class="form-control form-control-sm mb-1" required>
                        <button type="submit" name="upload_photo" class="btn btn-sm btn-primary w-100">
                            Сменить фото
                        </button>
                    </form>
                <?php endif; ?>

                <a href="logout.php" class="btn btn-danger btn-sm">Выйти</a>
            </div>

        </div>
    </div>

    <h2><?= $title ?></h2>

    <!-- ========================================== -->
    <!-- ✅ ФОРМА (ТОЛЬКО ДЛЯ ПСИХОЛОГА) -->
    <!-- ========================================== -->
    <?php if ($role === 'psychologist'): ?>
    <div class="card mb-4 shadow-sm">
        <div class="card-body">

            <h4>Назначить консультацию</h4>

            <form method="POST">
                <div class="row">

                    <div class="col-md-4">
                        <label>Клиент</label>
                        <select name="client_id" class="form-select" required>
                            <option value="">Выберите</option>
                            <?php foreach ($clients as $client): ?>
                                <option value="<?= $client['user_id'] ?>">
                                    <?= $client['first_name'] ?> <?= $client['last_name'] ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label>Дата начала</label>
                        <input type="datetime-local" name="datetime_from" class="form-control" required>
                    </div>

                    <div class="col-md-4">
                        <label>Дата окончания</label>
                        <input type="datetime-local" name="datetime_to" class="form-control" required>
                    </div>

                    <div class="col-md-4 mt-3">
                        <label>Тема</label>
                        <input type="text" name="topic" class="form-control" required>
                    </div>

                    <div class="col-md-12 mt-3">
                        <label>Дополнительные заметки</label>
                        <textarea name="notes" class="form-control" rows="3"></textarea>
                    </div>

                </div>

                <button type="submit" name="add" class="btn btn-success mt-3">
                    Добавить
                </button>
            </form>

        </div>
    </div>
    <?php endif; ?>


    <!-- ========================================== -->
    <!-- ✅ ТАБЛИЦА -->
    <!-- ========================================== -->
    <table class="table table-bordered">

        <thead class="table-dark">
            <tr>

                <th>Клиент</th>

                <?php if ($role === 'client'): ?>
                    <th>Психолог</th>
                    <th>Телефон психолога</th>
                    <th>Фото</th>
                <?php else: ?>
                    <th>Телефон клиента</th>
                <?php endif; ?>

                <th>Начало</th>
                <th>Конец</th>

                <?php if ($role === 'psychologist'): ?>
                    <th>Тема</th>
                    <th>Заметки</th>
                    <th>Действие</th>
                <?php endif; ?>

            </tr>
        </thead>

        <tbody>
        <?php foreach ($data as $row): ?>
            <tr>

                <td>
                    <?= $row['client_first_name'] ?> <?= $row['client_last_name'] ?>
                </td>

                <?php if ($role === 'client'): ?>

                    <td>
                        <?= $row['psychologist_first_name'] ?> <?= $row['psychologist_last_name'] ?>
                    </td>

                    <td>
                        <?= $row['psychologist_phone'] ?>
                    </td>

                    <td>
                        <?php if ($row['psychologist_photo']): ?>
                            <img src="<?= $row['psychologist_photo'] ?>" 
                                 width="70" height="70"
                                 style="object-fit: cover; border-radius: 10px;">
                        <?php else: ?>
                            -
                        <?php endif; ?>
                    </td>

                <?php else: ?>

                    <td>
                        <?= $row['client_phone'] ?>
                    </td>

                <?php endif; ?>

                <td><?= $row['datetime_from'] ?></td>
                <td><?= $row['datetime_to'] ?></td>

                <?php if ($role === 'psychologist'): ?>

                    <td><?= $row['topic'] ?></td>
                    <td><?= $row['notes'] ?: '-' ?></td>

                    <td>
                        <a href="delete.php?id=<?= $row['appointment_id'] ?>" 
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Удалить?')">
                           Удалить
                        </a>
                    </td>

                <?php endif; ?>

            </tr>
        <?php endforeach; ?>
        </tbody>

    </table>

</div>

</body>
</html>