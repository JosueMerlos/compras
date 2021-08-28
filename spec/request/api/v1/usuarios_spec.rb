require 'rails_helper'

RSpec.describe Api::V1::UsuariosController, type: :request do
  let!(:usuario_1) { create(:usuario_1) }
  let!(:usuario_2) { create(:usuario_2) }
  let!(:usuario_3) { create(:usuario_3) }
  let!(:orden_1) { create(:orden_1) }
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET #index' do
    let(:json_deseado) do
      { usuarios:
        [
          usuario_1.slice(%w(id email nombre)),
          usuario_2.slice(%w(id email nombre)),
          usuario_3.slice(%w(id email nombre))
        ],
        page: 1,
        per_page: 20,
        total: 3,
        total_pages: 1
      }
    end

    it 'se obtiene la lista de usuarios' do
      get api_v1_usuarios_path, headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
    end
  end

  describe 'GET #show' do
    let(:ordenes) do
      [
        {
          monto: orden_1.monto.to_f,
          estado_orden: orden_1.estado_orden,
          estado_pago: orden_1.estado_pago,
          fecha_pago: orden_1.fecha_pago,
          fecha_entrega: orden_1.fecha_entrega,
        }
      ]
    end

    it 'se obtiene los datos del usuario, con sus ordenes' do
      get '/api/v1/usuarios/1', headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      json_deseado = usuario_1.slice(%w(email nombre))
      json_deseado['ordenes'] = ordenes
      expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
    end
    
    it 'se obtiene los datos del usuario, con ordenes vacio si no tiene asociadas' do
      get '/api/v1/usuarios/2', headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      json_deseado = usuario_2.slice(%w(email nombre))
      json_deseado['ordenes'] = []
      expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
    end
  end

  describe 'POST #create' do
    context 'cuando el registro se creo correctamente' do
      let(:json_deseado) do
        {
          email: 'prueba@gmail.com',
          nombre: 'Usuario Prueba',
          ordenes: []
        }
      end
  
      it 'se obtiene el registro creado' do
        DatabaseCleaner.clean
        post '/api/v1/usuarios', params: { nombre: 'Usuario Prueba', email: 'prueba@gmail.com' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end

    context 'cuando el registro no se creo correctamente' do
      it 'se obtiene un mensaje indicando el error' do
        post '/api/v1/usuarios', params: { email: 'prueba@gmail.com' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ status: 422, message: "Nombre can't be blank", }.as_json)
      end
    end
  end

  describe 'PATCH #update_email' do
    context 'cuando el registro se modifico correctamente' do
      let(:json_deseado) do
        {
          email: 'prueba@gmail.com',
          nombre: usuario_3.nombre,
          ordenes: []
        }
      end
  
      it 'se obtiene el registro modificado' do
        patch '/api/v1/usuarios/update_email', params: { id: 3, email: 'prueba@gmail.com' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end

    context 'cuando el registro no se modifico correctamente' do
      it 'se obtiene un mensaje indicando el error' do
        patch '/api/v1/usuarios/update_email', params: { id: 3, email: '' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ status: 422, message: "Email can't be blank, Email is invalid", }.as_json)
      end
    end
  end

  describe 'PATCH #update_nombre' do
    context 'cuando el registro se modifico correctamente' do
      let(:json_deseado) do
        {
          email: usuario_3.email,
          nombre: 'John Doe',
          ordenes: []
        }
      end
  
      it 'se obtiene el registro modificado' do
        patch '/api/v1/usuarios/update_nombre', params: { id: 3, nombre: 'John Doe' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end

    context 'cuando el registro no se modifico correctamente' do
      it 'se obtiene un mensaje indicando el error' do
        patch '/api/v1/usuarios/update_nombre', params: { id: 3, nombre: '' }, headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ status: 422, message: "Nombre can't be blank", }.as_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'cuando el registro se elimina' do
      it 'se obtiene un mensaje indicando que se elimino el registro' do
        delete '/api/v1/usuarios/2', headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        json_deseado = Usuario.new.slice(%w(email nombre))
        json_deseado['ordenes'] = []
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end

    context 'cuando el registro no se elimina' do
      it 'se obtiene un mensaje indicando que el error' do
        delete '/api/v1/usuarios/1', headers: headers
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        json_deseado = { status: 422, message: "Can't delete record, because have orders associated" }
        expect(JSON.parse(response.body)).to eq(json_deseado.as_json)
      end
    end
  end
end
