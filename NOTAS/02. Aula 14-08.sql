-- MIN() MAX() -- 
-- Pessoa com menor salário --

DECLARE @salario_min DECIMAL(10,2);
SET @salario_min = (SELECT MIN (Salario) FROM FUNCIONARIO);
PRINT @salario_min;

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario = @salario_min;

-- COUNT() AVG() SUM() --
-- Quantas pessoas tem no banco COUNT --

SELECT COUNT (F.Cpf)
FROM FUNCIONARIO AS F;

SELECT COUNT (D.Nome_dependente)
FROM DEPENDENTE AS D;

SELECT
	(SELECT COUNT (F.Cpf) FROM FUNCIONARIO AS F) +
	(SELECT COUNT (D.Nome_dependente) FROM DEPENDENTE AS D)
	AS 'Quantidade de Pessoas'

-- Quem ganha abaixo da média (AVG) --

SELECT AVG (F.salario)
FROM FUNCIONARIO AS F;

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario < (SELECT AVG (F.salario) FROM FUNCIONARIO AS F)
ORDER BY F.Salario ASC;

-- Qual é o meu custo anual com a folha de pagamento dos funcionários (SUM) --

SELECT SUM (F.Salario * 12) AS 'Folha de Pagamento Anual'
FROM FUNCIONARIO AS F;

-- LIKE --
-- Recuper o(s) funcionário(s) nascido(s) no ano de 72 --

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Datanasc LIKE '__72%';
