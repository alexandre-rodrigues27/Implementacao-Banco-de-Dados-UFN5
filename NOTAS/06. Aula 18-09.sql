-- Adicionar um Novo Funcionário e Verificar se Já Existe (Nome Completo) --
CREATE OR ALTER PROCEDURE sp_add_funcionario (
	@nome VARCHAR(20),
	@meio_inicial CHAR(1),
	@sobrenome VARCHAR(20),
	@cpf VARCHAR(11))
AS
BEGIN
	IF EXISTS (SELECT 1 
			   FROM FUNCIONARIO 
			   WHERE @nome = Pnome 
			   AND @meio_inicial = Minicial
			   AND @sobrenome = Unome)
		BEGIN
			PRINT 'Já existe um funcionário com o nome de: ' + @nome + @meio_inicial + @sobrenome;
			RETURN;
		END
	ELSE
		BEGIN
			INSERT INTO FUNCIONARIO (Pnome, Unome, Minicial, Cpf)
			VALUES (@nome, @sobrenome, @meio_inicial, @cpf);
			PRINT @nome + @meio_inicial + @sobrenome + ' inserido com sucesso!'
		END
END
GO

EXEC sp_add_funcionario 'Alexandre', ' K', ' Rodrigues', '00011122200';
GO

-- Duplicar o Valor Utilizando o OUTPUT --
CREATE PROCEDURE sp_duplica (@valor AS INT OUTPUT)
AS
SELECT @valor*2
RETURN
GO

DECLARE @numero AS INT = 15;
EXEC sp_duplica @numero OUTPUT;
PRINT @numero;
GO


-- Somar o Salário de Todos os Funcionários de um --
-- Determinado Departamento --
CREATE OR ALTER PROCEDURE sp_soma_salario (
	@dpt_id INT,
	@salario_total DECIMAL(10,2) OUTPUT)
AS
BEGIN
	SELECT @salario_total = SUM(F.Salario)
	FROM FUNCIONARIO AS F
	WHERE Dnr = @dpt_id
	IF @salario_total IS NULL
		SET @salario_total=0
END

DECLARE @s_total DECIMAL(10,2);
EXEC sp_soma_salario @salario_total=@s_total OUTPUT, @dpt_id=99;
PRINT 'O Salário total é: ' + CAST(@s_total AS VARCHAR(10));

