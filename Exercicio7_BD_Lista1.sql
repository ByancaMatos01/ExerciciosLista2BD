use Exercicio7


--Consultar 10% de desconto no pedido 1003		
SELECT 
 ped.Valor,
 'R$ ' + CAST(CAST(ped.Valor * 0.9 AS DECIMAL(7,2)) AS VARCHAR(08)) AS PrecoComDesconto
FROM Pedido ped
 WHERE ped.Nota_Fiscal = 1003
--Consultar 5% de desconto em pedidos com valor maior de R$700,00	

SELECT
 ped.Data_Compra,
 ped.Valor,
 'RS'+ CAST(CAST(ped.Valor * 0.95 AS DECIMAL(7,2)) AS VARCHAR(08)) AS "Novo Valor"
FROM Pedido ped
 WHERE ped.Valor > 700

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10	
SELECT 
 m.Codigo,
 m.Preco,
 'R$ ' + CAST(CAST(m.Preco * 1.25 AS DECIMAL(7,2)) AS CHAR(08)) AS "Novo Preço"
FROM Mercadoria m
 WHERE m.Qtd < 10

--Data e valor dos pedidos do Luiz				
SELECT 
 p.Data_Compra,
 p.Valor

FROM pedido p INNER JOIN Cliente c 
 ON p.RG_Cliente = c.RG
  WHERE c.Nome = 'Luiz André'

--CPF, Nome e endereço concatenado do cliente de nota 1004	

SELECT
 SUBSTRING(c.CPF,1,3)+'.'+SUBSTRING(c.CPF,4,3)+'.'+SUBSTRING(c.CPF,7,3)+'-'+SUBSTRING(c.CPF,9,2),
 c.Nome,
 c.Logradouro + ', ' + CAST(c.Numero AS VARCHAR) AS "Endereço Completo"
FROM Cliente c INNER JOIN Pedido p
 ON c.RG = p.RG_Cliente
  WHERE P.Nota_Fiscal = 1004

--País e meio de transporte da Cx. De som		
SELECT 
 f.Pais,
 f.Transporte

FROM Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo
  WHERE m.Descricao = 'Cx. De som'


--Nome e Quantidade em estoque dos produtos fornecidos pela Clone	
SELECT 
 m.Descricao,
 m.Qtd,
 f.Nome
FROM Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo
  WHERE f.Nome = 'Clone'

--Endereço concatenado e telefone dos fornecedores do monitor. (Telefone brasileiro (XX)XXXX-XXXX ou XXXX-XXXXXX (Se for 0800), Telefone Americano (XXX)XXX-XXXX)	
SELECT 
 f.Nome,
 f.Logradouro + ' ' +  CAST(f.Numero AS varchar) AS "Endereço Completo",
 CASE WHEN f.Pais = 'BR' THEN '(' + SUBSTRING(f.Telefone,1,2) + ')'+ SUBSTRING(f.Telefone,3,5) + '-'+ SUBSTRING(f.Telefone,6,4) 
  WHEN f.Pais = 'USA' THEN '(' + SUBSTRING(f.Telefone,1,3) + ')'+ SUBSTRING(f.Telefone,4,3) + '-'+ SUBSTRING(f.Telefone,7,4) 
   WHEN f.Telefone LIKE '0800%' THEN SUBSTRING(f.Telefone,1,4) + '-'+ SUBSTRING(f.Telefone,5,6) 
   WHEN F.Telefone IS NULL THEN 'Telefone Vazio' END AS "Telefone"
FROM Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo
  WHERE m.Descricao LIKE '%Monitor%'
 

--Tipo de moeda que se compra o notebook
SELECT
 m.Descricao,
 f.Nome,
 f.Moeda

FROM
Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo 
  WHERE m.Descricao LIKE '%Notebook%'

---Considerando que hoje é 03/02/2019, há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses e pedido recente para os outros

     SELECT DateDiff(DAY, ped.Data_Compra, GETDate()) as 'dias ate hoje',
     CASE 
         WHEN  DateDiff(MONTH,  ped.Data_compra, GetDate())> 6  then 'Pedido antigo'
	else 'Pedido atrasado'
	END as 'Status do Pedido'
from Pedido ped;

--Nome e Quantos pedidos foram feitos por cada cliente
select cli.nome as 'nome cliente', COUNT(ped.RG_Cliente)  as 'Quantidade de compra'
from Pedido ped inner join cliente cli
on ped.RG_Cliente=cli.RG
group by cli.Nome


---- RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
select cli.Nome as 'Nome',  cli.CPF as 'CPF', cli.Logradouro +' '+  Cast(cli.Numero as varchar) as 'Endereço'
from Cliente cli  LEFT OUTER join Pedido ped
on cli.RG=ped.RG_Cliente
where ped.Nota_Fiscal is null

