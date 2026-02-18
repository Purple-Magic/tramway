# frozen_string_literal: true

clients_data = [
  { name: 'Acme Corp', email: 'contact@acme.example' },
  { name: 'Globex', email: 'hello@globex.example' },
  { name: 'Initech', email: 'support@initech.example' }
]

clients = clients_data.map.with_index(1) do |attrs, index|
  client = Client.find_or_create_by!(email: attrs[:email]) do |record|
    record.name = attrs[:name]
  end

  puts "[Client #{index}] id=#{client.id}, name=#{client.name}, email=#{client.email}"
  client
end

orders_data = [
  { number: 'ORD-1001', total_cents: 15_000, status: 'new' },
  { number: 'ORD-1002', total_cents: 29_900, status: 'paid' },
  { number: 'ORD-1003', total_cents: 7_500, status: 'shipped' }
]

orders_data.each_with_index do |attrs, index|
  client = clients[index % clients.length]

  order = Order.find_or_create_by!(number: attrs[:number]) do |record|
    record.client = client
    record.total_cents = attrs[:total_cents]
    record.status = attrs[:status]
  end

  puts "[Order #{index + 1}] id=#{order.id}, number=#{order.number}, client_id=#{order.client_id}, total_cents=#{order.total_cents}, status=#{order.status}"
end
