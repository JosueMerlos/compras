require 'rails_helper'

RSpec.describe Api::V1::OrdenesController, type: :routing do
  it {
    expect(
      get('/api/v1/ordenes')
    ).to route_to(controller: 'api/v1/ordenes', action: 'index')
  }

  it {
    expect(
      get('/api/v1/ordenes/1')
    ).to route_to(controller: 'api/v1/ordenes', action: 'show', id: '1')
  }

  it {
    expect(
      patch('/api/v1/ordenes/update_estado_pago')
    ).to route_to(controller: 'api/v1/ordenes', action: 'update_estado_pago')
  }

  it {
    expect(
      patch('/api/v1/ordenes/update_estado_despacho')
    ).to route_to(controller: 'api/v1/ordenes', action: 'update_estado_despacho')
  }

  it {
    expect(
      delete('/api/v1/ordenes/1')
    ).to route_to(controller: 'api/v1/ordenes', action: 'destroy', id: '1')
  }
end
