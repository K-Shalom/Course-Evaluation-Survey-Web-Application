-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 18, 2026 at 03:06 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `course_evaluation_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `credits` int(11) NOT NULL DEFAULT 3,
  `department` varchar(150) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `code`, `name`, `description`, `credits`, `department`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'CS901', 'Backend by using Java', 'twyuwekwedmwdsmsbdhs sljsuiwd', 5, 'Information Technology', 1, 1, '2026-03-18 11:23:37', '2026-03-18 11:24:50');

-- --------------------------------------------------------

--
-- Table structure for table `respondents`
--

CREATE TABLE `respondents` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `display_name` varchar(200) DEFAULT NULL,
  `respondent_type` enum('STUDENT','GUEST') NOT NULL DEFAULT 'GUEST',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `respondents`
--

INSERT INTO `respondents` (`id`, `user_id`, `email`, `display_name`, `respondent_type`, `created_at`) VALUES
(1, 14, 'ukwishaka36@gmail.com', 'Ukwishaka  Ezechiel ', 'STUDENT', '2026-03-18 13:14:34'),
(2, NULL, 'clarisseuwimana31@gmail.com', 'clarisse', 'GUEST', '2026-03-18 14:48:47');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'ADMIN', 'System administrator with full access'),
(2, 'INITIATOR', 'Designs and publishes evaluation surveys'),
(3, 'TEACHER', 'Linked to courses; monitors survey participation'),
(4, 'RESPONDENT', 'Student or guest who answers surveys');

-- --------------------------------------------------------

--
-- Table structure for table `surveys`
--

CREATE TABLE `surveys` (
  `id` int(11) NOT NULL,
  `title` varchar(300) NOT NULL,
  `description` text DEFAULT NULL,
  `course_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `status` enum('DRAFT','ACTIVE','CLOSED','ARCHIVED') NOT NULL DEFAULT 'DRAFT',
  `access_type` enum('AUTHENTICATED','GUEST','BOTH') NOT NULL DEFAULT 'BOTH',
  `require_email` tinyint(1) NOT NULL DEFAULT 1,
  `send_confirmation` tinyint(1) NOT NULL DEFAULT 1,
  `allow_anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `surveys`
--

INSERT INTO `surveys` (`id`, `title`, `description`, `course_id`, `created_by`, `status`, `access_type`, `require_email`, `send_confirmation`, `allow_anonymous`, `start_date`, `end_date`, `created_at`, `updated_at`) VALUES
(4, 'java survey', 'test survey', 1, 12, 'ACTIVE', 'BOTH', 1, 1, 0, '2026-03-18 12:03:00', '2026-03-19 12:03:00', '2026-03-18 14:03:25', '2026-03-18 15:04:01');

-- --------------------------------------------------------

--
-- Table structure for table `survey_options`
--

CREATE TABLE `survey_options` (
  `id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `option_text` varchar(500) NOT NULL,
  `order_index` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `survey_options`
--

INSERT INTO `survey_options` (`id`, `question_id`, `option_text`, `order_index`) VALUES
(6, 8, 'OOP', 0),
(7, 8, 'Exception Handling', 1),
(8, 8, 'Collections Framework', 2),
(9, 9, 'Eclipse', 0),
(10, 9, 'IntelliJ IDEA', 1),
(11, 9, 'NetBeans', 2),
(12, 10, '1', 0),
(13, 10, '2', 1),
(14, 10, '3', 2),
(15, 10, '4', 3),
(16, 10, '5', 4),
(17, 11, 'Yes', 0),
(18, 11, 'No', 1);

-- --------------------------------------------------------

--
-- Table structure for table `survey_questions`
--

