-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 14 2025 г., 10:37
-- Версия сервера: 5.7.33
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `609-31z_cda`
--

-- --------------------------------------------------------

--
-- Структура таблицы `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `psychologist_id` int(11) NOT NULL,
  `appointment_datetime` datetime NOT NULL COMMENT 'Дата и время консультации',
  `status` enum('scheduled','completed','cancelled') DEFAULT 'scheduled' COMMENT 'Статус консультации',
  `topic` varchar(255) DEFAULT NULL COMMENT 'Тема консультации',
  `notes` text COMMENT 'Дополнительные заметки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Бронирования консультаций';

--
-- Дамп данных таблицы `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `client_id`, `psychologist_id`, `appointment_datetime`, `status`, `topic`, `notes`) VALUES
(1, 1, 1, '2025-04-16 11:00:00', 'scheduled', 'Семейные конфликты', 'Повторный приём.'),
(2, 2, 2, '2025-04-17 16:00:00', 'completed', 'Тревожность на работе', 'Обсудили техники релаксации.'),
(3, 3, 1, '2025-04-18 10:00:00', 'cancelled', 'Развод и дети', 'Клиент отменил за день.'),
(4, 2, 2, '2025-04-17 15:00:00', 'scheduled', 'Панические атаки', NULL),
(5, 1, 2, '2025-04-17 14:00:00', 'scheduled', 'Проблемы общения', 'Новая тема.');

-- --------------------------------------------------------

--
-- Структура таблицы `availability`
--

CREATE TABLE `availability` (
  `availability_id` int(11) NOT NULL,
  `psychologist_id` int(11) NOT NULL,
  `date` date NOT NULL COMMENT 'Дата доступности',
  `time_from` time NOT NULL COMMENT 'Начало интервала',
  `time_to` time NOT NULL COMMENT 'Конец интервала',
  `status` enum('free','booked') DEFAULT 'free' COMMENT 'Статус слота'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Доступные временные слоты психологов';

--
-- Дамп данных таблицы `availability`
--

INSERT INTO `availability` (`availability_id`, `psychologist_id`, `date`, `time_from`, `time_to`, `status`) VALUES
(1, 1, '2025-04-16', '10:00:00', '11:00:00', 'free'),
(2, 1, '2025-04-16', '11:00:00', '12:00:00', 'booked'),
(3, 2, '2025-04-17', '14:00:00', '15:00:00', 'free'),
(4, 2, '2025-04-17', '15:00:00', '16:00:00', 'free'),
(5, 2, '2025-04-17', '16:00:00', '17:00:00', 'booked');

-- --------------------------------------------------------

--
-- Структура таблицы `clients`
--

CREATE TABLE `clients` (
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `birth_date` date DEFAULT NULL COMMENT 'Дата рождения клиента'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Данные о клиентах';

--
-- Дамп данных таблицы `clients`
--

INSERT INTO `clients` (`client_id`, `user_id`, `birth_date`) VALUES
(1, 1, '1990-04-15'),
(2, 2, '1985-10-20'),
(3, 5, '2000-07-09');

-- --------------------------------------------------------

--
-- Структура таблицы `psychologists`
--

CREATE TABLE `psychologists` (
  `psychologist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `specialization` varchar(255) DEFAULT NULL COMMENT 'Специализация психолога',
  `experience_years` int(11) DEFAULT NULL COMMENT 'Опыт работы (в годах)',
  `bio` text COMMENT 'Краткое описание или биография'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Данные о психологах';

--
-- Дамп данных таблицы `psychologists`
--

INSERT INTO `psychologists` (`psychologist_id`, `user_id`, `specialization`, `experience_years`, `bio`) VALUES
(1, 3, 'Семейная терапия', 7, 'Опытный специалист в области семейных отношений.'),
(2, 4, 'Когнитивно-поведенческая терапия', 5, 'Помогаю справляться с тревожностью и стрессом.');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) NOT NULL COMMENT 'Имя пользователя',
  `last_name` varchar(255) NOT NULL COMMENT 'Фамилия пользователя',
  `email` varchar(255) NOT NULL COMMENT 'Email пользователя',
  `phone` varchar(255) DEFAULT NULL COMMENT 'Телефон пользователя',
  `role` enum('client','psychologist') NOT NULL COMMENT 'Роль пользователя: клиент или психолог'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Общая таблица пользователей системы';

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone`, `role`) VALUES
(1, 'Иван', 'Петров', 'ivan.petrov@mail.com', '+79161234567', 'client'),
(2, 'Ольга', 'Сидорова', 'olga.sidorova@mail.com', '+79161234568', 'client'),
(3, 'Анна', 'Кузнецова', 'anna.kuz@mail.com', '+79161234569', 'psychologist'),
(4, 'Мария', 'Иванова', 'maria.ivanova@mail.com', '+79161234570', 'psychologist'),
(5, 'Павел', 'Орлов', 'pavel.orlov@mail.com', '+79161234571', 'client');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `psychologist_id` (`psychologist_id`);

--
-- Индексы таблицы `availability`
--
ALTER TABLE `availability`
  ADD PRIMARY KEY (`availability_id`),
  ADD KEY `psychologist_id` (`psychologist_id`);

--
-- Индексы таблицы `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`client_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `psychologists`
--
ALTER TABLE `psychologists`
  ADD PRIMARY KEY (`psychologist_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `availability`
--
ALTER TABLE `availability`
  MODIFY `availability_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `clients`
--
ALTER TABLE `clients`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `psychologists`
--
ALTER TABLE `psychologists`
  MODIFY `psychologist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`),
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`psychologist_id`) REFERENCES `psychologists` (`psychologist_id`);

--
-- Ограничения внешнего ключа таблицы `availability`
--
ALTER TABLE `availability`
  ADD CONSTRAINT `availability_ibfk_1` FOREIGN KEY (`psychologist_id`) REFERENCES `psychologists` (`psychologist_id`);

--
-- Ограничения внешнего ключа таблицы `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Ограничения внешнего ключа таблицы `psychologists`
--
ALTER TABLE `psychologists`
  ADD CONSTRAINT `psychologists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
