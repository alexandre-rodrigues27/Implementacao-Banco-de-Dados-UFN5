-- IN
-- Recupere as informações dos funcionários que recebem 25000 e 30000 R$

SELECT * 
FROM FUNCIONARIO AS F
WHERE F.Salario IN (25000, 30000);

-- Recupere os registros dos funcionários que trabalham (TRABALHAM_EM) no mesmo
-- projeto e na mesma quantidade de horas do "Fernando" (Fcpf = "33344555587")

-- Resgata o CPF do Fernando
SELECT F.Cpf
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Fernando';

-- Resgata os projetos em que o Fernando participa
SELECT T.Pnr
FROM TRABALHA_EM AS T
WHERE T.Fcpf = 33344555587;

-- Resgata os funcionários que no mesmo projeto e na mesma quantidade de horas que Fernando
SELECT F.Pnome, T.Pnr
FROM TRABALHA_EM AS T, FUNCIONARIO AS F
WHERE F.Cpf = T.Fcpf 
    AND F.Pnome <> 'Fernando'
    AND T.Pnr IN (SELECT T.Pnr 
                  FROM TRABALHA_EM AS T 
                  WHERE T.Fcpf = (SELECT F.Cpf 
                                  FROM FUNCIONARIO AS F 
                                  WHERE F.Pnome = 'Fernando'));

-- BETWEEN
-- Recuperar todos os funcionários no departamento 5 cujo salário 
-- esteja entre R$ 30.000 e R$ 40.000

SELECT * 
FROM FUNCIONARIO AS F
WHERE F.Dnr = 5 AND F.Salario BETWEEN 30000 and 40000;

--INNER JOIN
-- Primeiro nome, último nome, endereço dos funcionários que trabalham no departamento "Pesquisa"

SELECT Pnome, Unome, Endereco, Dnome
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero 
WHERE D.Dnome = 'Pesquisa';

-- Nome dos funcionários que estão desenvolvendo o "ProdutoX"
SELECT Pnome, Minicial, Unome, Horas, Projnome
FROM TRABALHA_EM AS T
INNER JOIN PROJETO AS P
ON T.Pnr = P.Projnumero
INNER JOIN FUNCIONARIO AS F
ON T.Fcpf = F.Cpf
WHERE P.Projnome = 'ProdutoX';

-- Para cada projeto localizado em "Mauá", liste o número do projeto, o número do 
-- departamento que  o controla, endereço e data de nascimento do gerente do departamento

-- Número do departamento que controla os projetos localizados em Mauá
SELECT D.Dnome, D.Dnumero, P.Projnome, P.Projlocal, F.Unome, D.Cpf_gerente, F.Endereco, F.Datanasc
FROM DEPARTAMENTO AS D
INNER JOIN PROJETO AS P
ON P.Dnum = D.Dnumero
INNER JOIN FUNCIONARIO AS F
ON F.Cpf = D.Cpf_gerente
WHERE P.Projlocal = 'Mauá';

-- LEFT JOIN
-- Liste o último nome de TODOS os funcionários e seus respectivos departamentos
SELECT F.Unome, D.Dnome
FROM FUNCIONARIO AS F
LEFT JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero;

-- RIGHT JOIN
-- Encontre os departamentos que não possuem funcionários
SELECT D.Dnome
FROM FUNCIONARIO AS F
RIGHT JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE F.Cpf IS NULL;

-- CROSS JOIN
-- Teste entre as relações FUNCIONARIO e DEPARTAMENTO
SELECT F.Pnome, D.Dnome
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnumero IS NULL OR F.Cpf IS NULL;

-- SELF JOIN
-- Crie uma consulta que mostra apenas os funcionários que têm um supervisor
SELECT F1.Pnome AS 'Funcionario' , F2.Unome 'Supervisor'
FROM FUNCIONARIO AS F1
JOIN FUNCIONARIO AS F2
ON F1.Cpf = F2.Cpf_supervisor
ORDER BY F1.Pnome ASC;

-- UNION
-- Listar todos os nomes, sexo e data de nascimento de todas as pessoas do banco
SELECT F.Pnome AS 'Nome', F.Sexo AS 'Sexo', F.Datanasc AS 'Data'
FROM FUNCIONARIO AS F

UNION

SELECT D.Nome_dependente AS 'Nome', D.Sexo AS 'Sexo', D.Datanasc AS 'Data'
FROM DEPENDENTE AS D;
