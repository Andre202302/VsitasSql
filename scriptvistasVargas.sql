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