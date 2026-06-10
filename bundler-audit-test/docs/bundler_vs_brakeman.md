## Bundler Audit x Brakeman

A diferença principal está no foco da análise de segurança que cada ferramenta cobre no ecossistema Ruby:

### Bundler Audit (bundle audit)

**O que faz**: é uma ferramenta que verifica o arquivo Gemfile.lock.

**Como funciona**: consulta um banco de dados de vulnerabilidades conhecidas em gems (Ruby Advisory Database).

**Foco**: garante que suas dependências não tenham CVEs ou versões inseguras conhecidas.

**Exemplo**: alerta se você usa uma versão do nokogiri ou devise com vulnerabilidade reportada.

### Brakeman

**O que faz**: é um static analysis tool voltado para aplicações Ruby on Rails.

**Como funciona**: analisa o código-fonte da aplicação sem precisar executá-la.

**Foco**: encontra vulnerabilidades de lógica, uso inseguro de parâmetros, XSS, SQL Injection, mass assignment, uso incorreto de autenticação/autorização, etc.

**Exemplo**: detecta se você está usando params[:id] diretamente numa query SQL ou se deixou um before_action de autenticação faltando.



✅ Resumo da diferença


`Bundle Audit`: olha para as **dependências (gems)** → problemas de versões vulneráveis.

`Brakeman`: olha para o código da aplicação → problemas de **implementação**.

**Eles se complementam**: o ideal é usar ambos no seu pipeline de CI/CD para cobrir código próprio + dependências.



# Comparação Bundler Audit vs Brakeman

![Mapa mental Bundler Audit vs Brakeman](../imgs/bundler_vs_brakeman.png)