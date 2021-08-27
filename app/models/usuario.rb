class Usuario < ApplicationRecord
  before_destroy :valid_destroy

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/ }

  validates :nombre, presence: true

  has_many :ordenes, class_name: 'Orden'

  def self.buscar(busqueda)
    busqueda.try(:strip!)
    where('email ilike :busqueda or nombre ilike :busqueda', busqueda: ['%', busqueda, '%'].join)
  end

  private

  def valid_destroy
    return true unless ordenes.any?
    errors.add(:base, "Can't delete record, because have orders associated")
    throw :abort
  end
end
