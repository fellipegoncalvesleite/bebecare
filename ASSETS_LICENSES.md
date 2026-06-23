# Licenças de assets — BebêCare

Este arquivo registra a origem e a licença de cada recurso usado no app.
Regra geral: **nada de conteúdo protegido por direitos autorais sem permissão**.
Só entram assets próprios, de domínio público ou sob licença permissiva (CC0,
CC-BY, OFL etc.).

## Imagens

| Arquivo | Origem | Licença / observação |
|--------|--------|----------------------|
| `assets/images/baby_icon.png` | Ilustração de bebê com fundo removido localmente (rembg). | Verifique os direitos de uso da imagem-base antes de publicar. Substituível por um ícone próprio ou de banco com licença permissiva. |

## Fontes

| Fonte | Origem | Licença |
|-------|--------|---------|
| Nunito | Google Fonts (pacote `google_fonts`) | SIL Open Font License 1.1 |

## Sons de animais

Nenhum áudio é distribuído com o app no momento. Os cards exibem o estado
"Som em breve" e **não tocam nada** até que um arquivo licenciado seja incluído.

Ao adicionar um som, salve em `assets/audio/animals/`, declare em `pubspec.yaml`
e registre aqui:

| Arquivo | Animal | Fonte | Licença |
|--------|--------|-------|---------|
| _(exemplo)_ `dog.mp3` | Cachorro | Freesound.org #XXXX | CC0 |

Fontes recomendadas: Freesound (filtrar por CC0), BBC Sound Effects (verificar
termos), gravações próprias.

## Histórias

As histórias em `lib/data/media_data.dart` são **originais, escritas para o
BebêCare**, ou de domínio público. Não reproduzem livros, personagens ou textos
protegidos.

- "A Lua que Queria uma Soneca" — original BebêCare.
- "O Pintinho e a Gota de Chuva" — original BebêCare.
- "O Caracol que Andava Devagar" — original BebêCare.

## Cantigas

Apenas **títulos e usos sugeridos** de cantigas tradicionais / domínio público.
O app **não armazena letras protegidas** — a audição acontece via busca em
plataformas externas (YouTube/Spotify) aberta pelo `url_launcher`.
