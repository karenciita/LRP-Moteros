INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_moteros','moteros',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_moteros','moteros',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_moteros', 'moteros', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('moteros', 'Moteros', 1);

 
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('moteros', 0, 'Iniciante', 'Iniciante', 1500, '{}', '{}'),
('moterosr', 1, 'Integrante', 'Integrante', 1800, '{}', '{}'),
('moteros', 2, 'Miembro', 'Miembro', 2100, '{}', '{}'),
('moteros', 3, 'boss', 'Lider', 2700, '{}', '{}');

CREATE TABLE `fine_types_moteros` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  
  PRIMARY KEY (`id`)
);

INSERT INTO `fine_types_moteros` (label, amount, category) VALUES 
	('extersion 1',3000,0),
	('extersion 2',5000,0)
;