--4
/*Realizar una consulta que muestre para todos los art�culos c�digo, detalle y cantidad de
art�culos que lo componen. Mostrar solo aquellos art�culos para los cuales el stock
promedio por dep�sito sea mayor a 100.*/
SELECT prod_codigo,prod_detalle, isnull(sum(comp_cantidad),1) cantidad_art
FROM Producto LEFT JOIN Composicion c on prod_codigo = c.comp_producto
where prod_codigo IN (select distinct stoc_producto
				FROM stock
				GROUP BY stoc_producto,stoc_deposito
				HAVING AVG(stoc_cantidad) > 100)
GROUP BY prod_codigo,prod_detalle
ORDER BY isnull(sum(comp_cantidad),1) DESC

--5
/*Realizar una consulta que muestre c�digo de art�culo, detalle y cantidad de egresos de
stock que se realizaron para ese art�culo en el a�o 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido m�s egresos que en el 2011.*/
SELECT prod_codigo,prod_detalle,sum(isnull(item_cantidad,0)) egresos
FROM Producto JOIN Item_Factura on prod_codigo = item_producto JOIN factura on item_numero = fact_numero
where year(fact_fecha) = 2012
GROUP BY prod_codigo,prod_detalle
having sum(isnull(item_cantidad,0)) > isnull((
	SELECT sum(isnull(item_cantidad,1))
	FROM Item_Factura JOIN factura on item_numero = fact_numero
	where year(fact_fecha) = 2011 and item_producto = prod_codigo
),0)

--6
/*Mostrar para todos los rubros de art�culos c�digo, detalle, cantidad de art�culos de ese
rubro y stock total de ese rubro de art�culos. Solo tener en cuenta aquellos art�culos que
tengan un stock mayor al del art�culo �00000000� en el dep�sito �00�.*/
select rubr_id,rubr_detalle,count(distinct prod_codigo) cant_articulos, sum(isnull(stoc_cantidad,0)) stock
from rubro join producto on rubr_id = prod_rubro left join stock on prod_codigo = stoc_producto
where prod_codigo in (
	select stoc_producto
	from stock
	group by stoc_producto
	having sum(isnull(stoc_cantidad,0)) > (
		select sum(isnull(stoc_cantidad,0))
		from stock
		where stoc_producto = '00000000' and stoc_deposito = '00'
	)
)
group by rubr_id,rubr_detalle
order by rubr_id

--7
/*Generar una consulta que muestre para cada art�culo c�digo, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos art�culos que posean
stock.*/
select prod_codigo,prod_detalle,isnull(MAX(item_precio),sum(prod_precio)) mayor_precio, isnull(MIN(item_precio),sum(prod_precio)) menor_precio,
case 
	when isnull(MIN(item_precio),sum(prod_precio)) = 0 then 0
	else (100*( isnull(MAX(item_precio),sum(prod_precio)) - isnull(MIN(item_precio),sum(prod_precio)) ) / isnull(MIN(item_precio),sum(prod_precio)) )
end porc_dif
from producto left join item_factura on item_producto = prod_codigo
where prod_codigo in (
	select stoc_producto
	from stock
	group by stoc_producto
	having sum(isnull(stoc_cantidad,0)) > 0
)
group by prod_codigo,prod_detalle
order by porc_dif desc

--8
/*Mostrar para el o los art�culos que tengan stock en todos los dep�sitos, nombre del
art�culo, stock del dep�sito que m�s stock tiene*/

--9
/*Mostrar el c�digo del jefe, c�digo del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de dep�sitos que ambos tienen asignados.*/

--10
/*Mostrar los 10 productos m�s vendidos en la historia y tambi�n los 10 productos menos
vendidos en la historia. Adem�s mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/

--11
/*Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deber�n
ordenar de mayor a menor, por la familia que m�s productos diferentes vendidos tenga,
solo se deber�n mostrar las familias que tengan una venta superior a 20000 pesos para
el a�o 2012.*/

--12
/*Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
promedio pagado por el producto, cantidad de dep�sitos en los cuales hay stock del
producto y stock actual del producto en todos los dep�sitos. Se deber�n mostrar
aquellos productos que hayan tenido operaciones en el a�o 2012 y los datos deber�n
ordenarse de mayor a menor por monto vendido del producto.*/

--13
/*Realizar una consulta que retorne para cada producto que posea composici�n nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deber�n mostrar los productos que est�n
compuestos por m�s de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.*/

--14
/*Escriba una consulta que retorne una estad�stica de ventas por cliente. Los campos que
debe retornar son:
C�digo del cliente
Cantidad de veces que compro en el �ltimo a�o
Promedio por compra en el �ltimo a�o
Cantidad de productos diferentes que compro en el �ltimo a�o
Monto de la mayor compra que realizo en el �ltimo a�o
Se deber�n retornar todos los clientes ordenados por la cantidad de veces que compro en
el �ltimo a�o.
No se deber�n visualizar NULLs en ninguna columna*/

--15
/*Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) m�s de 500 veces. El resultado debe mostrar el c�digo y
descripci�n de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse m�s de una vez.
Ejemplo de lo que retornar�a la consulta:
PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2*/

--16
/*Con el fin de lanzar una nueva campa�a comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que m�s se vendi� en el 2012.
Adem�s mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. C�digo de producto que mayor venta tuvo en el 2012 (en caso de existir m�s de 1,
mostrar solamente el de menor c�digo) para ese cliente.
Aclaraciones:
La composici�n es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por c�digo de provincia ascendente.*/

--17
/*Escriba una consulta que retorne una estad�stica de ventas por a�o y mes para cada
producto.
La consulta debe retornar:
PERIODO: A�o y mes de la estad�stica con el formato YYYYMM
PROD: C�digo de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_A�O_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del a�o anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendi� el producto en el
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y c�digo de producto.*/

--18
/*Escriba una consulta que retorne una estad�stica de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: C�digo del producto m�s vendido de dicho rubro
PROD2: C�digo del segundo producto m�s vendido de dicho rubro
CLIENTE: C�digo del cliente que compro m�s productos del rubro en los �ltimos 30
d�as
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.*/

--19
/*En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
- Codigo de producto
- Detalle del producto
- Codigo de la familia del producto
- Detalle de la familia actual del producto
- Codigo de la familia sugerido para el producto
- Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente*/

--20
/*Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que
hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
que superen los 100 pesos que haya vendido en el a�o, para los que tengan menos de 50
facturas en el a�o el calculo del puntaje sera el 50% de cantidad de facturas realizadas
por sus subordinados directos en dicho a�o.*/