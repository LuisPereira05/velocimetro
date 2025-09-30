# Velocímetro Flutter (MOBILE II)

Um aplicativo de **velocímetro digital** desenvolvido em Flutter, com suporte a **modo HUD (Head-Up Display)**, **hodômetro total** e **hodômetro de viagem (trip)**. Ideal para uso no carro apoiado no painel.

---

## 🔍 Funcionalidades

- **Leitura de velocidade em tempo real** (km/h)
- **Hodômetro total** (distância total percorrida)
- **Hodômetro de viagem** (resetável)
- **Modo HUD (espelhado verticalmente)** para projeção no para-brisa
- **Botão de Reset** para zerar a viagem
- **Layout adaptativo** (retrato e paisagem)

---

## Capturas de Tela

### Modo Mobile:

![Mobile Vertical](Captura1.png)
![Mobile Horizontal](Captura2.png)

### Modo Mobile:

![HUD Vertical](Captura3.png)
![HUD Horizontal](Captura4.png)

---

## Uso Sugerido

- **Modo HUD**: coloque o smartphone deitado no painel do carro e ative o modo HUD. A tela será espelhada verticalmente para refletir corretamente no para-brisa.
- **Hodômetro de Viagem**: reinicie antes de começar uma viagem para acompanhar a quilometragem da rota.

---


## 🚀 Como Executar

1. Clone o repositório:

   ```bash
   git clone https://github.com/LuisPereira05/velocimetro.git
   cd velocimetro
   flutter devices
   flutter run -d <device id>
