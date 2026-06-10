# App Bundle Audit Teste - Arquitetura

Rails 8 • Hotwire • Autenticação Segura • Arquitetura Limpa

*Bundle Audit Teste* é uma aplicação demonstrativa construída com **Rails 8** para explorar **bundle-audit**, **autenticação segura** e **boas práticas** modernas de desenvolvimento — sem livrarias externas (sem devise), sem frameworks JavaScript, sem frameworks CSS e sem ferramentas de build.

Este projeto demonstra:
```
🔐 Autenticação segura com bcrypt

🛡 Validação em múltiplas camadas (Aplicação + Banco de Dados)

🔄 Gerenciamento de sessão

🌍 Configuração de fuso horário local

🧠 Gerenciamento de usuário por requisição com Current

⚡ Import Maps (sem Node, sem bundlers)
```
### 📚 Sumário
```
- Visão Geral da Arquitetura

- Sistema de Autenticação

- Modelo de Segurança

- Gerenciamento de Sessão

- Integração com Hotwire

- Fuso Horário

- Contexto de Requisição com Current

- Visão Geral das Rotas
```

## Visão Geral da Arquitetura
O _Bundle Audit Teste_ segue a estrutura padrão do Rails 8:

- Arquitetura MVC

- Rotas RESTful

- Fluxo de autenticação seguro

- Estratégia de validação em camadas

- Dependências mínimas

- Sem pipeline de build frontend

O projeto é intencionalmente simples, mas pensado com consciência de produção.

## 🔐 Sistema de Autenticação

A autenticação é implementada usando o sistema nativo de senha segura do Rails com `bcrypt`.

Modelo User
```
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: true,
            length: { minimum: 6 },
            confirmation: true
end
```
**Por que password_digest?**

A coluna `password_digest` armazena o hash criptográfico da senha — **nunca a senha em texto puro**.

O Rails exige esse nome ao usar:

- has_secure_password

Isso habilita:

- Hash seguro com bcrypt

- Confirmação de senha

- Método `authenticate` para verificação no login

## 🛡 Modelo de Segurança

O _Bundle Audit Teste_ aplica o conceito de `Defesa em Profundidade`.

- Validação na Camada de Aplicação

- Presença de email

- Formato válido de email

- Comprimento mínimo de senha

- Confirmação de senha

- Proteção na Camada de Banco - 
`t.string :email, null: false`

Mesmo que alguém tente inserir dados diretamente via SQL, o banco impede registros inválidos.

 - Proteção contra `Mass Assignment` (ler **Nota¹**) 

- Uso de strong parameters:

`params.expect(user: [:email, :password, :password_confirmation])`

Isso impede injeção de atributos não autorizados.

- Segurança Herdada do Rails

A aplicação já conta com:
```
 - Proteção CSRF

- Escape automático contra XSS

- Sessões seguras via cookies

- Filtro automático de parâmetros sensíveis
```


## 🔑 Gerenciamento de Sessão

Sessões são implementadas manualmente via `SessionsController`.

Fluxo de Login:
```
user = User.find_by(email: params[:email])

if user&.authenticate(params[:password])
  session[:user_id] = user.id
end
```
✔ Verificação via bcrypt

✔ Sessão segura

✔ Logout limpa `session[:user_id]`

Rotas
```
GET    /sign_in
POST   /sign_in
DELETE /sign_out
```
O _mesmo endpoint_ pode responder a _diferentes verbos_ HTTP.

## 🧠 Contexto de Requisição com Current

**O projeto utiliza**:

`ActiveSupport::CurrentAttributes`

Implementação:
```
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
```
`Current.user` é:

- Escopado por requisição

- Thread-safe

- Acessível em `controllers`, `models` e `services`

Isso permite código mais limpo e organizado.

⚡ **Integração com Hotwire**

O _Bundle Audit Teste_ utiliza:

- Turbo

- Import Maps

- Sem Node

- Sem ferramentas de build

- Sem frameworks JS

**Isso mantém o projeto**:

- Simples

- Moderno

- Leve

- Performático

⏰ **Fuso Horário**

Configuração:
```
config.time_zone = "America/Porto_Velho"
config.active_record.default_timezone = :local
```
Uso de local-time via Import Maps para exibição correta no frontend.

Isso garante:

- Armazenamento consistente

- Exibição correta para o usuário

- Sem necessidade de JS complexo

## 🛣 Visão Geral das Rotas
```
root      -> main#index

/about    -> about#index

/sign_up  -> registrations#new
            registrations#create

/sign_in  -> sessions#new
            sessions#create

/sign_out -> sessions#destroy
```
▶️ Como Executar

1️⃣ Clonar
```
git clone <repo>
cd blog
```
2️⃣ Instalar dependências
```
bundle install
```
3️⃣ Preparar banco
```
rails db:create
rails db:migrate
```
4️⃣ Executar
```
bin/dev
```
Acesse:
```
http://127.0.0.1:3000

```
🧪 Compatibilidade com QA e Segurança

O projeto é compatível com:

- bundler-audit

- Brakeman

- Rubocop

- RSpec

- RubyCritic

#### Foi estruturado para integração fácil em pipelines de CI/CD.

🚀 Visão

O _Bundle Audit Teste_ não é apenas um tutorial.

É uma arquitetura de referência para autenticação segura em Rails 8 com Hotwire, mantendo simplicidade, clareza e consciência de produção.

---
### Nota¹ - Proteção contra Mass Assignment

Mass Assignment é quando vários atributos de um modelo são enviados de uma vez só via parâmetros da requisição.

Exemplo comum:

`User.create(params[:user])`

Se não houver controle, um usuário malicioso poderia enviar algo como:
```
{
  "user": {
    "email": "hacker@email.com",
    "password": "123456",
    "admin": true
  }
}
```
⚠️ Se o atributo admin existir no modelo, ele poderia se tornar administrador sem autorização.

✅ Como o Rails protege contra isso?

Com Strong Parameters no controller:
```
def user_params
  params.expect(user: [:email, :password, :password_confirmation])
end
```
Ou tradicionalmente:
```
params.require(:user).permit(:email, :password, :password_confirmation)
```
Isso significa:

✔ Apenas esses campos são permitidos
❌ Qualquer outro atributo enviado será ignorado

🎯 Resumo simples

`Mass Assignment` = atualizar vários campos de uma vez.

`Proteção` = permitir explicitamente apenas os atributos seguros.

Nunca confie diretamente em `params`.