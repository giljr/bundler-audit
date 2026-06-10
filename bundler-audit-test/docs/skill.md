---
name: bundler-audit
description: >
  Guia completo para instalar, configurar e executar o bundler-audit em projetos Ruby/Rails.
  Use esta skill sempre que o usuário mencionar bundler-audit, auditoria de gems, vulnerabilidades
  em gems Ruby, CVEs em dependências, atualização segura de gems, ou quiser garantir segurança
  nas dependências de um projeto Rails. Também acione para análise de resultados do bundler-audit,
  interpretação de CVEs/GHSA, e estratégias de atualização segura em produção.
---

# bundler-audit — Auditoria de Segurança para Gems Ruby

## O que é o bundler-audit?

O `bundler-audit` é uma ferramenta que verifica o `Gemfile.lock` do projeto contra um banco de dados de vulnerabilidades conhecidas (CVEs e GHSAs), identificando gems com falhas de segurança e recomendando versões seguras.

---

## Instalação passo a passo

### 1. Adicionar ao Gemfile

Adicione apenas no grupo de desenvolvimento — não é necessário em produção:

```ruby
group :development do
  gem 'bundler-audit', require: false
end
```

### 2. Instalar as gems do projeto

```bash
bundle install
```

### 3. Atualizar o banco de dados de vulnerabilidades

O bundler-audit mantém uma cópia local do banco de advisories. Sempre atualize antes de auditar:

```bash
bundle exec bundler-audit update
```

> O banco contém centenas de advisories (ex.: 1007 advisories, atualizado em 2025-08-15).

### 4. Executar a auditoria

```bash
bundle exec bundler-audit check --update
```

A flag `--update` garante que o banco seja atualizado automaticamente antes de checar.

---

## Interpretando os resultados

O bundler-audit reporta cada gem vulnerável com:

| Campo | Descrição |
|---|---|
| **Gem** | Nome da gem afetada |
| **Version** | Versão atualmente instalada |
| **Advisory** | Identificador CVE ou GHSA |
| **Criticality** | Nível: Unknown / Low / Medium / High / Critical |
| **Title** | Descrição resumida da vulnerabilidade |
| **Solution** | Versão segura recomendada |

**Resultado limpo:**
```
No vulnerabilities found
```

**Resultado com vulnerabilidade (exemplo):**
```
Name: rack
Version: 3.1.8
Advisory: CVE-2025-27610
Criticality: High
Title: Path traversal vulnerability
Solution: upgrade to >= 3.1.16
```

---

## Estratégia de atualização segura

### Ambiente de desenvolvimento / staging

Pode-se atualizar todas as gems vulneráveis de uma vez:

```bash
bundle update nokogiri rack net-imap activerecord activestorage rack-session thor uri
```

### Ambiente de produção (recomendado: atualização gradual)

> ⚠️ **Atenção:** Em produção, atualize gem a gem, executando os testes a cada passo.

```bash
# 1. Atualizar uma gem por vez
bundle update rack

# 2. Rodar testes da aplicação
rails test -v

# 3. Verificar se o bundler-audit está satisfeito com essa gem
bundle exec bundler-audit check

# 4. Repetir para a próxima gem
```

### Atualizar todas as gems do sistema (opcional)

```bash
gem update
```

> Use com cautela — pode causar quebras de compatibilidade em projetos que não gerenciam versões explicitamente.

---

## Exemplos de vulnerabilidades comuns (referência)

| Gem | CVEs frequentes | Tipo de risco |
|---|---|---|
| `nokogiri` | GHSA-mrxw-mxhj-p664 | Problemas em libxml2/libxslt |
| `rack` | CVE-2025-25184, 27610 | Log injection, LFI, DoS, ReDoS |
| `net-imap` | CVE-2025-25186 | DoS por exaustão de memória |
| `activerecord` | CVE-2025-55193 | ANSI escape injection em logs |
| `activestorage` | CVE-2025-24293 | Transformações potencialmente inseguras |
| `rack-session` | CVE-2025-46336 | Sessão restaurada após exclusão |
| `thor` | CVE-2025-54314 | Injeção via shell input |
| `uri` | CVE-2025-27221 | Vazamento de userinfo em URI join/merge |

---

## Integração com CI/CD

Adicione ao pipeline para bloquear deploys com vulnerabilidades:

```yaml
# Exemplo GitHub Actions
- name: Audit gems
  run: bundle exec bundler-audit check --update
```

O comando retorna exit code `1` se encontrar vulnerabilidades, o que interrompe o pipeline automaticamente.

---

## Ciclo completo recomendado

```
1. bundle exec bundler-audit update      # Atualiza banco de advisories
2. bundle exec bundler-audit check       # Verifica vulnerabilidades
3. bundle update <gem-vulnerável>        # Atualiza gem a gem (produção)
4. rails test -v                         # Valida que nada quebrou
5. bundle exec bundler-audit check       # Confirma que a vulnerabilidade foi corrigida
6. Repetir até: "No vulnerabilities found"
```

---

## O que são CVEs e GHSAs?

- **CVE** (Common Vulnerabilities and Exposures): identificador global de vulnerabilidades mantido pelo MITRE. Ex.: `CVE-2025-27610`.
- **GHSA** (GitHub Security Advisory): identificador de vulnerabilidades reportadas via GitHub. Ex.: `GHSA-mrxw-mxhj-p664`.
- Ambos são rastreados pelo banco de dados do bundler-audit.