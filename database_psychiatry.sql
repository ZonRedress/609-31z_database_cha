-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 14 2025 г., 17:04
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
  `schedule_id` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL COMMENT '1 - запланирована, 2 - завершена',
  `topic` varchar(255) DEFAULT NULL COMMENT 'Тема консультации',
  `notes` text COMMENT 'Дополнительные заметки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Бронирования консультаций';

--
-- Дамп данных таблицы `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `client_id`, `schedule_id`, `status`, `topic`, `notes`) VALUES
(1, 1, 1, 1, 'Стресс на работе', 'Клиент жалуется на хроническую усталость.'),
(2, 2, 3, 2, 'Проблемы в отношениях', 'Консультация завершена, предложены упражнения.'),
(3, 3, 5, 1, 'Тревожность', 'Обсуждение источников тревоги и дыхательные практики.'),
(4, 1, 2, 1, 'Неуверенность в себе', 'Проработка детских комплексов, назначена повторная встреча.'),
(5, 2, 4, 1, 'Карьерный кризис', 'Выявлены страхи перемен, даны рекомендации.'),
(6, 3, 6, 2, 'Посттравматическое восстановление', 'Завершен первый этап терапии.');

-- --------------------------------------------------------

--
-- Структура таблицы `schedule`
--

CREATE TABLE `schedule` (
  `schedule_id` int(11) NOT NULL,
  `psychologist_id` int(11) NOT NULL,
  `datetime_from` datetime NOT NULL COMMENT 'Дата и время начала слота',
  `datetime_to` datetime NOT NULL COMMENT 'Дата и время окончания слота',
  `status` enum('free','booked') DEFAULT 'free' COMMENT 'Статус слота'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Расписание доступных временных слотов психологов';

--
-- Дамп данных таблицы `schedule`
--

INSERT INTO `schedule` (`schedule_id`, `psychologist_id`, `datetime_from`, `datetime_to`, `status`) VALUES
(1, 4, '2025-04-15 10:00:00', '2025-04-15 11:00:00', 'booked'),
(2, 4, '2025-04-15 12:00:00', '2025-04-15 13:00:00', 'free'),
(3, 5, '2025-04-16 09:00:00', '2025-04-16 10:00:00', 'booked'),
(4, 5, '2025-04-16 11:00:00', '2025-04-16 12:00:00', 'free'),
(5, 6, '2025-04-17 15:00:00', '2025-04-17 16:00:00', 'booked'),
(6, 6, '2025-04-17 17:00:00', '2025-04-17 18:00:00', 'free');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL COMMENT 'Имя пользователя',
  `last_name` varchar(50) NOT NULL COMMENT 'Фамилия пользователя',
  `email` varchar(100) NOT NULL COMMENT 'Email пользователя',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Телефон пользователя',
  `role` enum('client','psychologist') NOT NULL COMMENT 'Роль пользователя: клиент или психолог'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Общая таблица пользователей системы';

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone`, `role`) VALUES
(1, 'Иван', 'Петров', 'ivan.petrov@example.com', '+79001112233', 'client'),
(2, 'Мария', 'Сидорова', 'maria.sidorova@example.com', '+79003445566', 'client'),
(3, 'Алексей', 'Кузнецов', 'aleksey.kuznecov@example.com', '+79007778899', 'client'),
(4, 'Елена', 'Иванова', 'elena.ivanova@example.com', '+79000001111', 'psychologist'),
(5, 'Дмитрий', 'Орлов', 'd.orlov@example.com', '+79002223344', 'psychologist'),
(6, 'Светлана', 'Миронова', 'svetlana.mironova@example.com', '+79005556677', 'psychologist');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `schedule_id` (`schedule_id`);

--
-- Индексы таблицы `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `psychologist_id` (`psychologist_id`);

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
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `schedule`
--
ALTER TABLE `schedule`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`schedule_id`);

--
-- Ограничения внешнего ключа таблицы `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`psychologist_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
