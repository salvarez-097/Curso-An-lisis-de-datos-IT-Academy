-- Nivel 1
-- Ejercicio 1
-- Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas de crédito. La nueva tabla debe ser capaz de identificar 
-- de forma única cada tarjeta y establecer una relación adecuada con las otras dos tablas ("transaction" y "company"). Después de crear la tabla será necesario que 
-- ingreses la información del documento denominado "datos_introducir_credit". Recuerda mostrar el diagrama y realizar una breve descripción del mismo.

-- Se crea la tabla credit_card
create table if not exists credit_card (
	id varchar(255) primary key not null,
    iban varchar(255),
    pan varchar(255),
    pin varchar(255),
    cvv varchar(255),
    expiring_date varchar(255)
);

-- Se ejecuta el archivo datos_introducir_sprint3_credit.sql

-- Se comprueba la longitud de los campos 
select max(length(id)) as longitud_id from credit_card;

select max(length(iban)) as longitud_iban from credit_card;

select max(length(pan)) as longitud_pan from credit_card;

select max(length(pin)) as longitud_pin from credit_card;

select max(length(cvv)) as longitud_cvv from credit_card;

select max(length(expiring_date)) as longitud_fecha_expiracion from credit_card;

-- Comprobacion de la tabla credit_card
describe credit_card;

-- Modificacion campos tabla credit_card
alter table credit_card
modify id varchar(8);

alter table credit_card
modify iban varchar(31);

alter table credit_card
modify pan varchar(19);

alter table credit_card
modify pin varchar(4);

alter table credit_card
modify cvv varchar(3);

-- Transformacion campo expiring_date a tipo date
UPDATE credit_card
SET credit_card.expiring_date =
    LAST_DAY(
        STR_TO_DATE(credit_card.expiring_date, '%m/%d/%y')
    )
limit 6000;

alter table credit_card
modify expiring_date date;

-- Comprobacion nuevamente de la tabla credit_card
describe credit_card;

-- Declaracion clave foranea credit_card ej transaction
alter table transaction
add constraint fk_credit_card_id
foreign key (credit_card_id)
references credit_card(id);

-- Ejercicio 2
-- El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado a su tarjeta de crédito con ID CcU-2938. 
-- La información que debe mostrarse para este registro es: TR323456312213576817699999. Recuerda mostrar que el cambio se realizó

-- Comprobacion de datos
select * from credit_card
where id = "CcU-2938";

-- Actualización de datos
update credit_card
set iban = "TR323456312213576817699999"
where id = "CcU-2938";

-- Comprobación nuevamente de datos
select * from credit_card
where id = "CcU-2938";

-- Ejercicio 3
-- En la tabla "transaction" ingresa una nueva transacción con la siguiente información:
-- Id 				108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id 	CcU-9999
-- company_id 		b-9999
-- user_id 			9999
-- lato				829.999
-- longitud 		-117.999
-- amunt 			111.11
-- declined 		0
-- HAY ALGUNOS CAMPOS MAL ESCRITOS EN LA TABLA (lato , longitud y amunt, serian lat, longitude y amount) Y FALTA timestamp

-- Query para insertar datos en la tabla transaction (causa error por calve foranea y falta de datos)
insert into transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestmp, amount, declined) values
("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", "9999", "829.999", "-117.999", "2024-08-14 12:24:25", "111.11", "0");

-- Query para insertar datos en la tabla credit_card
INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) VALUES
('CcU-9999', 'TR357681763013866195031221', '5424646668135533', '3585', '458', '2023-10-31');

-- Comprobacion de que se ha insertado bien el nuevo registro en la tabla credit_card
select * from credit_card
where id = "CcU-9999";

-- Query para insertar datos en la tabla company
INSERT INTO Company (id, company_name, phone, email, country, website) VALUES
('b-9999', 'Garden Smith Corp.', '07 45 87 32 28', 'garden.smith@protonmail.couk', 'United States', 'https://gardensmith.com');

-- Comprobacion de que se ha insertado bien el nuevo registro en la tabla company
select * from company
where id = "b-9999";

-- Query para insertar nuevanente datos en la tabla transaction (ahora no causa error por calve foranea ni falta de datos)
insert into transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) values 
("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", "9999", "829.999", "-117.999", "2024-08-14 12:24:25", "111.11", "0");

-- Comprobacion de que se ha insertado bien el nuevo registro en la tabla transaction
select *
from transaction
where id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";

-- Ejercicio 4
-- Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el cambio realizado.

-- Comprobacion de la existencia de la columna pan
select *
from credit_card;

-- Eliminacion de la columna pan
alter table credit_card drop column pan;

