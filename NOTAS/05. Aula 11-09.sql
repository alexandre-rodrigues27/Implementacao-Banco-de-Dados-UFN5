-- Função Dobro Salario --
CREATE OR ALTER FUNCTION fn_dobro (@numero DECIMAL (10,2))
RETURNS DECIMAL (10,2)
AS
BEGIN
	RETURN @numero*2;
END
GO;

DECLARE @menor_salario DECIMAL (10,2);
SELECT @menor_salario = MIN(Salario)
FROM FUNCIONARIO;
SELECT 
	Pnome,
	Unome,
	F.Salario,
	dbo.fn_dobro(F.Salario) AS 'Dobro Salario'
FROM FUNCIONARIO AS F
WHERE F.Salario > dbo.fn_dobro (@menor_salario)
GO;


-- Função Idade (Calcular Idade a partir da Data de Nascimento) --
CREATE FUNCTION fn_calcula_idade (@data_nasc DATE)
RETURNS INT
AS
BEGIN
	DECLARE @idade INT;
	SET @idade = DATEDIFF (YEAR, @data_nasc, GETDATE());
	IF (MONTH (@data_nasc) > MONTH (GETDATE())
		OR MONTH (@data_nasc) = MONTH (GETDATE()) AND
				DAY (@data_nasc) > DAY (GETDATE()))
		SET @idade = @idade-1;
	RETURN @idade;
END
GO;

SELECT 
	D.Nome_dependente,
	D.Datanasc,
	dbo.fn_calcula_idade(D.Datanasc) AS 'Idade'
FROM DEPENDENTE AS D;
GO;

SELECT 
	F.Pnome,
	F.Unome,
	CONVERT (VARCHAR, F.Datanasc, 103) AS 'Data de Nascimento',
	dbo.fn_calcula_idade (F.Datanasc) AS 'Idade'
FROM FUNCIONARIO AS F;
GO;


-- Função Retornar Tabela (Funcionários de Determinado Departamento) -- 
CREATE FUNCTION fn_func_dpt (@nome_dpt VARCHAR (50))
RETURNS TABLE
AS
RETURN
(
	SELECT 
		F.Pnome,
		F.Unome
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
	WHERE D.Dnome = @nome_dpt
);
GO;

SELECT * FROM dbo.fn_func_dpt ('Pesquisa');
GO;


-- Função Para Criar Tabela --
-- (Retornando Nome Completo e Valor Salário Anual + Férias + 13º) --
CREATE FUNCTION fn_salario_anual()
RETURNS @SalarioAnual TABLE
(
	nome_comp VARCHAR(100),
	salario DECIMAL(10,2),
	salario_anual DECIMAL(10,2)
)
AS 
BEGIN
	INSERT INTO @SalarioAnual
	SELECT
		CONCAT(F.Pnome, ' ', F.Minicial, ' ', F.Unome),
		F.Salario,
		F.Salario*13+(F.Salario*0.3)
	FROM FUNCIONARIO AS F;
	RETURN;
END
GO;

SELECT * FROM dbo.fn_salario_anual();
GO;


-- Procedimento Armazenado (Exibir Nome) -- 
CREATE PROCEDURE sp_exibe_meu_nome
AS
BEGIN
	PRINT 'Alexandre Kikuchi Rodrigues';
END
GO;

EXEC sp_exibe_meu_nome;
GO;


-- Criar um Procedure para Reajustar o Salário Anual --
-- (Salvando no Banco) --
CREATE OR ALTER PROCEDURE sp_aumento(
	@porcentagem DECIMAL(3,1),
	@cpf CHAR(11))
AS 
BEGIN
	UPDATE FUNCIONARIO
    SET Salario = Salario*(1+(@porcentagem/100))
	WHERE Cpf = @cpf
END
GO;

EXEC dbo.sp_aumento @porcentagem = 5, @cpf = '98765432300'
SELECT * FROM FUNCIONARIO;
GO;


-- Criar Procedure Criptografado --
CREATE PROCEDURE sp_funcionarios 
WITH ENCRYPTION 
AS 
SELECT * FROM FUNCIONARIO;
GO;

-- Criar um Procedure que Insire um Novo Departamento --
-- e sua Localidade no Banco --
CREATE PROCEDURE sp_add_dpt_loc (
	@dpt_nome VARCHAR(50),
	@dpt_numero INT,
	@local VARCHAR(50))
AS
BEGIN
	IF EXISTS (SELECT 1 
			   FROM DEPARTAMENTO 
			   WHERE Dnome = @dpt_nome)
		BEGIN
			PRINT 'Já existe um departamento ' + @dpt_nome;
			RETURN;
		END
	ELSE
		BEGIN
			INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
			VALUES (@dpt_nome, @dpt_numero);

			INSERT INTO LOCALIZACAO_DEP (Dnumero, Dlocal)
			VALUES (@dpt_numero, @local);
			PRINT @dpt_nome + ' inserido com sucesso!'
			PRINT @local + ' inserido com sucesso!'
		END
END
GO;

EXEC sp_add_dpt_loc 'Compras', 130, 'Santa Maria';

SELECT *
FROM DEPARTAMENTO AS D
JOIN LOCALIZACAO_DEP AS L
ON D.Dnumero = L.Dnumero;


-- Criar Procedure que Lista os Funcionários por Departamento --
-- Se o Departamento não for Especificado, Listar Todos os Funcionários --