CREATE TABLE `survey_questions` (
  `id` int(11) NOT NULL,
  `survey_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('SINGLE_CHOICE','MULTIPLE_CHOICE','TEXT','RATING','YES_NO') NOT NULL DEFAULT 'SINGLE_CHOICE',
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `order_index` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `survey_questions`
--

INSERT INTO `survey_questions` (`id`, `survey_id`, `question_text`, `question_type`, `is_required`, `order_index`) VALUES
(8, 4, 'Which Java topics did you find most difficult?', 'MULTIPLE_CHOICE', 1, 0),
(9, 4, 'Which tools did you use most?', 'SINGLE_CHOICE', 1, 1),
(10, 4, 'The course objectives were clear', 'RATING', 1, 2),
(11, 4, 'Have you used Java before this course?', 'YES_NO', 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `survey_responses`
--

CREATE TABLE `survey_responses` (
  `id` int(11) NOT NULL,
  `survey_id` int(11) NOT NULL,
  `respondent_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `answer_text` text DEFAULT NULL,
  `submission_id` varchar(36) NOT NULL,
  `submitted_at` datetime DEFAULT current_timestamp(),
  `confirmation_sent` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `survey_responses`
--

INSERT INTO `survey_responses` (`id`, `survey_id`, `respondent_id`, `question_id`, `option_id`, `answer_text`, `submission_id`, `submitted_at`, `confirmation_sent`) VALUES
(3, 4, 1, 8, 6, NULL, '659eff39-f9d6-4a3a-9d69-0adf924e08b6', '2026-03-18 14:22:51', 1),
(4, 4, 1, 8, 7, NULL, '659eff39-f9d6-4a3a-9d69-0adf924e08b6', '2026-03-18 14:22:51', 1),
(5, 4, 1, 8, 8, NULL, '659eff39-f9d6-4a3a-9d69-0adf924e08b6', '2026-03-18 14:22:51', 1),
(6, 4, 1, 9, 10, NULL, '659eff39-f9d6-4a3a-9d69-0adf924e08b6', '2026-03-18 14:22:51', 1),
(7, 4, 1, 10, 15, NULL, '659eff39-f9d6-4a3a-9d69-0adf924e08b6', '2026-03-18 14:22:51', 1),
(8, 4, 1, 11, 17, NULL, '659eff39-f9d6-4a3a-9d69-0adf924e08b6', '2026-03-18 14:22:51', 1),
(9, 4, 2, 8, 8, NULL, '160899aa-efd8-430b-969d-61b78c9076fe', '2026-03-18 14:48:47', 1),
(10, 4, 2, 9, 9, NULL, '160899aa-efd8-430b-969d-61b78c9076fe', '2026-03-18 14:48:47', 1),
(11, 4, 2, 10, 16, NULL, '160899aa-efd8-430b-969d-61b78c9076fe', '2026-03-18 14:48:47', 1),
(12, 4, 2, 11, 18, NULL, '160899aa-efd8-430b-969d-61b78c9076fe', '2026-03-18 14:48:47', 1);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `assigned_at` datetime DEFAULT current_timestamp(),
  `assigned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`id`, `user_id`, `course_id`, `assigned_at`, `assigned_by`) VALUES
(1, 13, 1, '2026-03-18 11:23:44', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `role_id` int(11) NOT NULL,
  `status` enum('PENDING','ACTIVE','REJECTED','SUSPENDED') NOT NULL DEFAULT 'PENDING',
  `email_verified` tinyint(1) NOT NULL DEFAULT 0,
  `verification_token` varchar(255) DEFAULT NULL,
  `token_expiry` datetime DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `first_name`, `last_name`, `role_id`, `status`, `email_verified`, `verification_token`, `token_expiry`, `reset_token`, `reset_token_expiry`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@ces.edu', 'admin', 'System', 'Admin', 1, 'ACTIVE', 1, NULL, NULL, NULL, NULL, '2026-03-18 00:45:55', '2026-03-18 00:45:55'),
(12, 'shalx', 'shalomkubwimbabazi@gmail.com', 'Shalx@123', 'shalom', 'MBABAZI', 2, 'ACTIVE', 1, NULL, NULL, NULL, NULL, '2026-03-18 01:21:06', '2026-03-18 01:24:01'),
(13, 'muhamadi', 'muhamadihavugimana@gmail.com', '1234Mh@#', 'muhamadi', 'H', 3, 'ACTIVE', 1, NULL, NULL, NULL, NULL, '2026-03-18 10:13:46', '2026-03-18 11:05:36'),
(14, 'ezechiel', 'ukwishaka36@gmail.com', '12345678', 'Ukwishaka ', 'Ezechiel ', 4, 'ACTIVE', 1, NULL, NULL, NULL, NULL, '2026-03-18 12:10:15', '2026-03-18 12:14:17'),
(15, 'clarisse', 'clarisseuwimana31@gmail.com', 'Shalx@123', 'Clarisse', 'Uwimana', 4, 'ACTIVE', 1, 'rD7PDM0-ldfO8lGD5wPMj_URDaW_xcEAaqlPRRJtY4M', '2026-03-19 13:09:37', NULL, NULL, '2026-03-18 15:09:38', '2026-03-18 15:10:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `respondents`
--
ALTER TABLE `respondents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `surveys`
--
ALTER TABLE `surveys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_surveys_course` (`course_id`),
  ADD KEY `idx_surveys_status` (`status`);

--
-- Indexes for table `survey_options`
--
ALTER TABLE `survey_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `survey_questions`
--
ALTER TABLE `survey_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_id` (`survey_id`);

--
-- Indexes for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `respondent_id` (`respondent_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `option_id` (`option_id`),
  ADD KEY `idx_survey_resp_sub` (`submission_id`),
  ADD KEY `idx_survey_resp_surv` (`survey_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_teacher_course` (`user_id`,`course_id`),
  ADD KEY `assigned_by` (`assigned_by`),
  ADD KEY `idx_teachers_user` (`user_id`),
  ADD KEY `idx_teachers_course` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_status` (`status`),
  ADD KEY `idx_users_role` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `respondents`
--
ALTER TABLE `respondents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `surveys`
--
ALTER TABLE `surveys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `survey_options`
--
ALTER TABLE `survey_options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `survey_questions`
--
ALTER TABLE `survey_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `survey_responses`
--
ALTER TABLE `survey_responses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `respondents`
--
ALTER TABLE `respondents`
  ADD CONSTRAINT `respondents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `surveys`
--
ALTER TABLE `surveys`
  ADD CONSTRAINT `surveys_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `surveys_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `survey_options`
--
ALTER TABLE `survey_options`
  ADD CONSTRAINT `survey_options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `survey_questions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `survey_questions`
--
ALTER TABLE `survey_questions`
  ADD CONSTRAINT `survey_questions_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD CONSTRAINT `survey_responses_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_responses_ibfk_2` FOREIGN KEY (`respondent_id`) REFERENCES `respondents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_responses_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `survey_questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_responses_ibfk_4` FOREIGN KEY (`option_id`) REFERENCES `survey_options` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teachers_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teachers_ibfk_3` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
