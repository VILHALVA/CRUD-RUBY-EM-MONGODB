require 'mongo'
require 'time'

class Usuario
  attr_accessor :nome, :idade

  def initialize(nome, idade)
    @nome = nome
    @idade = idade
  end
end

class GerenciadorUsuarios
  def initialize
    begin
      @cliente = Mongo::Client.new(['localhost:27017'], :database => 'cadastro')
      @collection = @cliente[:usuarios]
      puts "CONEXÃO AO BANCO DE DADOS ESTABELECIDA COM SUCESSO!"
    rescue Exception => e
      puts "ERRO AO CONECTAR AO BANCO DE DADOS: #{e}"
    end
  end

  def adicionar_usuario(nome, idade)
    begin
      usuario = { nome: nome, idade: idade }
      @collection.insert_one(usuario)
      puts "USUÁRIO ADICIONADO COM SUCESSO!"
    rescue Exception => e
      puts "ERRO AO ADICIONAR USUÁRIO: #{e}"
    end
  end

  def listar_usuarios
    begin
      usuarios = @collection.find.to_a

      if usuarios.any?
        puts "=" * 20
        puts "LISTA DE USUÁRIOS:"
        puts "-" * 20
        usuarios.each do |usuario|
          puts "*" * 20
          puts "NOME: #{usuario[:nome]}, IDADE: #{usuario[:idade]}"
          puts "*" * 20
        end
        puts "=" * 20
      else
        puts "NENHUM USUÁRIO CADASTRADO."
      end
    rescue Exception => e
      puts "ERRO AO LISTAR USUÁRIOS: #{e}"
    end
  end

  def atualizar_usuario(nome_antigo, novo_nome, nova_idade)
    begin
      query = { nome: nome_antigo }
      new_values = { "$set": { nome: novo_nome, idade: nova_idade } }
      @collection.update_one(query, new_values)
      puts "USUÁRIO ATUALIZADO COM SUCESSO!"
    rescue Exception => e
      puts "ERRO AO ATUALIZAR USUÁRIO: #{e}"
    end
  end

  def excluir_usuario(nome)
    begin
      query = { nome: nome }
      @collection.delete_one(query)
      puts "USUÁRIO EXCLUÍDO COM SUCESSO!"
    rescue Exception => e
      puts "ERRO AO EXCLUIR USUÁRIO: #{e}"
    end
  end
end

def exibir_menu
  puts "\nMENU:"
  puts "1. ADICIONAR USUÁRIO"
  puts "2. LISTAR USUÁRIOS"
  puts "3. ATUALIZAR USUÁRIO"
  puts "4. EXCLUIR USUÁRIO"
  puts "5. SAIR"
end

def main
  gerenciador = GerenciadorUsuarios.new

  loop do
    exibir_menu
    print "ESCOLHA UMA OPÇÃO:\n>>>"
    opcao = gets.chomp

    case opcao
    when "1"
      print "DIGITE O NOME:\n>>>"
      nome = gets.chomp
      print "DIGITE A IDADE:\n>>>"
      idade = gets.chomp
      gerenciador.adicionar_usuario(nome, idade)
    when "2"
      gerenciador.listar_usuarios
    when "3"
      print "DIGITE O NOME A SER ATUALIZADO:\n>>>"
      nome_antigo = gets.chomp
      print "DIGITE O NOVO NOME:\n>>>"
      novo_nome = gets.chomp
      print "DIGITE A NOVA IDADE:\n>>>"
      nova_idade = gets.chomp
      gerenciador.atualizar_usuario(nome_antigo, novo_nome, nova_idade)
    when "4"
      print "DIGITE O NOME DO USUÁRIO A SER EXCLUÍDO:\n>>>"
      nome = gets.chomp
      gerenciador.excluir_usuario(nome)
    when "5"
      puts "SAINDO..."
      sleep(3)
      break
    else
      puts "OPÇÃO INVÁLIDA. TENTE NOVAMENTE!"
    end
  end
end

if __FILE__ == $0
  main
end
