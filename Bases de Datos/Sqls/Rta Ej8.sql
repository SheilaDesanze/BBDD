--1. Frecuentan solamente bares que sirven alguna cerveza que les guste. 

--Personas que no son las personas que frecuentan bares que no sirven cervezas que les gusta

--Personas tales que no existen bares que frecuentan que no sirven cervezas que les gusta

--Personas que sirven alguna cerveza que les gusta en todos los bares que frecuentan

SELECT *, 1 as personas_les_gusta_todo FROM Frecuenta f1
WHERE f1.idPersona NOT IN (	SELECT f2.idPersona 
							FROM Frecuenta f2
							WHERE idBar IN (SELECT idBar 
											FROM Sirve s
											WHERE s.idBar NOT IN (	SELECT idBar FROM Sirve s
																	WHERE s.idCerveza IN ( SELECT g.idCerveza 
																							FROM Gusta g
																							WHERE g.idPersona = f2.idPersona))))


SELECT Persona.id, Persona.nombre
FROM Persona
WHERE NOT EXISTS (
    SELECT 1
    FROM Frecuenta
    WHERE Frecuenta.idPersona = Persona.id
    AND NOT EXISTS (
        SELECT 1
        FROM Sirve
        JOIN Gusta ON Sirve.idCerveza = Gusta.idCerveza
        WHERE Sirve.idBar = Frecuenta.idBar
        AND Gusta.idPersona = Frecuenta.idPersona
    )
);


--2. No frecuentan ningún bar que sirva alguna cerveza que les guste.

--Personas que solamente frecuentan bares que no sirven cerveza que les gusta

--Personas que no sirven alguna cerveza que les gusta en todos los bares que frecuentan


SELECT Persona.id, Persona.nombre
FROM Persona
WHERE NOT EXISTS (
    SELECT 1
    FROM Frecuenta
    WHERE Frecuenta.idPersona = Persona.id
    AND EXISTS (
        SELECT 1
        FROM Sirve
        JOIN Gusta ON Sirve.idCerveza = Gusta.idCerveza
        WHERE Sirve.idBar = Frecuenta.idBar
        AND Gusta.idPersona = Frecuenta.idPersona
    )
);

--3. Frecuentan solamente los bares que sirven todas las cervezas que les gustan.

--Personas que no frecuentan bares donde no sirvan todas las cervezas que le gustan

--Personas tales que no existen bares que frecuentan que no son los bares donde no exista cerveza que se sirva no esté entre las cervezas que les gusta -> todas las cervezas que se sirven les gusta en todos los bares

--Personas que no frecuentan bares donde no existe algo que les gusta que no sirvan ->  Todas las cervezas que no le gusta se sirve en todos los bares

--Personas que sirven todo lo que le gusta en todo lo que frecuenta

--Personas que no frecuentan bares donde existe algo que les gusta que no sirvan

--personas where not exists frecuenta where not exists gusta where not exists sirvan 

SELECT * FROM Persona
WHERE NOT EXISTS (
	SELECT 1
	FROM Frecuenta
	WHERE Persona.id = Frecuenta.idPersona
	AND EXISTS (
		SELECT 1
		FROM Gusta
		WHERE Gusta.idPersona = Frecuenta.idPersona
		AND NOT EXISTS (
			SELECT 1
			FROM Sirve
			WHERE Sirve.idBar = Frecuenta.idBar
			AND Gusta.idCerveza = Sirve.idCerveza
		)
	)
)


--4. Frecuentan solamente los bares que no sirven ninguna de las cervezas que no les gusta.--Personas que todo lo que frecuentan son bares donde todas las cervezas que sirven les gusta--Personas donde no existe (bar que no sirva cerveza que no les guste) que no frecuenten--Personas que no frecuentan bares que sirven cervezas que no les gusta--Personas que no frecuentan bares que sirven alguna cerveza que no les gusta
SELECT * FROM Persona
WHERE NOT EXISTS (
	SELECT 1
	FROM Frecuenta
	WHERE Persona.id = Frecuenta.idPersona
	AND EXISTS (
		SELECT 1
		FROM Sirve
		WHERE Sirve.idBar = Frecuenta.idBar
		AND NOT EXISTS (
			SELECT 1
			FROM Gusta
			WHERE Gusta.idPersona = Frecuenta.idPersona
			AND Gusta.idCerveza = Sirve.idCerveza
		)
	)
)