require 'rails_helper'

RSpec.describe Orden, type: :model do
  describe 'Validaciones base' do
    it 'si el factory es valido' do
      expect(build(:orden_1)).to be_valid
    end

    it 'crear' do
      expect { create(:orden_1) }.to change(described_class, :count).from(0).to(1)
    end

    it 'eliminar' do
      create(:orden_1)
      expect { described_class.last.destroy }.to change(described_class, :count).from(1).to(0)
    end
  end

  describe 'atributos' do
    subject { build(:orden_1) }

    it { is_expected.to have_attributes(id: 1) }
    it { is_expected.to have_attributes(usuario_id: 1) }
    it { is_expected.to have_attributes(monto: BigDecimal('325.56')) }
    it { is_expected.to have_attributes(estado_pago: 'pendiente') }
    it { is_expected.to have_attributes(estado_orden: 'recibida') }
  end

  describe 'validaciones' do
    subject { build(:orden_1) }

    it { is_expected.to validate_presence_of(:usuario_id) }
    it { is_expected.to validate_presence_of(:monto) }
    it { is_expected.to validate_presence_of(:estado_pago) }
    it { is_expected.to validate_presence_of(:estado_orden) }

    context 'cuando el estado de pago es pagada' do
      it 'valida que la fecha de pago este presente' do
        subject.estado_pago = 'pagada'
        expect(subject.valid?).to be_falsey
        expect(subject.errors.full_messages.join(', ')).to include("Fecha pago can't be blank")
      end
    end

    context 'cuando el estado de orden es entregada' do
      it 'valida que la fecha de entrega este presente' do
        subject.estado_orden = 'entregada'
        expect(subject.valid?).to be_falsey
        expect(subject.errors.full_messages.join(', ')).to include("Fecha entrega can't be blank")
      end
    end
  end

  describe 'scopes y metodos' do
    let!(:orden_3) { create(:orden_3) }

    describe '.por_fecha_entrega' do
      it 'se obtienen los registros cuyo fecha entrega coincida' do
        expect(described_class.por_fecha_entrega(Date.current.strftime('%Y-%m-%d'))).to contain_exactly(orden_3)
      end

      it 'no se obtienen ningun registro cuando no hay coincidencia' do
        expect(described_class.por_fecha_entrega(Date.yesterday.strftime('%Y-%m-%d'))).to be_empty
      end
    end
  end
end
