-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 14 2025 г., 16:12
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
-- База данных: `609-31z_database`
--

-- --------------------------------------------------------

--
-- Структура таблицы `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `appointment_datetime` datetime NOT NULL COMMENT 'Дата и время консультации',
  `status` tinyint(4) NOT NULL COMMENT '1 - запланирована, 2 - завершена',
  `topic` varchar(255) DEFAULT NULL COMMENT 'Тема консультации',
  `notes` text COMMENT 'Дополнительные заметки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Бронирования консультаций';

--
-- Дамп данных таблицы `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `client_id`, `schedule_id`, `appointment_datetime`, `status`, `topic`, `notes`) VALUES
(1, 1, 2, '2025-04-15 11:00:00', 1, 'Проблемы на работе', 'Клиент испытывает стресс.'),
(2, 2, 3, '2025-04-16 09:00:00', 2, 'Семейные отношения', 'Завершена. Обсуждение конфликта.'),
(3, 3, 6, '2025-04-17 14:00:00', 1, 'Тревожность', 'Требуется дополнительное наблюдение.'),
(4, 1, 3, '2025-04-10 15:00:00', 2, 'Переезд и адаптация', 'Обсуждение переезда в другой город.'),
(5, 2, 6, '2025-04-13 13:00:00', 2, 'Страх публичных выступлений', 'Рекомендована практика.'),
(6, 3, 2, '2025-04-11 12:00:00', 1, 'Прокрастинация', 'Обсуждение причин откладывания дел.');

-- --------------------------------------------------------

--
-- Структура таблицы `schedule`
--

CREATE TABLE `schedule` (
  `schedule_id` int(11) NOT NULL,
  `psychologist_id` int(11) NOT NULL,
  `date` date NOT NULL COMMENT 'Дата доступности',
  `time_from` time NOT NULL COMMENT 'Начало интервала',
  `time_to` time NOT NULL COMMENT 'Конец интервала',
  `status` enum('free','booked') DEFAULT 'free' COMMENT 'Статус слота'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Расписание доступных временных слотов психологов';

--
-- Дамп данных таблицы `schedule`
--

INSERT INTO `schedule` (`schedule_id`, `psychologist_id`, `date`, `time_from`, `time_to`, `status`) VALUES
(1, 4, '2025-04-15', '10:00:00', '11:00:00', 'free'),
(2, 4, '2025-04-15', '11:00:00', '12:00:00', 'booked'),
(3, 5, '2025-04-16', '09:00:00', '10:00:00', 'booked'),
(4, 5, '2025-04-16', '10:00:00', '11:00:00', 'free'),
(5, 6, '2025-04-17', '13:00:00', '14:00:00', 'free'),
(6, 6, '2025-04-17', '14:00:00', '15:00:00', 'booked');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Общая таблица пользователей системы';

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone`, `role`) VALUES
(1, 'Иван', 'Иванов', 'ivanov@mail.ru', '79001112233', 'client'),
(2, 'Мария', 'Сидорова', 'sidorova@mail.ru', '79002223344', 'client'),
(3, 'Анна', 'Козлова', 'kozlova@mail.ru', '79003334455', 'client'),
(4, 'Олег', 'Смирнов', 'smirnov@mail.ru', '79004445566', 'psychologist'),
(5, 'Екатерина', 'Орлова', 'orlova@mail.ru', '79005556677', 'psychologist'),
(6, 'Артем', 'Белов', 'belov@mail.ru', '79006667788', 'psychologist');

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
