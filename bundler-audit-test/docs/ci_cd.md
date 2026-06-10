## Configuração do Pipeline CI/CD para o projeto Bundler Audit

Este documento descreve o passo a passo para configurar o pipeline do GitLab CI/CD para o projeto **Bundler Audit**, incluindo stages, jobs e configuração do Semantic Release.
`Fonte: Jeovan Farias`

---

## 1. Criação do Pipeline

#### 1. Crie o arquivo `.gitlab-ci.yml` na raiz do projeto.
#### 2. Defina os **stages** do pipeline. Exemplo:

```yaml
stages:
  - build
  - test
  - release
```

#### 3. Para cada stage, especifique **o que deve ser executado** (scripts e comandos).

Exemplo:

```yaml
test:minitest:
  stage: test
  image: ruby:3.2
  script:
    - bundle install --jobs=4 --retry=3
    - mkdir -p tmp
    - bundle exec rails test -v 2>&1 | tee tmp/test.log || true
  artifacts:
    paths:
      - tmp/test.log
    when: always
    expire_in: 7 days
  allow_failure: false
  tags:
    - dev
```

```
Essa configuração trata da execução dos testes automatizados com Minitest no pipeline CI/CD.
De forma sucinta:

Job: test:minitest

Stage: test (fase de testes do pipeline)

Imagem Docker: ruby:3.2 (ambiente Ruby isolado)

Script executado:

. Instala as gems (bundle install) com retry e paralelismo.
. Cria a pasta tmp para logs temporários.
. Executa os testes do Rails (rails test) e salva o output em tmp/test.log.

Artifacts: o log de testes é salvo e disponível por 7 dias, mesmo se o job falhar.

Controle de falha: allow_failure: false → o pipeline para se os testes falharem.

Tags: dev → indica o runner específico a ser usado.

✅ Em resumo, garante que o código passe nos testes do Minitest antes de avançar para outras etapas do CI/CD.
```
---

## 2. Criação dos Jobs

Para cada stage, configure os jobs correspondentes. Exemplo para o **Semantic Release**:

####  2.1 Configuração do Semantic Release

#####  1. Crie o arquivo `.releaserc` na raiz do projeto.
#####  2. Inclua nele as bibliotecas e plugins necessários para rodar o release automático, por exemplo:

```json
{
  "branches": ["main", "master"],
  "plugins": [
    ["@semantic-release/commit-analyzer"],
    ["@semantic-release/release-notes-generator"],
    [
      "@semantic-release/changelog",
      {
        "changelogFile": "CHANGELOG.md"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md"],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ],
    ["@semantic-release/gitlab"]
  ]
}

```
```
Fluxo no Pipeline CI/CD:

O pipeline é acionado por um push para main/master

semantic-release analisa os commits desde a última tag

Determina a nova versão seguindo Semantic Versioning

Gera CHANGELOG.md e notas de release

Commita as mudanças no repositório

Cria uma tag git com a nova versão

Publica uma release no GitLab

```


#### 2.2 Criar Access Token

#####  1. Acesse **GitLab → Configurações → Access Tokens**.
#####  2. Crie um **Personal Access Token (GL_TOKEN)** com os scopes:

- `api`
- `read_api`
- `read_repository`
- `write_repository`

#### 2.3 Configurar variável de ambiente

#####  1. No projeto GitLab, acesse **Configurações → CI/CD → Variáveis**.
#####  2. Crie a variável de ambiente `GL_TOKEN` e cole o **token secreto** gerado no passo anterior.
#####  3. Marque a variável como **protected** se necessário (apenas para branches protegidas).

&nbsp;
---
#### Conclusão

Com isso, o pipeline estará pronto para executar **build, testes e releases automáticos**, garantindo que a auditoria de dependências e versionamento sejam realizados de forma automatizada.