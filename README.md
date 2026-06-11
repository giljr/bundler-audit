# Estudos com Skills — Claude Code

Este repositório documenta estudos práticos sobre o uso de **skills** no Claude Code.

O objetivo é explorar como skills personalizadas podem automatizar e padronizar fluxos de análise de qualidade e segurança em projetos Ruby/Rails.

---

## Estudo atual — bundler-audit

A primeira skill em estudo é a **bundler-audit**, focada em segurança de dependências.

Ela cobre o fluxo completo de auditoria de gems: instalação, atualização do banco de vulnerabilidades, interpretação de CVEs e GHSAs, e estratégias de atualização segura para ambientes de produção.

---

## Próximos estudos

Os próximos estudos serão conduzidos no **Codex** e abordarão outras ferramentas do ecossistema Ruby/Rails:

- **Brakeman** — análise estática de segurança para aplicações Rails
- **RuboCop** — linting e enforçamento de estilo de código Ruby
- outras ferramentas a definir conforme o andamento dos estudos

---

## Estrutura

```
claude/
└── SKILL.md    ← skill de auditoria de gems com bundler-audit
└── Proj 1
└── Proj 2
└── ...
```

---

*Estudo iniciado em junho de 2026.*
