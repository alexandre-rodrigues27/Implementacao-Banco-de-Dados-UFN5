-- Criando TRIGGER 
-- para mensagem após adicionar um departamento -- 

-- INSERTED --
-- recupera o valor que foi inserido -- 
CREATE OR ALTER TRIGGER trg_after_insert_departamento
ON DEPARTAMENTO
AFTER INSERT
AS 
BEGIN
	DECLARE @nome VARCHAR(40);
	SELECT @nome = I.Dnome
	FROM inserted AS I

	PRINT 'Foi inserido um novo departamento: ' + @nome;
END;
GO 

INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES (100, 'Estoque');
GO


-- Criando TRIGGER INSTEAD OF -- 
-- onde o comando é trocado para o que tem dentro do bloco -- 
CREATE TRIGGER trg_insteadof_delete_dpt
ON DEPARTAMENTO
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'NÃO DELETEI o registro';
END
GO

DELETE FROM DEPARTAMENTO 
WHERE Dnumero = 88;
GO


-- Desabilitar TRIGGER --
ALTER TABLE DEPARTAMENTO 
DISABLE TRIGGER trg_insteadof_delete_dpt;
GO


-- TRIGGER para não permitir nomes duplicados em DEPARTAMENTO -- 
CREATE OR ALTER TRIGGER trg_insteadof_insert_dpt
ON DEPARTAMENTO
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @nome VARCHAR(40);
    -- atribuir a variável @nome o valor que está no INSERT --
    SELECT @nome = I.Dnome
	FROM inserted AS I

    IF EXISTS (
        SELECT 1
        FROM DEPARTAMENTO AS D
        WHERE Dnome = @nome)

        RAISERROR('Já existe um departamento com esse nome', 16,1);
    ELSE
        INSERT INTO DEPARTAMENTO (Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
        SELECT I.Dnumero, I.Dnome, I.Cpf_gerente, I.Data_inicio_gerente 
        FROM inserted AS I
END
GO

SELECT * FROM DEPARTAMENTO;
INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES (100, 'Vendas');
GO


-- UPDATE() -- 
-- verificar se um nome foi alterado --
CREATE OR ALTER TRIGGER trg_for_update_nome
ON DEPARTAMENTO
FOR UPDATE -- FOR = AFTER
AS
BEGIN
    DECLARE @nome_antigo VARCHAR(40),
            @nome_novo VARCHAR(40);

    SELECT @nome_antigo = D.Dnome FROM deleted AS D
    SELECT @nome_novo = I.Dnome FROM inserted AS I
    IF UPDATE(Dnome)
    BEGIN
        PRINT 'Nome';
        PRINT 'Antigo: ' + @nome_antigo;
        PRINT 'Novo: ' + @nome_novo;
    END 
    ELSE 
        PRINT 'O nome não foi alterado';
END

UPDATE DEPARTAMENTO
SET Dnome = 'TI'
WHERE Dnome = 'Tecnologia'
GO


-- Criando tabela LOG --
CREATE TABLE LOG_FUNCIONARIO(
    log_id INT IDENTITY(100, 1) PRIMARY KEY,
    cpf CHAR(11),
    operacao VARCHAR(10),
    data_hora DATETIME DEFAULT GETDATE()
)
GO


-- TRIGGER de log de insert --
CREATE TRIGGER trg_for_insert_funcionario
ON FUNCIONARIO 
FOR INSERT
AS
BEGIN
    INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
    SELECT I.Cpf, 'INSERT'
    FROM inserted AS I
END
GO

-- TRIGGER de log de update --
CREATE TRIGGER trg_for_update_funcionario
ON FUNCIONARIO 
FOR UPDATE
AS
BEGIN
    INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
    SELECT I.Cpf, 'UPDATE'
    FROM inserted AS I
END
GO

-- TRIGGER de log de delete --
CREATE TRIGGER trg_for_delete_funcionario
ON FUNCIONARIO 
FOR DELETE
AS
BEGIN
    INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
    SELECT I.Cpf, 'DELETE'
    FROM deleted AS I
END

INSERT INTO FUNCIONARIO (Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus, Data_Admissao, Dnr)
VALUES ('Juca', ' da Silva', '12345678900', '2000-05-10', 'Rua Sete', 'M', 1100, 0, '2026-10-23', 9);

UPDATE FUNCIONARIO
SET Salario = 500
WHERE Cpf = '12345678900';

DELETE FROM FUNCIONARIO
WHERE Cpf = '12345678900';
GO


-- VIEW --
CREATE VIEW vw_rh_funcionario_dpt
AS
SELECT 
    CONCAT(Pnome, ' ', Minicial, '.', Unome) AS 'Nome',
    DATEDIFF(YEAR, Datanasc, GETDATE()) AS 'Idade',
    Endereco AS 'Endereço', 
    Data_Admissao AS 'Admissão',
    D.Dnome AS 'Departamento'
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero;
GO

SELECT * FROM vw_rh_funcionario_dpt ORDER BY 'Departamento';
SELECT * FROM vw_rh_funcionario_dpt WHERE DEPARTAMENTO = 'Matriz';

-- Exercícios --
-- Criar uma tabela para guardar todas as alterações de salários sofridas
-- por um funcionário. Em seguida crie triggers para guardar nesta tabela 
-- informações sobre essas alterações (id, cpf, salario anterior, data e hora)

