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
