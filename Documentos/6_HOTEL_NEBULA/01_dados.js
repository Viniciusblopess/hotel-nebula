const hotel = db.getSiblingDB("hotel_nebula");

const validators = {
  hospedes: {
    bsonType: "object",
    required: ["nome", "email", "ativo"],
    properties: {
      _id: { bsonType: "string" },
      nome: { bsonType: "string" },
      email: { bsonType: "string" },
      cpf: { bsonType: ["string", "null"] },
      telefone: { bsonType: ["string", "null"] },
      endereco: { bsonType: "object" },
      preferencias: { bsonType: "object" },
      ativo: { bsonType: "bool" }
    }
  },
  quartos: {
    bsonType: "object",
    required: ["numero", "tipo", "capacidade_max", "preco_diaria", "status"],
    properties: {
      _id: { bsonType: "string" },
      numero: { bsonType: "string" },
      tipo: { bsonType: "string" },
      capacidade_max: { bsonType: "int", minimum: 1 },
      preco_diaria: { bsonType: ["double", "decimal", "int", "long"], minimum: 0 },
      comodidades: { bsonType: "array", items: { bsonType: "string" } },
      caracteristicas: { bsonType: "object" },
      status: { enum: ["disponivel", "manutencao", "inativo"] }
    }
  },
  reservas: {
    bsonType: "object",
    required: ["hospede_id", "quarto_id", "data_checkin", "data_checkout", "status"],
    properties: {
      _id: { bsonType: "string" },
      hospede_id: { bsonType: "string" },
      quarto_id: { bsonType: "string" },
      data_checkin: { bsonType: "date" },
      data_checkout: { bsonType: "date" },
      status: { enum: ["confirmada", "concluida", "cancelada", "em_andamento"] },
      valor_total: { bsonType: ["double", "decimal", "int", "long"], minimum: 0 }
    }
  },
  hospedagens: {
    bsonType: "object",
    required: ["reserva_id", "hospede_id", "quarto_id", "servicos_consumidos", "status"],
    properties: {
      _id: { bsonType: "string" },
      reserva_id: { bsonType: "string" },
      hospede_id: { bsonType: "string" },
      quarto_id: { bsonType: "string" },
      servicos_consumidos: { bsonType: "array" },
      status: { enum: ["encerrada", "em_andamento"] },
      total_geral: { bsonType: ["double", "decimal", "int", "long"], minimum: 0 }
    }
  },
  pagamentos: {
    bsonType: "object",
    required: ["hospedagem_id", "valor_total", "status", "data_pagamento"],
    properties: {
      _id: { bsonType: "string" },
      hospedagem_id: { bsonType: "string" },
      valor_total: { bsonType: ["double", "decimal", "int", "long"], minimum: 0 },
      status: { enum: ["pago", "pendente", "estornado"] },
      data_pagamento: { bsonType: "date" },
      parcelas: { bsonType: "array" }
    }
  },
  funcionarios: {
    bsonType: "object",
    required: ["nome", "cargo", "ativo"],
    properties: {
      _id: { bsonType: "string" },
      nome: { bsonType: "string" },
      cargo: { bsonType: "string" },
      permissoes: { bsonType: "array", items: { bsonType: "string" } },
      ativo: { bsonType: "bool" }
    }
  },
  servicos: {
    bsonType: "object",
    required: ["nome", "categoria", "preco", "disponivel"],
    properties: {
      _id: { bsonType: "string" },
      nome: { bsonType: "string" },
      categoria: { bsonType: "string" },
      preco: { bsonType: ["double", "decimal", "int", "long"], minimum: 0 },
      disponivel: { bsonType: "bool" }
    }
  },
  feedbacks: {
    bsonType: "object",
    required: ["hospede_id", "hospedagem_id", "quarto_id", "nota_geral", "data_avaliacao"],
    properties: {
      _id: { bsonType: "string" },
      hospede_id: { bsonType: "string" },
      hospedagem_id: { bsonType: "string" },
      quarto_id: { bsonType: "string" },
      nota_geral: { bsonType: ["double", "decimal", "int", "long"], minimum: 1, maximum: 5 },
      data_avaliacao: { bsonType: "date" },
      visivel: { bsonType: "bool" }
    }
  }
};

