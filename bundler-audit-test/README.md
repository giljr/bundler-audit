### Relatório de Atividades – Cultura de Testes e Preparação de QA

[![test: passed](https://git.sefin.ro.gov.br/59291117668/bundler-audit-test/badges/main/pipeline.svg?ignore_skipped=true)](https://git.sefin.ro.gov.br/59291117668/bundler-audit-test/-/commits/main) [![Ruby](https://img.shields.io/badge/ruby-3.3.0-red?logo=ruby&logoColor=white)](https://www.ruby-lang.org/) [![Rails](https://img.shields.io/badge/rails-8.0.1-blue?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)

### 1. Introdução

Iniciamos nossos trabalhos propondo a cultura de testes, começando com um código o mais simples possível. A ideia é construir uma base sólida antes de introduzir complexidades, garantindo que a equipe compreenda completamente cada fluxo do sistema.
 
📌 [Entenda a Arquitetura do App](/docs/arquitetura.md)

📌 Veja também a [tabela de classes de testes do Minitest](docs/minitest_classes.md), que resume os principais tipos de testes disponíveis no Rails (por classes), seus propósitos e traz links diretos para a documentação oficial.

📌 [Uso de Tokens](/docs/tokens.md) - estudos avançados

### 2. Escolha por um Código sem Gems de Terceiros

Optamos por desenvolver a aplicação sem depender de gems externas, como o Devise. (ruby-3.2.3 / rails-8.0.1)

Objetivos dessa abordagem:

| Objetivo                                       | Descrição                                                                          |
| ---------------------------------------------- | ---------------------------------------------------------------------------------- |
| Entendimento completo do fluxo de autenticação | Não dependemos de “caixas pretas” externas; todos os detalhes são visíveis.        |
| Controle total sobre o código                  | Permite customizar cada detalhe sem limitações impostas por uma gem.               |
| Base sólida para evolução                      | Após consolidar o simples, podemos adicionar camadas de complexidade gradualmente. |

Essa abordagem fortalece o aprendizado, aumenta a confiabilidade do código e prepara a equipe para evoluir de forma estruturada.

### 3. Importância dos Testes

**3.1 Testes e Atualização de Gems**

Atualizar gems é essencial para manter segurança e estabilidade. Ferramentas como o **bundler-audit** ajudam a identificar:

| Recurso / Situação                     | Descrição                                                                                                                                                           |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Versões vulneráveis de gems            | Identifica gems desatualizadas ou inseguras.                                                                                                                        |
| Fontes inseguras (http:// e git://)    | Detecta e alerta sobre fontes não seguras para gems.                                                                                                                |
| Atualizações sem testes automatizados  | Qualquer atualização se torna arriscada.                                                                                                                            |
| Benefícios com suíte de testes robusta | Regressões são detectadas imediatamente; o código se mantém confiável mesmo após atualizações; reduz-se retrabalho e acelera-se a entrega de novas funcionalidades. |

**3.2 Testes em CI/CD**

Em pipelines de Integração Contínua e Entrega Contínua, os testes automatizados são críticos:

| Benefício                  | Descrição                                                                   |
| -------------------------- | --------------------------------------------------------------------------- |
| Detecção rápida de falhas  | Qualquer commit que quebre funcionalidades é identificado antes da produção |
| Redução de retrabalho      | Feedback imediato evita acúmulo de erros                                    |
| Segurança e confiabilidade | Alterações de código e atualizações de gems são validadas automaticamente   |
| Entrega ágil               | Novas versões podem ser liberadas com confiança e segurança                 |

### 4. Estratégia de Testes

Optamos por iniciar com [Minitest](https://github.com/minitest/minitest), que já vem integrado ao Rails e tem configuração mínima. Após consolidar a cultura de testes, a equipe poderá migrar gradualmente para [RSpec](https://github.com/rspec/rspec-rails), aproveitando sua sintaxe expressiva e recursos avançados.

Resumo da estratégia:

| Ferramenta                                                               | Propósito                                                     |
| ------------------------------------------------------------------------ | ------------------------------------------------------------- |
| [Minitest](https://docs.seattlerb.org/minitest/Minitest/Assertions.html) | Baixa barreira de entrada, cria hábito de testar naturalmente |
| [RSpec](https://github.com/rspec/rspec-rails)                            | Evolução natural, testes mais expressivos e complexos         |

### 5. Código Rails Puro – Funcionalidades Testadas

Criamos funcionalidades de login/logout, registro, recuperação de senha, e preparamos 22 testes.

| Nº  | Dir test / Arquivo                         | Teste Name                                                   | Classe Base                     |
| --- | ------------------------------------------ | ------------------------------------------------------------ | ------------------------------- |
| 1   | controllers / mainControllerTest           | deve_acessar_a_página_principal                              | ActionDispatch::IntegrationTest |
| 2   | controllers / registrationsControllerTest  | deve_exibir_o_formulário_de_cadastro                         | ActionDispatch::IntegrationTest |
| 3   | controllers / sessionsControllerTest       | deve_encerrar_a_sessão_e_redirecionar_para_a_página_inicial  | ActionDispatch::IntegrationTest |
| 4   | controllers / aboutControllerTest          | deve_acessar_a_página_sobre                                  | ActionDispatch::IntegrationTest |
| 5   | controllers / passwordResetsControllerTest | deve_exibir_o_formulário_de_edição_com_token_válido          | ActionDispatch::IntegrationTest |
| 6   | controllers / passwordResetsControllerTest | deve_enviar_email_de_redefinição_de_senha                    | ActionDispatch::IntegrationTest |
| 7   | controllers / passwordResetsControllerTest | deve_exibir_o_formulário_de_redefinição_de_senha             | ActionDispatch::IntegrationTest |
| 8   | controllers / passwordResetsControllerTest | deve_atualizar_a_senha_com_token_válido                      | ActionDispatch::IntegrationTest |
| 9   | controllers / passwordResetsControllerTest | deve_redirecionar_para_sign_in_com_token_inválido            | ActionDispatch::IntegrationTest |
| 10  | controllers / passwordResetsControllerTest | não_deve_atualizar_a_senha_com_token_inválido                | ActionDispatch::IntegrationTest |
| 11  | controllers / passwordsControllerTest      | deve_renderizar_a_página_de_edição_quando_estiver_logado     | ActionDispatch::IntegrationTest |
| 12  | controllers / passwordsControllerTest      | deve_redirecionar_para_sign_in_se_não_estiver_logado         | ActionDispatch::IntegrationTest |
| 13  | controllers / passwordsControllerTest      | não_deve_atualizar_a_senha_se_a_confirmação_não_corresponder | ActionDispatch::IntegrationTest |
| 14  | controllers / passwordsControllerTest      | deve_atualizar_a_senha_com_parâmetros_válidos                | ActionDispatch::IntegrationTest |
| 15  | controllers / passwordsControllerTest      | outro_usuário_também_pode_atualizar_a_propria_senha          | ActionDispatch::IntegrationTest |
| 16  | mailer / passwordMailerTest                | reset_email                                                  | ActionMailer::TestCase          |
|     | mailer/previews / passwordMailerTest       | reset                                                        | ActionMailer::Preview           |
| 17  | models / userTest                          | email_deve_estar_presente                                    | ActiveSupport::TestCase         |
| 18  | models / userTest                          | user_não_loga_sem_password                                   | ActiveSupport::TestCase         |
| 19  | models / currentTest                       | pode_armazenar_e_recuperar_o_usuário                         | ActiveSupport::TestCase         |
| 20  | models / currentTest                       | o*usuário_atual*é_nulo_por_padrão                            | ActiveSupport::TestCase         |
| 21  | integration / registrationsFlowTest        | usuario_pode_registrar_com_sucesso                           | ActionDispatch::IntegrationTest |
| 22  | integration / registrationsFlowTest        | falha_registro_usuario_com_dados_invalidos                   | ActionDispatch::IntegrationTest |

### 6. Uso do Bundler Audit

O [bundler-audit](https://github.com/rubysec/bundler-audit) é uma ferramenta que auxilia na segurança da aplicação. Seus recursos principais:

| Recurso                            | Descrição                                         |
| ---------------------------------- | ------------------------------------------------- |
| Verificação de versões vulneráveis | Identifica gems desatualizadas ou inseguras       |
| Verificação de fontes inseguras    | Detecta http:// ou git:// como fontes de gems     |
| Ignorar avisos manuais             | Permite contornar problemas que já foram tratados |
| Exibição de alertas                | Mostra informações sobre vulnerabilidades         |
| Operação offline                   | Não exige conexão com a internet                  |

### 7. Próximas Etapas

O trabalho seguirá de forma incremental, garantindo aprendizado e evolução estruturada:

| Versão                                     | Objetivo                                                  |
| ------------------------------------------ | --------------------------------------------------------- |
| [Versão 1](README.md)                      | Concluir etapa inicial com código puro e primeiros testes |
| [Versão 2](/docs/versao_2_apos_bundler.md) | Corrigir gems conforme recomendações do **bundler-audit** |
| [Versão 3](/docs/ci_cd.md)                 | Integrar a suíte de testes ao pipeline de **CI/CD**       |

Além disso, contamos com ferramentas de apoio importantes:

| Ferramenta     | Finalidade                          | Documentação                                                          |
| -------------- | ----------------------------------- | --------------------------------------------------------------------- |
| bundler-audit  | Verificação de vulnerabilidades     | [Rubysec/bundler-audit](https://github.com/rubysec/bundler-audit)     |
| Minitest       | Testes automatizados (nativo Rails) | [Rails Guides – Testing](https://guides.rubyonrails.org/testing.html) |
| CI/CD Pipeline | Integração e Deployment contínuos   | [GitLab CI/CD Docs](https://docs.gitlab.com/ee/ci/)                   |
| Rails API      | Referência oficial de classes       | [Rails API Documentation](https://api.rubyonrails.org/)               |

📌 Confira também a [tabela de classes de testes do Minitest](docs/minitest_classes.md), que resume os principais tipos de testes disponíveis no Rails (por classes), seus propósitos e links diretos para a documentação oficial.

### 8. Recursos de Aprendizado

Para fortalecer a prática de testes no Rails, reunimos materiais oficiais e tutoriais práticos:

#### 📘 Documentação Oficial

- [Rails Guides – Testing](https://guides.rubyonrails.org/testing.html) – Guia completo de testes no Rails.
- [Rails API Documentation](https://api.rubyonrails.org/) – Referência oficial das classes e módulos usados em testes.
- [Minitest – GitHub](https://github.com/minitest/minitest) – Repositório oficial do Minitest.

#### 🎥 Vídeos e Tutoriais

- [GoRails – Testing Basics](https://gorails.com/episodes?utf8=%E2%9C%93&search=testing) – Série de screencasts sobre testes no Rails.
- [Drifting Ruby – Episodes sobre Testing](https://www.driftingruby.com/episodes?utf8=%E2%9C%93&search=testing) – Tutoriais em vídeo focados em testes.
- [YouTube – Rails Testing Playlist](https://www.youtube.com/results?search_query=rails+testing+minitest) – Conteúdos gratuitos sobre testes com Minitest e RSpec.

#### 📝 Artigos e Blogs

- [Everyday Rails Testing with RSpec](https://everydayrails.com/) – Série de artigos para evoluir em testes.
- [Better Specs](https://www.betterspecs.org/) – Guia de boas práticas em testes (focado em RSpec, mas aplicável).
- [Thoughtbot Blog – Testing](https://thoughtbot.com/blog/tags/testing) – Artigos avançados sobre cultura de testes.

📌 Dica: Comece pelos **Rails Guides**, depois explore **GoRails** ou **Drifting Ruby** para vídeos mais práticos.
