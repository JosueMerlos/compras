require 'rails_helper'

RSpec.describe Api::V1::UsuariosController, type: :routing do
  it {
    expect(
      get('/api/v1/usuarios')
    ).to route_to(controller: 'api/v1/usuarios', action: 'index')
  }

  it {
    expect(
      get('/api/v1/usuarios/1')
    ).to route_to(controller: 'api/v1/usuarios', action: 'show', id: '1')
  }

  it {
    expect(
      patch('/api/v1/usuarios/update_email')
    ).to route_to(controller: 'api/v1/usuarios', action: 'update_email')
  }

  it {
    expect(
      patch('/api/v1/usuarios/update_nombre')
    ).to route_to(controller: 'api/v1/usuarios', action: 'update_nombre')
  }

  it {
    expect(
      delete('/api/v1/usuarios/1')
    ).to route_to(controller: 'api/v1/usuarios', action: 'destroy', id: '1')
  }
end
