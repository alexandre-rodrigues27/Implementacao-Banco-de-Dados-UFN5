CREATE DATABASE CAIXA;

USE CAIXA;

CREATE TABLE conta(
	ID INT PRIMARY KEY,
	Nome VARCHAR(50),
	Saldo MONEY
);

INSERT INTO conta
VALUES (10, 'Maria', 500),
	   (20, 'João', 1500),
	   (30, 'Paulo', 30000),
	   (40, 'Maria', 50000);
GO;

-- Primeira Transação --
BEGIN TRAN;
DECLARE @erro INT = 0;

INSERT INTO conta
VALUES (50, 'Pedro', 50);
SET @erro = @erro + @@ERROR

INSERT INTO conta
VALUES (10, 'Judas', 666);
SET @erro = @erro + @@ERROR

SELECT * FROM CONTA;

IF @erro <> 0
BEGIN
	PRINT 'Transação revertida!'
	ROLLBACK TRAN;
END
ELSE
BEGIN
	PRINT 'Transação realizada com sucesso!'
	COMMIT TRAN;
END

SELECT * FROM CONTA;


-- Segunda Transação --
BEGIN TRAN;
UPDATE conta 
SET Saldo = Saldo + 10000
WHERE Nome = 'Maria';

IF @@ROWCOUNT <> 1
BEGIN
	SELECT * FROM conta;
	ROLLBACK TRAN;
END
ELSE
	COMMIT TRAN;
GO;

-- Transferir dinheiro de uma pessoa para outra --
CREATE OR ALTER PROCEDURE usp_transferencia	
	@ContaOrigem INT,
	@ContaDestino INT,
	@Valor MONEY
AS
BEGIN
	BEGIN TRAN; 
	DECLARE @SaldoOrigem MONEY;
	-- Tirando dinheiro da conta de origem
	UPDATE conta
	SET Saldo = Saldo - @Valor
	WHERE ID = @ContaOrigem;

	--Depositando na conta de destino
	UPDATE conta
	SET Saldo = Saldo + @Valor
	WHERE ID = @ContaDestino;

	-- Ver possível estado da tabela conta
	SELECT * FROM conta;
	SELECT @SaldoOrigem = Saldo FROM conta WHERE ID = @ContaOrigem;

	-- Condição para Rollback
	IF @SaldoOrigem < 0
	BEGIN
		ROLLBACK TRAN;
		PRINT 'Saldo insuficiente!'
		SELECT * FROM conta;
	END

	-- Condição para Commit
	ELSE
	BEGIN
		COMMIT TRAN;
		PRINT 'Transferência realizada!'
	END
END

SELECT * FROM conta;

EXEC usp_transferencia 40, 10, 500;


-- Save point --
BEGIN TRAN;
INSERT INTO conta
VALUES (50, 'Pedro', 50);

-- SAVE POINT --
SAVE TRAN pedroOK
INSERT INTO conta
VALUES (10, 'Juca', -200);

IF @@ERROR <> 0 
BEGIN
	ROLLBACK TRAN pedroOK;
	COMMIT TRAN;
	PRINT 'Voltamos para o save point';
END
ELSE
	COMMIT TRAN;

SELECT * FROM conta;


-- TRY CATCH --
BEGIN TRY
	PRINT 'Olá TRY CATCH!';
	SELECT 1/0; -- ERRO

	PRINT 'NÃO CHEGUEI AQUI!';

END TRY
BEGIN CATCH
	PRINT 'DEU ERRO!'
	PRINT 'Número : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
END CATCH


-- TRANSACTION + TRY CATCH --
BEGIN TRAN;
	BEGIN TRY;
		INSERT INTO conta
		VALUES (60, 'Mateus', 15);
		SELECT * FROM conta;
		INSERT INTO conta
		VALUES (10, 'Juca', -200);
		COMMIT TRAN;
		SELECT * FROM conta;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT 'DEU ERRO!'
		PRINT 'Número : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
	END CATCH;
SELECT * FROM conta;
GO;

-- Procedure para inserir novo usuário no banco (não permita duplicidade de nomes) --
CREATE OR ALTER PROCEDURE usp_inserir
	@ID INT,
	@Nome VARCHAR(150),
	@Saldo MONEY
AS
BEGIN 
	BEGIN TRAN;
	BEGIN TRY
		INSERT INTO conta
		VALUES (@ID, @Nome, @Saldo);
		IF (SELECT COUNT(*) FROM conta WHERE nome = @nome) > 1
		BEGIN
			ROLLBACK TRAN;
			PRINT 'Já existe um usuário com esse nome';
		END
		ELSE
		BEGIN
			COMMIT TRAN
			PRINT 'Usuário cadastrado com sucesso!'
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT 'DEU ERRO!'
		PRINT 'Número : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
	END CATCH
END
go

EXEC usp_inserir 80, 'José', 600;
SELECT * FROM conta;
		
