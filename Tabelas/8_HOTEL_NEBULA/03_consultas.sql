USE hotel_nebula;

-- 1. Quartos disponíveis no período informado.
SET @data_checkin = '2026-12-02';
SET @data_checkout = '2026-12-04';

SELECT q.id_quarto, q.numero, q.tipo, q.capacidade, q.preco_diaria
FROM quartos AS q
WHERE q.status = 'disponivel'
  AND NOT EXISTS (
    SELECT 1
    FROM reservas AS r
    WHERE r.id_quarto = q.id_quarto
      AND r.status <> 'cancelada'
      AND r.data_checkin < @data_checkout
      AND r.data_checkout > @data_checkin
  )
ORDER BY q.numero;

-- 2. Hóspedes com mais reservas. A consulta inclui reservas canceladas.
SELECT h.id_hospede, h.nome, COUNT(*) AS total_reservas
FROM hospedes AS h
JOIN reservas AS r ON r.id_hospede = h.id_hospede
GROUP BY h.id_hospede, h.nome
ORDER BY total_reservas DESC, h.nome;

-- 3. Faturamento recebido por mês no ano de 2026.
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       SUM(valor) AS faturamento_recebido
FROM pagamentos
WHERE status = 'pago'
  AND data_pagamento >= '2026-01-01'
  AND data_pagamento < '2027-01-01'
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m')
ORDER BY mes;

-- 4. Serviços extras mais consumidos, por quantidade de unidades.
SELECT s.id_servico, s.nome,
       SUM(hs.quantidade) AS unidades_consumidas,
       SUM(hs.quantidade * hs.preco_unitario) AS receita_servico
FROM servicos AS s
JOIN hospedagem_servicos AS hs ON hs.id_servico = s.id_servico
GROUP BY s.id_servico, s.nome
ORDER BY unidades_consumidas DESC, s.nome;

-- 5. Quartos com as melhores avaliações; mostra também o total de avaliações.
SELECT q.id_quarto, q.numero,
       ROUND(AVG(f.nota_geral), 2) AS media_avaliacao,
       COUNT(*) AS total_avaliacoes
FROM quartos AS q
JOIN reservas AS r ON r.id_quarto = q.id_quarto
JOIN hospedagens AS hp ON hp.id_reserva = r.id_reserva
JOIN feedbacks AS f ON f.id_hospedagem = hp.id_hospedagem
WHERE f.visivel = TRUE
GROUP BY q.id_quarto, q.numero
ORDER BY media_avaliacao DESC, total_avaliacoes DESC, q.numero;

-- 6. Reservas canceladas.
SELECT r.codigo_reserva, h.nome AS hospede, q.numero AS quarto,
       r.data_checkin, r.data_checkout, r.canal
FROM reservas AS r
JOIN hospedes AS h ON h.id_hospede = r.id_hospede
JOIN quartos AS q ON q.id_quarto = r.id_quarto
WHERE r.status = 'cancelada'
ORDER BY r.data_checkin;

-- 7. Hospedagens atendidas por profissional, separadas por função.
SELECT f.id_funcionario, f.nome, atendimento.funcao,
       COUNT(*) AS total_hospedagens
FROM (
  SELECT id_funcionario_checkin AS id_funcionario, 'check-in' AS funcao
  FROM hospedagens
  WHERE id_funcionario_checkin IS NOT NULL
  UNION ALL
  SELECT id_funcionario_checkout AS id_funcionario, 'check-out' AS funcao
  FROM hospedagens
  WHERE id_funcionario_checkout IS NOT NULL
) AS atendimento
JOIN funcionarios AS f ON f.id_funcionario = atendimento.id_funcionario
GROUP BY f.id_funcionario, f.nome, atendimento.funcao
ORDER BY f.nome, atendimento.funcao;
