## 🥷🏼 Uso de Tokens 
(para envio de nova senha via email - link: `forgot password?`)


`token` é o coração de um fluxo seguro de redefinição de senha no Ruby on Rails.
Vou explicar de forma clara, passo a passo.

**🔐 O que é esse “token”?**

É um **ID assinado**, **temporário** e à **prova de adulteração** que comprova:

`Este link realmente pertence a este usuário específico e ainda é válido.`

O Rails o cria usando **criptografia** para que ninguém consiga falsificar ou alterar.

**🧩 Onde o token é criado**

**Fluxo**:  `
Gerado em Mailer → Envio via Email → Verificado no Controlador → Reusado no Submit`

**Geração**: `app/mailers/password_mailer.rb # reset`
```rails
@token = @user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
```
O Rails gera um token assinado a partir do ID do usuário.

O Rails cria um token assinado e previne o uso indevido (no caso, aplicado somente para resetar o password), expirável - melhorando a segurança.



**Consumo**: `app/controllers/password_resets_controller.rb # update`
```ruby
@user = User.find_signed!(params[:token], purpose: 'password_reset')
```
Recuperação do usuário por token temporário e a prova de falsificação, sem exposição de dados críticos.


**📦 O que existe dentro do token?**

Pense nele como um _envelope lacrado_ contendo:
```ruby
- user_id
- purpose: "password_reset"
- expiration_time
- digital_signature
```
**📘 Cada opção explicada**

`signed_id`	Gera um token assinado e seguro a partir do registro do usuário

`purpose`:	Restringe onde o token pode ser usado

`expires_in`:	Torna o token automaticamente inválido após um tempo limite

**🎯 Então esse token**:

✅ Identifica o usuário

✅ Funciona apenas para redefinição de senha

✅ Expira em 15 minutos

✅ Não pode ser falsificado nem alterado

**✉️ Como o token é enviado**

**View do e-mail**
```ruby
<%= link_to "Reset password", password_reset_edit_url(token: @token) %>
```
Isso cria um link como:

https://example.com/password_reset/edit?token=eyJfcmFpbHMiOns...

O token viaja com segurança na URL.

**🔍 Como o Rails verifica o token**

**Controller — ação edit**
```
@user = User.find_signed!(params[:token], purpose: 'password_reset')
```
**O Rails**:

 - Lê o token dos parâmetros da URL

- Verifica a assinatura digital

- Confere o tempo de expiração

- Confirma se o propósito corresponde

- Extrai o user_id original

- Carrega o usuário do banco de dados

- Se qualquer coisa estiver errada → ele gera um erro.

**❌ Token expirado ou inválido**
```ruby
rescue ActiveSupport::MessageVerifier::InvalidSignature
  redirect_to sign_in_path, alert: 'Your token has expired.'
```
*Isso acontece se*:

 - O token expirou

 - O token foi modificado

 - O token foi usado para o propósito errado

 - O token é falso

O Rails bloqueia o acesso automaticamente.

**🔁 Por que o token é usado novamente no update**
```ruby
@user = User.find_signed!(params[:token], purpose: 'password_reset')
```
- Porque HTTP não mantém estado.

- Quando o usuário envia o formulário:

- O Rails precisa verificar a identidade novamente

- Ele não pode confiar em campos ocultos

- O token comprova o usuário outra vez

**🧠 Por que essa abordagem é segura**

**Sem tokens ❌**

- Qualquer pessoa poderia redefinir qualquer senha

- URLs poderiam ser adivinhadas

- Links antigos funcionariam para sempre

**Com tokens assinados** ✅

- A identidade do usuário é verificada criptograficamente

- Links expiram automaticamente

- Tokens não podem ser falsificados

- O propósito impede reutilização em outros fluxos

**🔬 Por baixo dos panos**

O Rails usa:

- `ActiveSupport::MessageVerifier`

- Chave secreta da aplicação

- Assinatura HMAC

- Se alguém alterar até 1 caractere → a assinatura quebra.

**🧱 Analogia do mundo real**

O token é como:

🎫 Um _ingresso de show_ com:

- Seu nome

- Nome do evento

- Data de validade

- Selo holográfico oficial

Checagens de segurança:

 - O selo é verdadeiro?

- O evento está correto?

- Ainda está válido?

- Quem é o dono?

**✅ Resumo**

Seu token é:

`Uma prova de identidade temporária e segura para redefinição de senha.`


