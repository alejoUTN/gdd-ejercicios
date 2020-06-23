--1
/*Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es
menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
“DEPOSITO COMPLETO”.*/
DROP FUNCTION IF EXISTS dbo.estado_deposito_producto;
CREATE FUNCTION estado_deposito_producto(@producto char(8), @deposito char(2))
RETURNS char(40) AS
BEGIN
    RETURN (select case
		when stoc_stock_maximo is null then 'n/c'
		when stoc_cantidad < stoc_stock_maximo then 'OCUPACION DEL DEPOSITO:' + str(100*(stoc_cantidad/stoc_stock_maximo))+'%'
		else 'DEPOSITO COMPLETO'
	end
	from stock where stoc_producto = @producto and stoc_deposito = @deposito);
END;
GO;

select *, dbo.estado_deposito_producto(stoc_producto,stoc_deposito) estado_deposito_producto
from stock
order by estado_deposito_producto desc;

select * from stock where stoc_producto = '00000030' and stoc_deposito = '00';

--2
/*Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha*/
DROP FUNCTION IF EXISTS dbo.stock_fecha;
CREATE FUNCTION stock_fecha(@producto char(8), @fecha date)
RETURNS int AS
BEGIN
    RETURN ;
END;
GO;

--3
/*Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.*/

--4
/*Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.*/

--5
/*Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:
Create table Fact_table
( anio char(4),
mes char(2),
familia char(3),
rubro char(4),
zona char(3),
cliente char(6),
producto char(8),
cantidad decimal(12,2),
monto decimal(12,2)
)
Alter table Fact_table
Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto)*/

--6
/*Realizar un procedimiento que si en alguna factura se facturaron componentes
que conforman un combo determinado (o sea que juntos componen otro
producto de mayor nivel), en cuyo caso deberá reemplazar las filas
correspondientes a dichos productos por una sola fila con el producto que
componen con la cantidad de dicho producto que corresponda.*/