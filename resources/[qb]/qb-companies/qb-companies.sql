CREATE TABLE `companies` (
  `name` tinytext DEFAULT NULL,
  `label` tinytext DEFAULT NULL,
  `owner` tinytext DEFAULT NULL,
  `employees` tinytext DEFAULT NULL,
  `money` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;