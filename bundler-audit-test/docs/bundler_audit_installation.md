## Instruções de Instalação do Bundler-Audit

Para instalar e configurar o **bundler-audit** em seu projeto Ruby on Rails, siga os passos abaixo:

#### Passo 1: Adicionar à Gemfile

Adicione a gem `bundler-audit` no grupo de desenvolvimento:

```ruby
group :development do
  gem 'bundler-audit', require: false
end
```
#### Passo 2: Instalar a gem
Execute o comando:

    bundle install

#### Passo 3: Atualizar a base de dados de vulnerabilidades

    bundle exec bundler-audit update

#### Passo 4: Executar a auditoria
Para verificar se existem gems vulneráveis:


    bundle exec bundler-audit check --update
⚠️ Caso alguma vulnerabilidade seja encontrada, a ferramenta exibirá alertas. Avalie atualizar ou substituir a gem afetada.

