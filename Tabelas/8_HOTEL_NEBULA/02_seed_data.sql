USE hotel_nebula;

INSERT INTO hospedes
  (id_hospede, nome, email, cpf, telefone, data_nascimento, nacionalidade)
VALUES
  (1, 'Alice Moraes', 'alice.moraes@email.com', '111.111.111-11', '+55 11 90000-0001', '1990-04-12', 'Brasileira'),
  (2, 'Bruno Lima', 'bruno.lima@email.com', '222.222.222-22', '+55 21 90000-0002', '1987-08-03', 'Brasileiro'),
  (3, 'Carla Santos', 'carla.santos@email.com', '333.333.333-33', '+55 31 90000-0003', '1994-01-25', 'Brasileira'),
  (4, 'Diego Nunes', 'diego.nunes@email.com', '444.444.444-44', '+55 41 90000-0004', '1982-11-19', 'Brasileiro'),
  (5, 'Elisa Costa', 'elisa.costa@email.com', '555.555.555-55', '+55 51 90000-0005', '1992-06-07', 'Brasileira'),
  (6, 'Felipe Rocha', 'felipe.rocha@email.com', '666.666.666-66', '+55 61 90000-0006', '1989-02-14', 'Brasileiro');

INSERT INTO quartos
  (id_quarto, numero, andar, tipo, capacidade, preco_diaria, status, descricao)
VALUES
  (1, '101', 1, 'standard', 2, 250.00, 'disponivel', 'Quarto standard com vista para o jardim.'),
  (2, '102', 1, 'standard', 2, 250.00, 'disponivel', 'Quarto standard acessível.'),
  (3, '201', 2, 'suite', 2, 500.00, 'disponivel', 'Suíte com cama king e varanda.'),
  (4, '202', 2, 'deluxe', 2, 450.00, 'disponivel', 'Quarto deluxe com banheira.'),
  (5, '301', 3, 'familia', 4, 600.00, 'disponivel', 'Quarto família com dois ambientes.'),
  (6, '302', 3, 'standard', 2, 325.00, 'disponivel', 'Quarto standard com vista para a cidade.'),
  (7, '401', 4, 'suite', 2, 650.00, 'disponivel', 'Suíte premium com vista para o mar.'),
  (8, '402', 4, 'deluxe', 2, 425.00, 'manutencao', 'Quarto deluxe temporariamente em manutenção.');

INSERT INTO funcionarios
  (id_funcionario, nome, cpf, email, telefone, cargo, departamento, data_admissao)
VALUES
  (1, 'Juliana Martins', '900.000.000-01', 'juliana@hotelnebula.com', '+55 21 91000-0001', 'Recepcionista', 'Recepção', '2022-08-01'),
  (2, 'Marcos Vieira', '900.000.000-02', 'marcos@hotelnebula.com', '+55 21 91000-0002', 'Recepcionista', 'Recepção', '2021-03-15'),
  (3, 'Ana Ribeiro', '900.000.000-03', 'ana@hotelnebula.com', '+55 21 91000-0003', 'Supervisora', 'Hospedagem', '2020-05-10'),
  (4, 'Pedro Alves', '900.000.000-04', 'pedro@hotelnebula.com', '+55 21 91000-0004', 'Concierge', 'Atendimento', '2023-01-20'),
  (5, 'Lucas Melo', '900.000.000-05', 'lucas@hotelnebula.com', '+55 21 91000-0005', 'Recepcionista', 'Recepção', '2024-06-03');

INSERT INTO servicos
  (id_servico, nome, categoria, descricao, preco, disponivel)
VALUES
  (1, 'Café da manhã', 'alimentacao', 'Buffet servido no restaurante do hotel.', 45.00, TRUE),
  (2, 'Lavanderia', 'conveniencia', 'Lavagem de uma peça de roupa.', 80.00, TRUE),
  (3, 'Minibar', 'alimentacao', 'Consumo de item do minibar.', 25.00, TRUE),
  (4, 'Transfer aeroporto', 'transporte', 'Traslado entre o hotel e o aeroporto.', 120.00, TRUE),
  (5, 'Spa', 'bem_estar', 'Acesso a uma sessão de spa.', 180.00, TRUE),
  (6, 'Estacionamento', 'conveniencia', 'Uma diária de estacionamento.', 35.00, TRUE);

INSERT INTO reservas
  (id_reserva, codigo_reserva, id_hospede, id_quarto, data_checkin, data_checkout, num_hospedes, preco_diaria, status, canal, observacoes)
VALUES
  (1001, 'HN-2026-001', 1, 1, '2026-02-01', '2026-02-04', 2, 250.00, 'concluida', 'site', NULL),
  (1002, 'HN-2026-002', 2, 3, '2026-02-02', '2026-02-06', 2, 500.00, 'concluida', 'telefone', 'Solicitou travesseiro extra.'),
  (1003, 'HN-2026-003', 1, 4, '2026-03-10', '2026-03-12', 2, 450.00, 'concluida', 'site', NULL),
  (1004, 'HN-2026-004', 3, 5, '2026-12-01', '2026-12-05', 3, 600.00, 'confirmada', 'agencia', NULL),
  (1005, 'HN-2026-005', 4, 2, '2026-01-20', '2026-01-22', 1, 250.00, 'cancelada', 'site', 'Cancelada pelo hóspede.'),
  (1006, 'HN-2026-006', 5, 6, '2026-04-03', '2026-04-05', 2, 325.00, 'concluida', 'site', NULL),
  (1007, 'HN-2026-007', 6, 7, '2026-04-15', '2026-04-18', 2, 650.00, 'concluida', 'telefone', NULL),
  (1008, 'HN-2026-008', 2, 1, '2026-05-05', '2026-05-08', 2, 250.00, 'concluida', 'site', NULL),
  (1009, 'HN-2026-009', 3, 3, '2026-06-01', '2026-06-04', 2, 500.00, 'cancelada', 'agencia', 'Cancelada sem cobrança.'),
  (1010, 'HN-2026-010', 1, 5, '2026-12-15', '2026-12-20', 2, 600.00, 'confirmada', 'site', NULL),
  (1011, 'HN-2026-011', 4, 4, '2026-12-16', '2026-12-18', 2, 450.00, 'confirmada', 'site', NULL),
  (1012, 'HN-2026-012', 1, 1, '2026-07-02', '2026-07-04', 1, 250.00, 'concluida', 'telefone', NULL);

