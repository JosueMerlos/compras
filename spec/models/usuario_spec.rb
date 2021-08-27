require 'rails_helper'

RSpec.describe Usuario, type: :model do
  describe 'Validaciones base' do
    it 'si el factory es valido' do
      expect(build(:usuario_1)).to be_valid
    end

    it 'crear' do
      expect { create(:usuario_1) }.to change(described_class, :count).from(0).to(1)
    end

    it 'eliminar' do
      create(:usuario_1)
      expect { described_class.last.destroy }.to change(described_class, :count).from(1).to(0)
    end
  end

  describe 'atributos' do
    subject { build(:usuario_1) }

    it { is_expected.to have_attributes(id: 1) }
    it { is_expected.to have_attributes(email: 'test@email.com') }
    it { is_expected.to have_attributes(nombre: 'Usuario Test') }
  end

  describe 'validaciones' do
    subject { build(:usuario_1) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:nombre) }
  end

  describe 'scopes y metodos' do
    let!(:usuario_1) { create(:usuario_1) }
    let!(:usuario_2) { create(:usuario_2) }
    let!(:usuario_3) { create(:usuario_3) }

    describe '.buscar' do
      it 'se obtienen los registros cuyo busqueda coincida' do
        expect(described_class.buscar('Test')).to contain_exactly(usuario_1)
      end

      it 'se obtienen todos los registros si la busqueda es una cadena vacia' do
        expect(described_class.buscar('')).to contain_exactly(usuario_1, usuario_2, usuario_3)
      end

      it 'no se obtienen ningun registro cuando no hay coincidencia' do
        expect(described_class.buscar('Doe')).to be_empty
      end
    end
  end
end