for (const [name, schema] of Object.entries(validators)) {
  if (!hotel.getCollectionNames().includes(name)) {
    hotel.createCollection(name, {
      validator: { $jsonSchema: schema },
      validationLevel: "strict",
      validationAction: "error"
    });
  }
}

hotel.hospedes.createIndex({ email: 1 }, { unique: true });
hotel.hospedes.createIndex({ cpf: 1 }, {
  unique: true,
  partialFilterExpression: { cpf: { $type: "string" } }
});
hotel.quartos.createIndex({ numero: 1 }, { unique: true });
hotel.reservas.createIndex({ hospede_id: 1, data_checkin: -1 });
hotel.reservas.createIndex({ codigo_reserva: 1 }, { unique: true });
hotel.reservas.createIndex({ quarto_id: 1, data_checkin: 1, data_checkout: 1, status: 1 });
hotel.hospedagens.createIndex({ reserva_id: 1 }, { unique: true });
hotel.pagamentos.createIndex({ status: 1, data_pagamento: 1 });
hotel.feedbacks.createIndex({ quarto_id: 1, nota_geral: -1 });

const seeds = {
  hospedes: [
    {
      _id: "hsp001", nome: "Carlos Andrade", cpf: "123.456.789-00",
      email: "carlos.andrade@email.com", telefone: "+55 11 98765-4321",
      nacionalidade: "Brasileiro", ativo: true,
      endereco: { cidade: "São Paulo", estado: "SP", pais: "Brasil" },
      preferencias: { tipo_quarto: "suite", andar_alto: true, cama: "king" },
      data_cadastro: ISODate("2026-01-10T10:30:00Z")
    },
    {
      _id: "hsp002", nome: "Marina Costa", cpf: "234.567.890-11",
      email: "marina.costa@email.com", telefone: "+55 21 98888-2222",
      nacionalidade: "Brasileira", ativo: true,
      endereco: { cidade: "Rio de Janeiro", estado: "RJ", pais: "Brasil" },
      preferencias: { tipo_quarto: "deluxe", andar_alto: false, cama: "queen" },
      data_cadastro: ISODate("2026-01-12T11:00:00Z")
    },
    {
      _id: "hsp003", nome: "Paulo Lima", cpf: "345.678.901-22",
      email: "paulo.lima@email.com", telefone: "+55 31 97777-3333",
      nacionalidade: "Brasileiro", ativo: true,
      endereco: { cidade: "Belo Horizonte", estado: "MG", pais: "Brasil" },
      preferencias: { tipo_quarto: "standard", andar_alto: false, cama: "casal" },
      data_cadastro: ISODate("2026-01-15T09:00:00Z")
    }
  ],
  quartos: [
    {
      _id: "qrt101", numero: "101", andar: 1, tipo: "standard", categoria: "economico",
      capacidade_max: NumberInt(2), preco_diaria: 250.00, status: "disponivel",
      comodidades: ["ar-condicionado", "wifi", "frigobar"],
      caracteristicas: { vista: "jardim", banheira: false, varanda: false, area_m2: 28 }
    },
    {
      _id: "qrt201", numero: "201", andar: 2, tipo: "suite", categoria: "premium",
      capacidade_max: NumberInt(2), preco_diaria: 500.00, status: "disponivel",
      comodidades: ["ar-condicionado", "wifi", "frigobar", "banheira"],
      caracteristicas: { vista: "mar", banheira: true, varanda: true, area_m2: 48 }
    },
    {
      _id: "qrt301", numero: "301", andar: 3, tipo: "familia", categoria: "familia",
      capacidade_max: NumberInt(4), preco_diaria: 600.00, status: "disponivel",
      comodidades: ["ar-condicionado", "wifi", "cozinha compacta"],
      caracteristicas: { vista: "cidade", banheira: false, varanda: true, area_m2: 55 }
    },
    {
      _id: "qrt401", numero: "401", andar: 4, tipo: "deluxe", categoria: "premium",
      capacidade_max: NumberInt(2), preco_diaria: 425.00, status: "manutencao",
      comodidades: ["ar-condicionado", "wifi", "banheira"],
      caracteristicas: { vista: "cidade", banheira: true, varanda: false, area_m2: 40 }
    }
  ],
  funcionarios: [
    { _id: "fnc005", nome: "Juliana Martins", cargo: "recepcionista", departamento: "recepção", ativo: true, permissoes: ["checkin", "checkout", "reservas_visualizar"] },
    { _id: "fnc008", nome: "Marcos Vieira", cargo: "recepcionista", departamento: "recepção", ativo: true, permissoes: ["checkin", "checkout", "reservas_editar"] },
    { _id: "fnc010", nome: "Ana Ribeiro", cargo: "supervisora", departamento: "hospedagem", ativo: true, permissoes: ["checkin", "checkout", "feedback_responder"] }
  ],
  servicos: [
    { _id: "svc003", nome: "Café da manhã", categoria: "alimentacao", preco: 45.00, disponivel: true, unidade: "pessoa" },
    { _id: "svc011", nome: "Lavanderia", categoria: "conveniencia", preco: 80.00, disponivel: true, unidade: "servico" },
    { _id: "svc019", nome: "Minibar", categoria: "alimentacao", preco: 25.00, disponivel: true, unidade: "item" },
    { _id: "svc020", nome: "Spa", categoria: "bem_estar", preco: 180.00, disponivel: true, unidade: "sessao" }
  ],
  reservas: [
    {
      _id: "rsv2026001", hospede_id: "hsp001",
      hospede_snapshot: { nome: "Carlos Andrade", email: "carlos.andrade@email.com" },
      quarto_id: "qrt101", quarto_snapshot: { numero: "101", tipo: "standard", preco_diaria: 250.00 },
      data_checkin: ISODate("2026-04-10T00:00:00Z"), data_checkout: ISODate("2026-04-13T00:00:00Z"),
      num_noites: 3, num_hospedes: 2, valor_total: 750.00, status: "concluida",
      canal: "site_proprio", codigo_reserva: "HN-2026-001", data_criacao: ISODate("2026-03-20T14:00:00Z")
    },
    {
      _id: "rsv2026002", hospede_id: "hsp001",
      hospede_snapshot: { nome: "Carlos Andrade", email: "carlos.andrade@email.com" },
      quarto_id: "qrt201", quarto_snapshot: { numero: "201", tipo: "suite", preco_diaria: 500.00 },
      data_checkin: ISODate("2026-06-05T00:00:00Z"), data_checkout: ISODate("2026-06-08T00:00:00Z"),
      num_noites: 3, num_hospedes: 2, valor_total: 1500.00, status: "concluida",
      canal: "telefone", codigo_reserva: "HN-2026-002", data_criacao: ISODate("2026-05-10T12:00:00Z")
    },
    {
      _id: "rsv2026003", hospede_id: "hsp002",
      hospede_snapshot: { nome: "Marina Costa", email: "marina.costa@email.com" },
      quarto_id: "qrt301", quarto_snapshot: { numero: "301", tipo: "familia", preco_diaria: 600.00 },
      data_checkin: ISODate("2026-12-10T00:00:00Z"), data_checkout: ISODate("2026-12-14T00:00:00Z"),
      num_noites: 4, num_hospedes: 3, valor_total: 2400.00, status: "confirmada",
      canal: "agencia", codigo_reserva: "HN-2026-003", data_criacao: ISODate("2026-10-01T12:00:00Z")
    },
    {
      _id: "rsv2026004", hospede_id: "hsp003",
      hospede_snapshot: { nome: "Paulo Lima", email: "paulo.lima@email.com" },
      quarto_id: "qrt101", quarto_snapshot: { numero: "101", tipo: "standard", preco_diaria: 250.00 },
      data_checkin: ISODate("2026-08-02T00:00:00Z"), data_checkout: ISODate("2026-08-04T00:00:00Z"),
      num_noites: 2, num_hospedes: 1, valor_total: 500.00, status: "cancelada",
      canal: "site_proprio", codigo_reserva: "HN-2026-004", data_criacao: ISODate("2026-07-15T10:00:00Z")
    }
  ],
  hospedagens: [
    {
      _id: "hpd2026001", reserva_id: "rsv2026001", hospede_id: "hsp001", quarto_id: "qrt101",
      checkin_real: ISODate("2026-04-10T14:35:00Z"), checkout_real: ISODate("2026-04-13T11:10:00Z"),
      status: "encerrada", funcionario_checkin_id: "fnc005", funcionario_checkout_id: "fnc008",
      servicos_consumidos: [
        { servico_id: "svc003", nome: "Café da manhã", quantidade: 2, preco_unitario: 45.00, total: 90.00, data: ISODate("2026-04-11T08:15:00Z") },
        { servico_id: "svc019", nome: "Minibar", quantidade: 1, preco_unitario: 25.00, total: 25.00, data: ISODate("2026-04-12T22:30:00Z") }
      ],
      total_servicos: 115.00, total_diarias: 750.00, total_geral: 865.00
    },
    {
      _id: "hpd2026002", reserva_id: "rsv2026002", hospede_id: "hsp001", quarto_id: "qrt201",
      checkin_real: ISODate("2026-06-05T15:00:00Z"), checkout_real: ISODate("2026-06-08T10:50:00Z"),
      status: "encerrada", funcionario_checkin_id: "fnc008", funcionario_checkout_id: "fnc005",
      servicos_consumidos: [
        { servico_id: "svc020", nome: "Spa", quantidade: 1, preco_unitario: 180.00, total: 180.00, data: ISODate("2026-06-06T16:00:00Z") }
      ],
      total_servicos: 180.00, total_diarias: 1500.00, total_geral: 1680.00
    }
  ],
  pagamentos: [
    {
      _id: "pgt2026001", hospedagem_id: "hpd2026001", reserva_id: "rsv2026001", hospede_id: "hsp001",
      valor_total: 865.00, status: "pago", data_pagamento: ISODate("2026-04-13T11:15:00Z"),
      parcelas: [{ metodo: "cartao_credito", bandeira: "Visa", valor: 865.00, num_parcelas: 1, status: "aprovado", transacao_id: "TX-HN-001" }]
    },
    {
      _id: "pgt2026002", hospedagem_id: "hpd2026002", reserva_id: "rsv2026002", hospede_id: "hsp001",
      valor_total: 1680.00, status: "pago", data_pagamento: ISODate("2026-06-08T11:00:00Z"),
      parcelas: [
        { metodo: "cartao_credito", bandeira: "Mastercard", valor: 1500.00, num_parcelas: 1, status: "aprovado", transacao_id: "TX-HN-002A" },
        { metodo: "pix", valor: 180.00, status: "aprovado", transacao_id: "TX-HN-002B" }
      ]
    }
  ],
  feedbacks: [
    {
      _id: "fdb2026001", hospede_id: "hsp001", hospedagem_id: "hpd2026001", quarto_id: "qrt101",
      data_avaliacao: ISODate("2026-04-14T09:00:00Z"), nota_geral: 4.8,
      notas_detalhadas: { limpeza: 5, atendimento: 5, conforto: 4, custo_beneficio: 5 },
      comentario: "Ótima estadia e equipe atenciosa.", visivel: true
    },
    {
      _id: "fdb2026002", hospede_id: "hsp001", hospedagem_id: "hpd2026002", quarto_id: "qrt201",
      data_avaliacao: ISODate("2026-06-09T09:00:00Z"), nota_geral: 5.0,
      notas_detalhadas: { limpeza: 5, atendimento: 5, conforto: 5, custo_beneficio: 4 },
      comentario: "Suíte confortável e vista excelente.", visivel: true,
      resposta_hotel: { texto: "Obrigado por avaliar sua estadia!", data: ISODate("2026-06-10T10:00:00Z"), funcionario_id: "fnc005" }
    }
  ]
};

for (const [name, documents] of Object.entries(seeds)) {
  if (hotel.getCollection(name).countDocuments() === 0) {
    hotel.getCollection(name).insertMany(documents);
    print(`${name}: ${documents.length} documentos inseridos`);
  } else {
    print(`${name}: coleção já contém dados; inserção ignorada`);
  }
}
