
# POC de instalação de skill no Claude

### Introdução

Neste tutorial, vamos criar uma Skill para o Claude capaz de executar auditorias de segurança em projetos Ruby utilizando o `bundler-audit`.

Após configurada, basta solicitar:
```
Audite as gems deste projeto com bundler-audit
```
A Skill executará a análise na raiz do projeto e apresentará um relatório com possíveis vulnerabilidades e recomendações de atualização das gems afetadas.

[SKILL.md](bundler-audit-test/docs/skill.md)
[Rodando no vera!](bundler-audit-test/docs/radando_no_vera.txt) 
### O que vamos fazer
Pegar o `SKILL.md` que você salvou no VS Code e instalar no Claude como uma skill real, funcionando em claude.ai (web/desktop).

Pré-requisitos
```
Conta Claude (free, Pro, Max, Team ou Enterprise — todos suportam skills)
Code Execution habilitado (necessário para skills funcionar)
O arquivo bundler-audit/SKILL.md já salvo no VS Code
```

### Passo 1 — Verificar se Code Execution está ativo
No `claude.ai`, abra as configurações e confirme que `Code Execution and File Creation` está habilitado. Se não estiver, ative antes de continuar.

### Passo 2 — Estrutura da pasta
Cada `skill` precisa de um diretório contendo pelo menos um arquivo `skill.md`. A estrutura correta é: Claude
```
bundler-audit/
└── RAILS PROJECT        ← seu projeto a ser testado
└── SKILL.md             ← seu arquivo já criado
```

Você já tem isso pronto no VS Code. Nada a fazer aqui.

### Passo 3 — Criar o ZIP
A estrutura correta do ZIP deve ter a pasta da skill como raiz: Claude

No terminal (dentro da pasta pai do bundler-audit/):
```
bash# Linux / WSL2 / macOS
zip -r bundler-audit.zip bundler-audit/
```
No PowerShell (Windows 11)
```
Compress-Archive -Path bundler-audit -DestinationPath bundler-audit.zip
```
⚠️ Não coloque os arquivos diretamente na raiz do ZIP — o Claude não reconhece assim.


### Passo 4 — Upload no claude.ai
```
Acesse claude.ai → Settings (Configurações)
Vá em Customize → Skills
Clique em "Add skill" ou "Upload skill"
Selecione o arquivo bundler-audit.zip
Aguarde o upload e confirme que aparece na lista
```

### Passo 5 — Ativar a skill
Após o upload, habilite a skill em `Customize > Skills` e tente alguns prompts diferentes que deveriam acioná-la. Revise o pensamento do Claude para confirmar que está carregando a `skill`.

### Passo 6 — Testar (o POC de verdade)
Inicie uma nova conversa no `claude.ai` e tente estes prompts:
```
Como faço para auditar vulnerabilidades nas gems do meu projeto Rails?
```
```
Quero instalar o bundler-audit no meu projeto. Como começo?
```
```
O bundler-audit encontrou CVE-2025-27610 no rack. O que faço?
```
Se a skill estiver funcionando, o Claude vai responder seguindo exatamente o conteúdo do seu `SKILL.md` — o fluxo de instalação, a tabela de gems vulneráveis, a estratégia de atualização gradual para produção.

Resumo do fluxo
```
VS Code (SKILL.md)
      ↓
   ZIP file
      ↓
claude.ai → Settings → Customize → Skills → Upload
      ↓
Nova conversa → prompt relacionado a bundler-audit
      ↓
Claude aciona a skill automaticamente ✓
```
### Dica: 
Se o Claude não acionar a `skill` automaticamente, o problema costuma ser no campo description do `frontmatter`. A descrição é o que o Claude usa para decidir quando carregar a skill. Se precisar ajustar, edite o  `SKILL.md`, recrie o `ZIP` e faça o re-upload.


----

----

## Note ¹
### O que é o Frontmatter?


O frontmatter é o bloco de metadados que fica no início do arquivo SKILL.md, normalmente entre linhas com ---.

Exemplo:
```
---
name: Bundler Audit
description: Audita gems Ruby com bundler-audit e gera um relatório de vulnerabilidades.
---

Bundler Audit Skill

```
Nesse exemplo:
```
name → nome da skill.
description → descrição da skill.
Outros campos podem existir dependendo da plataforma.
```

O campo `description` é especialmente importante porque o Claude usa esse texto para decidir quando deve carregar automaticamente a skill.

Por exemplo, se a descrição for:
```yml
description: Executa auditorias de segurança em projetos Ruby usando bundler-audit.
```
o Claude tem mais chances de ativar a skill quando você pedir:

`Audite as gems deste projeto com bundler-audit`

ou

`Verifique vulnerabilidades das gems`

Já uma descrição muito genérica, como:
```yml
description: Ferramentas para Ruby.
```
dificulta o Claude entender quando a skill é relevante.

**Em resumo**: o `frontmatter` é o cabeçalho de metadados do `SKILL.md`, e o campo description funciona como o principal gatilho para o Claude decidir carregar a skill automaticamente.

 


