json.id @orden.id
json.monto @orden.monto.to_f
json.estado_orden @orden.estado_orden
json.estado_pago @orden.estado_pago
json.fecha_pago @orden.fecha_pago
json.fecha_entrega @orden.fecha_entrega
json.usuario @orden.usuario, :id, :email, :nombre unless @orden.new_record?
