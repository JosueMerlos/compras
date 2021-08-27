class Api::V1::OrdenesController < ApplicationController
  def index
    @ordenes = Orden.all
    fecha_entrega = Date.parse(index_params[:fecha_entrega]) rescue nil
    @ordenes = @ordenes.por_fecha_entrega(fecha_entrega) if fecha_entrega.present?

    render formats: :json
  end

  def show
    @orden = Orden.find(show_params[:id])

    render formats: :json
  end

  def create
    @orden = Orden.new(
      usuario_id: create_params[:usuario_id],
      monto: create_params[:monto],
      estado_pago: create_params[:estado_pago].presence || 'pendiente',
      estado_orden: create_params[:estado_orden].presence || 'recibida'
    )
    @orden.fecha_pago = DateTime.parse(create_params[:fecha_pago]) rescue nil
    @orden.fecha_entrega = DateTime.parse(create_params[:fecha_entrega]) rescue nil
    raise ExceptionApi, @orden.errors.full_messages.join(', ') unless @orden.save

    render :show, formats: :json
  end

  def update_estado_pago
    @orden = Orden.find(update_pago_params[:id])
    raise ExceptionApi, 'It is not a valid estado_pago' unless estado_pago_valido?(update_despacho_params[:estado_pago])

    @orden.estado_pago = update_pago_params[:estado_pago]
    fecha_pago = DateTime.parse(update_pago_params[:fecha_pago]) rescue nil
    @orden.fecha_pago = fecha_pago || Time.current if @orden.pagada?
    raise ExceptionApi, @orden.errors.full_messages.join(', ') unless @orden.save

    render :show, formats: :json
  end

  def update_estado_despacho
    @orden = Orden.find(update_despacho_params[:id])
    raise ExceptionApi, 'It is not a valid estado_orden' unless estado_orden_valido?(update_despacho_params[:estado_orden])

    @orden.estado_orden = update_despacho_params[:estado_orden]
    fecha_entrega = DateTime.parse(update_despacho_params[:fecha_entrega]) rescue nil
    @orden.fecha_entrega = fecha_entrega || Time.current if @orden.entregada?
    raise ExceptionApi, @orden.errors.full_messages.join(', ') unless @orden.save

    render :show, formats: :json
  end

  def destroy
    @orden = Orden.find(destroy_params[:id])
    raise ExceptionApi, @orden.errors.full_messages.join(', ') unless @orden.destroy

    @orden = Orden.new
    render :show, formats: :json
  end

  private

  def index_params
    params.permit(:fecha_entrega, :page, :per_page)
  end

  def show_params
    params.permit(:id)
  end

  def create_params
    params.permit(:usuario_id, :monto, :estado_pago, :estado_orden, :fecha_pago, :fecha_entrega)
  end

  def update_pago_params
    params.permit(:id, :estado_pago, :fecha_pago)
  end

  def update_despacho_params
    params.permit(:id, :estado_orden, :fecha_entrega)
  end

  def destroy_params
    params.permit(:id)
  end

  def estado_pago_valido?(estado)
    estado.in?(Orden.estado_pagos.keys)
  end

  def estado_orden_valido?(estado)
    estado.in?(Orden.estado_ordens.keys)
  end
end
