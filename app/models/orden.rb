class Orden < ApplicationRecord
  self.table_name = 'ordenes'
  
  enum estado_orden: [:recibida, :en_preparacion, :en_reparto, :entregada]
  enum estado_pago: [:pendiente, :pagada, :no_pagada]

  validates :usuario_id, presence: true
  validates :monto, presence: true,
                    numericality: { greater_than: 0, less_than: 100000000 },
                    format: { with: /\A\d{1,8}(\.\d{1,2})?\z/ }
  validates :estado_pago, presence: true,
                          inclusion: { in: estado_pagos.keys }
  validates :estado_orden, presence: true,
                           inclusion: { in: estado_ordens.keys }
  validates :fecha_pago, presence: true, if: :pagada?
  validates :fecha_pago, absence: true, unless: :pagada?
  validates :fecha_entrega, presence: true, if: :entregada?
  validates :fecha_entrega, absence: true, unless: :entregada?

  belongs_to :usuario

  scope :por_fecha_entrega, ->(fecha_entrega) { where('fecha_entrega::date = ?', fecha_entrega) }
end
