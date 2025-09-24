# Gerenciamento Sol

> Um aplicativo de controle financeiro simples, desenvolvido em Flutter para ajudar minha mãe, revendedora de produtos Natura, a gerenciar suas vendas e compras de forma eficiente.


---

## Sobre o Projeto

Este projeto nasceu de uma necessidade real. Minha mãe, que é revendedora de produtos da Natura, fazia grandes compras durante o mês, mas tinha dificuldades para rastrear as vendas individuais e entender sua lucratividade. As anotações em cadernos eram insuficientes e planilhas, pouco práticas.

O "Gerenciamento Sol" foi desenvolvido do zero para ser um assistente financeiro pessoal, permitindo o registro rápido de transações e a visualização clara da saúde do negócio através de dashboards e relatórios.

## Funcionalidades

O aplicativo conta com um ciclo completo de funcionalidades para gestão financeira:

* **📊 Dashboard Reativo:** Visão geral e em tempo real das finanças do mês, com filtros por período.
* **💸 Registro de Lançamentos:** Formulário intuitivo para adicionar vendas (entradas) e compras (gastos).
* **✏️ Gestão Completa (CRUD):** Funcionalidades para editar e excluir qualquer lançamento já registrado.
* **📈 Relatórios por Categoria:** Análise detalhada do saldo (lucro/prejuízo) de cada categoria de produto.
* **📖 Histórico Completo:** Uma lista de todas as transações já feitas, ordenadas da mais recente para a mais antiga.
* **🎨 Gráficos Visuais:** Gráficos de pizza que mostram a distribuição de entradas e gastos por categoria, facilitando a análise.
* **📱 Design Responsivo:** Interface limpa e funcional que se adapta a diferentes tamanhos de tela.

## Tecnologias Utilizadas

A stack utilizada foi escolhida para criar uma aplicação moderna, performática e de fácil manutenção:

* **Framework:** [Flutter](https://flutter.dev/)
* **Linguagem:** [Dart](https://dart.dev/)
* **Gerenciamento de Estado:** [Riverpod](https://riverpod.dev/)
* **Banco de Dados Local:** [Drift (SQLite)](https://drift.simonbinder.eu/)
* **Gráficos:** [fl_chart](https://pub.dev/packages/fl_chart)
* **Formatação (Data e Moeda):** [intl](https://pub.dev/packages/intl)
* **Geração de Ícones:** [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
* **Prototipação e Design:** [Figma](https://www.figma.com/)

## Como Executar o Projeto

Para executar este projeto localmente, siga os passos abaixo:

**Pré-requisitos:**
* Ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
* Ter um dispositivo (emulador ou físico) conectado.

**Instalação:**
1.  Clone o repositório:
    ```bash
    git clone [https://github.com/seu-usuario/gerenciamento-sol.git](https://github.com/seu-usuario/gerenciamento-sol.git)
    ```
2.  Navegue até a pasta do projeto:
    ```bash
    cd gerenciamento_sol
    ```
3.  Instale as dependências:
    ```bash
    flutter pub get
    ```
4.  Rode o gerador de código do Drift:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5.  Execute o aplicativo:
    ```bash
    flutter run
    ```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## Contato

**Caio Melo**

* **LinkedIn:** [https://www.linkedin.com/in/caio-melo-borges/](https://www.linkedin.com/in/caio-melo-borges/)

---
