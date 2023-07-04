CREATE DATABASE workshopVargas;

USE workshopVargas;

CREATE TABLE IF NOT EXISTS workshopVargas.dominios (
	serie INT AUTO_INCREMENT,
	dominio VARCHAR(30),
    abreviatura VARCHAR(6),
    significado VARCHAR(60),     
  PRIMARY KEY (serie)
);
CREATE TABLE IF NOT EXISTS workshopVargas.usuarios (
	cod_usuario VARCHAR(6) NOT NULL,
    n_usuario VARCHAR(45) NOT NULL,
    o_clave VARCHAR(6) NOT NULL,     
    i_activo VARCHAR(1) NOT NULL,     
    id INT NOT NULL,     
    PRIMARY KEY (cod_usuario)
);
CREATE TABLE IF NOT EXISTS workshopVargas.contabilidad (
	k_codcon VARCHAR(16) NOT NULL,
    n_codcon VARCHAR(45) NOT NULL,
    i_natura VARCHAR(1) NOT NULL,
    cod_usuario VARCHAR(6) NOT NULL,
    PRIMARY KEY (k_codcon),
    CONSTRAINT fk_usuarios FOREIGN KEY (cod_usuario) REFERENCES usuarios (cod_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.tipo_documentos (
	doc_ref VARCHAR(3) NOT NULL,
    n_doc_ref VARCHAR(60) NOT NULL,
    tipo_documento VARCHAR(3) NOT NULL,
    i_efecto VARCHAR(1) NOT NULL,
    PRIMARY KEY (doc_ref)
);
CREATE TABLE IF NOT EXISTS workshopVargas.modalidades_cred (
	cod_modalidad VARCHAR(3) NOT NULL,
    n_modalidad VARCHAR(60) NOT NULL,
    i_activo VARCHAR(1) NOT NULL,
    PRIMARY KEY (cod_modalidad)
);
CREATE TABLE IF NOT EXISTS workshopVargas.tipoaso (
	tipo_aso VARCHAR(3) NOT NULL,
    n_tipoaso VARCHAR(50) NOT NULL,
    i_activo VARCHAR(1) NOT NULL,
    PRIMARY KEY (tipo_aso)
);
CREATE TABLE IF NOT EXISTS workshopVargas.pais (
	cod_pais VARCHAR(3) NOT NULL,
    n_pais VARCHAR(100) NOT NULL,
    PRIMARY KEY (cod_pais)
);
CREATE TABLE IF NOT EXISTS workshopVargas.ciudad (
	cod_ciudad VARCHAR(5) NOT NULL,
    n_ciudad VARCHAR(50) NOT NULL,
    cod_pais VARCHAR(3) NOT NULL,
    PRIMARY KEY (cod_ciudad),
    CONSTRAINT fk_ciudad_pais FOREIGN KEY (cod_pais) REFERENCES pais (cod_pais) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.cliente (
	id INT AUTO_INCREMENT,
    numdoc VARCHAR(50) NOT NULL,
    i_tipdoc VARCHAR(1) NOT NULL,
    n_apell1 VARCHAR(50) NOT NULL,
    n_apell2 VARCHAR(50) NOT NULL,
    n_nombr1 VARCHAR(50) NOT NULL,
    n_nombr2 VARCHAR(50) NOT NULL,
    n_razons VARCHAR(50),
    i_sexo VARCHAR(1) NOT NULL,
    f_nacimi DATE,
    cod_pais_nacimi VARCHAR(3) NOT NULL,
    cod_ciudad_nacimi VARCHAR(8) NOT NULL,
    cod_usuario VARCHAR(6) NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_documento (numdoc),
    CONSTRAINT fk_cliente_pais FOREIGN KEY (cod_pais_nacimi) REFERENCES pais (cod_pais) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_ciudad FOREIGN KEY (cod_ciudad_nacimi) REFERENCES ciudad (cod_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_usuario FOREIGN KEY (cod_usuario) REFERENCES usuarios (cod_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.direcciones (
	serie INT AUTO_INCREMENT,
    id INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    i_direccion VARCHAR(1) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    cod_pais VARCHAR(3) NOT NULL,
    cod_ciudad VARCHAR(8) NOT NULL,
    email VARCHAR(50) NOT NULL,
    PRIMARY KEY (serie),
    CONSTRAINT fk_cliente_direccion FOREIGN KEY (id) REFERENCES cliente (id) ON DELETE RESTRICT ON UPDATE CASCADE   
);
CREATE TABLE IF NOT EXISTS workshopVargas.empresas (
	id_nomina VARCHAR(3) NOT NULL,
    n_nomina VARCHAR(50) NOT NULL,
    i_periodicidad VARCHAR(1) NOT NULL,
    i_activo VARCHAR(1) NOT NULL,
    id INT NOT NULL,     
    PRIMARY KEY (id_nomina),
    CONSTRAINT fk_empresa_cliente FOREIGN KEY (id) REFERENCES cliente (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.asociados (
	id INT,
    numdoc VARCHAR(50) NOT NULL,
    nombres VARCHAR(200) NOT NULL,
    n_razons VARCHAR(200),
    f_afiliacion DATE NOT NULL,
    tipo_aso VARCHAR(3) NOT NULL,
    id_nomina VARCHAR(3) NOT NULL,
    i_periodicidad VARCHAR(1) NOT NULL,
    salario INT NOT NULL,
    i_estado VARCHAR(1) NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_nombres (nombres),
    INDEX idx_docu (numdoc),
    CONSTRAINT fk_asociado_cliente_num FOREIGN KEY (numdoc) REFERENCES cliente (numdoc) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_asociado_empresa FOREIGN KEY (id_nomina) REFERENCES empresas (id_nomina) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_asociado_tipoaso FOREIGN KEY (tipo_aso) REFERENCES tipoaso (tipo_aso) ON DELETE RESTRICT ON UPDATE CASCADE
    );

CREATE TABLE IF NOT EXISTS workshopVargas.ahorros (
	id_ahorro INT AUTO_INCREMENT,
    doc_ref INT NOT NULL,
    id INT NOT NULL,     
    i_periodicidad VARCHAR(1) NOT NULL,
    valor_aporte NUMERIC NOT NULL,
    porcentaje_aporte INT,
    saldo_aporte NUMERIC,
    PRIMARY KEY (id_ahorro),
    CONSTRAINT fk_ahorro_id FOREIGN KEY (id) REFERENCES asociados (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.credito (
	cod_credito INT AUTO_INCREMENT,
    id INT NOT NULL,     
    doc_ref VARCHAR(3) NOT NULL,
    fecha_credito DATE,
    cod_modalidad VARCHAR(3) NOT NULL,
    valor_credito NUMERIC NOT NULL,
    valor_cuota NUMERIC NOT NULL,
    plazo INT,
    saldo_credito INT,
    INDEX idx_credito (cod_credito),
    PRIMARY KEY (cod_credito),
    CONSTRAINT fk_credito_asociado FOREIGN KEY (id) REFERENCES asociados (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_credito_modalidad FOREIGN KEY (cod_modalidad) REFERENCES modalidades_cred (cod_modalidad) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.det_contable (
	serie INT AUTO_INCREMENT,
    tipo_documento VARCHAR(3) NOT NULL,
    k_codcon VARCHAR(16) NOT NULL,
    k_ano YEAR NOT NULL,
    cod_credito INT,
    id_otrods INT,
    n_movimi VARCHAR(40) NOT NULL,
    cr_peso NUMERIC NOT NULL,
    db_peso NUMERIC NOT NULL,
    f_movimi DATE NOT NULL,
    i_anulado VARCHAR(1),
    INDEX idx_k_numdoc (serie),
    PRIMARY KEY (serie),
    CONSTRAINT fk_det_contable_contabilidad FOREIGN KEY (k_codcon) REFERENCES contabilidad (k_codcon) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_det_contable_ahorros FOREIGN KEY (id_otrods) REFERENCES ahorros (id_ahorro) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_det_contable_credito FOREIGN KEY (cod_credito) REFERENCES credito (cod_credito) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO dominios VALUES
(1,'i_tipdoc','N','Nit'),
(2,'i_tipdoc','C','Cedula'),
(3,'i_tipdoc','R','Registro Civil'),
(4,'i_tipdoc','T','Tajeta de Identidad'),
(5,'i_tipdoc','O','Cedula de estranjeria'),
(6,'i_sexo','F','Femenino'),
(7,'i_sexo','M','Masculino'),
(8,'i_sexo','O','Otro'),
(9,'i_direccion','C','Comercial'),
(10,'i_direccion','R','Residencial'),
(11,'i_direccion','L','Laboral'),
(12,'i_activo','Y','Yes(Si)'),
(13,'i_activo','N','No (No)'),
(14,'i_estado','A','Activo'),
(15,'i_estado','R','Retirado'),
(16,'i_periodicidad','Q','Quincenal'),
(17,'i_periodicidad','M','Mensual');

INSERT INTO usuarios VALUES
('ADMIN','Administrador','123456','Y',1);

INSERT INTO contabilidad VALUES
('11100501','BANCO','D','ADMIN'),
('14500505','CREDITO','D','ADMIN'),
('21100201','AHORROS','C','ADMIN'),
('31100505','APORTES','C','ADMIN'),
('41250101','INGRESO','C','ADMIN'),
('27500103','TRANSITORIA CONTABLE','C','ADMIN');

INSERT INTO tipo_documentos VALUES
('200','Aportes','AP','C'),
('201','Ahorros','AH','C'),
('300','Poliza Seguro de Vida','CC','D'),
('400','Excedentes','CP','D'),
('500','Creditos','OB','C');

INSERT INTO modalidades_cred VALUES
('100','VIVIENDA','Y'),
('101','VEHICULO','Y'),
('102','LIBRE INVERSION','Y');

INSERT INTO tipoaso VALUES
('100','NOMINA','Y'),
('101','VENTANILLA','Y'),
('102','PENSIONADO','Y');

INSERT INTO pais VALUES
('169','COLOMBIA'),
('170','ARGENTINA'),
('171','CHILE');

INSERT INTO ciudad VALUES
('66001','BOGOTA','169'),
('10000','LA PLATA','170'),
('76001','CALI','169'),
('20000','CHILE','171');

INSERT INTO cliente VALUES
(1,'0','C','','','','','AMINISTRADOR','',NULL,'169','66001','ADMIN'),
(2,'2233','C','VARGAS','MORENO','LEIDY','ANDREA','','F','83-06-23','169','66001','ADMIN'),
(3,'892115006','N','','','','','COLPENSIONES','',NULL,'171','20000','ADMIN'),
(4,'900013167','N','','','','','ASOCIACION COLOMBIANA DE AVIADORES CIVILES','',NULL,'169','66001','ADMIN'),
(5,'900017447','N','','','','','FONDO SOCIAL DEL CONGRESO DE LA REPUBLIC','',NULL,'169','66001','ADMIN'),
(6,'860045904','N','','','','','FEMSA','',NULL,'170','10000','ADMIN'),
(7,'900046561','N','','','','','FONDO DE EMPLEADOS MI FONDO','',NULL,'169','66001','ADMIN'),
(8,'1000007453','C','SOLARTE','QUINTERO','BAIRON','NICOLAS','','M','95-05-18','169','76001','ADMIN'),
(9,'1000007610','R','GIRALDO','','JUTSARA','LOPEZ','','M','98-10-01','169','66001','ADMIN'),
(10,'10000163221','T','SALINAS','PEDROZA','STEVE','SEBASTIAN','','M','93-02-12','171','20000','ADMIN'),
(11,'1000018025','C','ROMERO','POLANIA','DANIEL','FELIPE','','M','93-02-13','169','76001','ADMIN'),
(12,'10000233','C','FAJARDO','BELLO','JOSE','ALID','','M','96-06-15','169','76001','ADMIN'),
(13,'40020243','C','VALIENTE','ACUÑA','LINA','MARCELA','','F','93-12-25','170','10000','ADMIN'),
(14,'1000035020','R','CARDENAS','GONZALEZ','CAMILO','','','M','94-02-02','171','20000','ADMIN'),
(15,'1000048944','T','MARTINEZ','VELEZ','MARIANA','','','F','94-04-10','169','66001','ADMIN'),
(16,'50710607','C','NIETO','CAMPO','LINA','MARCELA','','F','98-04-18','169','76001','ADMIN'),
(17,'5077378','C','PARRA','TERNERA','GLENDYS','PAOLA','','F','93-04-18','169','66001','ADMIN'),
(18,'50850427','C','TOVAR','VALENCIA','DARLY','DALILA','','F','95-01-01','169','76001','ADMIN'),
(19,'50850495','C','RUEDA','ROBAYO','NICOLAS','ALEJANDRO','','M','91-12-29','169','66001','ADMIN'),
(20,'50851144','C','TABORDA','BERNAL','MARIA','TERESA','','F','84-04-18','169','76001','ADMIN'),
(21,'50851197','C','BETANCUR','','DUVIER','','','M','88-06-29','169','66001','ADMIN'),
(22,'20273677','C','BONILLA','ARBELAEZ','RONALD','ALEJANDRO','','M','89-09-12','170','10000','ADMIN');

INSERT INTO direcciones VALUES
(1,'1','CL 105  No 14    140','C','3131110','171','66001','paola.gomez@fonalianza.co'),
(2,'2','MZ 1 CA 31 ','C','3046832796','169','66001','teslalove5ong2015@gmail.com'),
(3,'3','MZ 9 CA 29','C','3059217337','169','66001','valentinacruzv.28@gmail.com'),
(4,'4','CR 36 D 9 56','C','3046718605','170','10000','angelikruiz35@gmail.com'),
(5,'5','AK 7 32 33 SANTA FE','C','4565667','169','66001','ddfdlikruiz35@gmail.com'),
(6,'6','MZ 5 CA 29','C','3165516585','169','76001','moniksoto43@gmail.com'),
(7,'7','CR 23 30 62','C','318823661','169','66001','eyderplata@gmail.com'),
(8,'8','CL 7 150 32','L','5215478','171','20000','danielricoalzate@gmail.com'),
(9,'8','CR 6 9 51','R','3137921054','171','20000','danielricoalzate@gmail.com'),
(10,'9','CR 42 BB CL 48 C SUR 186','R','3043301706','169','76001','shecar1202@hotmail.com'),
(11,'10','CR 46 21 BIS 220','R','3002055021','169','76001','lizpavabe@hotmail.com'),
(12,'11','CR 89 C 40 04','R','5567788','170','10000','heidysantana2525@gmail.com'),
(13,'12','CL 139 59 32','L','8512012','171','20000','ofevsluis@gmail.com'),
(14,'12','CR 35 C 73 50','R','3118907426','171','20000','ofevsluis@gmail.com'),
(15,'13','CR 26 C 77 59','L','3172198018','169','66001','gicarlos1999@gmail.com'),
(16,'14','CR 17 C 59 A 46','R','3015829847','169','66001','geral2096jimenez@gmail.com'),
(17,'15','CL 120 110 95','L','2545878','169','66001','lmirandaguerra@outlook.com'),
(18,'15','CR 57 48 23','R','5567890','169','66001','lmirandaguerra@outlook.com'),
(19,'16','CL 25 8 46','R','6200214','169','76001','annetorres2694@gmail.com'),
(20,'17','MZ 27 CA 18','C','3115003023','169','66001','marthaquesada311500@gmail.com'),
(21,'18','CL 105 14 140','L','8745487','169','76001','joseynataly0920@gmail.com'),
(22,'19','MZ 2 CA 16','L','3127420270','169','66001','tatianaocampo.m@gmail.com'),
(23,'20','AV CL 26 73 50','L','1254125','170','10000','alejandrambar98@gmail.com'),
(24,'21','AK 68  No 72  - 43','C','8572940','169','66001','sdsf@gmail.com'),
(25,'22','CL 13  No 8  - 176','C','3481248','169','66001','errere@gmail.com');

INSERT INTO empresas VALUES
('200','FEMSA','Q','Y','6'),
('201','VENTANILLA','M','Y','7'),
('202','COLPENSIONES','M','Y','3');

INSERT INTO asociados VALUES
(7,'1000007610','GIRALDO  JUTSARA LOPEZ','','20-03-28','100','200','Q',5000000,'A'),
(8,'10000163221','SALINAS PEDROZA STEVE SEBASTIAN','','20-11-05','101','201','M',6000000,'A'),
(9,'1000018025','ROMERO POLANIA DANIEL FELIPE','','20-10-23','101','201','M',8000000,'A'),
(10,'10000233','FAJARDO BELLO JOSE ALID','','18-06-16','102','202','M',4000000,'A'),
(11,'40020243','VALIENTE ACUÑA LINA MARCELA','','20-08-23','100','200','Q',5500000,'A'),
(12,'1000035020','CARDENAS  CAMILO GONZALEZ','','19-07-18','100','200','Q',6800000,'A'),
(13,'1000048944','MARTINEZ  MARIANA VELEZ','','20-12-23','102','202','M',7100000,'A'),
(14,'50710607','NIETO CAMPO LINA MARCELA','','20-12-23','101','201','M',5800000,'A'),
(15,'5077378','PARRA TERNERA GLENDYS PAOLA','','10-11-23','100','200','Q',3800000,'A'),
(16,'50850427','TOVAR VALENCIA DARLY DALILA','','13-09-15','102','202','M',2650000,'A'),
(17,'50850495','RUEDA ROBAYO NICOLAS ALEJANDRO','','19-04-30','100','200','Q',4350000,'R'),
(18,'50851144','TABORDA BERNAL MARIA TERESA','','21-06-01','102','202','M',5320000,'A'),
(19,'50851197','BETANCUR  DUVIER HERNANDEZ','','22-08-23','100','200','Q',3850000,'A'),
(20,'20273677','BONILLA ARBELAEZ RONALD ALEJANDRO','','17-01-23','101','201','M',5225000,'A');

INSERT INTO ahorros VALUES
(1,200,7,'Q',50000,NULL,5000000),
(2,200,8,'M',100000,NULL,7000000),
(3,200,9,'M',100000,NULL,8000000),
(4,200,10,'M',100000,NULL,10000000),
(5,200,11,'Q',50000,NULL,15000000),
(6,200,12,'Q',50000,NULL,20500000),
(7,200,13,'M',100000,NULL,13000000),
(8,200,14,'M',100000,NULL,2000000),
(9,200,15,'Q',50000,NULL,6500000),
(10,200,16,'M',100000,NULL,7800000),
(11,200,17,'Q',50000,NULL,3800000),
(12,200,18,'M',100000,NULL,8800000),
(13,200,19,'Q',50000,NULL,10500000),
(14,200,20,'M',100000,NULL,8500000);

INSERT INTO credito VALUES
(1,7,'500',CURDATE(),'100',80000000,666666,120,73333333),
(2,8,'500',CURDATE(),'102',18000000,300000,60,13500000),
(3,9,'500',CURDATE(),'100',120000000,1000000,120,80000000),
(4,10,'500',CURDATE(),'101',16000000,266666,60,10666666),
(5,11,'500',CURDATE(),'102',10000000,217391,46,3913043),
(6,17,'500',CURDATE(),'102',8000000,222222,36,3555555),
(7,18,'500',CURDATE(),'101',20000000,333333,60,8333333),
(8,19,'500',CURDATE(),'102',5000000,416666,12,4166666);

INSERT INTO det_contable VALUES
(1,'OB','11100501',YEAR(CURDATE()),1,NULL,'DESEMBOLSO CREDITO',0,80000000,CURDATE(),'N'),
(2,'OB','11100501',YEAR(CURDATE()),2,NULL,'DESEMBOLSO CREDITO',0,18000000,CURDATE(),'N'),
(3,'OB','11100501',YEAR(CURDATE()),3,NULL,'DESEMBOLSO CREDITO',0,120000000,CURDATE(),'N'),
(4,'OB','11100501',YEAR(CURDATE()),4,NULL,'DESEMBOLSO CREDITO',0,16000000,CURDATE(),'N'),
(5,'OB','11100501',YEAR(CURDATE()),5,NULL,'DESEMBOLSO CREDITO',0,10000000,CURDATE(),'N'),
(6,'OB','11100501',YEAR(CURDATE()),6,NULL,'DESEMBOLSO CREDITO',0,8000000,CURDATE(),'N'),
(7,'OB','11100501',YEAR(CURDATE()),7,NULL,'DESEMBOLSO CREDITO',0,20000000,CURDATE(),'N'),
(8,'OB','11100501',YEAR(CURDATE()),8,NULL,'DESEMBOLSO CREDITO',0,5000000,CURDATE(),'N'),
(9,'OB','27500103',YEAR(CURDATE()),1,NULL,'DESEMBOLSO CREDITO',80000000,0,CURDATE(),'N'),
(10,'OB','27500103',YEAR(CURDATE()),2,NULL,'DESEMBOLSO CREDITO',18000000,0,CURDATE(),'N'),
(11,'OB','27500103',YEAR(CURDATE()),3,NULL,'DESEMBOLSO CREDITO',120000000,0,CURDATE(),'N'),
(12,'OB','27500103',YEAR(CURDATE()),4,NULL,'DESEMBOLSO CREDITO',16000000,0,CURDATE(),'N'),
(13,'OB','27500103',YEAR(CURDATE()),5,NULL,'DESEMBOLSO CREDITO',10000000,0,CURDATE(),'N'),
(14,'OB','27500103',YEAR(CURDATE()),6,NULL,'DESEMBOLSO CREDITO',8000000,0,CURDATE(),'N'),
(15,'OB','27500103',YEAR(CURDATE()),7,NULL,'DESEMBOLSO CREDITO',20000000,0,CURDATE(),'N'),
(16,'OB','27500103',YEAR(CURDATE()),8,NULL,'DESEMBOLSO CREDITO',5000000,0,CURDATE(),'N'),
(17,'AP','31100505',YEAR(CURDATE()),NULL,1,'CONTABILIZACION DE APORTES',50000,0,CURDATE(),'N'),
(18,'AP','31100505',YEAR(CURDATE()),NULL,2,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(19,'AP','31100505',YEAR(CURDATE()),NULL,3,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(20,'AP','31100505',YEAR(CURDATE()),NULL,4,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(21,'AP','31100505',YEAR(CURDATE()),NULL,5,'CONTABILIZACION DE APORTES',50000,0,CURDATE(),'Y'),
(22,'AP','31100505',YEAR(CURDATE()),NULL,6,'CONTABILIZACION DE APORTES',50000,0,CURDATE(),'N'),
(23,'AP','31100505',YEAR(CURDATE()),NULL,7,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(24,'AP','31100505',YEAR(CURDATE()),NULL,8,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'Y'),
(25,'AP','31100505',YEAR(CURDATE()),NULL,9,'CONTABILIZACION DE APORTES',50000,0,CURDATE(),'N'),
(26,'AP','31100505',YEAR(CURDATE()),NULL,10,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(27,'AP','31100505',YEAR(CURDATE()),NULL,11,'CONTABILIZACION DE APORTES',50000,0,CURDATE(),'N'),
(28,'AP','31100505',YEAR(CURDATE()),NULL,12,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(29,'AP','31100505',YEAR(CURDATE()),NULL,13,'CONTABILIZACION DE APORTES',50000,0,CURDATE(),'N'),
(30,'AP','31100505',YEAR(CURDATE()),NULL,14,'CONTABILIZACION DE APORTES',100000,0,CURDATE(),'N'),
(31,'AP','11100501',YEAR(CURDATE()),NULL,1,'CONTABILIZACION DE APORTES',0,50000,CURDATE(),'N'),
(32,'AP','11100501',YEAR(CURDATE()),NULL,2,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N'),
(33,'AP','11100501',YEAR(CURDATE()),NULL,3,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N'),
(34,'AP','11100501',YEAR(CURDATE()),NULL,4,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N'),
(35,'AP','11100501',YEAR(CURDATE()),NULL,5,'CONTABILIZACION DE APORTES',0,50000,CURDATE(),'Y'),
(36,'AP','11100501',YEAR(CURDATE()),NULL,6,'CONTABILIZACION DE APORTES',0,50000,CURDATE(),'N'),
(37,'AP','11100501',YEAR(CURDATE()),NULL,7,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N'),
(38,'AP','11100501',YEAR(CURDATE()),NULL,8,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'Y'),
(39,'AP','11100501',YEAR(CURDATE()),NULL,9,'CONTABILIZACION DE APORTES',0,50000,CURDATE(),'N'),
(40,'AP','11100501',YEAR(CURDATE()),NULL,10,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N'),
(41,'AP','11100501',YEAR(CURDATE()),NULL,11,'CONTABILIZACION DE APORTES',0,50000,CURDATE(),'N'),
(42,'AP','11100501',YEAR(CURDATE()),NULL,12,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N'),
(43,'AP','11100501',YEAR(CURDATE()),NULL,13,'CONTABILIZACION DE APORTES',0,50000,CURDATE(),'N'),
(44,'AP','11100501',YEAR(CURDATE()),NULL,14,'CONTABILIZACION DE APORTES',0,100000,CURDATE(),'N');
    
-- Creación de Vistas
-- USE workshopcontactos_viewvargas;
-- 1.Vista de datos de contacto de los asociados al fondo de empleados
CREATE OR REPLACE VIEW contactos_view AS				
(	
SELECT 			
		a.numdoc		
		,a.nombres		
        ,d.direccion
        ,o.significado
        ,d.telefono
        ,c.n_ciudad
	FROM asociados AS a			
    JOIN direcciones AS d ON a.id = d.id
    JOIN ciudad AS c ON c.cod_ciudad = d.cod_ciudad
    JOIN dominios AS o ON d.i_direccion = o.abreviatura AND o.dominio = 'i_direccion'
    );
-- 2.Vista de los asociados que pagan sus obligaciones por la empresa FEMSA
CREATE OR REPLACE VIEW femsa_view AS				
(	
SELECT 			
		a.numdoc		
		,a.nombres		
        ,e.n_nomina
FROM asociados AS a			
JOIN empresas AS e ON a.id_nomina = e.id_nomina AND e.id_nomina = '200'
);

-- 3. Vista de los asociados que pagan sus obligaciones por la empresa VENTANILLA
CREATE OR REPLACE VIEW ventanilla_view AS				
(	
SELECT 			
		a.numdoc		
		,a.nombres		
        ,e.n_nomina
FROM asociados AS a			
JOIN empresas AS e ON a.id_nomina = e.id_nomina AND e.id_nomina = '201'
);

-- 4. Vista de los asociados que pagan sus obligaciones por la empresa PENSIONADOS
CREATE OR REPLACE VIEW colpensiones_view AS				
(	
SELECT 			
		a.numdoc		
		,a.nombres		
        ,e.n_nomina
FROM asociados AS a			
JOIN empresas AS e ON a.id_nomina = e.id_nomina AND e.id_nomina = '202'
);

-- 5. Vista de los nombres de los asociados que No tienen crédito en el fondo de empleados
CREATE OR REPLACE VIEW sin_credito_view AS				
(	
SELECT DISTINCT a.nombres FROM asociados a
  WHERE NOT EXISTS (SELECT * FROM credito c
                    WHERE c.id = a.id)
);

-- 6.Vista de los ultimos 8 asociados que ingresaron como afiliados al fondo de empleados
CREATE OR REPLACE VIEW ult_afiliados_view AS				
(	
SELECT
		a.id		
		, a.nombres		
        , a.f_afiliacion				
	FROM asociados AS a
    order by f_afiliacion desc LIMIT 5
);