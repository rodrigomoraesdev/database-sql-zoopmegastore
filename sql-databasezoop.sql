--Consulta Vendas - Completa
  SELECT STRFTIME('%Y',data_venda) as Ano,
  COUNT(id_venda) AS TotalVendas
  FROM vendas
  GROUP by Ano
  ORDER BY Ano;

--Consulta Vendas - Período Interesse
SELECT STRFTIME('%Y',data_venda) as Ano, STRFTIME('%m',data_venda) as Mes,
COUNT(id_venda) AS TotalVendas
FROM vendas
where Mes = '01' OR Mes = '11' OR Mes = '12'
GROUP by Ano, Mes
ORDER BY Ano;

--Papel dos Fornecedores na Black Friday
SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, f.nome AS NomeFornecedor, COUNT(iv.produto_id) AS QtdVendas 
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON iv.produto_id = p.id_produto
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
where AnoMes LIKE '%/10%' OR AnoMes LIKE '%/11%' OR AnoMes LIKE '%/12%'
GROUP By NomeFornecedor, "AnoMes"
ORDER BY NomeFornecedor;

--Categoria de Produtos da Black Friday;
SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, c.nome_categoria AS NomeCategoria, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
where AnoMes LIKE '%/10%' OR AnoMes LIKE '%/11%' OR AnoMes LIKE '%/12%'
GROUP BY NomeCategoria, AnoMes
ORDER BY AnoMes, Qtd_Vendas;


--Entrevista Fornecedores com Maior QtdVenda
SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, f.nome AS NomeFornecedor, COUNT(iv.produto_id) AS QtdVendas 
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON iv.produto_id = p.id_produto
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE STRFTIME('%Y/%m', v.data_venda) = '2022/11'
GROUP By NomeFornecedor, "AnoMes"
ORDER BY QtdVendas DESC;

--Entrevista Categoria de Produtos com Maior QtdVenda
SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, c.nome_categoria AS NomeCategoria, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE STRFTIME('%Y/%m', v.data_venda) = '2022/11'
GROUP BY NomeCategoria, AnoMes
ORDER BY AnoMes, Qtd_Vendas DESC;

--Entrevista Validação Total Registros
SELECT SUM(QtdVendas) AS TotalRegistros
FROM (
  SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, f.nome AS NomeFornecedor, COUNT(iv.produto_id) AS QtdVendas 
  FROM	 itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON iv.produto_id = p.id_produto
  JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
  GROUP By NomeFornecedor, "AnoMes"
  ORDER BY NomeFornecedor);

--Solicitação: Detalhes QtdVendas NebulaNetworks
SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, cOUNT(iv.produto_id) AS QtdVendas 
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON iv.produto_id = p.id_produto
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE f.nome = 'NebulaNetworks'
GROUP By f.nome, "AnoMes"
ORDER BY AnoMes, QtdVendas DESC;

--Adicional: Detalhes Qtd Vendas Top3Fornecedores
SELECT AnoMes, 
SUM(CASE WHEN NomeFornecedor == 'NebulaNetworks' THEN QtdVendas ELSE 0 END) As NebulaNetworks_QtdVendas,
SUM(CASE WHEN NomeFornecedor == 'AstroSupply' THEN QtdVendas ELSE 0 END) AS AstroSupply_QtdVendas,
SUM(CASE WHEN NomeFornecedor == 'HorizonDistributors' THEN QtdVendas ELSE 0 END) AS HorizonDistributors_QtdVendas
FROM(
  SELECT STRFTIME('%Y/%m', v.data_venda) AS AnoMes, f.nome AS NomeFornecedor, COUNT(iv.produto_id) AS QtdVendas 
  FROM itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON iv.produto_id = p.id_produto
  JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
  WHERE f.nome = 'NebulaNetworks' OR f.nome = 'AstroSupply' OR f.nome = 'HorizonDistributors'
  GROUP By NomeFornecedor, "AnoMes"
  ORDER BY NomeFornecedor
 )
 GROUP BY AnoMes;
 
 --Quadro Geral
SELECT Mes,
SUM(CASE WHEN Ano=='2020' THEN Qtd_Vendas ELSE 0 END) AS '2020',
SUM(CASE WHEN Ano=='2021' THEN Qtd_Vendas ELSE 0 END) AS '2021',
SUM(CASE WHEN Ano=='2022' THEN Qtd_Vendas ELSE 0 END) AS '2022',
SUM(CASE WHEN Ano=='2023' THEN Qtd_Vendas ELSE 0 END) AS '2023'
FROM(
    SELECT strftime('%m', data_venda) AS Mes, strftime('%Y', data_venda) AS Ano, COUNT(*) AS Qtd_Vendas
    FROM Vendas
    GROUP BY Mes, Ano
    ORDER BY Mes
    )
    GROUP BY Mes;
    
    
--Metrica
WITH Media_Vendas_Anteriores AS (SELECT AVG(Qtd_Vendas) AS Media_Qtd_Vendas
FROM (
    SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
    FROM vendas v
    WHERE strftime('%m', v.data_venda) = '11' AND Ano != '2022'
    GROUP BY Ano
)), Vendas_Atual AS (SELECT Qtd_Vendas AS Qtd_Vendas_Atual
FROM(
    SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
    FROM vendas v
    WHERE strftime('%m', v.data_venda) = '11' AND Ano = '2022'
    GROUP BY Ano
    ))
    SELECT
    mva.Media_Qtd_Vendas,
    va.Qtd_Vendas_Atual,
    ROUND((va.Qtd_Vendas_Atual - mva.Media_Qtd_Vendas)/mva.Media_Qtd_Vendas *100.0, 2) || '%' AS Porcentagem
    FROM Vendas_Atual va, Media_Vendas_Anteriores mva