-- Comprobacion de nuevo para verificar la eliminacion de la columna pan
select *
from credit_card;

-- Nivel 2
-- Ejercicio 1
-- Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.

-- Comprobación de la existencia del dato
select *
from transaction 
where id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

-- Eliminación del dato
delete from transaction
where id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

-- Comprobación de la eliminacion exitosa del dato
select *
from transaction 
where id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

-- Ejercicio 2
-- La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
-- Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
-- Será necesario que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. Teléfono de contacto. 
-- País de residencia. Media de compra realizada por cada compañía. Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.

-- Creacion de la vista con create view y query en la que se selecciona lo solicitado por la sección de marketing
create view VistaMarketing as
select company_name as nombreCompañia, phone as telefonoContacto, country as paisResidencia, round(avg(amount), 2) as mediaCompras
from company
join transaction 
on company.id = transaction.company_id
group by company_name, phone, country
order by mediaCompras desc;

-- Visualización de la vista
select * from vistamarketing;

-- Ejercicio 3
-- Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"
select * 
from vistamarketing
where paisResidencia = "Germany";

-- Nivel 3
-- Ejercicio 1
-- La próxima semana tendrás una nueva reunión con los gerentes de marketing. Un compañero de tu equipo realizó modificaciones en la base de datos, 
-- pero no recuerda cómo las realizó. Te pide que le ayudes a dejar los comandos ejecutados para obtener el siguiente diagrama:

-- Eliminación columna website de la tabla company
alter table company
drop column website;

-- Eliminación calve fotanea de la tabla credit_card en la tabla transaction
ALTER TABLE transaction
DROP FOREIGN KEY fk_credit_card_id;

-- Cambios de tipos de datos y longitudes
alter table credit_card
modify id varchar(20);

alter table credit_card
modify iban varchar(50);

alter table credit_card
modify pin varchar(4);

alter table credit_card
modify cvv int;

alter table credit_card
modify expiring_date varchar(255);

-- Creación columna nueva fecha_actual
alter table credit_card
add fecha_actual date default (current_date);

-- Creación tabla users
CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

select *from users;

-- Inserción datos datos introducir sprint3 user.sql 

-- Modificación de datos y longitudes
alter table transaction
modify user_id int;

alter table user
modify id int;

alter table transaction
modify credit_card_id varchar(20);

-- Se renombra la tabla user por data_user
alter table user rename to data_user;

-- Se renombra en campo email (de la tabla data_user) por personal_email
alter table data_user
rename column email to personal_email; 

-- Se definen las claves foraneas de la tabla credit_card y data_user en la tabla transaction
alter table transaction
add constraint fk_credit_card_id
foreign key (credit_card_id)
references credit_card(id);

-- Da error por inexistenica de datos en ambas tablas
alter table transaction
add constraint fk_data_user_id
foreign key (user_id)
references data_user(id);

-- Se comprueba la existencia del usuario 9999 en la tabla transaction y en la tabla data_user (solo existe en la tabla transaction)
select *
from transaction
where user_id = "9999";

select *
from data_user
where id = "9999";

-- Se añade el usuario que falta en la tabla data_user
insert into data_user (id, name, surname, phone, email, birth_date, country, city, postal_code, address) VALUES 
("9999", "lzxjnvlj", ",mxsfknw", "+39-478-3548", "asgaxisdgsi@example.com", "Jan 15, 1989", "Canada", "Winnipeg", "R2C 0A1", "284 Btardzti St");

-- Se comprueba que se ha añadido bien el usuario 9999 en la tabla data_user
select *
from data_user
where id = "9999";

-- Se declara de nuevo la clave foranea de data_user en transaction
alter table transaction
add constraint fk_data_user_id
foreign key (user_id)
references data_user(id);

-- Ejercicio 2
-- La empresa también le pide crear una vista llamada "InformeTecnico" que contenga la siguiente información:
-- ID de la transacción
-- Nombre del usuario/a
-- Apellido del usuario/a
-- IBAN de la tarjeta de crédito usada.
-- Nombre de la compañía de la transacción realizada.
-- Asegúrese de incluir información relevante de las tablas que conocerá y utilice alias para cambiar de nombre columnas según sea necesario.
-- Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.

-- Se crea la vista con create view y se seleccionan los campos requeridos con join entre todas las tablas para poder obtener todos los datos solicitados
create view InformeTecnico as
select t.id as identificador, du.name as nombre_usuario, du.surname as apellido_usuario, cc.iban, c.company_name as nombre_compañia, c.phone as telefonoCompañia
from credit_card cc
join transaction t
on cc.id = t.credit_card_id
join data_user du
on t.user_id = du.id
join company c
on t.company_id = c.id;

select * from informetecnico
order by identificador desc;