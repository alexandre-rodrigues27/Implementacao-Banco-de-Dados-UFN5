USE EMPRESA

-- CAST -- 
GO;
DECLARE @nome VARCHAR(100), 
		@salario DECIMAL(10,2)

SET @nome = 'Jennifer';

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'O funcionário(a) ' 
	  + @nome 
	  + ' tem um salário de: R$' 
	  + CAST(@salario AS VARCHAR(10));
GO;


-- CONVERT -- 
GO;
DECLARE @nome VARCHAR(100), 
		@salario DECIMAL(10,2),
		@data_nasc DATE;

SET @nome = 'Jennifer';

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

SELECT @data_nasc = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'O funcionário(a) ' 
	  + @nome 
	  + ' nasceu em ' 
	  + CONVERT(VARCHAR(10), @data_nasc, 103);
GO;


-- IF/ELSE -- 
GO;
DECLARE @nome VARCHAR(100), 
		@salario DECIMAL(10,2),
		@salario_medio DECIMAL (10,2);

SET @nome = 'Jennifer';

SELECT @salario_medio = AVG(F.Salario)
FROM FUNCIONARIO AS F;

SELECT @salario = Salario
FROM FUNCIONARIO 
WHERE  @nome = Pnome;

IF (@salario < @salario_medio)
	PRINT 'O funcionário(a) ' 
		  + @nome
		  + ' ganha ABAIXO da média';

ELSE
	PRINT 'O funcionário(a) ' 
		  + @nome
		  + ' ganha ACIMA da média';
GO;

-- IF/ELSE (2) --
GO;
DECLARE @ano_atual INT,
		@ano_nasc INT,
		@nome VARCHAR(100),
		@idade INT;

SET @nome = 'Fernando';
SET @ano_atual = YEAR(GETDATE());

SELECT @ano_nasc = YEAR(Datanasc)
FROM FUNCIONARIO 
WHERE @nome = Pnome;

SET @idade = @ano_atual - @ano_nasc;

IF (@idade <= 55)
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) +' --> LONGE' 
ELSE IF (@idade > 55 AND @idade <= 60)
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) +' --> PRÓXIMO'
ELSE
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' --> PASSOU'
GO;


-- DESAFIO -- 
-- Calcular a idade correta --
GO;
DECLARE @data_nasc DATE,
		@nome VARCHAR(100),
		@idade INT;

SET @nome = 'Maria';

SELECT @data_nasc = Datanasc
FROM FUNCIONARIO
WHERE Pnome = @nome

IF (MONTH(GETDATE()) < MONTH(@data_nasc))
	SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE()) -1

ELSE IF (MONTH(GETDATE()) = MONTH(@data_nasc) 
		AND DAY(GETDATE()) < DAY(@data_nasc))
	SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE()) -1

ELSE
	SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE()) 

PRINT @data_nasc
PRINT @idade
GO;


-- IIF --
GO;
SELECT
	F.Pnome,
	F.Unome,
	F.Salario,
	IIF(F.Salario < 20000, 'Baixo', 'Alto') AS 'Categoria'
FROM FUNCIONARIO AS F;
GO;


-- CASE --
GO;
SELECT
	F.Pnome,
	F.Unome,
	F.Salario,
	CASE
		WHEN F.Salario > 0 AND F.Salario <= 10000 THEN 'Baixo'
		WHEN F.Salario > 10000 AND F.Salario <=  30000 THEN 'Médio'
		WHEN F.Salario > 30000 THEN 'Alto'
		ELSE 'ERRO'
	END AS 'Categoria'
FROM FUNCIONARIO AS F;
GO;


-- WHILE --
GO;
DECLARE @contador INT = 0;

WHILE @contador < 10
BEGIN 
	SET @contador = @contador + 1
	IF @contador % 2 = 0 
		PRINT 'Contador: ' + CAST(@contador AS VARCHAR(3));
--BREAK = QUANDO ACONTECER TIRA DO LAÇO
--CONTINUE = ENQUANTO ACONTECER SEGUE NO LAÇO
END
GO;


-- CURSORES --
DECLARE @nome VARCHAR(50);

DECLARE cursorFuncionario CURSOR FOR
SELECT Pnome FROM FUNCIONARIO;

OPEN cursorFuncionario

