import '../models/media.dart';

/// Animal sounds — placeholders only. No audio ships yet; [assetPath] stays
/// null until a CC0 / public-domain / owned recording is added and documented
/// in ASSETS_LICENSES.md. The UI shows a "som em breve" state, never plays
/// unlicensed audio.
const List<AnimalSound> animalSounds = [
  AnimalSound(
    name: 'Cachorro',
    emoji: '🐶',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Gato',
    emoji: '🐱',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Vaca',
    emoji: '🐮',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Galo',
    emoji: '🐔',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Pato',
    emoji: '🦆',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Ovelha',
    emoji: '🐑',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Cavalo',
    emoji: '🐴',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Passarinho',
    emoji: '🐦',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Abelha',
    emoji: '🐝',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
  AnimalSound(
    name: 'Sapo',
    emoji: '🐸',
    source: 'Acervo próprio (a gravar)',
    license: 'A definir — apenas CC0 / domínio público',
  ),
];

/// Three original short stories written for BabyCare (no famous characters).
/// Simple, repetitive, calming — suited for babies and toddlers.
const List<Story> stories = [
  Story(
    id: 'lua_soneca',
    title: 'A Lua que Queria uma Soneca',
    ageRange: '0–2 anos',
    readingMinutes: 2,
    origin: 'História original BabyCare',
    paragraphs: [
      'Era uma noite bem quietinha. A Lua subiu devagar, devagarinho, e bocejou: aaaah.',
      'Uma estrela piscou para ela. "Boa noite, Lua." A Lua sorriu e respondeu baixinho: "Boa noite, estrelinha."',
      'O vento passou macio, fazendo as folhas dizerem xiiii, xiiii, como quem pede silêncio.',
      'A Lua fechou um olho, depois o outro. E o céu inteiro ficou calminho, só esperando o sono chegar.',
      'Quando você fechar os olhos também, a Lua vai estar bem ali, cuidando do seu sono. Durma bem.',
    ],
  ),
  Story(
    id: 'pintinho_chuva',
    title: 'O Pintinho e a Gota de Chuva',
    ageRange: '1–3 anos',
    readingMinutes: 2,
    origin: 'História original BabyCare',
    paragraphs: [
      'Pinx era um pintinho amarelinho que nunca tinha visto a chuva.',
      'Plic! Uma gota caiu no seu biquinho. Plic, ploc! Caíram mais duas no chão.',
      '"Que barulho engraçado!", pensou Pinx, e saiu pulando: plic, ploc, plic, ploc.',
      'A galinha mamãe abriu a asa quentinha e chamou: "Vem, Pinx." E ele correu para baixo da asa.',
      'Lá de dentro, Pinx ouvia a chuva cantar plic-ploc lá fora, e foi ficando quentinho, quentinho, até dormir.',
    ],
  ),
  Story(
    id: 'caracol_devagar',
    title: 'O Caracol que Andava Devagar',
    ageRange: '1–4 anos',
    readingMinutes: 3,
    origin: 'História original BabyCare',
    paragraphs: [
      'Cacá, o caracol, andava bem devagar. Tão devagar que as formigas passavam por ele correndo.',
      '"Corre, Cacá!", diziam elas. Mas Cacá gostava de ir devagar, olhando cada folha pelo caminho.',
      'Ele viu uma flor cor-de-rosa. Parou. Cheirou. Sorriu.',
      'Ele viu uma poça d\'água brilhando. Parou. Olhou o céu lá dentro. Sorriu de novo.',
      'No fim do dia, Cacá chegou em casa devagarinho e disse: "Eu vi o dia inteiro." E foi dormir feliz.',
      'Às vezes, ir devagar é o jeito mais bonito de chegar.',
    ],
  ),
];

/// Traditional / public-domain Brazilian songs. We store only a title, a
/// suggested use, and a search query — never the full copyrighted-arrangement
/// lyrics.
const List<Song> songs = [
  Song(
    title: 'Nana Neném',
    moment: SongMoment.sleep,
    suggestion: 'Acalanto tradicional para embalar o sono.',
    searchQuery: 'Nana Neném cantiga de ninar tradicional',
  ),
  Song(
    title: 'Boi da Cara Preta',
    moment: SongMoment.sleep,
    suggestion: 'Cantiga de ninar bem conhecida para a hora de dormir.',
    searchQuery: 'Boi da Cara Preta cantiga de ninar',
  ),
  Song(
    title: 'Se Essa Rua Fosse Minha',
    moment: SongMoment.calm,
    suggestion: 'Melodia lenta, boa para acalmar no colo.',
    searchQuery: 'Se Essa Rua Fosse Minha cantiga tradicional',
  ),
  Song(
    title: 'Borboletinha',
    moment: SongMoment.play,
    suggestion: 'Cantiga com gestos para brincar de imitar.',
    searchQuery: 'Borboletinha cantiga infantil tradicional',
  ),
  Song(
    title: 'Ciranda, Cirandinha',
    moment: SongMoment.play,
    suggestion: 'Roda cantada para brincar junto.',
    searchQuery: 'Ciranda Cirandinha cantiga de roda',
  ),
  Song(
    title: 'Peixe Vivo',
    moment: SongMoment.bath,
    suggestion: 'Cantiga leve, combina com a hora do banho.',
    searchQuery: 'Como Pode o Peixe Vivo cantiga tradicional',
  ),
];

/// External recommendations — each opens a search on YouTube/Spotify.
const List<ExternalMediaLink> externalRecommendations = [
  ExternalMediaLink(
    label: 'Músicas calmas para bebê',
    query: 'músicas calmas para bebê dormir',
    description: 'Playlists suaves para relaxar e embalar.',
  ),
  ExternalMediaLink(
    label: 'Ruído branco para sono',
    query: 'ruído branco para bebê dormir white noise',
    description: 'Som contínuo que ajuda alguns bebês a pegar no sono.',
  ),
  ExternalMediaLink(
    label: 'Sons da natureza',
    query: 'sons da natureza relaxante chuva mar',
    description: 'Chuva, mar e vento para um ambiente tranquilo.',
  ),
  ExternalMediaLink(
    label: 'Cantigas tradicionais infantis',
    query: 'cantigas tradicionais infantis domínio público',
    description: 'Clássicos de roda e de ninar para cantar junto.',
  ),
  ExternalMediaLink(
    label: 'Vídeos sem estímulo excessivo',
    query: 'vídeos calmos para bebê sem estímulo excessivo',
    description: 'Imagens lentas e cores suaves, com pouco estímulo.',
  ),
];
