json.email @usuario.email
json.nombre @usuario.nombre
json.ordenes @usuario.ordenes.order(created_at: :desc).last(5) do |orden|
  json.monto orden.monto.to_f
  json.estado_orden orden.estado_orden
  json.estado_pago orden.estado_pago
  json.fecha_pago orden.fecha_pago
  json.fecha_entrega orden.fecha_entrega
end
