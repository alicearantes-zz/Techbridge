CREATE DATABASE techbridge;
USE techbridge;

-- cadastro empresa
CREATE TABLE tb_empresa(
	emp_id INT AUTO_INCREMENT PRIMARY KEY,
	emp_nome VARCHAR(255) NOT NULL, 
	emp_cnpj VARCHAR(20) NOT NULL UNIQUE, 
	emp_email VARCHAR(100) NOT NULL UNIQUE,
	emp_cep VARCHAR(9) NOT NULL,
	emp_rua VARCHAR(255) NOT NULL,
	emp_numero VARCHAR(10),
	emp_complemento VARCHAR(100),
	emp_bairro VARCHAR(255),
	emp_cidade VARCHAR(255),
	emp_estado CHAR(2),
	emp_pais VARCHAR(100) default 'Brasil',
	emp_contato VARCHAR(200) NOT NULL,
	emp_tipo_empresa VARCHAR(50) NOT NULL, 
	emp_data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Diagnostico
CREATE TABLE tb_diagnostico(
	diag_id INT AUTO_INCREMENT PRIMARY KEY,
	emp_id INT NOT NULL,
	diag_data DATE,
	diag_nivel_geral ENUM('BAIXO', 'MÉDIO', 'ALTO'),
	diag_observacoes TEXT,
	FOREIGN KEY (emp_id) REFERENCES tb_empresa (emp_id)
);

-- avaliacao (juncao da area, vulnerabilidade e solucao)
CREATE TABLE tb_avaliacao(
	avl_id INT AUTO_INCREMENT PRIMARY KEY, 
	diag_id INT NOT NULL,
	avl_nome_area VARCHAR(50) NOT NULL,
	avl_nome_vulnerabilidade VARCHAR(100) NOT NULL,
	avl_descricao TEXT,
	avl_nivel_risco ENUM('BAIXO', 'MÉDIO', 'ALTO'),
	avl_solucao TEXT,
	avl_prioridade ENUM('BAIXA', 'MÉDIA', 'ALTA'),
	FOREIGN KEY (diag_id) REFERENCES tb_diagnostico (diag_id)
);

-- resultado diagnostico
CREATE TABLE tb_resultado_diagnostico(
	resu_id INT AUTO_INCREMENT PRIMARY KEY, 
	diag_id INT NOT NULL,
	avl_id INT NOT NULL,
	resu_nivel_impacto ENUM('BAIXO','MÉDIO','ALTO'),
	resu_status ENUM('PENDENTE','EM_ANDAMENTO','FINALIZADO'),
	resu_data_inicio DATE,
	resu_data_fim DATE,
	FOREIGN KEY (diag_id ) REFERENCES tb_diagnostico(diag_id),
	FOREIGN KEY (avl_id) REFERENCES tb_avaliacao(avl_id)
);


-- insert 

-- insert empresa 
INSERT INTO tb_empresa( emp_nome, emp_cnpj, emp_email, emp_cep, emp_rua, emp_numero,
 emp_complemento, emp_bairro, emp_cidade, emp_estado, emp_pais, emp_contato, emp_tipo_empresa, emp_data_cadastro) VALUES 
 ('AgileTech Solutions', '35.985.357/0097-55', 'contato@agiletech.com', '98798-098', 'Machado de Assis', '347',
 'Ap 10º andar', 'Brigadeiro', 'Taboão da Serra', 'SP', 'Brasil', '(11) 98765-8753', 'Tecnologia', '2026-01-10'),
 ('Inova Gestão', '76.008.766/1167-00', 'inova@gest.com', '87533-064', 'Argentina', '76', 'Ap. 3º andar', 'Catuaba',
 'São Bento', 'SP', 'Brasil', '(11) 98756-5443', 'Consultoria', '2025-09-27');

-- insert diagnostico
INSERT INTO  tb_diagnostico( emp_id, diag_data, diag_nivel_geral, diag_observacoes) VALUES
(1, '2026-01-15', 'ALTO', 'Empresa sem processos ágeis definidos'),
(2, '2025-10-01', 'MÉDIO', 'Uso parcial de métodos ágeis');

-- insert avalicao
INSERT INTO tb_avaliacao(diag_id, avl_nome_area, avl_nome_vulnerabilidade, avl_descricao, avl_nivel_risco,
avl_solucao, avl_prioridade) VALUES 
-- SCRUM
(1, 'Gestão de Projetos', 'Falta de SCRUM estruturado', 'Não há definição de sprints, blacklog ou daily meeting',
'ALTO', 'Implementar SCRUM com definição de papéis e cerimônias', 'ALTA'),
-- Kanban
(2, 'Operacional', 'Fluxo desorganizado', 'Equipe não utiliza quadro Kanban para visualizar tarefas', 'MÉDIO', 'Implementar Kanban
para controle visual de tarefas', 'MÉDIA'),
-- SWOT 
(2, 'Estratégia', 'Ausência de análise SWOT', 'Empresa não analisa forças, fraquezas, oportunidade e ameaças', 
'ALTO', 'Aplicar Matriz SWOT para planejamento estratégico', 'ALTA');

-- insert resultado 
INSERT INTO  tb_resultado_diagnostico( diag_id, avl_id, resu_nivel_impacto, resu_status,
resu_data_inicio, resu_data_fim) VALUES 
(1, 1, 'ALTO', 'PENDENTE', '2026-01-15', '2026-01-30'),	
(2, 3, 'MÉDIO', 'EM_ANDAMENTO', '2026-03-06', '2026-04-10');

-- UPDATE atualizando dados

UPDATE tb_empresa 
SET
	emp_nome = 'Ecogestor',
    emp_email = 'gestor@eco.com'
WHERE emp_id = 1;

SELECT * FROM tb_empresa WHERE emp_id = 1;

-- DELETE 
DELETE FROM tb_empresa 
WHERE emp_cnpj = '35.985.357/0097-58';


-- GROUP BY
SELECT emp_cidade, COUNT(*) AS total_empresas
FROM tb_empresa 
GROUP BY emp_cidade;