--Hallar para una persona dada, por ejemplo José Pérez, los tipos y números de documentos, nombres, dirección y fecha de nacimiento de todos sus hijos.

SELECT * FROM persona hijo
INNER JOIN progenitor
ON progenitor.NroDocHijo = hijo.NroDoc
INNER JOIN persona padre
ON progenitor.NroDoc = padre.NroDoc
WHERE padre.nombre = 'Maria'

--2. Hallar para cada persona los tipos y números de documento, nombre, domicilio y fecha de nacimiento de:

/*
			  Roberto
	Julio		 |
	  |		 ----------
	  |		 |        |
	Maria y Juan   Carlos y Ana
	      |				 |
	  ---------		 ---------
	  |       |		 |       |
	Pedro   Lucia   Pablo  Laura
	  |       |
	Jorge    Sofia,Mateo,Camila
*/

--a. Todos sus hermanos, incluyendo medios hermanos.

SELECT uno_mismo.*, hijo_de_sus_padres.* FROM persona uno_mismo
INNER JOIN progenitor progenitor_de_uno
ON progenitor_de_uno.NroDocHijo = uno_mismo.NroDoc
INNER JOIN progenitor progenitor_de_hermanos
ON progenitor_de_hermanos.NroDoc = progenitor_de_uno.NroDoc
INNER JOIN persona hijo_de_sus_padres
ON uno_mismo.NroDoc <> hijo_de_sus_padres.NroDoc
AND hijo_de_sus_padres.NroDoc = progenitor_de_hermanos.NroDocHijo
order by uno_mismo.NroDoc

--b. Su madre


SELECT madre.*, hijo.* FROM persona madre
INNER JOIN Progenitor progenio_a
ON madre.NroDoc = progenio_a.NroDoc
INNER JOIN persona hijo
ON hijo.NroDoc = progenio_a.NroDocHijo
WHERE madre.sexo = 'F'


--c. Su abuelo materno


SELECT abuelo.*, madre.*, hije.* FROM persona abuelo
INNER JOIN progenitor padre_de_madre
ON abuelo.NroDoc = padre_de_madre.NroDoc
INNER JOIN persona madre
ON padre_de_madre.NroDocHijo = madre.NroDoc
INNER JOIN Progenitor madre_de_hije
ON madre_de_hije.NroDoc = madre.NroDoc
INNER JOIN persona hije
ON hije.NroDoc = madre_de_hije.NroDocHijo
WHERE madre.Sexo = 'F'
AND abuelo.Sexo = 'M'
ORDER BY abuelo.NroDoc

--d. Todos sus nietos

SELECT abuelo.*, nieto.* from persona nieto
INNER JOIN Progenitor padre_del_nieto
ON padre_del_nieto.NroDocHijo = nieto.NroDoc
INNER JOIN persona padre
ON padre_del_nieto.NroDoc = padre.NroDoc
INNER JOIN Progenitor padre_del_padre
ON padre_del_padre.NroDocHijo = padre.NroDoc
INNER JOIN persona abuelo
ON padre_del_padre.NroDoc = abuelo.NroDoc
ORDER BY abuelo.NroDoc


--Parcial. Liste los abuelos varones y sus nietos, tales que, el nieto 1 sea solo primo del nieto 2, donde el padre del nieto 1 sea hermano de la madre del nieto 2. Además debe validar que el nieto 1 sea hijo único y que el nieto 2 tenga exactamente 2 hermanos. El formato de la tupla debería ser:
--           abuelo | niete 1 | niete 2


SELECT abuelo.Nombre as abuelo, nieto1.Nombre as niete1, nieto2.Nombre as niete2 FROM persona nieto1
INNER JOIN Progenitor padre_del_nieto1
ON padre_del_nieto1.NroDocHijo = nieto1.NroDoc
INNER JOIN Progenitor padre_del_padre_de_n1
ON padre_del_padre_de_n1.NroDocHijo = padre_del_nieto1.NroDoc
INNER JOIN persona abuelo
ON abuelo.NroDoc = padre_del_padre_de_n1.NroDoc
INNER JOIN Progenitor padre_dela_madre_de_n2
ON padre_dela_madre_de_n2.NroDoc = padre_del_padre_de_n1.nroDoc
INNER JOIN Progenitor madre_del_nieto2
ON madre_del_nieto2.NroDoc = padre_dela_madre_de_n2.NroDocHijo
AND madre_del_nieto2.NroDoc <> padre_del_nieto1.NroDoc
INNER JOIN Persona madre_n2
ON madre_del_nieto2.NroDoc = madre_n2.NroDoc
INNER JOIN Persona nieto2
ON madre_del_nieto2.NroDocHijo = nieto2.NroDoc
WHERE madre_del_nieto2.NroDoc IN (	SELECT NroDoc FROM Progenitor madre_de_tres_hijos
									WHERE madre_de_tres_hijos.NroDoc = madre_del_nieto2.NroDoc
									group by madre_de_tres_hijos.NroDoc
									having count(madre_de_tres_hijos.NroDocHijo) = 3)
AND padre_del_nieto1.NroDoc IN (	SELECT NroDoc FROM Progenitor padre_de_hijo_unico
									WHERE padre_de_hijo_unico.NroDoc = padre_del_nieto1.NroDoc
									group by padre_de_hijo_unico.NroDoc
									having count(padre_de_hijo_unico.NroDocHijo) = 1)
AND madre_n2.Sexo = 'F'
AND abuelo.Sexo = 'M'