FETCH NEXT FROM cursorFuncionario INTO @nome;

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @nome;
	FETCH NEXT FROM cursorFuncionario INTO @nome;
END

CLOSE cursorFuncionario;
DEALLOCATE cursorFuncionario;


-- 1. Variáveis no SQL Server

GO;
DECLARE @NomeProduto VARCHAR(100),
        @QtdEstoque INT,
        @PrecoProduto DECIMAL(10,2);

SET @NomeProduto = 'Notebook';
SET @QtdEstoque = 15;
SET @PrecoProduto = 2999.99;

PRINT 'Produto: ' + @NomeProduto;
PRINT 'Quantidade em estoque: ' + CAST(@QtdEstoque AS VARCHAR(10));
PRINT 'Preço: R$' + CAST(@PrecoProduto AS VARCHAR(10));

SELECT 
    @NomeProduto AS NomeProduto,
    @QtdEstoque AS QuantidadeEstoque,
    @PrecoProduto AS PrecoProduto;
GO;

GO;
DECLARE @SalarioBase DECIMAL(10,2),
        @Bonus DECIMAL(10,2),
        @SalarioTotal DECIMAL(10,2);

SET @SalarioBase = 5000.00;
SET @Bonus = 800.00;

SET @SalarioTotal = @SalarioBase + @Bonus;

PRINT 'Salário Total: R$' + CAST(@SalarioTotal AS VARCHAR(10));

SELECT @SalarioTotal AS SalarioTotal;
GO;


-- 3. Estruturas Condicionais no SQL
GO;
DECLARE @Idade INT;

SET @Idade = 20;

IF (@Idade >= 18)
	PRINT 'Maior de Idade';
ELSE
	PRINT 'Menor de Idade';
GO;

GO;
DECLARE @NotaFinal DECIMAL(5,2);

SET @NotaFinal = 82;

IF (@NotaFinal >= 90)
	PRINT 'Aprovado com Excelência';
ELSE IF (@NotaFinal >= 70 AND @NotaFinal < 90)
	PRINT 'Aprovado';
ELSE IF (@NotaFinal >= 50 AND @NotaFinal < 70)
	PRINT 'Em Recuperação';
ELSE
	PRINT 'Reprovado';
GO;

GO;
DECLARE @Ano INT;

SET @Ano = 2024;

IF ((@Ano % 4 = 0 AND @Ano % 100 <> 0) OR (@Ano % 400 = 0))
	PRINT 'Ano Bissexto';
ELSE
	PRINT 'Ano Comum';
GO;


-- 4. Loops no SQL
GO;
DECLARE @Contador INT = 1;

WHILE @Contador <= 10
BEGIN
	PRINT 'Número: ' + CAST(@Contador AS VARCHAR(3));
	SET @Contador = @Contador + 1;
END
GO;

GO;
DECLARE @Valor INT = 100;

WHILE @Valor >= 50
BEGIN
	PRINT 'Valor: ' + CAST(@Valor AS VARCHAR(5));
	SET @Valor = @Valor - 5;
END
GO;

GO;
DECLARE @Indice INT = 1,
        @TotalProdutos INT,
        @PrecoLimite DECIMAL(10,2),
        @NomeProduto VARCHAR(100),
        @PrecoProduto DECIMAL(10,2);

SET @PrecoLimite = 100.00;

SELECT @TotalProdutos = COUNT(*) FROM Produtos;

WHILE @Indice <= @TotalProdutos
BEGIN
	SELECT 
		@NomeProduto = Nome,
		@PrecoProduto = Preco
	FROM (
		SELECT 
			Nome, 
			Preco,
			ROW_NUMBER() OVER (ORDER BY Nome) AS NumeroLinha
		FROM Produtos
	) AS ProdutosNumerados
	WHERE NumeroLinha = @Indice;

	IF (@PrecoProduto > @PrecoLimite)
		PRINT 'Produto: ' + @NomeProduto + ' - Preço: R$' + CAST(@PrecoProduto AS VARCHAR(10));

	SET @Indice = @Indice + 1;
END
GO;

GO;
DECLARE @Numero INT = 2;

WHILE @Numero <= 1000
BEGIN
	PRINT 'Número: ' + CAST(@Numero AS VARCHAR(10));
	SET @Numero = @Numero * 2;
END
GO;
