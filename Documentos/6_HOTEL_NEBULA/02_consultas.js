const hotel = db.getSiblingDB("hotel_nebula");

// Quartos disponíveis com vista para o mar ou banheira.
hotel.quartos.find({
  status: "disponivel",
  $or: [
    { "caracteristicas.vista": "mar" },
    { "caracteristicas.banheira": true }
  ]
}, { numero: 1, tipo: 1, comodidades: 1, caracteristicas: 1 });

// Hóspedes com mais de uma reserva não cancelada.
hotel.reservas.aggregate([
  { $match: { status: { $ne: "cancelada" } } },
  {
    $group: {
      _id: "$hospede_id",
      nome: { $first: "$hospede_snapshot.nome" },
      total_reservas: { $sum: 1 }
    }
  },
  { $match: { total_reservas: { $gt: 1 } } },
  { $sort: { total_reservas: -1, nome: 1 } }
]);

// Faturamento recebido em abril de 2026.
hotel.pagamentos.aggregate([
  {
    $match: {
      status: "pago",
      data_pagamento: {
        $gte: ISODate("2026-04-01T00:00:00Z"),
        $lt: ISODate("2026-05-01T00:00:00Z")
      }
    }
  },
  {
    $group: {
      _id: { $dateToString: { format: "%Y-%m", date: "$data_pagamento" } },
      faturamento: { $sum: "$valor_total" },
      pagamentos: { $sum: 1 }
    }
  },
  { $project: { _id: 0, mes: "$_id", faturamento: 1, pagamentos: 1 } }
]);

// Meses com mais reservas não canceladas, agrupadas pelo mês de check-in.
hotel.reservas.aggregate([
  { $match: { status: { $ne: "cancelada" } } },
  {
    $group: {
      _id: { $dateToString: { format: "%Y-%m", date: "$data_checkin" } },
      total_reservas: { $sum: 1 }
    }
  },
  { $sort: { total_reservas: -1, _id: 1 } },
  { $project: { _id: 0, mes: "$_id", total_reservas: 1 } }
]);

// Dias da semana com mais check-ins (1 = domingo, 7 = sábado).
hotel.reservas.aggregate([
  { $match: { status: { $ne: "cancelada" } } },
  {
    $group: {
      _id: { $dayOfWeek: "$data_checkin" },
      total_checkins: { $sum: 1 }
    }
  },
  { $sort: { total_checkins: -1, _id: 1 } },
  { $project: { _id: 0, dia_semana: "$_id", total_checkins: 1 } }
]);
