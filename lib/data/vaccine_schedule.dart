import '../models/vaccine.dart';

/// Calendário Nacional de Vacinação da Criança — PNI / Ministério da Saúde.
///
/// Baseado na Instrução Normativa do Calendário Nacional de Vacinação 2026
/// (gov.br/saude) e notas técnicas relacionadas (MenACWY desde 01/07/2025;
/// transição VPC10 → VPC20 a partir de jun/2026; ampliação da faixa do
/// rotavírus, NT 23/2025).
///
/// Itens em transição (produto pneumocócico VPC10/VPC20 e esquema de COVID-19,
/// que varia conforme o produto e o município) ficam com
/// [VaccineInfo.requiresProfessionalConfirmation] = true para o app sinalizar
/// que se deve confirmar na UBS.
const List<VaccineScheduleItem> vaccineSchedule = [
  VaccineScheduleItem(
    ageLabel: 'Ao nascer',
    ageInMonths: 0,
    vaccines: [
      VaccineInfo(
        id: 'bcg_0',
        name: 'BCG',
        dose: 'Dose única',
        protectsAgainst: 'Formas graves de tuberculose (meníngea e miliar)',
        notes:
            'Aplicar o mais cedo possível, ainda na maternidade. Disponível '
            'até 4 anos, 11 meses e 29 dias para quem não vacinou.',
      ),
      VaccineInfo(
        id: 'hepb_0',
        name: 'Hepatite B',
        dose: '1ª dose (ao nascer)',
        protectsAgainst: 'Hepatite B',
        notes:
            'Monovalente, idealmente nas primeiras 12–24h. As doses seguintes '
            'vêm na Pentavalente (2, 4 e 6 meses).',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '2 meses',
    ageInMonths: 2,
    vaccines: [
      VaccineInfo(
        id: 'penta_2',
        name: 'Pentavalente (DTP+Hib+HB)',
        dose: '1ª dose',
        protectsAgainst:
            'Difteria, tétano, coqueluche, Haemophilus influenzae b e hepatite B',
        notes: 'Vacina combinada, aplicação intramuscular.',
      ),
      VaccineInfo(
        id: 'vip_2',
        name: 'Poliomielite (VIP)',
        dose: '1ª dose',
        protectsAgainst: 'Poliomielite (paralisia infantil)',
        notes:
            'Injetável. O esquema é 100% VIP — a gotinha (VOP) foi retirada.',
      ),
      VaccineInfo(
        id: 'pneumo_2',
        name: 'Pneumocócica (VPC10/VPC20)',
        dose: '1ª dose',
        protectsAgainst: 'Pneumonia, meningite, otite e sepse pneumocócica',
        notes:
            'Transição em curso: a 1ª dose pode ser VPC20 onde já disponível, '
            'ou VPC10. Confirme o produto na UBS.',
        requiresProfessionalConfirmation: true,
      ),
      VaccineInfo(
        id: 'rota_2',
        name: 'Rotavírus',
        dose: '1ª dose',
        protectsAgainst: 'Diarreia grave por rotavírus',
        notes:
            'Oral. Limite rígido: 1ª dose até 3 meses e 15 dias. Perdeu a '
            'janela, perde a dose — não há reposição fora do prazo.',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '3 meses',
    ageInMonths: 3,
    vaccines: [
      VaccineInfo(
        id: 'menc_3',
        name: 'Meningocócica C',
        dose: '1ª dose',
        protectsAgainst: 'Doença meningocócica do sorogrupo C',
        notes: 'Idade mínima de 2 meses.',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '4 meses',
    ageInMonths: 4,
    vaccines: [
      VaccineInfo(
        id: 'penta_4',
        name: 'Pentavalente (DTP+Hib+HB)',
        dose: '2ª dose',
        protectsAgainst:
            'Difteria, tétano, coqueluche, Haemophilus influenzae b e hepatite B',
        notes: 'Continuação do esquema básico.',
      ),
      VaccineInfo(
        id: 'vip_4',
        name: 'Poliomielite (VIP)',
        dose: '2ª dose',
        protectsAgainst: 'Poliomielite',
        notes: 'Injetável (VIP).',
      ),
      VaccineInfo(
        id: 'pneumo_4',
        name: 'Pneumocócica (VPC10/VPC20)',
        dose: '2ª dose',
        protectsAgainst: 'Doença pneumocócica',
        notes:
            'Durante a transição, a 2ª dose costuma seguir com VPC10 enquanto '
            'houver estoque. Confirme na UBS.',
        requiresProfessionalConfirmation: true,
      ),
      VaccineInfo(
        id: 'rota_4',
        name: 'Rotavírus',
        dose: '2ª dose',
        protectsAgainst: 'Diarreia grave por rotavírus',
        notes:
            'Oral. 2ª dose até 7 meses e 29 dias. Não repetir se a criança '
            'regurgitar/vomitar.',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '5 meses',
    ageInMonths: 5,
    vaccines: [
      VaccineInfo(
        id: 'menc_5',
        name: 'Meningocócica C',
        dose: '2ª dose',
        protectsAgainst: 'Doença meningocócica do sorogrupo C',
        notes: 'Conclui o esquema básico de MenC.',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '6 meses',
    ageInMonths: 6,
    vaccines: [
      VaccineInfo(
        id: 'penta_6',
        name: 'Pentavalente (DTP+Hib+HB)',
        dose: '3ª dose',
        protectsAgainst:
            'Difteria, tétano, coqueluche, Haemophilus influenzae b e hepatite B',
        notes: 'Conclui o esquema básico da Pentavalente.',
      ),
      VaccineInfo(
        id: 'vip_6',
        name: 'Poliomielite (VIP)',
        dose: '3ª dose',
        protectsAgainst: 'Poliomielite',
        notes: 'Conclui o esquema básico (3 doses de VIP).',
      ),
      VaccineInfo(
        id: 'influenza_6',
        name: 'Influenza (gripe)',
        dose: '1ª dose',
        protectsAgainst: 'Gripe (influenza)',
        notes:
            'Rotina anual dos 6 meses aos 5 anos. Na 1ª vacinação da vida são '
            '2 doses, com 30 dias de intervalo.',
        requiresProfessionalConfirmation: true,
      ),
      VaccineInfo(
        id: 'covid_6',
        name: 'COVID-19',
        dose: '1ª dose',
        protectsAgainst: 'Formas graves e óbito por COVID-19',
        notes:
            'Vacina de RNAm, dos 6 meses aos 4 anos. O nº de doses depende do '
            'produto (Pfizer: 3 doses; Moderna: 2). Confirme na UBS.',
        requiresProfessionalConfirmation: true,
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '9 meses',
    ageInMonths: 9,
    vaccines: [
      VaccineInfo(
        id: 'febreamarela_9',
        name: 'Febre Amarela',
        dose: '1ª dose',
        protectsAgainst: 'Febre amarela',
        notes:
            'Em algumas situações/áreas pode ser antecipada para 6–8 meses, a '
            'critério da equipe de saúde.',
      ),
      VaccineInfo(
        id: 'covid_9',
        name: 'COVID-19',
        dose: '3ª dose (esquema Pfizer)',
        protectsAgainst: 'Formas graves e óbito por COVID-19',
        notes:
            'Aplica-se apenas no esquema Pfizer/Comirnaty (6, 7 e 9 meses). '
            'Confirme o esquema do seu produto na UBS.',
        requiresProfessionalConfirmation: true,
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '12 meses',
    ageInMonths: 12,
    vaccines: [
      VaccineInfo(
        id: 'triplice_viral_12',
        name: 'Tríplice Viral (SCR)',
        dose: '1ª dose',
        protectsAgainst: 'Sarampo, caxumba e rubéola',
        notes: 'Primeira dose do esquema de tríplice viral.',
      ),
      VaccineInfo(
        id: 'pneumo_12',
        name: 'Pneumocócica (VPC10/VPC20)',
        dose: 'Reforço',
        protectsAgainst: 'Doença pneumocócica',
        notes:
            'Reforço único. Na transição, passa a ser VPC20 onde disponível. '
            'Confirme o produto na UBS.',
        requiresProfessionalConfirmation: true,
      ),
      VaccineInfo(
        id: 'menacwy_12',
        name: 'Meningocócica ACWY',
        dose: 'Reforço',
        protectsAgainst: 'Doença meningocócica dos sorogrupos A, C, W e Y',
        notes:
            'Desde 01/07/2025 substitui o antigo reforço de Meningocócica C '
            'aos 12 meses.',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '15 meses',
    ageInMonths: 15,
    vaccines: [
      VaccineInfo(
        id: 'dtp_15',
        name: 'Tríplice Bacteriana (DTP)',
        dose: '1º reforço',
        protectsAgainst: 'Difteria, tétano e coqueluche',
        notes: 'DTP de células inteiras (pediátrica), não dTpa.',
      ),
      VaccineInfo(
        id: 'vip_15',
        name: 'Poliomielite (VIP)',
        dose: 'Reforço',
        protectsAgainst: 'Poliomielite',
        notes: 'Reforço também é VIP injetável (substituiu a antiga VOP oral).',
      ),
      VaccineInfo(
        id: 'triplice_viral_15',
        name: 'Tríplice Viral (SCR)',
        dose: '2ª dose',
        protectsAgainst: 'Sarampo, caxumba e rubéola',
        notes:
            'A tetraviral (SCRV) só é usada na falta de tríplice viral e/ou '
            'varicela monovalente.',
      ),
      VaccineInfo(
        id: 'varicela_15',
        name: 'Varicela',
        dose: '1ª dose',
        protectsAgainst: 'Catapora (varicela)',
        notes: 'Varicela monovalente.',
      ),
      VaccineInfo(
        id: 'hepa_15',
        name: 'Hepatite A',
        dose: 'Dose única',
        protectsAgainst: 'Hepatite A',
        notes: 'No PNI, o esquema infantil é de 1 dose aos 15 meses.',
      ),
    ],
  ),
  VaccineScheduleItem(
    ageLabel: '4 anos',
    ageInMonths: 48,
    vaccines: [
      VaccineInfo(
        id: 'dtp_48',
        name: 'Tríplice Bacteriana (DTP)',
        dose: '2º reforço',
        protectsAgainst: 'Difteria, tétano e coqueluche',
        notes: 'Após este reforço, segue dT a cada 10 anos.',
      ),
      VaccineInfo(
        id: 'varicela_48',
        name: 'Varicela',
        dose: '2ª dose',
        protectsAgainst: 'Catapora (varicela)',
        notes: 'Conclui o esquema de varicela.',
      ),
      VaccineInfo(
        id: 'febreamarela_48',
        name: 'Febre Amarela',
        dose: 'Reforço',
        protectsAgainst: 'Febre amarela',
        notes: 'Reforço único.',
      ),
    ],
  ),
];
