### Versão 2 – Atualização de Gems e Auditoria de Segurança

**Objetivo**: Garantir que todas as gems da aplicação estejam atualizadas e sem vulnerabilidades conhecidas, utilizando o bundler-audit.

#### Ações realizadas:

**1. Adição do bundler-audit ao Gemfile**:
```ruby
group :development do
  gem 'bundler-audit', require: false
end
```

**2. Instalação das gems do projeto**:

    bundle install


**3. Atualização do banco de dados de vulnerabilidades**:

    bundle exec bundler-audit update


**4. Verificação de vulnerabilidades nas gems**:

    bundle exec bundler-audit check --update


**5 Atualização das gems do Ruby (opcional, se necessário)**:

    gem update

#### Nota: 
```
Esta etapa deve ser conduzida com cautela. 
Se a aplicação já estiver em produção, 
é recomendável atualizar as gems uma a uma, 
seguindo as recomendações do bundler-audit. 
A cada atualização, execute os testes da versão anterior 
para garantir que nenhuma funcionalidade seja comprometida.
```
👉️ Recomendações do Bundle_Audit para a [Versão 1](v1_log_audit.txt/) do aplicativo teste:

A seguir uma tabela comparando as Versões Originais x Versões Atualizadas:

| Gem           | Versão | Versão Atualizada | CVE / GHSA                       | Criticidade | Título / Descrição                                 | Versão Segura |
|---------------|--------|-------------------|---------------------------------|-------------|---------------------------------------------------|---------------|
| nokogiri      | 1.18.1 | 1.18.9            | Múltiplos (ex: GHSA-mrxw-mxhj-p664, GHSA-353f-x4gh-cqq8) | Alta / Desconhecida | Problemas em libxml2 e libxslt, múltiplas CVEs | >= 1.18.9 / 1.18.4 |
| rack          | 3.1.8  | 3.2.0             | CVE-2025-25184, 27111, 27610, 46727, 49007 | Alta / Desconhecida | Injeção de logs, LFI, DoS, ReDoS | >= 3.1.16 |
| net-imap      | 0.5.5  | 0.5.9             | CVE-2025-25186, 43857            | Média / Desconhecida | Possível DoS por exaustão de memória             | >= 0.5.6 / 0.5.7 |
| activerecord  | 8.0.1  | 8.0.2.1           | CVE-2025-55193                    | Desconhecida | Logging vulnerável a ANSI escape injection       | >= 8.0.2.1 |
| activestorage | 8.0.1  | 8.0.2.1           | CVE-2025-24293                    | Desconhecida | Métodos de transformação potencialmente inseguros | >= 8.0.2.1 |
| rack-session  | 2.1.0  | 2.1.1             | CVE-2025-46336                    | Média       | Sessão restaurada após exclusão                  | >= 2.1.1 |
| thor          | 1.3.2  | 1.4.0             | CVE-2025-54314                    | Baixa       | Comando shell inseguro a partir de entrada       | >= 1.4.0 |
| uri           | 1.0.2  | 1.0.3             | CVE-2025-27221                    | Baixa       | Vazamento de userinfo em URI#join, #merge, #+   | >= 1.0.3 |

#### Observações:
```
. Todas as gems vulneráveis foram atualizadas para versões seguras;
. As gems do Rails (activerecord, activestorage) foram atualizadas de 8.0.1 para 8.0.2.1;
. A gem rack foi atualizada de 3.1.8 para 3.2.0 (que é superior à versão segura mínima recomendada de 3.1.16);
. Todas as atualizações atendem ou superam as versões seguras mínimas recomendadas pelo `bundler_audit`.

```

**6. Execução dos testes do Rails para validar integridade do código**:

    rails test -v

**7. Resultado da Auditoria**:

```
Banco de dados de vulnerabilidades atualizado: 1007 advisories

Data da última atualização: 2025-08-15 09:06:14 -0700

Status da auditoria: Nenhuma vulnerabilidade encontrada
```
**8. Injeções e Ataques**

`xss` - Cross Site Script - injeções maiciosaa - robo cokies, sequestro de sessões
`CVE` - Commun Vulnerabilities and Exposures(Vulnerabilidades e Exposições Comuns - VEC)
`DoS` - Deniel of Services - envia muitas requisições - app lenta - Ataque por indisponibilidade geral . Ex: Endpoint (sem _rate limiting_); Query (pesada _sem índice_); Upload (grande _sem controle_)
`ReDos` - Regular Expression Denial of Services - volume de tráfico - multiplas requisições - DoS causado por Regex mal-construídas - /(a+)+$/

**9. Conclusão**:

A aplicação está segura, todas as gems estão atualizadas e os testes confirmam que não houve regressões. Com isso, a Versão 2 está pronta para ser registrada e serve como base para iniciar a integração com pipelines de CI/CD na Versão 3.

**Atualização (mar/2026)**: Após reexecução do `bundle-audit`, realizamos a atualização da plataforma **Ruby** da versão **3.2.3** para **3.3.0**, garantindo conformidade com requisitos de **segurança** e **suporte**. 

**O que o relatório disse**:

**🔎 Overview**
```
Controllers: 7
Models: 3
Templates: 15
Errors: 0
Security Warnings: 1
```
```
✔ Brakeman analisou seu app
✔ Não encontrou erros
⚠ Encontrou 1 alerta de segurança
```
**⚠ Tipo do alerta**
```
Category: Unmaintained Dependency
Check: EOLRuby
Confidence: Medium
```
**Isso significa**:
```
Unmaintained Dependency → você está usando algo que terá fim de suporte.

EOLRuby → verificação de versão do Ruby.

Confidence: Medium → não é bug confirmado, é um aviso preventivo.
```
🚨 Mensagem principal
```
Support for Ruby 3.2.3 ends on 2026-03-31
File: .ruby-version
Line: 1
```
**Isso significa**:

#### 📅 O Ruby 3.2.3 terá fim de suporte oficial em 31 de março de 2026.

Após essa data:
```
❌ Não recebe correções de segurança

❌ Não recebe bugfixes

⚠ Pode ter vulnerabilidades futuras não corrigidas
```
