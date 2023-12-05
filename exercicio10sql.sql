CREATE DATABASE hospital_plano
GO
USE hospital_plano
GO
CREATE TABLE plano_saude
(
    codigo INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    telefone CHAR(13) NOT NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE paciente 
(
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    telefone CHAR(13) NOT NULL,
    plano_saude INT NOT NULL
    PRIMARY KEY (cpf)
    FOREIGN KEY (plano_saude) REFERENCES plano_saude(codigo)
)
GO
CREATE TABLE medico 
(
    codigo INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL,
    plano_saude INT NOT NULL
    PRIMARY KEY (codigo)
    FOREIGN KEY (plano_saude) REFERENCES plano_saude(codigo)
)
GO
CREATE TABLE consulta
(
    codigo_medico INT NOT NULL,
    cpf_paciente CHAR(11) NOT NULL,
    datahora DATETIME NOT NULL,
    diagnostico VARCHAR(50) NOT NULL
    PRIMARY KEY (codigo_medico, cpf_paciente, datahora)
    FOREIGN KEY (codigo_medico) REFERENCES medico(codigo),
    FOREIGN KEY (cpf_paciente) REFERENCES paciente(cpf)
)

INSERT INTO plano_saude 
VALUES
(1234, 'Amil', '41599856'),
(2345, 'Sul Am�rica', '45698745'),
(3456, 'Unimed', '48759836'),
(4567, 'Bradesco Sa�de', '47265897'),
(5678, 'Interm�dica', '41415269')

INSERT INTO paciente 
VALUES
('85987458920', 'Maria Paula', 'R. Volunt�rios da P�tria', 589, 'Santana', '98458741', 2345),
('87452136900', 'Ana Julia', 'R. XV de Novembro', 657, 'Centro', '69857412', 5678),
('23659874100', 'Jo�o Carlos', 'R. Sete de Setembro', 12, 'Rep�blica', '74859632', 1234),
('63259874100', 'Jos� Lima', 'R. Anhaia', 768, 'Barra Funda', '96524156', 2345)

INSERT INTO medico 
VALUES
('Claudio', 'Cl�nico Geral', 1234),
('Larissa', 'Ortopedista', 2345),
('Juliana', 'Otorrinolaringologista', 4567),
('S�rgio', 'Pediatra', 1234),
('Julio', 'Cl�nico Geral', 4567),
('Samara', 'Cirurgi�o', 1234)

INSERT INTO consulta 
VALUES
(1, '85987458920', '2021-02-10 10:30:00', 'Gripe'),
(2, '23659874100', '2021-02-10 11:00:00', 'P� Fraturado'),
(4, '85987458920', '2021-02-11 14:00:00', 'Pneumonia'),
(1, '23659874100', '2021-02-11 15:00:00', 'Asma'),
(3, '87452136900', '2021-02-11 16:00:00', 'Sinusite'),
(5, '63259874100', '2021-02-11 17:00:00', 'Rinite'),
(4, '23659874100', '2021-02-11 18:00:00', 'Asma'),
(5, '63259874100', '2021-02-12 10:00:00', 'Rinoplastia')


select*from plano_saude
select*from paciente
select*from medico
select*from consulta

-- consultas: 
--1) Consultar Nome e especialidade dos m�dicos da Amil
select med.nome as 'Medico', med.especialidade as 'Especialidade'
from medico med inner join plano_saude pd on med.plano_saude= pd.codigo
where pd.nome like 'Amil'

--2) Consultar Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes
select paci.nome as 'nome',  paci.rua+'-'+ paci.bairro+'-'+Cast(paci.numero as varchar)as 'Endereco', paci.telefone as 'Telefone', ps.nome as 'nome do plano'
from paciente paci inner join plano_saude ps on paci.plano_saude=ps.codigo

--3) Consultar Telefone do Plano de  Sa�de de Ana J�lia
select ps.telefone as'Telefone do plano'
from plano_saude ps inner join paciente pac on ps.codigo=pac.plano_saude
where pac.nome like 'Ana%'

--4) Consultar Plano de Sa�de que n�o tem pacientes cadastrados
select ps.nome as 'Nome do Plano'
from plano_saude ps left join paciente pac on ps.codigo=pac.plano_saude
where pac.plano_saude is null

--5) Consultar Planos de Sa�de que n�o tem m�dicos cadastrados
select ps.nome as 'Nome do Plano'
from plano_saude ps left join medico med on ps.codigo=med.plano_saude
where med.plano_saude is null

--6) Consultar Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas
SELECT m.nome,
CONVERT(VARCHAR, datahora, 103) AS data_consulta, 
CONVERT(VARCHAR, datahora, 108) AS hora_consulta,
m.nome, p.nome, c.diagnostico 
FROM consulta c, medico m, paciente p 
WHERE c.codigo_medico = m.codigo 
	AND c.cpf_paciente = p.cpf 

--7)Consultar Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima
select med.nome as 'Nome do medico', cons.diagnostico as'Diagnostico',
Convert(VARCHAR, cons.datahora,103) as data_consulta,
Convert(varchar, cons.datahora,108) as hora_consulta
from medico med inner join consulta cons on  med.codigo=cons.codigo_medico
inner join paciente pac on cons.cpf_paciente= pac.cpf
where pac.nome like'Jos�%'

--8)Consultar Diagn�stico e Quantidade de consultas que aquele diagn�stico foi dado (Coluna deve chamar qtd)
select COUNT(cons.diagnostico) as 'qtd', cons.diagnostico
from consulta cons
GROUP BY cons.diagnostico

--9)Consultar Quantos Planos de Sa�de que n�o tem m�dicos cadastrados
select Count(ps.codigo) as'Quantidade de plano sem medicos', ps.nome
from plano_saude ps left join medico med on ps.codigo=med.plano_saude
where med.plano_saude is null
group by ps.nome
 --10) Alterar o nome de Jo�o Carlos para Jo�o Carlos da Silva
 update paciente
 set nome='Jo�o Carlos da Silva'
 where nome like 'Jo�o%'
 select*from paciente
--11)Deletar o plano de Sa�de Unimed
delete plano_saude
where nome like 'Unimed'

--12)Renomear a coluna Rua da tabela Paciente para Logradouro.
EXEC sp_rename 'Paciente.Rua', 'Logradouro', 'COLUMN';

--13) Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente.
ALTER TABLE paciente 
ADD data_nasc DATE

UPDATE paciente 
SET data_nasc = '1990-04-18'
WHERE nome LIKE 'Jo�o%'

UPDATE paciente 
SET data_nasc = '1981-03-25'
WHERE nome LIKE 'Jos�%'

UPDATE paciente 
SET data_nasc = '2004-09-04'
WHERE nome LIKE 'Maria%'

UPDATE paciente 
SET data_nasc = '1986-06-18'
WHERE nome LIKE 'Ana%'

select*from paciente



