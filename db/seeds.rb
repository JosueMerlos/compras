# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
usuario = Usuario.create(email: 'user@test.com', nombre: 'Usuario Test')
Orden.create(usuario: usuario, monto: '10245.55', estado_pago: 'pendiente', estado_orden: 'recibida')
