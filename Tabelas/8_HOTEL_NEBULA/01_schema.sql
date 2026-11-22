CREATE DATABASE IF NOT EXISTS hotel_nebula
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE hotel_nebula;

CREATE TABLE IF NOT EXISTS hospedes (
  id_hospede INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  cpf VARCHAR(14) NULL,
  telefone VARCHAR(20) NULL,
  data_nascimento DATE NULL,
  nacionalidade VARCHAR(60) NULL,
  data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_hospede),
  UNIQUE KEY uq_hospedes_email (email),
  UNIQUE KEY uq_hospedes_cpf (cpf)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS quartos (
  id_quarto INT UNSIGNED NOT NULL AUTO_INCREMENT,
  numero VARCHAR(10) NOT NULL,
  andar SMALLINT NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  capacidade SMALLINT UNSIGNED NOT NULL,
  preco_diaria DECIMAL(10,2) NOT NULL,
  status ENUM('disponivel','manutencao','inativo') NOT NULL DEFAULT 'disponivel',
  descricao VARCHAR(500) NULL,
  PRIMARY KEY (id_quarto),
  UNIQUE KEY uq_quartos_numero (numero),
  CONSTRAINT chk_quartos_capacidade CHECK (capacidade > 0),
  CONSTRAINT chk_quartos_preco CHECK (preco_diaria >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS funcionarios (
  id_funcionario INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) NULL,
  email VARCHAR(150) NOT NULL,
  telefone VARCHAR(20) NULL,
  cargo VARCHAR(60) NOT NULL,
  departamento VARCHAR(60) NOT NULL,
  data_admissao DATE NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_funcionario),
  UNIQUE KEY uq_funcionarios_cpf (cpf),
  UNIQUE KEY uq_funcionarios_email (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reservas (
  id_reserva INT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo_reserva VARCHAR(20) NOT NULL,
  id_hospede INT UNSIGNED NOT NULL,
  id_quarto INT UNSIGNED NOT NULL,
  data_checkin DATE NOT NULL,
  data_checkout DATE NOT NULL,
  num_hospedes SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  preco_diaria DECIMAL(10,2) NOT NULL,
  status ENUM('confirmada','em_andamento','concluida','cancelada') NOT NULL DEFAULT 'confirmada',
  canal VARCHAR(30) NOT NULL DEFAULT 'site',
  observacoes VARCHAR(500) NULL,
  data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_reserva),
  UNIQUE KEY uq_reservas_codigo (codigo_reserva),
  KEY ix_reservas_periodo_quarto (id_quarto, data_checkin, data_checkout, status),
  KEY ix_reservas_hospede (id_hospede),
  CONSTRAINT fk_reservas_hospede FOREIGN KEY (id_hospede)
    REFERENCES hospedes (id_hospede) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reservas_quarto FOREIGN KEY (id_quarto)
    REFERENCES quartos (id_quarto) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_reservas_datas CHECK (data_checkout > data_checkin),
  CONSTRAINT chk_reservas_hospedes CHECK (num_hospedes > 0),
  CONSTRAINT chk_reservas_preco CHECK (preco_diaria >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS servicos (
  id_servico INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  categoria VARCHAR(50) NOT NULL,
  descricao VARCHAR(500) NULL,
  preco DECIMAL(10,2) NOT NULL,
  disponivel BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_servico),
  UNIQUE KEY uq_servicos_nome (nome),
  CONSTRAINT chk_servicos_preco CHECK (preco >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hospedagens (
  id_hospedagem INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_reserva INT UNSIGNED NOT NULL,
  id_funcionario_checkin INT UNSIGNED NULL,
  id_funcionario_checkout INT UNSIGNED NULL,
  checkin_real DATETIME NOT NULL,
  checkout_real DATETIME NULL,
  status ENUM('em_andamento','encerrada') NOT NULL DEFAULT 'em_andamento',
  observacoes VARCHAR(500) NULL,
  PRIMARY KEY (id_hospedagem),
  UNIQUE KEY uq_hospedagens_reserva (id_reserva),
  KEY ix_hospedagens_checkin_funcionario (id_funcionario_checkin),
  KEY ix_hospedagens_checkout_funcionario (id_funcionario_checkout),
  CONSTRAINT fk_hospedagens_reserva FOREIGN KEY (id_reserva)
    REFERENCES reservas (id_reserva) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_hospedagens_funcionario_checkin FOREIGN KEY (id_funcionario_checkin)
    REFERENCES funcionarios (id_funcionario) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_hospedagens_funcionario_checkout FOREIGN KEY (id_funcionario_checkout)
    REFERENCES funcionarios (id_funcionario) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT chk_hospedagens_datas CHECK (checkout_real IS NULL OR checkout_real >= checkin_real)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hospedagem_servicos (
  id_hospedagem_servico INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_hospedagem INT UNSIGNED NOT NULL,
  id_servico INT UNSIGNED NOT NULL,
  quantidade SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  preco_unitario DECIMAL(10,2) NOT NULL,
  consumido_em DATETIME NOT NULL,
  PRIMARY KEY (id_hospedagem_servico),
  KEY ix_hospedagem_servicos_hospedagem (id_hospedagem),
  KEY ix_hospedagem_servicos_servico (id_servico),
  CONSTRAINT fk_hospedagem_servicos_hospedagem FOREIGN KEY (id_hospedagem)
    REFERENCES hospedagens (id_hospedagem) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_hospedagem_servicos_servico FOREIGN KEY (id_servico)
    REFERENCES servicos (id_servico) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_hospedagem_servicos_quantidade CHECK (quantidade > 0),
  CONSTRAINT chk_hospedagem_servicos_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pagamentos (
  id_pagamento INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_hospedagem INT UNSIGNED NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  metodo ENUM('dinheiro','cartao_credito','cartao_debito','pix','transferencia') NOT NULL,
  status ENUM('pendente','pago','estornado') NOT NULL DEFAULT 'pendente',
  data_pagamento DATETIME NULL,
  codigo_transacao VARCHAR(100) NULL,
  PRIMARY KEY (id_pagamento),
  UNIQUE KEY uq_pagamentos_transacao (codigo_transacao),
  KEY ix_pagamentos_data_status (data_pagamento, status),
  KEY ix_pagamentos_hospedagem (id_hospedagem),
  CONSTRAINT fk_pagamentos_hospedagem FOREIGN KEY (id_hospedagem)
    REFERENCES hospedagens (id_hospedagem) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_pagamentos_valor CHECK (valor > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS feedbacks (
  id_feedback INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_hospedagem INT UNSIGNED NOT NULL,
  nota_geral DECIMAL(2,1) NOT NULL,
  nota_limpeza TINYINT UNSIGNED NULL,
  nota_atendimento TINYINT UNSIGNED NULL,
  nota_conforto TINYINT UNSIGNED NULL,
  comentario VARCHAR(1000) NULL,
  resposta_hotel VARCHAR(1000) NULL,
  respondido_por INT UNSIGNED NULL,
  data_avaliacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  visivel BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_feedback),
  UNIQUE KEY uq_feedbacks_hospedagem (id_hospedagem),
  KEY ix_feedbacks_nota (nota_geral),
  CONSTRAINT fk_feedbacks_hospedagem FOREIGN KEY (id_hospedagem)
    REFERENCES hospedagens (id_hospedagem) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_feedbacks_funcionario FOREIGN KEY (respondido_por)
    REFERENCES funcionarios (id_funcionario) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT chk_feedbacks_nota_geral CHECK (nota_geral BETWEEN 1 AND 5),
  CONSTRAINT chk_feedbacks_nota_limpeza CHECK (nota_limpeza IS NULL OR nota_limpeza BETWEEN 1 AND 5),
  CONSTRAINT chk_feedbacks_nota_atendimento CHECK (nota_atendimento IS NULL OR nota_atendimento BETWEEN 1 AND 5),
  CONSTRAINT chk_feedbacks_nota_conforto CHECK (nota_conforto IS NULL OR nota_conforto BETWEEN 1 AND 5)
) ENGINE=InnoDB;
