/*================================================================================*/
/* CREATE TABLES                                                                  */
/*================================================================================*/

CREATE TABLE zona (
  id_zona SERIAL NOT NULL,
  tx_nome VARCHAR(32) NOT NULL,
  CONSTRAINT pk_zona PRIMARY KEY (id_zona)
);

CREATE TABLE estado (
  id_estado SERIAL NOT NULL,
  tx_nome VARCHAR(56) NOT NULL,
  tx_sigla CHAR(2) NOT NULL,
  CONSTRAINT pk_estado PRIMARY KEY (id_estado)
);

CREATE TABLE cidade (
  id_cidade SERIAL NOT NULL,
  id_estado INTEGER NOT NULL,
  tx_nome VARCHAR(56) NOT NULL,
  CONSTRAINT pk_cidade PRIMARY KEY (id_cidade, id_estado)
);

CREATE TABLE bairro (
  id_bairro SERIAL NOT NULL,
  id_zona INTEGER NOT NULL,
  id_cidade INTEGER NOT NULL,
  id_estado INTEGER NOT NULL,
  tx_nome VARCHAR(64) NOT NULL,
  CONSTRAINT pk_bairro PRIMARY KEY (id_bairro)
);

CREATE TABLE estado_civil (
  id_estado_civil SERIAL NOT NULL,
  tx_descricao VARCHAR(36) NOT NULL,
  CONSTRAINT pk_estado_civil PRIMARY KEY (id_estado_civil)
);

CREATE TABLE cliente (
  id_cliente SERIAL NOT NULL,
  id_bairro INTEGER NOT NULL,
  id_estado_civil INTEGER NOT NULL,
  tx_nome VARCHAR(64) NOT NULL,
  nb_renda_mensal NUMERIC(16,2) NOT NULL,
  cs_sexo CHAR(1) NOT NULL,
  cs_status CHAR(1) NOT NULL CHECK (cs_status in ('A','D')),
  CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)
);

CREATE TABLE departamento (
  id_departamento SERIAL NOT NULL,
  tx_nome VARCHAR(56) NOT NULL,
  CONSTRAINT pk_departamento PRIMARY KEY (id_departamento)
);

CREATE TABLE filial (
  id_filial SERIAL NOT NULL,
  id_bairro INTEGER NOT NULL,
  tx_nome VARCHAR(64) NOT NULL,
  CONSTRAINT pk_filial PRIMARY KEY (id_filial)
);

CREATE TABLE fornecedor (
  id_fornecedor SERIAL NOT NULL,
  id_bairro INTEGER NOT NULL,
  tx_nome VARCHAR(56) NOT NULL,
  tx_cnpj VARCHAR(20) NOT NULL,
  CONSTRAINT pk_fornecedor PRIMARY KEY (id_fornecedor)
);

CREATE TABLE funcionario (
  id_funcionario SERIAL NOT NULL,
  id_departamento INTEGER NOT NULL,
  id_estado_civil INTEGER NOT NULL,
  id_funcionario_gerente INTEGER,
  tx_nome VARCHAR(56) NOT NULL,
  nb_salario NUMERIC(16,2) NOT NULL,
  tx_login VARCHAR(10) NOT NULL,
  tx_senha VARCHAR(10) NOT NULL,
  dt_admissao DATE,
  dt_nascimento DATE,
  CONSTRAINT pk_funcionario PRIMARY KEY (id_funcionario)
);

CREATE TABLE grupo_produto (
  id_grupo_produto SERIAL NOT NULL,
  tx_descricao VARCHAR(40) NOT NULL,
  nb_comissao NUMERIC(16,2) NOT NULL,
  nb_percentual_lucro NUMERIC(5,2) NOT NULL,
  CONSTRAINT pk_grupo_produto PRIMARY KEY (id_grupo_produto)
);

CREATE TABLE venda (
  id_venda SERIAL NOT NULL,
  id_filial INTEGER NOT NULL,
  id_cliente INTEGER NOT NULL,
  dt_venda TIMESTAMP NOT NULL,
  CONSTRAINT pk_venda PRIMARY KEY (id_venda)
);

