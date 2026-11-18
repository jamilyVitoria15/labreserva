-- LabReserva: esquema do banco de dados (MySQL 8)
-- Recria o banco do zero a cada execução.

DROP DATABASE IF EXISTS labreserva;
CREATE DATABASE labreserva
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE labreserva;

CREATE TABLE usuarios (
  id         INT          NOT NULL AUTO_INCREMENT,
  nome       VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL,
  senha_hash VARCHAR(100) NOT NULL,
  perfil     ENUM('ALUNO', 'PROFESSOR', 'ADMIN') NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_usuarios_email (email)
) ENGINE=InnoDB;

CREATE TABLE laboratorios (
  id         INT          NOT NULL AUTO_INCREMENT,
  codigo     VARCHAR(20)  NOT NULL,
  nome       VARCHAR(100) NOT NULL,
  capacidade INT          NOT NULL,
  recursos   VARCHAR(255),
  ativo      BOOLEAN      NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id),
  UNIQUE KEY uk_laboratorios_codigo (codigo),
  CONSTRAINT ck_laboratorios_capacidade CHECK (capacidade > 0)
) ENGINE=InnoDB;

CREATE TABLE reservas (
  id                INT          NOT NULL AUTO_INCREMENT,
  laboratorio_id    INT          NOT NULL,
  usuario_id        INT          NOT NULL,
  data              DATE         NOT NULL,
  hora_inicio       TIME         NOT NULL,
  hora_fim          TIME         NOT NULL,
  participantes     INT          NOT NULL,
  finalidade        VARCHAR(200) NOT NULL,
  status            ENUM('PENDENTE', 'CONFIRMADA', 'RECUSADA', 'CANCELADA')
                    NOT NULL DEFAULT 'PENDENTE',
  criada_em         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  grupo_recorrencia VARCHAR(36)  NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_reservas_laboratorio FOREIGN KEY (laboratorio_id)
    REFERENCES laboratorios (id),
  CONSTRAINT fk_reservas_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuarios (id),
  CONSTRAINT ck_reservas_horario CHECK (hora_fim > hora_inicio),
  CONSTRAINT ck_reservas_participantes CHECK (participantes > 0),
  INDEX idx_reservas_lab_data (laboratorio_id, data),
  INDEX idx_reservas_usuario (usuario_id),
  INDEX idx_reservas_grupo (grupo_recorrencia)
) ENGINE=InnoDB;
