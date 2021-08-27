FactoryBot.define do
  factory :orden_1, class: Orden do
    id           { 1 }
    association  :usuario, factory: :usuario_1, strategy: :build
    monto        { '325.56' }
    estado_pago  { 'pendiente' }
    estado_orden { 'recibida' }
  end

  factory :orden_2, class: Orden do
    id           { 2 }
    association  :usuario, factory: :usuario_1, strategy: :build
    monto        { '225.00' }
    estado_pago  { 'pagada' }
    fecha_pago   { Time.current }
    estado_orden { 'recibida' }
  end

  factory :orden_3, class: Orden do
    id            { 3 }
    association  :usuario, factory: :usuario_2, strategy: :build
    monto         { '143.50' }
    estado_pago   { 'pagada' }
    fecha_pago    { Time.current }
    estado_orden  { 'entregada' }
    fecha_entrega { Time.current }
  end
end
