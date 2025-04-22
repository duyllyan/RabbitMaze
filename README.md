# 🐰 Rabbit Maze

**Rabbit Maze** é um jogo interativo desenvolvido com **SwiftUI**, no qual o jogador deve ajudar um coelho a encontrar a saída de um labirinto gerado proceduralmente com diferentes algoritmos clássicos.

---

## ✨ Funcionalidades

- 📦 Geração procedural de labirintos com os seguintes algoritmos:
  - Backtracking
  - Prim's
  - Kruskal's
  - Eller's
  - Wilson's
  - Hunt-and-Kill
  - Sidewinder
  - Recursive Division
- 🎮 Interface intuitiva com suporte a toque (touchscreen)
- 📱 Layout adaptável e responsivo
- 🧠 Visualização passo a passo dos algoritmos
- 🐇 Interação direta com o coelho via arraste no labirinto
- 🎨 Elementos visuais temáticos (cenoura, caminho, parede, coelho)

---

## 🛠️ Tecnologias

- `SwiftUI`
- `MVVM`
- `Clean Architecture`
- `AsyncStream` para animação dos algoritmos
- `Combine` e `ObservableObject` para estados reativos

---

## 🚀 Como executar

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/rabbit-maze.git
```

2. Abra o projeto no Xcode:

```bash
open RabbitMaze.xcodeproj
```

3. Execute no simulador ou dispositivo real (`⌘ + R`)

---

## 🧠 Estrutura do Projeto

O projeto segue os princípios de **Clean Architecture** com separação em camadas:

```
RabbitMaze/
│
├── Domain/            # Contratos e entidades
├── UseCases/          # Casos de uso da aplicação
├── Data/              # Implementações concretas
├── Presentation/      # Views (SwiftUI) e ViewModels
├── Utils/             # Funções auxiliares e extensões
└── Resources/         # Assets e constantes visuais
```

---

## 📚 Aprendizados

Este projeto foi idealizado como um desafio de aprendizado, com os seguintes focos:

- Aplicação de algoritmos de grafos e geração de labirintos
- Animação e visualização de passos usando `AsyncStream`
- Interação por toque com `DragGesture`
- Criação de uma interface amigável usando somente `SwiftUI`
- Adoção de uma arquitetura limpa e escalável

---

## 🙌 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para enviar pull requests com melhorias, correções ou novas funcionalidades.

1. Faça um fork do projeto
2. Crie uma branch com sua feature:

```bash
git checkout -b feature/nome-da-feature
```

3. Commit suas alterações:

```bash
git commit -m "feat: minha nova feature"
```

4. Envie para o repositório remoto:

```bash
git push origin feature/nome-da-feature
```

5. Abra um **Pull Request** 🚀

---

## 📄 Licença

Este projeto está sob a licença [MIT](LICENSE).

---

Desenvolvido com 💙 por [Duyllyan Carvalho](https://github.com/seu-usuario)