CREATE TABLE produto (
  id_produto SERIAL NOT NULL,
  id_grupo_produto INTEGER NOT NULL,
  id_fornecedor INTEGER NOT NULL,
  tx_nome VARCHAR(56) NOT NULL,
  nb_preco_custo NUMERIC(16,2) NOT NULL,
  nb_preco_venda NUMERIC(16,2) NOT NULL,
  cs_status CHAR(1) NOT NULL CHECK (cs_status in ('A','D')),
  CONSTRAINT pk_produto PRIMARY KEY (id_produto)
);

CREATE TABLE item_venda (
  id_item_venda SERIAL NOT NULL,
  id_venda INTEGER NOT NULL,
  id_produto INTEGER NOT NULL,
  nb_quantidade NUMERIC(16,3) NOT NULL,
  CONSTRAINT pk_item_venda PRIMARY KEY (id_item_venda, id_venda)
);

/*================================================================================*/
/* CREATE INDEXES                                                                 */
/*================================================================================*/

CREATE UNIQUE INDEX ak_tx_nome_zona ON zona (tx_nome);

CREATE UNIQUE INDEX ak_tx_descricao ON estado_civil (tx_descricao);

CREATE UNIQUE INDEX ak_tx_nome_departamento ON departamento (tx_nome);

CREATE UNIQUE INDEX ak_tx_cnpj ON fornecedor (tx_cnpj);

CREATE UNIQUE INDEX ak_tx_login ON funcionario (tx_login);

/*================================================================================*/
/* CREATE FOREIGN KEYS                                                            */
/*================================================================================*/

ALTER TABLE cidade
  ADD CONSTRAINT fk_cidade_estado
  FOREIGN KEY (id_estado) REFERENCES estado (id_estado);

ALTER TABLE bairro
  ADD CONSTRAINT fk_bairro_zona
  FOREIGN KEY (id_zona) REFERENCES zona (id_zona);

ALTER TABLE bairro
  ADD CONSTRAINT fk_bairro_cidade
  FOREIGN KEY (id_cidade, id_estado) REFERENCES cidade (id_cidade, id_estado);

ALTER TABLE cliente
  ADD CONSTRAINT fk_cliente_bairro
  FOREIGN KEY (id_bairro) REFERENCES bairro (id_bairro);

ALTER TABLE cliente
  ADD CONSTRAINT fk_cliente_estado_civil
  FOREIGN KEY (id_estado_civil) REFERENCES estado_civil (id_estado_civil);

ALTER TABLE filial
  ADD CONSTRAINT fk_filial_bairro
  FOREIGN KEY (id_bairro) REFERENCES bairro (id_bairro);

ALTER TABLE fornecedor
  ADD CONSTRAINT FK_fornecedor_bairro
  FOREIGN KEY (id_bairro) REFERENCES bairro (id_bairro);

ALTER TABLE funcionario
  ADD CONSTRAINT fk_funcionario_departamento
  FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento);

ALTER TABLE funcionario
  ADD CONSTRAINT fk_funcionario_estado_civil
  FOREIGN KEY (id_estado_civil) REFERENCES estado_civil (id_estado_civil);

ALTER TABLE funcionario
  ADD CONSTRAINT fk_funcionario_gerente
  FOREIGN KEY (id_funcionario_gerente) REFERENCES funcionario (id_funcionario);

ALTER TABLE venda
  ADD CONSTRAINT fk_venda_filial
  FOREIGN KEY (id_filial) REFERENCES filial (id_filial);

ALTER TABLE venda
  ADD CONSTRAINT fk_venda_cliente
  FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente);

ALTER TABLE produto
  ADD CONSTRAINT fk_produto_grupo_produto
  FOREIGN KEY (id_grupo_produto) REFERENCES grupo_produto (id_grupo_produto);

ALTER TABLE produto
  ADD CONSTRAINT fk_produto_fornecedor
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor);

ALTER TABLE item_venda
  ADD CONSTRAINT fk_item_venda_venda
  FOREIGN KEY (id_venda) REFERENCES venda (id_venda);

ALTER TABLE item_venda
  ADD CONSTRAINT fk_item_venda_produto
  FOREIGN KEY (id_produto) REFERENCES produto (id_produto);

