require 'rails_helper'

RSpec.describe Api::V1::OrdenesController, type: :request do
  let!(:orden_1) { create(:orden_1) }
  let!(:orden_2) { create(:orden_2) }
  let!(:orden_3) { create(:orden_3) }
  let!(:orden_1) { create(:orden_1) }
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET #index' do
    it 'se obtiene la lista de ordenes' do
      get api_v1_ordenes_path, headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['ordenes'][0]['monto']).to eq('325.56'.to_f)
      expect(JSON.parse(response.body)['ordenes'][1]['monto']).to eq('225.00'.to_f)
      expect(JSON.parse(response.body)['ordenes'][2]['monto']).to eq('143.50'.to_f)
    end
  end

  describe 'GET #show' do
    let(:json_deseado) do
      {
        id: 1,
        monto: orden_1.monto.to_f,
        estado_orden: orden_1.estado_orden,
        estado_pago: orden_1.estado_pago,
        fecha_pago: orden_1.fecha_pago,
        fecha_entrega: orden_1.fecha_entrega,
        usuario: {
          id: 1,
          email: orden_1.usuario.email,
          nombre: orden_1.usuario.nombre,
        }
      }
    end

    it 'se obtiene los datos de la orden' do
      get '/api/v1/ordenes/1', headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
    end
  end

  describe 'POST #create' do
    context 'cuando el registro se creo correctamente' do
      let(:json_deseado) do
        {
          id: 1,
          monto: '1245.55'.to_f,
          estado_orden: 'recibida',
          estado_pago: 'pendiente',
          fecha_pago: nil,
          fecha_entrega: nil,
          usuario: {
            id: 1,
            email: 'test@email.com',
            nombre: 'Usuario Test'
          }
        }
      end
  
      it 'se obtiene el registro creado' do
        DatabaseCleaner.clean
        create(:usuario_1)
        post '/api/v1/ordenes', params: {
          usuario_id: 1, monto: '1245.55', estado_pago: 'pendiente', estado_orden: 'recibida'
        }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end

    context 'cuando el registro no se creo correctamente' do
      it 'se obtiene un mensaje indicando el error' do
        post '/api/v1/ordenes', params: { monto: '1245.55', estado_pago: 'pendiente', estado_orden: 'recibida' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ status: 422, message: "Usuario can't be blank, Usuario must exist", }.as_json)
      end
    end
  end

  describe 'PATCH #update_estado_pago' do
    context 'cuando el registro se modifico correctamente' do
      it 'se obtiene el registro modificado' do
        patch '/api/v1/ordenes/update_estado_pago', params: { id: 1, estado_pago: 'no_pagada' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['estado_pago']).to eq('no_pagada')
      end
    end

    context 'cuando el registro no se modifico correctamente' do
      it 'se obtiene un mensaje indicando el error' do
        patch '/api/v1/ordenes/update_estado_pago', params: { id: 3, estado_pago: 'credito' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ status: 422, message: 'It is not a valid estado_pago', }.as_json)
      end
    end
  end

  describe 'PATCH #update_estado_despacho' do
    context 'cuando el registro se modifico correctamente' do
      it 'se obtiene el registro modificado' do
        patch '/api/v1/ordenes/update_estado_despacho', params: { id: 1, estado_orden: 'en_preparacion' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['estado_orden']).to eq('en_preparacion')
      end
    end

    context 'cuando el registro no se modifico correctamente' do
      it 'se obtiene un mensaje indicando el error' do
        patch '/api/v1/ordenes/update_estado_despacho', params: { id: 3, estado_orden: 'preparada' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ status: 422, message: 'It is not a valid estado_orden', }.as_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'cuando el registro se elimina' do
      it 'se obtiene un registro nuevo y vacio' do
        delete '/api/v1/ordenes/2', headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        json_deseado = Orden.new.slice(%w(id monto estado_orden estado_pago fecha_pago fecha_entrega))
        json_deseado['monto'] = '0.0'.to_f
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end
  end
end
