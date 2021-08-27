total_count = @ordenes.length
json.ordenes @ordenes.paginate(page: params[:page], per_page: params[:per_page]) do |orden|
  json.id orden.id
  json.monto orden.monto.to_f
  json.estado_orden orden.estado_orden
  json.estado_pago orden.estado_pago
  json.fecha_pago orden.fecha_pago
  json.fecha_entrega orden.fecha_entrega
  json.usuario orden.usuario, :id, :email, :nombre
end
json.partial! 'api/v1/shared/pagination', page: params[:page], per_page: params[:per_page], total_count: total_count