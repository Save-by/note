/*
SQLyog Ultimate v11.33 (64 bit)
MySQL - 8.0.19 : Database - test
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`test` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `test`;

/*Table structure for table `t_course` */

DROP TABLE IF EXISTS `t_course`;

CREATE TABLE `t_course` (
  `course_id` int NOT NULL,
  `name` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `examination_start_time` datetime NOT NULL,
  `examination_length` time NOT NULL,
  PRIMARY KEY (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_course` */

/*Table structure for table `t_r_cour_room` */

DROP TABLE IF EXISTS `t_r_cour_room`;

CREATE TABLE `t_r_cour_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `room_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `t_r_cour_room_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `t_room` (`room_id`),
  CONSTRAINT `t_r_cour_room_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_r_cour_room` */

/*Table structure for table `t_r_stu_room` */

DROP TABLE IF EXISTS `t_r_stu_room`;

CREATE TABLE `t_r_stu_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `room_id` int NOT NULL,
  `position_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `t_r_stu_room_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `t_student` (`student_id`),
  CONSTRAINT `t_r_stu_room_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `t_room` (`room_id`),
  CONSTRAINT `t_r_stu_room_ibfk_3` FOREIGN KEY (`room_id`) REFERENCES `t_room` (`room_id`),
  CONSTRAINT `t_r_stu_room_ibfk_4` FOREIGN KEY (`room_id`) REFERENCES `t_room` (`room_id`),
  CONSTRAINT `t_r_stu_room_ibfk_5` FOREIGN KEY (`room_id`) REFERENCES `t_room` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_r_stu_room` */

/*Table structure for table `t_r_teac_cour` */

DROP TABLE IF EXISTS `t_r_teac_cour`;

CREATE TABLE `t_r_teac_cour` (
  `id` int NOT NULL AUTO_INCREMENT,
  `work_id` int NOT NULL,
  `course_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `work_id` (`work_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `t_r_teac_cour_ibfk_1` FOREIGN KEY (`work_id`) REFERENCES `t_teacher` (`work_id`),
  CONSTRAINT `t_r_teac_cour_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_r_teac_cour` */

/*Table structure for table `t_r_teac_room` */

DROP TABLE IF EXISTS `t_r_teac_room`;

CREATE TABLE `t_r_teac_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `work_id` int NOT NULL,
  `room_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`),
  KEY `work_id` (`work_id`),
  CONSTRAINT `t_r_teac_room_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `t_room` (`room_id`),
  CONSTRAINT `t_r_teac_room_ibfk_2` FOREIGN KEY (`work_id`) REFERENCES `t_teacher` (`work_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_r_teac_room` */

/*Table structure for table `t_room` */

DROP TABLE IF EXISTS `t_room`;

CREATE TABLE `t_room` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `conference_number` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `link` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `software_name` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_room` */

/*Table structure for table `t_student` */

DROP TABLE IF EXISTS `t_student`;

CREATE TABLE `t_student` (
  `student_id` int NOT NULL,
  `name` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `college` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `grade` int NOT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_student` */

/*Table structure for table `t_teacher` */

DROP TABLE IF EXISTS `t_teacher`;

CREATE TABLE `t_teacher` (
  `work_id` int NOT NULL,
  `name` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `college` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`work_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_teacher` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
