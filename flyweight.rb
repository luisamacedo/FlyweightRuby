require 'json'

# O Flyweight é um padrão de design estrutural que permite que os programas suportem
# grandes quantidades de objetos, mantendo baixo o consumo de memória.

# O Flyweight armazena uma parte comum do estado que pertence a várias entidades
# comerciais reais. O Flyweight aceita o restante do estado através de seus
# parâmetros de método.

class Flyweight
  # estado compartilhado
  def initialize(shared_state)
    @shared_state = shared_state
  end

  # estado exclusivo
  def operation(unique_state)
    s = @shared_state.to_json
    u = unique_state.to_json
    print "Flyweight: Exibindo estado compartilhado (#{s}) e exclusivo (#{u})."
  end
end

# A Flyweight Factory cria e gerencia os objetos Flyweight.
# Ele garante que os Flyweights sejam compartilhados corretamente.
# Quando o cliente solicita um Flyweight, a fábrica retorna uma 
# instância existente ou cria uma nova, se ainda não existir.

class FlyweightFactory
  # Flyweigths iniciais
  def initialize(initial_flyweights)
    @flyweights = {}
    initial_flyweights.each do |state|
      @flyweights[get_key(state)] = Flyweight.new(state)
    end
  end

  # Retorna o hash da string do Flyweight para um determinado estado.
  def get_key(state)
    state.sort.join('_')
  end

  # Retorna um Flyweight existente com um determinado estado ou cria um novo.
  def get_flyweight(shared_state)
    key = get_key(shared_state)

    if !@flyweights.key?(key)
      puts 'FlyweightFactory: Não é possível encontrar um Flyweight, criando um novo.'
      @flyweights[key] = Flyweight.new(shared_state)
    else
      puts 'FlyweightFactory: Reutilizando o Flyweight existente.'
    end

    @flyweights[key]
  end

  def list_flyweights
    puts "FlyweightFactory: Eu tenho #{@flyweights.size} flyweights:"
    print @flyweights.keys.join("\n")
  end
end


def add_car_to_police_database(factory, plates, owner, brand, model, color)
  puts "\n\nCliente: Adicionando um carro ao banco de dados."
  flyweight = factory.get_flyweight([brand, model, color])
  # O código do cliente armazena ou reusa o estado extrínseco e o passa para os métodos do flyweight.
  flyweight.operation([plates, owner])
end

# O código do cliente geralmente cria um monte de Flyweights 
# pré-preenchidos no estágio de inicialização do aplicativo.

factory = FlyweightFactory.new([
                                 %w[Chevrolet Camaro2018 pink],
                                 ['Mercedes Benz', 'C300', 'black'],
                                 ['Mercedes Benz', 'C500', 'red'],
                                 %w[BMW M5 red],
                                 %w[BMW X6 white]
                               ])

factory.list_flyweights

add_car_to_police_database(factory, 'CL234IR', 'James Doe', 'BMW', 'M5', 'red')

add_car_to_police_database(factory, 'CL234IR', 'James Doe', 'BMW', 'X1', 'red')

puts "\n\n"

factory.list_flyweights