INSERT INTO hospedagens
  (id_hospedagem, id_reserva, id_funcionario_checkin, id_funcionario_checkout, checkin_real, checkout_real, status)
VALUES
  (2001, 1001, 1, 2, '2026-02-01 14:05:00', '2026-02-04 10:15:00', 'encerrada'),
  (2002, 1002, 1, 3, '2026-02-02 15:10:00', '2026-02-06 11:00:00', 'encerrada'),
  (2003, 1003, 2, 2, '2026-03-10 13:50:00', '2026-03-12 10:30:00', 'encerrada'),
  (2006, 1006, 5, 2, '2026-04-03 14:20:00', '2026-04-05 09:50:00', 'encerrada'),
  (2007, 1007, 1, 3, '2026-04-15 14:10:00', '2026-04-18 11:20:00', 'encerrada'),
  (2008, 1008, 2, 2, '2026-05-05 14:30:00', '2026-05-08 10:05:00', 'encerrada'),
  (2012, 1012, 5, 1, '2026-07-02 14:00:00', '2026-07-04 10:00:00', 'encerrada');

INSERT INTO hospedagem_servicos
  (id_hospedagem_servico, id_hospedagem, id_servico, quantidade, preco_unitario, consumido_em)
VALUES
  (1, 2001, 1, 2, 45.00, '2026-02-02 08:00:00'),
  (2, 2001, 3, 1, 25.00, '2026-02-03 21:00:00'),
  (3, 2002, 1, 4, 45.00, '2026-02-03 08:00:00'),
  (4, 2002, 4, 1, 120.00, '2026-02-02 16:00:00'),
  (5, 2003, 5, 1, 180.00, '2026-03-11 16:00:00'),
  (6, 2006, 1, 2, 45.00, '2026-04-04 08:00:00'),
  (7, 2007, 2, 1, 80.00, '2026-04-16 09:00:00'),
  (8, 2007, 6, 3, 35.00, '2026-04-15 14:10:00'),
  (9, 2008, 1, 3, 45.00, '2026-05-06 08:00:00'),
  (10, 2008, 3, 2, 25.00, '2026-05-07 22:00:00'),
  (11, 2012, 1, 2, 45.00, '2026-07-03 08:00:00');

INSERT INTO pagamentos
  (id_pagamento, id_hospedagem, valor, metodo, status, data_pagamento, codigo_transacao)
VALUES
  (1, 2001, 865.00, 'cartao_credito', 'pago', '2026-02-04 10:20:00', 'TX-HN-001'),
  (2, 2002, 2000.00, 'cartao_credito', 'pago', '2026-02-06 10:30:00', 'TX-HN-002A'),
  (3, 2002, 300.00, 'pix', 'pago', '2026-02-06 10:31:00', 'TX-HN-002B'),
  (4, 2003, 1080.00, 'pix', 'pago', '2026-03-12 10:35:00', 'TX-HN-003'),
  (5, 2006, 740.00, 'cartao_debito', 'pago', '2026-04-05 09:55:00', 'TX-HN-006'),
  (6, 2007, 2135.00, 'cartao_credito', 'pago', '2026-04-18 11:25:00', 'TX-HN-007'),
  (7, 2008, 935.00, 'pix', 'pago', '2026-05-08 10:10:00', 'TX-HN-008'),
  (8, 2012, 590.00, 'cartao_credito', 'pago', '2026-07-04 10:05:00', 'TX-HN-012');

INSERT INTO feedbacks
  (id_feedback, id_hospedagem, nota_geral, nota_limpeza, nota_atendimento, nota_conforto, comentario, data_avaliacao, visivel)
VALUES
  (1, 2001, 5.0, 5, 5, 5, 'Quarto muito limpo e equipe atenciosa.', '2026-02-05 09:00:00', TRUE),
  (2, 2002, 4.5, 5, 4, 4, 'Ótima localização e bom café da manhã.', '2026-02-07 09:00:00', TRUE),
  (3, 2003, 4.0, 4, 4, 4, 'Estadia agradável.', '2026-03-13 09:00:00', TRUE),
  (4, 2006, 4.8, 5, 5, 4, 'Tudo organizado e confortável.', '2026-04-06 09:00:00', TRUE),
  (5, 2007, 4.8, 5, 5, 5, 'Vista excelente e ótimo atendimento.', '2026-04-19 09:00:00', TRUE),
  (6, 2008, 4.7, 5, 4, 5, 'Voltaria a me hospedar.', '2026-05-09 09:00:00', TRUE),
  (7, 2012, 4.8, 5, 5, 4, 'Boa experiência, recomendo.', '2026-07-05 09:00:00', TRUE);

