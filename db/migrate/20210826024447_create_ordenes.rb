class CreateOrdenes < ActiveRecord::Migration[6.1]
  def change
    create_table :ordenes do |t|
      t.decimal :monto, null: false, precision: 10, scale: 2
      t.integer :estado_pago, null: false
      t.integer :estado_orden, null: false
      t.timestamp :fecha_pago
      t.timestamp :fecha_entrega
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
