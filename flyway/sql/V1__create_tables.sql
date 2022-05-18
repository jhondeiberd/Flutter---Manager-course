
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ratingdb`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0- teacher\r\n1-director',
  `profile_picture` varchar(2048) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users`  (name,email, password,type,profile_picture,is_deleted,created_at,modified_at)
VALUES
('Safal', 's@gmail.com', '$2a$10$CAcqdA7uL2yZ1WoNuB2CsOWQbXET2//.pzGSb75w3xBrOR9azvkcW', 1, '', 0, '2022-04-02 20:48:25', '2022-04-22 19:27:00'),
('Rohith', 'r@gmail.com', '$2a$10$a.M6wKCJ4yZFrNPEL0YmOukD4qAsmWr0U2N0vD62zhdiSxxvBGg6u', 0, '', 1, '2022-04-22 19:27:18', '2022-04-22 20:33:09');



--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `poll_started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `poll_ends_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_COURSE_TEACHER` FOREIGN KEY (`teacher_id`) REFERENCES users(id) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `courses` (title, description, teacher_id, is_deleted, created_at, modified_at, poll_started_at, poll_ends_at)
VALUES
('C++', 'test', 1, 0, '2022-04-14 22:30:54', '2022-04-22 19:12:48', '2022-04-14 22:30:54', NULL),
('Java', 'test', 1, 0, '2022-04-15 21:28:33', '2022-04-22 19:12:34', '2022-04-15 21:28:33', NULL),
('Python', 'test', 1, 0, '2022-04-22 20:32:25', NULL, '2022-04-22 20:32:25', NULL),
('Flutter', 'test', 1, 0, '2022-04-22 21:53:49', NULL, '2022-04-22 21:53:49', NULL);



DROP TABLE IF EXISTS `criteria`;
CREATE TABLE `criteria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  `course_id` int(11) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_CRITERIA_COURSE` FOREIGN KEY (`course_id`) REFERENCES courses(id) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `criteria`
--

INSERT INTO `criteria` (question, course_id, is_deleted, created_at, modified_at)
VALUES
('Was complete syllabus covered ?', 1, 0, '2022-04-21 18:28:56', '2022-04-21 19:26:21'),
('Were the explanations good?', 1, 0, '2022-04-21 18:30:46', '2022-04-21 19:21:03'),
('practical knowledge was given?', 1, 0, '2022-04-21 19:29:42', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `one_time_passwords`
--

DROP TABLE IF EXISTS `one_time_passwords`;
CREATE TABLE `one_time_passwords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` mediumint(9) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_COURSE_REVIEW` FOREIGN KEY (`course_id`) REFERENCES courses(id)  ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `review_ratings`
--

DROP TABLE IF EXISTS `review_ratings`;
CREATE TABLE `review_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `review_id` int(11) NOT NULL,
  `criterion_id` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_RATING_CRITERIA` FOREIGN KEY (`criterion_id`) REFERENCES criteria(id)  ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_RATING_REVIEW` FOREIGN KEY (`review_id`) REFERENCES reviews(id)  ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
