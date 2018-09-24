CREATE TABLE nutrition.aliment (
  al_id SERIAL NOT NULL,
  al_name varchar(50) NOT NULL,
  al_barcode varchar(255) DEFAULT NULL,
  al_hydrates decimal(4,1) NOT NULL,
  al_proteins decimal(4,1) NOT NULL,
  al_fat decimal(4,1) NOT NULL,

  PRIMARY KEY(al_id)
);

INSERT INTO nutrition.aliment (al_id, al_name, al_hydrates, al_proteins, al_fat) VALUES
(1, 'Pechuga de pollo', '10.2', '13.4', '2.2'),
(2, 'Brocoli', '10.2', '13.4', '2.2'),
(3, 'Pavo', '10.2', '13.4', '2.2'),
(4, 'Escarola', '10.2', '13.4', '2.2'),
(5, 'Manzana', '10.2', '13.4', '2.2');

CREATE TABLE nutrition.user (
  us_id SERIAL NOT NULL,
  us_password varchar(255) NOT NULL,
  us_name varchar(50) NOT NULL,
  us_mail varchar(50) NOT NULL,
  us_age INTEGER NOT NULL,
  us_weight decimal(4,1) NOT NULL,
  us_height INTEGER NOT NULL,

  PRIMARY KEY(us_id)
);

INSERT INTO nutrition.user (us_id, us_password, us_name, us_mail, us_age, us_weight, us_height) VALUES
(1, '12345', 'Manuel Martinez', 'manuel@manuel.com', 24, '69.0', 170);

CREATE TABLE nutrition.unit (
  un_id SERIAL NOT NULL,
  un_name varchar(50) NOT NULL,

  PRIMARY KEY(un_id)
);

INSERT INTO nutrition.unit (un_id, un_name) VALUES
(1, 'Loncha'),
(2, 'Unidad');

CREATE TABLE nutrition.meal_type (
  mety_id SERIAL NOT NULL,
  mety_name varchar(50) NOT NULL,

  PRIMARY KEY(mety_id)
);

INSERT INTO nutrition.meal_type (mety_id, mety_name) VALUES
(1, 'Desayuno');

CREATE TABLE nutrition.meal (
  me_id SERIAL NOT NULL,
  us_id INTEGER NOT NULL,
  mety_id INTEGER NOT NULL,
  me_date date NOT NULL,

  PRIMARY KEY(me_id),
  FOREIGN KEY(us_id) REFERENCES nutrition.user(us_id),
  FOREIGN KEY(mety_id) REFERENCES nutrition.meal_type(mety_id)
);

INSERT INTO nutrition.meal (me_id, us_id, mety_id, me_date) VALUES
(1, 1, 1, '2018-08-24');


CREATE TABLE nutrition.aliment_unit (
  al_unit_id SERIAL NOT NULL,  
  al_id INTEGER NOT NULL,
  un_id INTEGER NOT NULL,
  grams_per_unit INTEGER NOT NULL,

  PRIMARY KEY(al_unit_id),
  FOREIGN KEY(al_id) REFERENCES nutrition.aliment(al_id),
  FOREIGN KEY(un_id) REFERENCES nutrition.unit(un_id)
);

INSERT INTO nutrition.aliment_unit (al_unit_id, al_id, un_id, grams_per_unit) VALUES
(1, 1, 1, 40),
(2, 2, 1, 20),
(3, 2, 2, 150),
(4, 3, 1, 5),
(5, 4, 1, 10);

CREATE TABLE nutrition.meal_aliment (
  me_al_id SERIAL NOT NULL,
  al_id INTEGER NOT NULL,
  me_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  un_id INTEGER NOT NULL,

  PRIMARY KEY(me_al_id),
  FOREIGN KEY(al_id) REFERENCES nutrition.aliment(al_id),
  FOREIGN KEY(me_id) REFERENCES nutrition.meal(me_id),
  FOREIGN KEY(un_id) REFERENCES nutrition.unit(un_id)
);

INSERT INTO nutrition.meal_aliment (me_al_id, al_id, me_id, quantity, un_id) VALUES
(1, 2, 1, 3, 1);

CREATE TABLE nutrition.recipe (
  re_id SERIAL NOT NULL,
  us_id INTEGER NOT NULL,
  re_name VARCHAR(50) NOT NULL,
  re_person_quantity INTEGER NOT NULL,

  PRIMARY KEY(re_id),
  FOREIGN KEY(us_id) REFERENCES nutrition.user(us_id)

);

INSERT INTO nutrition.recipe (re_id, us_id, re_name, re_person_quantity) VALUES
(1, 1, 'Verduras con pollo', 4),
(2, 1, 'Verduras con pavo', 2);

CREATE TABLE nutrition.meal_recipe (
  me_re_id SERIAL NOT NULL,
  me_id INTEGER NOT NULL,
  re_id INTEGER NOT NULL,

  PRIMARY KEY(me_re_id),
  FOREIGN KEY(me_id) REFERENCES nutrition.meal(me_id),
  FOREIGN KEY(re_id) REFERENCES nutrition.recipe(re_id)
);

INSERT INTO nutrition.meal_recipe (me_re_id, me_id, re_id) VALUES
(1, 1, 1),
(2, 1, 2);

CREATE TABLE nutrition.recipe_aliment (
  re_al_id SERIAL NOT NULL,  
  al_id INTEGER NOT NULL,
  re_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  un_id INTEGER NOT NULL,

  PRIMARY KEY(re_al_id),
  FOREIGN KEY(al_id) REFERENCES nutrition.aliment(al_id),
  FOREIGN KEY(re_id) REFERENCES nutrition.recipe(re_id),
  FOREIGN KEY(un_id) REFERENCES nutrition.unit(un_id)

);

INSERT INTO nutrition.recipe_aliment (re_al_id, al_id, re_id, quantity, un_id) VALUES
(1, 1, 1, 2, 1),
(2, 2, 1, 1, 1),
(3, 3, 2, 2, 1),
(4, 4, 1, 3, 1),
(5, 4, 2, 2, 1);